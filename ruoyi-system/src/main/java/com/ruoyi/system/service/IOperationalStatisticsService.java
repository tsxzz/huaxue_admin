package com.ruoyi.system.service;

import com.ruoyi.system.domain.dto.OperationalStatisticsDTO;
import java.util.Date;

/**
 * 运营数据统计服务接口
 * 
 * @author ruoyi
 */
public interface IOperationalStatisticsService {
    
    /**
     * 获取运营统计数据
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @param type 统计类型（daily/weekly/monthly）
     * @return 运营统计数据
     */
    OperationalStatisticsDTO getOperationalStatistics(Date startDate, Date endDate, String type);
}
