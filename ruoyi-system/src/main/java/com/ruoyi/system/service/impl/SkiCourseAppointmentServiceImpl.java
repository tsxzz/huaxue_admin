package com.ruoyi.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SkiCourseAppointment;
import com.ruoyi.system.domain.SkiCourseSchedule;
import com.ruoyi.system.mapper.SkiCourseAppointmentMapper;
import com.ruoyi.system.mapper.SkiCourseScheduleMapper;
import com.ruoyi.system.service.ISkiCourseAppointmentService;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.common.core.domain.entity.SysUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 课程预约Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class SkiCourseAppointmentServiceImpl implements ISkiCourseAppointmentService {
    @Autowired
    private SkiCourseAppointmentMapper skiCourseAppointmentMapper;

    @Autowired
    private SkiCourseScheduleMapper skiCourseScheduleMapper;

    @Autowired
    private ISysUserService userService;

    @Override
    public SkiCourseAppointment selectSkiCourseAppointmentById(Long id) {
        return skiCourseAppointmentMapper.selectById(id);
    }

    @Override
    public List<SkiCourseAppointment> selectSkiCourseAppointmentList(SkiCourseAppointment skiCourseAppointment) {
        LambdaQueryWrapper<SkiCourseAppointment> wrapper = Wrappers.lambdaQuery();
        if (skiCourseAppointment.getCourseId() != null) {
            wrapper.eq(SkiCourseAppointment::getCourseId, skiCourseAppointment.getCourseId());
        }
        if (skiCourseAppointment.getScheduleId() != null) {
            wrapper.eq(SkiCourseAppointment::getScheduleId, skiCourseAppointment.getScheduleId());
        }
        if (skiCourseAppointment.getStudentId() != null) {
            wrapper.eq(SkiCourseAppointment::getStudentId, skiCourseAppointment.getStudentId());
        }
        if (skiCourseAppointment.getCoachId() != null) {
            wrapper.eq(SkiCourseAppointment::getCoachId, skiCourseAppointment.getCoachId());
        }
        if (skiCourseAppointment.getStatus() != null) {
            wrapper.eq(SkiCourseAppointment::getStatus, skiCourseAppointment.getStatus());
        }
        if (skiCourseAppointment.getPaymentStatus() != null) {
            wrapper.eq(SkiCourseAppointment::getPaymentStatus, skiCourseAppointment.getPaymentStatus());
        }
        wrapper.orderByDesc(SkiCourseAppointment::getAppointmentDate);
        wrapper.orderByDesc(SkiCourseAppointment::getCreateTime);
        return skiCourseAppointmentMapper.selectList(wrapper);
    }

    @Override
    @Transactional
    public int insertSkiCourseAppointment(SkiCourseAppointment appointment) {
        // 设置学员ID
        if (appointment.getStudentId() == null) {
            appointment.setStudentId(SecurityUtils.getUserId());
        }
        // 设置学员姓名
        if (appointment.getStudentName() == null || appointment.getStudentName().isEmpty()) {
            SysUser user = userService.selectUserById(appointment.getStudentId());
            if (user != null) {
                appointment.setStudentName(user.getNickName() != null && !user.getNickName().isEmpty() 
                    ? user.getNickName() : user.getUserName());
            }
        }
        if (appointment.getStatus() == null) {
            appointment.setStatus("0"); // 待确认
        }
        if (appointment.getPaymentStatus() == null) {
            appointment.setPaymentStatus("0"); // 未支付
        }

        // 插入预约记录
        int result = skiCourseAppointmentMapper.insert(appointment);

        // 更新时间表的已预约名额
        if (result > 0 && appointment.getScheduleId() != null) {
            SkiCourseSchedule schedule = skiCourseScheduleMapper.selectById(appointment.getScheduleId());
            if (schedule != null) {
                int newBookedSlots = (schedule.getBookedSlots() == null ? 0 : schedule.getBookedSlots()) + 1;
                schedule.setBookedSlots(newBookedSlots);
                skiCourseScheduleMapper.updateById(schedule);
            }
        }

        return result;
    }

    @Override
    public int updateSkiCourseAppointment(SkiCourseAppointment skiCourseAppointment) {
        return skiCourseAppointmentMapper.updateById(skiCourseAppointment);
    }

    @Override
    public int deleteSkiCourseAppointmentByIds(Long[] ids) {
        return skiCourseAppointmentMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    @Override
    public int deleteSkiCourseAppointmentById(Long id) {
        return skiCourseAppointmentMapper.deleteById(id);
    }

    @Override
    @Transactional
    public int cancelAppointment(Long id, String cancelReason) {
        SkiCourseAppointment appointment = skiCourseAppointmentMapper.selectById(id);
        if (appointment == null) {
            return 0;
        }

        // 更新预约状态为已取消
        appointment.setStatus("3"); // 已取消
        appointment.setCancelReason(cancelReason);
        int result = skiCourseAppointmentMapper.updateById(appointment);

        // 更新时间表的已预约名额（减1）
        if (result > 0 && appointment.getScheduleId() != null) {
            SkiCourseSchedule schedule = skiCourseScheduleMapper.selectById(appointment.getScheduleId());
            if (schedule != null) {
                int newBookedSlots = Math.max(0, (schedule.getBookedSlots() == null ? 0 : schedule.getBookedSlots()) - 1);
                schedule.setBookedSlots(newBookedSlots);
                // 如果名额未满，恢复为可预约状态
                if (newBookedSlots < schedule.getAvailableSlots()) {
                    schedule.setStatus("0");
                }
                skiCourseScheduleMapper.updateById(schedule);
            }
        }

        return result;
    }

    @Override
    @Transactional
    public int payAppointment(Long id, String paymentMethod) {
        SkiCourseAppointment appointment = skiCourseAppointmentMapper.selectById(id);
        if (appointment == null) {
            throw new RuntimeException("预约不存在");
        }
        
        // 只有未支付的预约才能支付
        if (!"0".equals(appointment.getPaymentStatus())) {
            throw new RuntimeException("只有未支付的预约才能支付");
        }
        
        // 更新支付状态和支付信息
        appointment.setPaymentStatus("1"); // 已支付
        appointment.setPaymentMethod(paymentMethod);
        appointment.setPaymentTime(new Date());
        
        return skiCourseAppointmentMapper.updateById(appointment);
    }

    @Override
    @Transactional
    public int confirmAppointment(Long id) {
        SkiCourseAppointment appointment = skiCourseAppointmentMapper.selectById(id);
        if (appointment == null) {
            throw new RuntimeException("预约不存在");
        }
        
        // 只有待确认的预约才能确认
        if (!"0".equals(appointment.getStatus())) {
            throw new RuntimeException("只有待确认的预约才能确认");
        }
        
        // 更新预约状态为已确认
        appointment.setStatus("1"); // 已确认
        
        return skiCourseAppointmentMapper.updateById(appointment);
    }

    @Override
    @Transactional
    public int completeAppointment(Long id) {
        SkiCourseAppointment appointment = skiCourseAppointmentMapper.selectById(id);
        if (appointment == null) {
            throw new RuntimeException("预约不存在");
        }
        
        // 只有已确认的预约才能完成
        if (!"1".equals(appointment.getStatus())) {
            throw new RuntimeException("只有已确认的预约才能完成");
        }
        
        // 更新预约状态为已完成
        appointment.setStatus("2"); // 已完成
        
        return skiCourseAppointmentMapper.updateById(appointment);
    }
}
