package com.ruoyi.system.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.dto.FinancialStatisticsDTO;
import com.ruoyi.system.service.IFinancialStatisticsService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

/**
 * 财务统计Controller
 * 
 * @author ruoyi
 */
@Api(tags = "财务统计管理")
@RestController
@RequestMapping("/system/financialStatistics")
public class FinancialStatisticsController extends BaseController {
    
    @Autowired
    private IFinancialStatisticsService financialStatisticsService;
    
    /**
     * 获取财务统计数据
     */
    @ApiOperation("获取财务统计数据")
    @GetMapping("/statistics")
    public AjaxResult getStatistics(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        FinancialStatisticsDTO statistics = financialStatisticsService.getFinancialStatistics(startDate, endDate);
        return AjaxResult.success(statistics);
    }
}
