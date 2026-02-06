package com.ruoyi.system.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SkiCourse;
import com.ruoyi.system.domain.SkiCourseSchedule;
import com.ruoyi.system.service.ISkiCourseScheduleService;
import com.ruoyi.system.service.ISkiCourseService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 课程时间表Controller
 * 
 * @author ruoyi
 */
@Api(tags = "课程时间表管理")
@RestController
@RequestMapping("/system/courseSchedule")
public class SkiCourseScheduleController extends BaseController {
    @Autowired
    private ISkiCourseScheduleService skiCourseScheduleService;

    @Autowired
    private ISkiCourseService skiCourseService;

    /**
     * 查询课程时间表列表
     */
    @ApiOperation("查询课程时间表列表")
    @GetMapping("/list")
    public TableDataInfo list(SkiCourseSchedule skiCourseSchedule) {
        startPage();
        // 如果不是管理员，只查询当前教练的课程时间表
        if (!SecurityUtils.isAdmin() && skiCourseSchedule.getCourseId() != null) {
            SkiCourse course = skiCourseService.selectSkiCourseById(skiCourseSchedule.getCourseId());
            if (course != null && !course.getCoachId().equals(SecurityUtils.getUserId())) {
                return getDataTable(null);
            }
        }
        List<SkiCourseSchedule> list = skiCourseScheduleService.selectSkiCourseScheduleList(skiCourseSchedule);
        return getDataTable(list);
    }

    /**
     * 根据课程ID查询时间表
     */
    @ApiOperation("根据课程ID查询时间表")
    @GetMapping("/course/{courseId}")
    public AjaxResult getByCourseId(@PathVariable("courseId") Long courseId) {
        // 如果不是管理员，验证课程归属
        if (!SecurityUtils.isAdmin()) {
            SkiCourse course = skiCourseService.selectSkiCourseById(courseId);
            if (course == null || !course.getCoachId().equals(SecurityUtils.getUserId())) {
                return error("无权查看此课程的时间表");
            }
        }
        List<SkiCourseSchedule> list = skiCourseScheduleService.selectSkiCourseScheduleByCourseId(courseId);
        return success(list);
    }

    /**
     * 获取时间表详细信息
     */
    @ApiOperation("获取时间表详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(skiCourseScheduleService.selectSkiCourseScheduleById(id));
    }

    /**
     * 新增课程时间表
     */
    @ApiOperation("新增课程时间表")
    @Log(title = "课程时间表", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SkiCourseSchedule skiCourseSchedule) {
        // 验证课程归属
        if (skiCourseSchedule.getCourseId() != null) {
            SkiCourse course = skiCourseService.selectSkiCourseById(skiCourseSchedule.getCourseId());
            if (course == null) {
                return error("课程不存在");
            }
            if (!SecurityUtils.isAdmin() && !course.getCoachId().equals(SecurityUtils.getUserId())) {
                return error("无权为此课程添加时间表");
            }
        }
        return toAjax(skiCourseScheduleService.insertSkiCourseSchedule(skiCourseSchedule));
    }

    /**
     * 修改课程时间表
     */
    @ApiOperation("修改课程时间表")
    @Log(title = "课程时间表", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SkiCourseSchedule skiCourseSchedule) {
        // 验证课程归属
        if (skiCourseSchedule.getCourseId() != null) {
            SkiCourse course = skiCourseService.selectSkiCourseById(skiCourseSchedule.getCourseId());
            if (course != null && !SecurityUtils.isAdmin() && !course.getCoachId().equals(SecurityUtils.getUserId())) {
                return error("无权修改此课程的时间表");
            }
        }
        return toAjax(skiCourseScheduleService.updateSkiCourseSchedule(skiCourseSchedule));
    }

    /**
     * 删除课程时间表
     */
    @ApiOperation("删除课程时间表")
    @Log(title = "课程时间表", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        // 验证课程归属
        if (!SecurityUtils.isAdmin()) {
            for (Long id : ids) {
                SkiCourseSchedule schedule = skiCourseScheduleService.selectSkiCourseScheduleById(id);
                if (schedule != null) {
                    SkiCourse course = skiCourseService.selectSkiCourseById(schedule.getCourseId());
                    if (course == null || !course.getCoachId().equals(SecurityUtils.getUserId())) {
                        return error("无权删除此课程的时间表");
                    }
                }
            }
        }
        return toAjax(skiCourseScheduleService.deleteSkiCourseScheduleByIds(ids));
    }

    /**
     * 公开查询课程时间表（用于游客预约）
     */
    @ApiOperation("公开查询课程时间表")
    @GetMapping("/public/course/{courseId}")
    public AjaxResult publicGetByCourseId(@PathVariable("courseId") Long courseId) {
        List<SkiCourseSchedule> list = skiCourseScheduleService.selectSkiCourseScheduleByCourseId(courseId);
        return success(list);
    }
}
