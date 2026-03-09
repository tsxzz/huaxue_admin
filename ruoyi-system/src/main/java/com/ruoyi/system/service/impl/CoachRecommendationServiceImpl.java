package com.ruoyi.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.domain.SkiCoachInfo;
import com.ruoyi.system.domain.SkiCourseAppointment;
import com.ruoyi.system.domain.dto.CoachRecommendationDTO;
import com.ruoyi.system.mapper.SkiCoachInfoMapper;
import com.ruoyi.system.mapper.SkiCourseAppointmentMapper;
import com.ruoyi.system.service.ICoachRecommendationService;
import com.ruoyi.system.service.ISysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 教练推荐服务实现类
 * 实现基于协同过滤的推荐算法
 * 
 * @author ruoyi
 */
@Service
public class CoachRecommendationServiceImpl implements ICoachRecommendationService {
    
    @Autowired
    private SkiCourseAppointmentMapper appointmentMapper;
    
    @Autowired
    private SkiCoachInfoMapper coachInfoMapper;
    
    @Autowired
    private ISysUserService userService;
    
    /** 最小相似用户数（用于用户CF） */
    private static final int MIN_SIMILAR_USERS = 2;
    
    /** 最小相似教练数（用于物品CF） */
    private static final int MIN_SIMILAR_COACHES = 2;
    
    /** 默认推荐数量 */
    private static final int DEFAULT_TOP_N = 10;
    
    @Override
    public List<CoachRecommendationDTO> recommendCoachesByUserCF(Long userId, Integer topN) {
        if (topN == null || topN <= 0) {
            topN = DEFAULT_TOP_N;
        }
        
        // 1. 获取当前用户预约过的教练列表
        List<SkiCourseAppointment> userAppointments = getUserAppointments(userId);
        if (userAppointments.isEmpty()) {
            // 如果用户没有预约记录，返回热门教练
            return getPopularCoaches(topN);
        }
        
        Set<Long> userCoachIds = userAppointments.stream()
            .map(SkiCourseAppointment::getCoachId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        
        // 2. 获取所有其他用户的预约记录
        Map<Long, List<SkiCourseAppointment>> allUserAppointments = getAllUserAppointments(userId);
        
        // 3. 计算用户相似度
        Map<Long, Double> userSimilarities = new HashMap<>();
        for (Map.Entry<Long, List<SkiCourseAppointment>> entry : allUserAppointments.entrySet()) {
            Long otherUserId = entry.getKey();
            List<SkiCourseAppointment> otherAppointments = entry.getValue();
            
            double similarity = calculateUserSimilarity(userId, otherUserId);
            if (similarity > 0) {
                userSimilarities.put(otherUserId, similarity);
            }
        }
        
        // 4. 找到相似用户（相似度 > 0.1）
        List<Map.Entry<Long, Double>> similarUsers = userSimilarities.entrySet().stream()
            .filter(e -> e.getValue() > 0.1)
            .sorted((a, b) -> Double.compare(b.getValue(), a.getValue()))
            .limit(50) // 取前50个相似用户
            .collect(Collectors.toList());
        
        if (similarUsers.size() < MIN_SIMILAR_USERS) {
            return getPopularCoaches(topN);
        }
        
        // 5. 统计相似用户预约过的教练（加权）
        Map<Long, Double> coachScores = new HashMap<>();
        Map<Long, Integer> coachUserCounts = new HashMap<>();
        
        for (Map.Entry<Long, Double> similarUser : similarUsers) {
            Long similarUserId = similarUser.getKey();
            Double similarity = similarUser.getValue();
            
            List<SkiCourseAppointment> similarUserAppointments = allUserAppointments.get(similarUserId);
            for (SkiCourseAppointment appointment : similarUserAppointments) {
                Long coachId = appointment.getCoachId();
                if (coachId != null && !userCoachIds.contains(coachId)) {
                    // 未预约过的教练才推荐
                    coachScores.put(coachId, coachScores.getOrDefault(coachId, 0.0) + similarity);
                    coachUserCounts.put(coachId, coachUserCounts.getOrDefault(coachId, 0) + 1);
                }
            }
        }
        
        // 6. 生成推荐列表
        return buildRecommendationList(coachScores, coachUserCounts, topN, "基于相似用户的推荐");
    }
    
    @Override
    public List<CoachRecommendationDTO> recommendCoachesByItemCF(Long userId, Integer topN) {
        if (topN == null || topN <= 0) {
            topN = DEFAULT_TOP_N;
        }
        
        // 1. 获取当前用户预约过的教练列表
        List<SkiCourseAppointment> userAppointments = getUserAppointments(userId);
        if (userAppointments.isEmpty()) {
            return getPopularCoaches(topN);
        }
        
        Set<Long> userCoachIds = userAppointments.stream()
            .map(SkiCourseAppointment::getCoachId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        
        // 2. 获取所有教练的预约记录
        Map<Long, List<SkiCourseAppointment>> coachAppointments = getAllCoachAppointments();
        
        // 3. 对用户预约过的每个教练，找到相似教练
        Map<Long, Double> coachScores = new HashMap<>();
        Map<Long, Integer> coachSimilarCounts = new HashMap<>();
        
        for (Long userCoachId : userCoachIds) {
            // 计算与当前教练相似的其他教练
            Map<Long, Double> similarCoaches = new HashMap<>();
            
            for (Map.Entry<Long, List<SkiCourseAppointment>> entry : coachAppointments.entrySet()) {
                Long otherCoachId = entry.getKey();
                if (!otherCoachId.equals(userCoachId) && !userCoachIds.contains(otherCoachId)) {
                    double similarity = calculateCoachSimilarity(userCoachId, otherCoachId);
                    if (similarity > 0.1) {
                        similarCoaches.put(otherCoachId, similarity);
                    }
                }
            }
            
            // 将相似教练加入推荐列表（加权）
            for (Map.Entry<Long, Double> similarCoach : similarCoaches.entrySet()) {
                Long similarCoachId = similarCoach.getKey();
                Double similarity = similarCoach.getValue();
                
                coachScores.put(similarCoachId, 
                    coachScores.getOrDefault(similarCoachId, 0.0) + similarity);
                coachSimilarCounts.put(similarCoachId, 
                    coachSimilarCounts.getOrDefault(similarCoachId, 0) + 1);
            }
        }
        
        if (coachSimilarCounts.size() < MIN_SIMILAR_COACHES) {
            return getPopularCoaches(topN);
        }
        
        // 4. 生成推荐列表
        return buildRecommendationList(coachScores, coachSimilarCounts, topN, "基于相似教练的推荐");
    }
    
    @Override
    public List<CoachRecommendationDTO> recommendCoachesHybrid(Long userId, Integer topN) {
        if (topN == null || topN <= 0) {
            topN = DEFAULT_TOP_N;
        }
        
        // 获取用户CF和物品CF的推荐结果
        List<CoachRecommendationDTO> userCFResults = recommendCoachesByUserCF(userId, topN * 2);
        List<CoachRecommendationDTO> itemCFResults = recommendCoachesByItemCF(userId, topN * 2);
        
        // 合并推荐结果（加权平均）
        Map<Long, CoachRecommendationDTO> mergedResults = new HashMap<>();
        
        // 用户CF权重：0.6
        for (CoachRecommendationDTO dto : userCFResults) {
            Long coachId = dto.getCoachId();
            if (mergedResults.containsKey(coachId)) {
                CoachRecommendationDTO existing = mergedResults.get(coachId);
                existing.setRecommendationScore(
                    existing.getRecommendationScore() * 0.6 + dto.getRecommendationScore() * 0.6
                );
            } else {
                dto.setRecommendationScore(dto.getRecommendationScore() * 0.6);
                mergedResults.put(coachId, dto);
            }
        }
        
        // 物品CF权重：0.4
        for (CoachRecommendationDTO dto : itemCFResults) {
            Long coachId = dto.getCoachId();
            if (mergedResults.containsKey(coachId)) {
                CoachRecommendationDTO existing = mergedResults.get(coachId);
                existing.setRecommendationScore(
                    existing.getRecommendationScore() + dto.getRecommendationScore() * 0.4
                );
                existing.setRecommendationReason("混合推荐（用户相似度 + 教练相似度）");
            } else {
                dto.setRecommendationScore(dto.getRecommendationScore() * 0.4);
                dto.setRecommendationReason("基于相似教练的推荐");
                mergedResults.put(coachId, dto);
            }
        }
        
        // 排序并返回TopN
        return mergedResults.values().stream()
            .sorted((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()))
            .limit(topN)
            .collect(Collectors.toList());
    }
    
    @Override
    public Double calculateUserSimilarity(Long userId1, Long userId2) {
        // 获取两个用户的预约记录
        List<SkiCourseAppointment> user1Appointments = getUserAppointments(userId1);
        List<SkiCourseAppointment> user2Appointments = getUserAppointments(userId2);
        
        if (user1Appointments.isEmpty() || user2Appointments.isEmpty()) {
            return 0.0;
        }
        
        // 构建教练ID集合
        Set<Long> user1Coaches = user1Appointments.stream()
            .map(SkiCourseAppointment::getCoachId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        
        Set<Long> user2Coaches = user2Appointments.stream()
            .map(SkiCourseAppointment::getCoachId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        
        // 计算交集和并集
        Set<Long> intersection = new HashSet<>(user1Coaches);
        intersection.retainAll(user2Coaches);
        
        Set<Long> union = new HashSet<>(user1Coaches);
        union.addAll(user2Coaches);
        
        if (union.isEmpty()) {
            return 0.0;
        }
        
        // Jaccard相似度（交集/并集）
        return (double) intersection.size() / union.size();
    }
    
    @Override
    public Double calculateCoachSimilarity(Long coachId1, Long coachId2) {
        // 获取两个教练的学员集合
        Set<Long> coach1Students = getCoachStudents(coachId1);
        Set<Long> coach2Students = getCoachStudents(coachId2);
        
        if (coach1Students.isEmpty() || coach2Students.isEmpty()) {
            return 0.0;
        }
        
        // 计算交集和并集
        Set<Long> intersection = new HashSet<>(coach1Students);
        intersection.retainAll(coach2Students);
        
        Set<Long> union = new HashSet<>(coach1Students);
        union.addAll(coach2Students);
        
        if (union.isEmpty()) {
            return 0.0;
        }
        
        // Jaccard相似度
        return (double) intersection.size() / union.size();
    }
    
    /**
     * 获取用户的预约记录
     */
    private List<SkiCourseAppointment> getUserAppointments(Long userId) {
        LambdaQueryWrapper<SkiCourseAppointment> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiCourseAppointment::getStudentId, userId)
            .eq(SkiCourseAppointment::getPaymentStatus, "1") // 只考虑已支付的预约
            .isNotNull(SkiCourseAppointment::getCoachId);
        return appointmentMapper.selectList(wrapper);
    }
    
    /**
     * 获取所有其他用户的预约记录
     */
    private Map<Long, List<SkiCourseAppointment>> getAllUserAppointments(Long excludeUserId) {
        LambdaQueryWrapper<SkiCourseAppointment> wrapper = Wrappers.lambdaQuery();
        wrapper.ne(SkiCourseAppointment::getStudentId, excludeUserId)
            .eq(SkiCourseAppointment::getPaymentStatus, "1")
            .isNotNull(SkiCourseAppointment::getCoachId);
        
        List<SkiCourseAppointment> appointments = appointmentMapper.selectList(wrapper);
        
        return appointments.stream()
            .collect(Collectors.groupingBy(SkiCourseAppointment::getStudentId));
    }
    
    /**
     * 获取所有教练的预约记录
     */
    private Map<Long, List<SkiCourseAppointment>> getAllCoachAppointments() {
        LambdaQueryWrapper<SkiCourseAppointment> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiCourseAppointment::getPaymentStatus, "1")
            .isNotNull(SkiCourseAppointment::getCoachId);
        
        List<SkiCourseAppointment> appointments = appointmentMapper.selectList(wrapper);
        
        return appointments.stream()
            .collect(Collectors.groupingBy(SkiCourseAppointment::getCoachId));
    }
    
    /**
     * 获取教练的学员集合
     */
    private Set<Long> getCoachStudents(Long coachId) {
        LambdaQueryWrapper<SkiCourseAppointment> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiCourseAppointment::getCoachId, coachId)
            .eq(SkiCourseAppointment::getPaymentStatus, "1")
            .isNotNull(SkiCourseAppointment::getStudentId);
        
        List<SkiCourseAppointment> appointments = appointmentMapper.selectList(wrapper);
        
        return appointments.stream()
            .map(SkiCourseAppointment::getStudentId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
    }
    
    /**
     * 构建推荐列表
     */
    private List<CoachRecommendationDTO> buildRecommendationList(
            Map<Long, Double> coachScores,
            Map<Long, Integer> coachCounts,
            Integer topN,
            String reason) {
        
        // 获取所有教练信息
        LambdaQueryWrapper<SkiCoachInfo> wrapper = Wrappers.lambdaQuery(SkiCoachInfo.class);
        wrapper.eq(SkiCoachInfo::getStatus, "0"); // 只推荐正常状态的教练
        List<SkiCoachInfo> allCoaches = coachInfoMapper.selectList(wrapper);
        
        // 关联用户信息
        for (SkiCoachInfo coach : allCoaches) {
            if (coach.getUserId() != null && coach.getUser() == null) {
                SysUser user = userService.selectUserById(coach.getUserId());
                coach.setUser(user);
            }
        }
        
        // 使用userId作为key（因为coachId是教练信息表的ID，而预约表中存储的是userId）
        Map<Long, SkiCoachInfo> coachInfoMap = allCoaches.stream()
            .collect(Collectors.toMap(SkiCoachInfo::getUserId, c -> c));
        
        // 构建推荐DTO列表
        List<CoachRecommendationDTO> recommendations = new ArrayList<>();
        
        for (Map.Entry<Long, Double> entry : coachScores.entrySet()) {
            Long coachId = entry.getKey();
            Double score = entry.getValue();
            Integer count = coachCounts.getOrDefault(coachId, 0);
            
            SkiCoachInfo coachInfo = coachInfoMap.get(coachId);
            if (coachInfo == null) {
                continue;
            }
            
            // 关联用户信息
            if (coachInfo.getUserId() != null && coachInfo.getUser() == null) {
                SysUser user = userService.selectUserById(coachInfo.getUserId());
                coachInfo.setUser(user);
            }
            
            CoachRecommendationDTO dto = new CoachRecommendationDTO();
            dto.setCoachId(coachInfo.getId());
            dto.setUserId(coachInfo.getUserId());
            dto.setCoachName(coachInfo.getUser() != null ? 
                (coachInfo.getUser().getNickName() != null && !coachInfo.getUser().getNickName().isEmpty() ? 
                    coachInfo.getUser().getNickName() : coachInfo.getUser().getUserName()) : "");
            dto.setAvatar(coachInfo.getUser() != null ? coachInfo.getUser().getAvatar() : null);
            dto.setCoachLevel(coachInfo.getCoachLevel());
            dto.setSpecialty(coachInfo.getSpecialty());
            dto.setHourlyRate(coachInfo.getHourlyRate());
            dto.setAverageRating(coachInfo.getAverageRating());
            dto.setRecommendationScore(score);
            dto.setRecommendationReason(reason);
            
            if (reason.contains("用户")) {
                dto.setSimilarUserCount(count);
            } else {
                dto.setSimilarCoachCount(count);
            }
            
            recommendations.add(dto);
        }
        
        // 按推荐分数排序
        recommendations.sort((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()));
        
        return recommendations.stream().limit(topN).collect(Collectors.toList());
    }
    
    /**
     * 获取热门教练（作为冷启动推荐）
     */
    private List<CoachRecommendationDTO> getPopularCoaches(Integer topN) {
        LambdaQueryWrapper<SkiCoachInfo> wrapper = Wrappers.lambdaQuery(SkiCoachInfo.class);
        wrapper.eq(SkiCoachInfo::getStatus, "0")
            .orderByDesc(SkiCoachInfo::getTotalStudents)
            .orderByDesc(SkiCoachInfo::getAverageRating)
            .last("LIMIT " + topN);
        
        List<SkiCoachInfo> coaches = coachInfoMapper.selectList(wrapper);
        
        // 关联用户信息
        for (SkiCoachInfo coach : coaches) {
            if (coach.getUserId() != null && coach.getUser() == null) {
                SysUser user = userService.selectUserById(coach.getUserId());
                coach.setUser(user);
            }
        }
        
        return coaches.stream().map(coach -> {
            CoachRecommendationDTO dto = new CoachRecommendationDTO();
            dto.setCoachId(coach.getId());
            dto.setUserId(coach.getUserId());
            dto.setCoachName(coach.getUser() != null ? 
                (coach.getUser().getNickName() != null && !coach.getUser().getNickName().isEmpty() ? 
                    coach.getUser().getNickName() : coach.getUser().getUserName()) : "");
            dto.setAvatar(coach.getUser() != null ? coach.getUser().getAvatar() : null);
            dto.setCoachLevel(coach.getCoachLevel());
            dto.setSpecialty(coach.getSpecialty());
            dto.setHourlyRate(coach.getHourlyRate());
            dto.setAverageRating(coach.getAverageRating());
            dto.setRecommendationScore(0.5); // 默认分数
            dto.setRecommendationReason("热门教练推荐");
            return dto;
        }).collect(Collectors.toList());
    }
}
