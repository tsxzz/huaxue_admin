package com.ruoyi.system.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SkiCourse;
import com.ruoyi.system.service.ISkiCourseService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 课程Controller
 * 
 * @author ruoyi
 */
@Api(tags = "课程管理")
@RestController
@RequestMapping("/system/course")
public class SkiCourseController extends BaseController {
    @Autowired
    private ISkiCourseService skiCourseService;

    /**
     * 查询课程列表
     */
    @ApiOperation("查询课程列表")
    @GetMapping("/list")
    public TableDataInfo list(SkiCourse skiCourse) {
        startPage();
        // 如果不是管理员，只查询当前教练的课程
        if (!SecurityUtils.isAdmin()) {
            skiCourse.setCoachId(SecurityUtils.getUserId());
        }
        List<SkiCourse> list = skiCourseService.selectSkiCourseList(skiCourse);
        return getDataTable(list);
    }

    /**
     * 获取课程详细信息
     */
    @ApiOperation("获取课程详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(skiCourseService.selectSkiCourseById(id));
    }

    /**
     * 新增课程
     */
    @ApiOperation("新增课程")
    @Log(title = "课程", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SkiCourse skiCourse) {
        // 如果不是管理员，自动设置为当前用户
        if (!SecurityUtils.isAdmin()) {
            skiCourse.setCoachId(SecurityUtils.getUserId());
        }
        return toAjax(skiCourseService.insertSkiCourse(skiCourse));
    }

    /**
     * 修改课程
     */
    @ApiOperation("修改课程")
    @Log(title = "课程", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SkiCourse skiCourse) {
        // 如果不是管理员，只能修改自己的课程
        if (!SecurityUtils.isAdmin()) {
            SkiCourse existing = skiCourseService.selectSkiCourseById(skiCourse.getId());
            if (existing == null || !existing.getCoachId().equals(SecurityUtils.getUserId())) {
                return error("无权修改此课程");
            }
        }
        return toAjax(skiCourseService.updateSkiCourse(skiCourse));
    }

    /**
     * 删除课程
     */
    @ApiOperation("删除课程")
    @Log(title = "课程", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        // 如果不是管理员，只能删除自己的课程
        if (!SecurityUtils.isAdmin()) {
            for (Long id : ids) {
                SkiCourse existing = skiCourseService.selectSkiCourseById(id);
                if (existing == null || !existing.getCoachId().equals(SecurityUtils.getUserId())) {
                    return error("无权删除此课程");
                }
            }
        }
        return toAjax(skiCourseService.deleteSkiCourseByIds(ids));
    }

    /**
     * 公开查询课程列表（用于游客预约）
     */
    @ApiOperation("公开查询课程列表")
    @GetMapping("/public/list")
    public TableDataInfo publicList(SkiCourse skiCourse) {
        startPage();
        skiCourse.setStatus("0"); // 只查询正常状态的课程
        List<SkiCourse> list = skiCourseService.selectSkiCourseList(skiCourse);
        return getDataTable(list);
    }
}
