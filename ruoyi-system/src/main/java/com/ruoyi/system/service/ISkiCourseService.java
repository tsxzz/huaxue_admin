package com.ruoyi.system.service;

import com.ruoyi.system.domain.SkiCourse;
import java.util.List;

/**
 * 课程Service接口
 * 
 * @author ruoyi
 */
public interface ISkiCourseService {
    /**
     * 查询课程
     * 
     * @param id 课程主键
     * @return 课程
     */
    public SkiCourse selectSkiCourseById(Long id);

    /**
     * 查询课程列表
     * 
     * @param skiCourse 课程
     * @return 课程集合
     */
    public List<SkiCourse> selectSkiCourseList(SkiCourse skiCourse);

    /**
     * 新增课程
     * 
     * @param skiCourse 课程
     * @return 结果
     */
    public int insertSkiCourse(SkiCourse skiCourse);

    /**
     * 修改课程
     * 
     * @param skiCourse 课程
     * @return 结果
     */
    public int updateSkiCourse(SkiCourse skiCourse);

    /**
     * 批量删除课程
     * 
     * @param ids 需要删除的课程主键集合
     * @return 结果
     */
    public int deleteSkiCourseByIds(Long[] ids);

    /**
     * 删除课程信息
     * 
     * @param id 课程主键
     * @return 结果
     */
    public int deleteSkiCourseById(Long id);
}
