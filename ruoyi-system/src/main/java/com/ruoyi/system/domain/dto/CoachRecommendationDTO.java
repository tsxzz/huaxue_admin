package com.ruoyi.system.domain.dto;

import java.math.BigDecimal;

/**
 * 教练推荐DTO
 * 
 * @author ruoyi
 */
public class CoachRecommendationDTO {
    
    /** 教练ID */
    private Long coachId;
    
    /** 教练用户ID */
    private Long userId;
    
    /** 教练姓名 */
    private String coachName;
    
    /** 教练头像 */
    private String avatar;
    
    /** 教练等级 */
    private String coachLevel;
    
    /** 擅长领域 */
    private String specialty;
    
    /** 课时费 */
    private BigDecimal hourlyRate;
    
    /** 平均评分 */
    private BigDecimal averageRating;
    
    /** 推荐分数（0-1之间，越高越推荐） */
    private Double recommendationScore;
    
    /** 推荐理由 */
    private String recommendationReason;
    
    /** 相似用户数量（用于用户CF） */
    private Integer similarUserCount;
    
    /** 相似教练数量（用于物品CF） */
    private Integer similarCoachCount;

    public Long getCoachId() {
        return coachId;
    }

    public void setCoachId(Long coachId) {
        this.coachId = coachId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getCoachName() {
        return coachName;
    }

    public void setCoachName(String coachName) {
        this.coachName = coachName;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getCoachLevel() {
        return coachLevel;
    }

    public void setCoachLevel(String coachLevel) {
        this.coachLevel = coachLevel;
    }

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public BigDecimal getHourlyRate() {
        return hourlyRate;
    }

    public void setHourlyRate(BigDecimal hourlyRate) {
        this.hourlyRate = hourlyRate;
    }

    public BigDecimal getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(BigDecimal averageRating) {
        this.averageRating = averageRating;
    }

    public Double getRecommendationScore() {
        return recommendationScore;
    }

    public void setRecommendationScore(Double recommendationScore) {
        this.recommendationScore = recommendationScore;
    }

    public String getRecommendationReason() {
        return recommendationReason;
    }

    public void setRecommendationReason(String recommendationReason) {
        this.recommendationReason = recommendationReason;
    }

    public Integer getSimilarUserCount() {
        return similarUserCount;
    }

    public void setSimilarUserCount(Integer similarUserCount) {
        this.similarUserCount = similarUserCount;
    }

    public Integer getSimilarCoachCount() {
        return similarCoachCount;
    }

    public void setSimilarCoachCount(Integer similarCoachCount) {
        this.similarCoachCount = similarCoachCount;
    }
}
