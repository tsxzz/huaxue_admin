package com.ruoyi.system.service;

import com.ruoyi.system.domain.dto.CoachRecommendationDTO;
import java.util.List;

/**
 * 教练推荐服务接口
 * 基于协同过滤算法推荐教练
 * 
 * @author ruoyi
 */
public interface ICoachRecommendationService {
    
    /**
     * 基于用户的协同过滤推荐教练
     * 找到与当前用户相似的其他用户，推荐他们预约过的教练
     * 
     * @param userId 用户ID
     * @param topN 推荐数量，默认10
     * @return 推荐的教练列表
     */
    List<CoachRecommendationDTO> recommendCoachesByUserCF(Long userId, Integer topN);
    
    /**
     * 基于物品的协同过滤推荐教练
     * 找到与用户预约过的教练相似的教练
     * 
     * @param userId 用户ID
     * @param topN 推荐数量，默认10
     * @return 推荐的教练列表
     */
    List<CoachRecommendationDTO> recommendCoachesByItemCF(Long userId, Integer topN);
    
    /**
     * 混合推荐（结合用户CF和物品CF）
     * 
     * @param userId 用户ID
     * @param topN 推荐数量，默认10
     * @return 推荐的教练列表
     */
    List<CoachRecommendationDTO> recommendCoachesHybrid(Long userId, Integer topN);
    
    /**
     * 计算两个用户的相似度（余弦相似度）
     * 
     * @param userId1 用户1ID
     * @param userId2 用户2ID
     * @return 相似度（0-1之间）
     */
    Double calculateUserSimilarity(Long userId1, Long userId2);
    
    /**
     * 计算两个教练的相似度（余弦相似度）
     * 
     * @param coachId1 教练1ID
     * @param coachId2 教练2ID
     * @return 相似度（0-1之间）
     */
    Double calculateCoachSimilarity(Long coachId1, Long coachId2);
}
