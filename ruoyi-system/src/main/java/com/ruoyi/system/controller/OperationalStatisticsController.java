package com.ruoyi.system.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.dto.OperationalStatisticsDTO;
import com.ruoyi.system.service.IOperationalStatisticsService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

/**
 * 运营数据统计Controller
 * 
 * @author ruoyi
 */
@Api(tags = "运营数据统计管理")
@RestController
@RequestMapping("/system/operationalStatistics")
public class OperationalStatisticsController extends BaseController {
    
    @Autowired
    private IOperationalStatisticsService operationalStatisticsService;
    
    /**
     * 获取运营统计数据
     */
    @ApiOperation("获取运营统计数据")
    @GetMapping("/statistics")
    public AjaxResult getStatistics(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            @RequestParam(defaultValue = "daily") String type) {
        OperationalStatisticsDTO statistics = operationalStatisticsService.getOperationalStatistics(startDate, endDate, type);
        return AjaxResult.success(statistics);
    }
}
