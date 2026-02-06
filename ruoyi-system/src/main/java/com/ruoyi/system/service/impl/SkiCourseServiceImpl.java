package com.ruoyi.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SkiCourse;
import com.ruoyi.system.mapper.SkiCourseMapper;
import com.ruoyi.system.service.ISkiCourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 课程Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class SkiCourseServiceImpl implements ISkiCourseService {
    @Autowired
    private SkiCourseMapper skiCourseMapper;

    @Override
    public SkiCourse selectSkiCourseById(Long id) {
        return skiCourseMapper.selectById(id);
    }

    @Override
    public List<SkiCourse> selectSkiCourseList(SkiCourse skiCourse) {
        LambdaQueryWrapper<SkiCourse> wrapper = Wrappers.lambdaQuery();
        if (skiCourse.getCoachId() != null) {
            wrapper.eq(SkiCourse::getCoachId, skiCourse.getCoachId());
        }
        if (skiCourse.getCourseName() != null && !skiCourse.getCourseName().isEmpty()) {
            wrapper.like(SkiCourse::getCourseName, skiCourse.getCourseName());
        }
        if (skiCourse.getCourseType() != null && !skiCourse.getCourseType().isEmpty()) {
            wrapper.eq(SkiCourse::getCourseType, skiCourse.getCourseType());
        }
        if (skiCourse.getStatus() != null) {
            wrapper.eq(SkiCourse::getStatus, skiCourse.getStatus());
        } else {
            // 默认只查询正常状态的课程
            wrapper.eq(SkiCourse::getStatus, "0");
        }
        return skiCourseMapper.selectList(wrapper);
    }

    @Override
    public int insertSkiCourse(SkiCourse skiCourse) {
        if (skiCourse.getCoachId() == null) {
            skiCourse.setCoachId(SecurityUtils.getUserId());
        }
        if (skiCourse.getStatus() == null) {
            skiCourse.setStatus("0");
        }
        if (skiCourse.getDuration() == null) {
            skiCourse.setDuration(60);
        }
        if (skiCourse.getMaxStudents() == null) {
            skiCourse.setMaxStudents(1);
        }
        return skiCourseMapper.insert(skiCourse);
    }

    @Override
    public int updateSkiCourse(SkiCourse skiCourse) {
        return skiCourseMapper.updateById(skiCourse);
    }

    @Override
    public int deleteSkiCourseByIds(Long[] ids) {
        return skiCourseMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    @Override
    public int deleteSkiCourseById(Long id) {
        return skiCourseMapper.deleteById(id);
    }
}
