package com.ruoyi.system.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SkiCourseAppointment;
import com.ruoyi.system.service.ISkiCourseAppointmentService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 课程预约Controller
 * 
 * @author ruoyi
 */
@Api(tags = "课程预约管理")
@RestController
@RequestMapping("/system/courseAppointment")
public class SkiCourseAppointmentController extends BaseController {
    @Autowired
    private ISkiCourseAppointmentService skiCourseAppointmentService;

    /**
     * 查询课程预约列表
     */
    @ApiOperation("查询课程预约列表")
    @GetMapping("/list")
    public TableDataInfo list(SkiCourseAppointment skiCourseAppointment) {
        startPage();
        // 如果不是管理员，根据角色过滤
        if (!SecurityUtils.isAdmin()) {
            Long userId = SecurityUtils.getUserId();
            // 判断是教练还是学员
            // 这里简化处理：如果coachId为空，则查询当前用户作为学员的预约
            // 如果coachId不为空，则查询当前用户作为教练的预约
            if (skiCourseAppointment.getCoachId() == null && skiCourseAppointment.getStudentId() == null) {
                // 默认查询当前用户相关的预约（作为学员或教练）
                skiCourseAppointment.setStudentId(userId);
            }
        }
        List<SkiCourseAppointment> list = skiCourseAppointmentService.selectSkiCourseAppointmentList(skiCourseAppointment);
        return getDataTable(list);
    }

    /**
     * 查询当前教练的预约列表
     */
    @ApiOperation("查询当前教练的预约列表")
    @GetMapping("/coach/list")
    public TableDataInfo coachList(SkiCourseAppointment skiCourseAppointment) {
        startPage();
        skiCourseAppointment.setCoachId(SecurityUtils.getUserId());
        List<SkiCourseAppointment> list = skiCourseAppointmentService.selectSkiCourseAppointmentList(skiCourseAppointment);
        return getDataTable(list);
    }

    /**
     * 查询当前学员的预约列表
     */
    @ApiOperation("查询当前学员的预约列表")
    @GetMapping("/student/list")
    public TableDataInfo studentList(SkiCourseAppointment skiCourseAppointment) {
        startPage();
        skiCourseAppointment.setStudentId(SecurityUtils.getUserId());
        List<SkiCourseAppointment> list = skiCourseAppointmentService.selectSkiCourseAppointmentList(skiCourseAppointment);
        return getDataTable(list);
    }

    /**
     * 获取预约详细信息
     */
    @ApiOperation("获取预约详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(skiCourseAppointmentService.selectSkiCourseAppointmentById(id));
    }

    /**
     * 新增课程预约
     */
    @ApiOperation("新增课程预约")
    @Log(title = "课程预约", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SkiCourseAppointment skiCourseAppointment) {
        // 自动设置学员ID
        if (skiCourseAppointment.getStudentId() == null) {
            skiCourseAppointment.setStudentId(SecurityUtils.getUserId());
        }
        return toAjax(skiCourseAppointmentService.insertSkiCourseAppointment(skiCourseAppointment));
    }

    /**
     * 修改课程预约
     */
    @ApiOperation("修改课程预约")
    @Log(title = "课程预约", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SkiCourseAppointment skiCourseAppointment) {
        // 验证权限：只能修改自己的预约或自己作为教练的预约
        if (!SecurityUtils.isAdmin()) {
            SkiCourseAppointment existing = skiCourseAppointmentService.selectSkiCourseAppointmentById(skiCourseAppointment.getId());
            if (existing == null) {
                return error("预约不存在");
            }
            Long userId = SecurityUtils.getUserId();
            if (!existing.getStudentId().equals(userId) && !existing.getCoachId().equals(userId)) {
                return error("无权修改此预约");
            }
        }
        return toAjax(skiCourseAppointmentService.updateSkiCourseAppointment(skiCourseAppointment));
    }

    /**
     * 删除课程预约
     */
    @ApiOperation("删除课程预约")
    @Log(title = "课程预约", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        // 验证权限：只能删除自己的预约或自己作为教练的预约
        if (!SecurityUtils.isAdmin()) {
            for (Long id : ids) {
                SkiCourseAppointment existing = skiCourseAppointmentService.selectSkiCourseAppointmentById(id);
                if (existing != null) {
                    Long userId = SecurityUtils.getUserId();
                    if (!existing.getStudentId().equals(userId) && !existing.getCoachId().equals(userId)) {
                        return error("无权删除此预约");
                    }
                }
            }
        }
        return toAjax(skiCourseAppointmentService.deleteSkiCourseAppointmentByIds(ids));
    }

    /**
     * 支付预约
     */
    @ApiOperation("支付预约")
    @Log(title = "支付预约", businessType = BusinessType.UPDATE)
    @PutMapping("/pay/{id}")
    public AjaxResult pay(@PathVariable("id") Long id, 
                         @RequestParam(required = false, defaultValue = "2") String paymentMethod) {
        // 验证权限：只能支付自己的预约
        SkiCourseAppointment appointment = skiCourseAppointmentService.selectSkiCourseAppointmentById(id);
        if (appointment == null) {
            return error("预约不存在");
        }
        if (!SecurityUtils.isAdmin()) {
            Long userId = SecurityUtils.getUserId();
            if (!appointment.getStudentId().equals(userId)) {
                return error("无权支付此预约");
            }
        }
        try {
            return toAjax(skiCourseAppointmentService.payAppointment(id, paymentMethod));
        } catch (RuntimeException e) {
            return error(e.getMessage());
        }
    }

    /**
     * 确认预约
     */
    @ApiOperation("确认预约")
    @Log(title = "确认预约", businessType = BusinessType.UPDATE)
    @PutMapping("/confirm/{id}")
    public AjaxResult confirm(@PathVariable("id") Long id) {
        // 验证权限：只能确认自己作为教练的预约
        SkiCourseAppointment appointment = skiCourseAppointmentService.selectSkiCourseAppointmentById(id);
        if (appointment == null) {
            return error("预约不存在");
        }
        if (!SecurityUtils.isAdmin()) {
            Long userId = SecurityUtils.getUserId();
            if (!appointment.getCoachId().equals(userId)) {
                return error("无权确认此预约");
            }
        }
        try {
            return toAjax(skiCourseAppointmentService.confirmAppointment(id));
        } catch (RuntimeException e) {
            return error(e.getMessage());
        }
    }

    /**
     * 完成预约
     */
    @ApiOperation("完成预约")
    @Log(title = "完成预约", businessType = BusinessType.UPDATE)
    @PutMapping("/complete/{id}")
    public AjaxResult complete(@PathVariable("id") Long id) {
        // 验证权限：只能完成自己作为教练的预约
        SkiCourseAppointment appointment = skiCourseAppointmentService.selectSkiCourseAppointmentById(id);
        if (appointment == null) {
            return error("预约不存在");
        }
        if (!SecurityUtils.isAdmin()) {
            Long userId = SecurityUtils.getUserId();
            if (!appointment.getCoachId().equals(userId)) {
                return error("无权完成此预约");
            }
        }
        try {
            return toAjax(skiCourseAppointmentService.completeAppointment(id));
        } catch (RuntimeException e) {
            return error(e.getMessage());
        }
    }

    /**
     * 取消预约（退课）
     */
    @ApiOperation("取消预约（退课）")
    @Log(title = "取消预约", businessType = BusinessType.UPDATE)
    @PutMapping("/cancel/{id}")
    public AjaxResult cancel(@PathVariable("id") Long id, @RequestParam(required = false) String cancelReason) {
        // 验证权限：只能取消自己的预约或自己作为教练的预约
        SkiCourseAppointment appointment = skiCourseAppointmentService.selectSkiCourseAppointmentById(id);
        if (appointment == null) {
            return error("预约不存在");
        }
        if (!SecurityUtils.isAdmin()) {
            Long userId = SecurityUtils.getUserId();
            if (!appointment.getStudentId().equals(userId) && !appointment.getCoachId().equals(userId)) {
                return error("无权取消此预约");
            }
        }
        return toAjax(skiCourseAppointmentService.cancelAppointment(id, cancelReason));
    }
}
