package com.ruoyi.system.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.dto.CoachPerformanceDTO;
import com.ruoyi.system.service.ICoachPerformanceService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

/**
 * 教练业绩Controller
 * 
 * @author ruoyi
 */
@Api(tags = "教练业绩管理")
@RestController
@RequestMapping("/system/coachPerformance")
public class CoachPerformanceController extends BaseController {
    @Autowired
    private ICoachPerformanceService coachPerformanceService;

    /**
     * 获取教练业绩统计
     */
    @ApiOperation("获取教练业绩统计")
    @GetMapping("/statistics")
    public AjaxResult getStatistics(
            @RequestParam(required = false) Long coachId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        // 如果不是管理员，只能查询自己的业绩
        if (!SecurityUtils.isAdmin() && coachId != null && !coachId.equals(SecurityUtils.getUserId())) {
            return error("无权查看其他教练的业绩");
        }
        // 如果不是管理员且没有指定coachId，使用当前用户
        if (!SecurityUtils.isAdmin() && coachId == null) {
            coachId = SecurityUtils.getUserId();
        }
        CoachPerformanceDTO performance = coachPerformanceService.getCoachPerformance(coachId, startDate, endDate);
        return success(performance);
    }
}
