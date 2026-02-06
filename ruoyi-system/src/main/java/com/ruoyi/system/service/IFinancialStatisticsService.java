package com.ruoyi.system.service;

import com.ruoyi.system.domain.dto.FinancialStatisticsDTO;
import java.util.Date;

/**
 * 财务统计服务接口
 * 
 * @author ruoyi
 */
public interface IFinancialStatisticsService {
    
    /**
     * 获取财务统计数据
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 财务统计数据
     */
    FinancialStatisticsDTO getFinancialStatistics(Date startDate, Date endDate);
}
