package com.ruoyi.system.service;

import com.ruoyi.system.domain.SkiCourseSchedule;
import java.util.List;

/**
 * 课程时间表Service接口
 * 
 * @author ruoyi
 */
public interface ISkiCourseScheduleService {
    /**
     * 查询课程时间表
     * 
     * @param id 时间表主键
     * @return 课程时间表
     */
    public SkiCourseSchedule selectSkiCourseScheduleById(Long id);

    /**
     * 查询课程时间表列表
     * 
     * @param skiCourseSchedule 课程时间表
     * @return 课程时间表集合
     */
    public List<SkiCourseSchedule> selectSkiCourseScheduleList(SkiCourseSchedule skiCourseSchedule);

    /**
     * 根据课程ID查询时间表
     * 
     * @param courseId 课程ID
     * @return 课程时间表集合
     */
    public List<SkiCourseSchedule> selectSkiCourseScheduleByCourseId(Long courseId);

    /**
     * 新增课程时间表
     * 
     * @param skiCourseSchedule 课程时间表
     * @return 结果
     */
    public int insertSkiCourseSchedule(SkiCourseSchedule skiCourseSchedule);

    /**
     * 修改课程时间表
     * 
     * @param skiCourseSchedule 课程时间表
     * @return 结果
     */
    public int updateSkiCourseSchedule(SkiCourseSchedule skiCourseSchedule);

    /**
     * 批量删除课程时间表
     * 
     * @param ids 需要删除的时间表主键集合
     * @return 结果
     */
    public int deleteSkiCourseScheduleByIds(Long[] ids);

    /**
     * 删除课程时间表信息
     * 
     * @param id 时间表主键
     * @return 结果
     */
    public int deleteSkiCourseScheduleById(Long id);
}
