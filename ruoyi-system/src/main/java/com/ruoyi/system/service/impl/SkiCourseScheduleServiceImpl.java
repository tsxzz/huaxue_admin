package com.ruoyi.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.system.domain.SkiCourseSchedule;
import com.ruoyi.system.mapper.SkiCourseScheduleMapper;
import com.ruoyi.system.service.ISkiCourseScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 课程时间表Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class SkiCourseScheduleServiceImpl implements ISkiCourseScheduleService {
    @Autowired
    private SkiCourseScheduleMapper skiCourseScheduleMapper;

    @Override
    public SkiCourseSchedule selectSkiCourseScheduleById(Long id) {
        return skiCourseScheduleMapper.selectById(id);
    }

    @Override
    public List<SkiCourseSchedule> selectSkiCourseScheduleList(SkiCourseSchedule skiCourseSchedule) {
        LambdaQueryWrapper<SkiCourseSchedule> wrapper = Wrappers.lambdaQuery();
        if (skiCourseSchedule.getCourseId() != null) {
            wrapper.eq(SkiCourseSchedule::getCourseId, skiCourseSchedule.getCourseId());
        }
        if (skiCourseSchedule.getScheduleDate() != null) {
            wrapper.eq(SkiCourseSchedule::getScheduleDate, skiCourseSchedule.getScheduleDate());
        }
        if (skiCourseSchedule.getStatus() != null) {
            wrapper.eq(SkiCourseSchedule::getStatus, skiCourseSchedule.getStatus());
        } else {
            // 默认只查询可预约状态
            wrapper.eq(SkiCourseSchedule::getStatus, "0");
        }
        wrapper.orderByAsc(SkiCourseSchedule::getScheduleDate);
        wrapper.orderByAsc(SkiCourseSchedule::getStartTime);
        return skiCourseScheduleMapper.selectList(wrapper);
    }

    @Override
    public List<SkiCourseSchedule> selectSkiCourseScheduleByCourseId(Long courseId) {
        LambdaQueryWrapper<SkiCourseSchedule> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiCourseSchedule::getCourseId, courseId);
        wrapper.eq(SkiCourseSchedule::getStatus, "0"); // 只查询可预约的
        wrapper.orderByAsc(SkiCourseSchedule::getScheduleDate);
        wrapper.orderByAsc(SkiCourseSchedule::getStartTime);
        return skiCourseScheduleMapper.selectList(wrapper);
    }

    @Override
    public int insertSkiCourseSchedule(SkiCourseSchedule skiCourseSchedule) {
        if (skiCourseSchedule.getStatus() == null) {
            skiCourseSchedule.setStatus("0");
        }
        if (skiCourseSchedule.getAvailableSlots() == null) {
            skiCourseSchedule.setAvailableSlots(1);
        }
        if (skiCourseSchedule.getBookedSlots() == null) {
            skiCourseSchedule.setBookedSlots(0);
        }
        return skiCourseScheduleMapper.insert(skiCourseSchedule);
    }

    @Override
    public int updateSkiCourseSchedule(SkiCourseSchedule skiCourseSchedule) {
        // 如果已预约名额达到可预约名额，自动更新状态为已满
        if (skiCourseSchedule.getAvailableSlots() != null && skiCourseSchedule.getBookedSlots() != null) {
            if (skiCourseSchedule.getBookedSlots() >= skiCourseSchedule.getAvailableSlots()) {
                skiCourseSchedule.setStatus("1"); // 已满
            } else if ("1".equals(skiCourseSchedule.getStatus()) && 
                       skiCourseSchedule.getBookedSlots() < skiCourseSchedule.getAvailableSlots()) {
                skiCourseSchedule.setStatus("0"); // 恢复为可预约
            }
        }
        return skiCourseScheduleMapper.updateById(skiCourseSchedule);
    }

    @Override
    public int deleteSkiCourseScheduleByIds(Long[] ids) {
        return skiCourseScheduleMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    @Override
    public int deleteSkiCourseScheduleById(Long id) {
        return skiCourseScheduleMapper.deleteById(id);
    }
}
