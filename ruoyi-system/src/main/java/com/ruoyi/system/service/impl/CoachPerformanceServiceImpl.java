package com.ruoyi.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SkiCourse;
import com.ruoyi.system.domain.SkiCourseAppointment;
import com.ruoyi.system.domain.dto.CoachPerformanceDTO;
import com.ruoyi.system.mapper.SkiCourseAppointmentMapper;
import com.ruoyi.system.mapper.SkiCourseMapper;
import com.ruoyi.system.service.ICoachPerformanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 教练业绩Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class CoachPerformanceServiceImpl implements ICoachPerformanceService {
    @Autowired
    private SkiCourseAppointmentMapper appointmentMapper;

    @Autowired
    private SkiCourseMapper courseMapper;

    @Override
    public CoachPerformanceDTO getCoachPerformance(Long coachId, LocalDate startDate, LocalDate endDate) {
        // 如果没有指定教练ID，使用当前登录用户
        if (coachId == null) {
            coachId = SecurityUtils.getUserId();
        }

        // 构建查询条件：查询已完成的预约（status='2'）
        LambdaQueryWrapper<SkiCourseAppointment> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiCourseAppointment::getCoachId, coachId);
        wrapper.eq(SkiCourseAppointment::getStatus, "2"); // 已完成

        // 日期范围过滤
        if (startDate != null) {
            wrapper.ge(SkiCourseAppointment::getAppointmentDate, startDate);
        }
        if (endDate != null) {
            wrapper.le(SkiCourseAppointment::getAppointmentDate, endDate);
        }

        // 查询所有已完成的预约
        List<SkiCourseAppointment> appointments = appointmentMapper.selectList(wrapper);

        // 获取所有课程信息（用于获取课程名称和类型）
        List<Long> courseIds = appointments.stream()
            .map(SkiCourseAppointment::getCourseId)
            .distinct()
            .collect(Collectors.toList());
        
        final Map<Long, SkiCourse> courseMap;
        if (!courseIds.isEmpty()) {
            List<SkiCourse> courses = courseMapper.selectBatchIds(courseIds);
            courseMap = courses.stream()
                .collect(Collectors.toMap(SkiCourse::getId, course -> course));
        } else {
            courseMap = new HashMap<>();
        }

        // 构建DTO
        CoachPerformanceDTO dto = new CoachPerformanceDTO();
        
        // 总完成课程数
        dto.setTotalCompletedCourses(appointments.size());
        
        // 计算总收入
        BigDecimal totalRevenue = appointments.stream()
            .map(SkiCourseAppointment::getPrice)
            .filter(price -> price != null)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        dto.setTotalRevenue(totalRevenue);
        
        // 计算已支付收入
        BigDecimal paidRevenue = appointments.stream()
            .filter(apt -> "1".equals(apt.getPaymentStatus()))
            .map(SkiCourseAppointment::getPrice)
            .filter(price -> price != null)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        dto.setPaidRevenue(paidRevenue);
        
        // 计算待支付收入
        BigDecimal unpaidRevenue = appointments.stream()
            .filter(apt -> "0".equals(apt.getPaymentStatus()))
            .map(SkiCourseAppointment::getPrice)
            .filter(price -> price != null)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        dto.setUnpaidRevenue(unpaidRevenue);
        
        // 按月份统计
        Map<String, CoachPerformanceDTO.MonthlyPerformance> monthlyMap = new HashMap<>();
        DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("yyyy-MM");
        
        for (SkiCourseAppointment apt : appointments) {
            String month = apt.getAppointmentDate().format(monthFormatter);
            monthlyMap.computeIfAbsent(month, k -> {
                CoachPerformanceDTO.MonthlyPerformance mp = new CoachPerformanceDTO.MonthlyPerformance();
                mp.setMonth(month);
                mp.setCourseCount(0);
                mp.setRevenue(BigDecimal.ZERO);
                return mp;
            });
            
            CoachPerformanceDTO.MonthlyPerformance mp = monthlyMap.get(month);
            mp.setCourseCount(mp.getCourseCount() + 1);
            if (apt.getPrice() != null) {
                mp.setRevenue(mp.getRevenue().add(apt.getPrice()));
            }
        }
        
        List<CoachPerformanceDTO.MonthlyPerformance> monthlyData = new ArrayList<>(monthlyMap.values());
        monthlyData.sort((a, b) -> a.getMonth().compareTo(b.getMonth()));
        dto.setMonthlyData(monthlyData);
        
        // 按课程类型统计
        Map<String, CoachPerformanceDTO.CourseTypePerformance> typeMap = new HashMap<>();
        
        for (SkiCourseAppointment apt : appointments) {
            SkiCourse course = courseMap.get(apt.getCourseId());
            String courseType = (course != null && course.getCourseType() != null) 
                ? course.getCourseType() : "未分类";
            
            typeMap.computeIfAbsent(courseType, k -> {
                CoachPerformanceDTO.CourseTypePerformance cp = new CoachPerformanceDTO.CourseTypePerformance();
                cp.setCourseType(courseType);
                cp.setCourseCount(0);
                cp.setRevenue(BigDecimal.ZERO);
                return cp;
            });
            
            CoachPerformanceDTO.CourseTypePerformance cp = typeMap.get(courseType);
            cp.setCourseCount(cp.getCourseCount() + 1);
            if (apt.getPrice() != null) {
                cp.setRevenue(cp.getRevenue().add(apt.getPrice()));
            }
        }
        
        List<CoachPerformanceDTO.CourseTypePerformance> courseTypeData = new ArrayList<>(typeMap.values());
        courseTypeData.sort((a, b) -> b.getRevenue().compareTo(a.getRevenue()));
        dto.setCourseTypeData(courseTypeData);
        
        // 最近完成的课程列表（最多20条）
        List<CoachPerformanceDTO.CourseDetail> recentCourses = appointments.stream()
            .sorted((a, b) -> {
                int dateCompare = b.getAppointmentDate().compareTo(a.getAppointmentDate());
                if (dateCompare != 0) return dateCompare;
                return b.getCreateTime().compareTo(a.getCreateTime());
            })
            .limit(20)
            .map(apt -> {
                CoachPerformanceDTO.CourseDetail detail = new CoachPerformanceDTO.CourseDetail();
                detail.setAppointmentId(apt.getId());
                SkiCourse course = courseMap.get(apt.getCourseId());
                detail.setCourseName(course != null ? course.getCourseName() : "未知课程");
                detail.setCourseType(course != null ? course.getCourseType() : "未分类");
                detail.setStudentName(apt.getStudentName());
                detail.setAppointmentDate(apt.getAppointmentDate().toString());
                detail.setPrice(apt.getPrice());
                detail.setPaymentStatus(apt.getPaymentStatus());
                detail.setStatus(apt.getStatus());
                return detail;
            })
            .collect(Collectors.toList());
        
        dto.setRecentCourses(recentCourses);
        
        return dto;
    }
}
