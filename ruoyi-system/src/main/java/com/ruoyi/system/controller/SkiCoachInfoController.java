package com.ruoyi.system.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SkiCoachInfo;
import com.ruoyi.system.service.ISkiCoachInfoService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 教练信息Controller
 * 
 * @author ruoyi
 */
@Api(tags = "教练信息管理")
@RestController
@RequestMapping("/system/coachInfo")
public class SkiCoachInfoController extends BaseController {
    @Autowired
    private ISkiCoachInfoService skiCoachInfoService;

    /**
     * 查询教练信息列表
     */
    @ApiOperation("查询教练信息列表")
    @GetMapping("/list")
    public TableDataInfo list(SkiCoachInfo skiCoachInfo) {
        startPage();
        List<SkiCoachInfo> list = skiCoachInfoService.selectSkiCoachInfoList(skiCoachInfo);
        return getDataTable(list);
    }

    /**
     * 获取当前登录教练的信息
     */
    @ApiOperation("获取当前登录教练的信息")
    @GetMapping("/current")
    public AjaxResult getCurrentCoachInfo() {
        Long userId = SecurityUtils.getUserId();
        SkiCoachInfo coachInfo = skiCoachInfoService.selectSkiCoachInfoByUserId(userId);
        if (coachInfo == null) {
            // 如果不存在，创建一个默认的教练信息
            coachInfo = new SkiCoachInfo();
            coachInfo.setUserId(userId);
            coachInfo.setCoachLevel("初级");
            coachInfo.setTeachingYears(0);
            coachInfo.setTotalStudents(0);
            coachInfo.setCurrentStudents(0);
            coachInfo.setTotalTeachingHours(0);
            coachInfo.setAverageRating(java.math.BigDecimal.ZERO);
            coachInfo.setRatingCount(0);
            coachInfo.setStatus("0");
            skiCoachInfoService.insertSkiCoachInfo(coachInfo);
        }
        return success(coachInfo);
    }

    /**
     * 获取教练信息详细信息
     */
    @ApiOperation("获取教练信息详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(skiCoachInfoService.selectSkiCoachInfoById(id));
    }

    /**
     * 新增教练信息
     */
    @PreAuthorize("@ss.hasPermi('system:coachInfo:add')")
    @Log(title = "教练信息", businessType = BusinessType.INSERT)
    @ApiOperation("新增教练信息")
    @PostMapping
    public AjaxResult add(@RequestBody SkiCoachInfo skiCoachInfo) {
        return toAjax(skiCoachInfoService.insertSkiCoachInfo(skiCoachInfo));
    }

    /**
     * 修改教练信息
     */
    @Log(title = "教练信息", businessType = BusinessType.UPDATE)
    @ApiOperation("修改教练信息")
    @PutMapping
    public AjaxResult edit(@RequestBody SkiCoachInfo skiCoachInfo) {
        // 确保只能修改自己的信息
        Long userId = SecurityUtils.getUserId();
        SkiCoachInfo existing = skiCoachInfoService.selectSkiCoachInfoByUserId(userId);
        if (existing != null && !existing.getUserId().equals(userId)) {
            return error("只能修改自己的教练信息");
        }
        if (skiCoachInfo.getUserId() == null) {
            skiCoachInfo.setUserId(userId);
        }
        return toAjax(skiCoachInfoService.updateSkiCoachInfo(skiCoachInfo));
    }

    /**
     * 删除教练信息
     */
    @PreAuthorize("@ss.hasPermi('system:coachInfo:remove')")
    @Log(title = "教练信息", businessType = BusinessType.DELETE)
    @ApiOperation("删除教练信息")
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(skiCoachInfoService.deleteSkiCoachInfoByIds(ids));
    }
}
