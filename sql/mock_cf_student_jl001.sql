-- ============================================
-- 【最终版】为 jl001（sys_user.user_id = 101）补充学员侧已支付预约
--
-- 作用：
-- 1) 让混合推荐能读到 student_id=101 且 payment_status='1' 的行为（非教练维度统计）。
-- 2) 第三条约教练 109，与 mock 中学员 116、117、127 等同选 109，提高用户 CF / 物品 CF 命中概率。
--
-- 重要：若界面仍「全员同分」，需同步部署后端 CoachRecommendationServiceImpl：
--       - getPopularCoaches 冷启动分数按名次递减（不再写死 0.5）
--       - recommendCoachesHybrid 末尾 spreadRecommendationScores 归一化/防全等
--
-- 前置：已执行 mock_users_for_recommendation / mock_courses_for_recommendation /
--       mock_data_for_recommendation
-- ============================================

-- 可重复执行：先删本脚本产生的数据
DELETE FROM `ski_course_appointment` WHERE `student_id` = 101 AND `schedule_id` IN (200, 201, 202);
DELETE FROM `ski_course_schedule` WHERE `id` IN (200, 201, 202);

-- 独立时间表，避免与 115 等学员占用同一 schedule
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`)
VALUES
(200, 10, '2026-02-10', '09:00:00', '11:00:00', 2, 1, '0', 'admin', NOW()),
(201, 13, '2026-02-11', '14:00:00', '16:00:00', 1, 1, '0', 'admin', NOW()),
(202, 14, '2026-02-15', '10:00:00', '11:30:00', 3, 1, '0', 'admin', NOW());

-- jl001 作为学员：105、108 与 A 组共性；109 与 116/117/127 等同选，利于协同过滤展示相似用户/教练数量
INSERT INTO `ski_course_appointment` (
  `course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`,
  `appointment_date`, `start_time`, `end_time`, `price`,
  `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`
) VALUES
(10, 200, 101, 'jl001', 105, '2026-02-10', '09:00:00', '11:00:00', 300.00, '1', '2', NOW(), '2', 'admin', NOW()),
(13, 201, 101, 'jl001', 108, '2026-02-11', '14:00:00', '16:00:00', 400.00, '1', '2', NOW(), '2', 'admin', NOW()),
(14, 202, 101, 'jl001', 109, '2026-02-15', '10:00:00', '11:30:00', 180.00, '1', '2', NOW(), '2', 'admin', NOW());

-- 与 mock_data_for_recommendation 一致：刷新教练累计学员数
UPDATE `ski_coach_info` SET `total_students` = (
  SELECT COUNT(DISTINCT `student_id`)
  FROM `ski_course_appointment`
  WHERE `coach_id` = `ski_coach_info`.`user_id`
    AND `payment_status` = '1'
) WHERE `user_id` BETWEEN 105 AND 114 OR `user_id` = 101;
