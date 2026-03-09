package com.ruoyi.system.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.dto.CoachRecommendationDTO;
import com.ruoyi.system.service.ICoachRecommendationService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 教练推荐Controller
 * 
 * @author ruoyi
 */
@Api(tags = "教练推荐管理")
@RestController
@RequestMapping("/system/coachRecommendation")
public class CoachRecommendationController extends BaseController {
    
    @Autowired
    private ICoachRecommendationService recommendationService;
    
    /**
     * 获取当前用户的教练推荐（混合推荐）
     */
    @ApiOperation("获取当前用户的教练推荐")
    @GetMapping("/recommend")
    public TableDataInfo getRecommendations(
            @RequestParam(required = false, defaultValue = "10") Integer topN,
            @RequestParam(required = false, defaultValue = "hybrid") String type) {
        Long userId = SecurityUtils.getUserId();
        List<CoachRecommendationDTO> recommendations;
        
        switch (type.toLowerCase()) {
            case "user":
                recommendations = recommendationService.recommendCoachesByUserCF(userId, topN);
                break;
            case "item":
                recommendations = recommendationService.recommendCoachesByItemCF(userId, topN);
                break;
            case "hybrid":
            default:
                recommendations = recommendationService.recommendCoachesHybrid(userId, topN);
                break;
        }
        
        return getDataTable(recommendations);
    }
    
    /**
     * 基于用户的协同过滤推荐
     */
    @ApiOperation("基于用户的协同过滤推荐")
    @GetMapping("/recommend/user")
    public TableDataInfo recommendByUserCF(
            @RequestParam(required = false, defaultValue = "10") Integer topN) {
        Long userId = SecurityUtils.getUserId();
        List<CoachRecommendationDTO> recommendations = 
            recommendationService.recommendCoachesByUserCF(userId, topN);
        return getDataTable(recommendations);
    }
    
    /**
     * 基于物品的协同过滤推荐
     */
    @ApiOperation("基于物品的协同过滤推荐")
    @GetMapping("/recommend/item")
    public TableDataInfo recommendByItemCF(
            @RequestParam(required = false, defaultValue = "10") Integer topN) {
        Long userId = SecurityUtils.getUserId();
        List<CoachRecommendationDTO> recommendations = 
            recommendationService.recommendCoachesByItemCF(userId, topN);
        return getDataTable(recommendations);
    }
    
    /**
     * 计算用户相似度
     */
    @ApiOperation("计算用户相似度")
    @GetMapping("/similarity/user")
    public AjaxResult calculateUserSimilarity(@RequestParam Long userId2) {
        Long userId1 = SecurityUtils.getUserId();
        Double similarity = recommendationService.calculateUserSimilarity(userId1, userId2);
        return success(similarity);
    }
    
    /**
     * 计算教练相似度
     */
    @ApiOperation("计算教练相似度")
    @GetMapping("/similarity/coach")
    public AjaxResult calculateCoachSimilarity(
            @RequestParam Long coachId1,
            @RequestParam Long coachId2) {
        Double similarity = recommendationService.calculateCoachSimilarity(coachId1, coachId2);
        return success(similarity);
    }
}
