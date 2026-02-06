package com.ruoyi.system.service;

import com.ruoyi.system.domain.dto.CoachPerformanceDTO;
import java.time.LocalDate;

/**
 * 教练业绩Service接口
 * 
 * @author ruoyi
 */
public interface ICoachPerformanceService {
    /**
     * 获取教练业绩统计
     * 
     * @param coachId 教练ID（为空则查询当前登录教练）
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 业绩统计
     */
    public CoachPerformanceDTO getCoachPerformance(Long coachId, LocalDate startDate, LocalDate endDate);
}
