-- ============================================
-- 协同过滤推荐算法模拟数据
-- 用于演示推荐算法的效果
-- ============================================

-- 1. 创建教练用户（user_id: 105-114，共10个教练）
-- 注意：这些用户需要在sys_user表中存在，如果不存在请先创建

-- 2. 插入教练信息数据
-- 删除可能存在的测试数据
DELETE FROM `ski_coach_info` WHERE `user_id` BETWEEN 105 AND 114;

INSERT INTO `ski_coach_info` (`user_id`, `coach_level`, `teaching_years`, `specialty`, `introduction`, `hourly_rate`, `total_students`, `current_students`, `total_teaching_hours`, `average_rating`, `rating_count`, `status`, `create_by`, `create_time`) VALUES
-- 教练1：张教练 - 高级单板教练
(105, '高级', 5, '单板滑雪 特技滑雪', '专业单板滑雪教练，擅长单板基础教学和特技动作，教学经验丰富。', 300.00, 0, 0, 0, 4.8, 0, '0', 'admin', NOW()),

-- 教练2：李教练 - 中级双板教练
(106, '中级', 3, '双板滑雪 儿童教学', '温和耐心的双板教练，特别擅长儿童滑雪教学，深受家长信赖。', 200.00, 0, 0, 0, 4.6, 0, '0', 'admin', NOW()),

-- 教练3：王教练 - 高级双板教练
(107, '高级', 6, '双板滑雪 高级技巧', '资深双板教练，精通各种双板技巧，帮助学员快速提升水平。', 350.00, 0, 0, 0, 4.9, 0, '0', 'admin', NOW()),

-- 教练4：刘教练 - 专业单板教练
(108, '专业', 8, '单板滑雪 自由式滑雪', '国家级单板教练，自由式滑雪专家，培养过多名优秀学员。', 400.00, 0, 0, 0, 5.0, 0, '0', 'admin', NOW()),

-- 教练5：陈教练 - 中级单板教练
(109, '中级', 2, '单板滑雪 基础教学', '年轻有活力的单板教练，教学方法新颖，适合初学者。', 180.00, 0, 0, 0, 4.5, 0, '0', 'admin', NOW()),

-- 教练6：赵教练 - 高级双板教练
(110, '高级', 4, '双板滑雪 竞速滑雪', '竞速滑雪专业教练，帮助学员提升速度和技巧。', 320.00, 0, 0, 0, 4.7, 0, '0', 'admin', NOW()),

-- 教练7：孙教练 - 中级单板教练
(111, '中级', 3, '单板滑雪 儿童教学', '耐心细致的单板教练，特别适合儿童和初学者。', 220.00, 0, 0, 0, 4.6, 0, '0', 'admin', NOW()),

-- 教练8：周教练 - 高级双板教练
(112, '高级', 5, '双板滑雪 特技滑雪', '双板特技教练，擅长各种高难度动作教学。', 380.00, 0, 0, 0, 4.8, 0, '0', 'admin', NOW()),

-- 教练9：吴教练 - 中级双板教练
(113, '中级', 2, '双板滑雪 基础教学', '基础教学专家，帮助学员打好扎实基础。', 190.00, 0, 0, 0, 4.4, 0, '0', 'admin', NOW()),

-- 教练10：郑教练 - 专业双板教练
(114, '专业', 7, '双板滑雪 自由式滑雪 竞速滑雪', '全能型双板教练，精通各种双板技巧和风格。', 450.00, 0, 0, 0, 4.9, 0, '0', 'admin', NOW());

-- 3. 创建课程数据（为每个教练创建至少1个课程）
-- 注意：需要先有ski_course表，如果不存在请先创建
-- 这里假设课程ID从1开始，每个教练有1个课程

-- 4. 创建课程时间表数据（schedule_id）
-- 注意：需要先有ski_course_schedule表
-- 这里假设schedule_id从1开始

-- 5. 插入课程预约数据（体现协同过滤效果）
-- 删除可能存在的测试数据
DELETE FROM `ski_course_appointment` WHERE `student_id` BETWEEN 115 AND 134 OR `coach_id` BETWEEN 105 AND 114;

-- 设计预约模式，体现协同过滤：
-- 用户组A（115-119）：都喜欢单板教练（105, 108, 109）
-- 用户组B（120-124）：都喜欢双板教练（106, 107, 110）
-- 用户组C（125-129）：混合偏好
-- 用户组D（130-134）：新用户，预约较少

-- 用户115：预约过教练105（单板）、108（单板）
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(10, 100, 115, '学员115', 105, '2026-01-15', '09:00:00', '11:00:00', 300.00, '1', '2', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00'),
(13, 110, 115, '学员115', 108, '2026-01-20', '14:00:00', '16:00:00', 400.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户116：预约过教练105（单板）、109（单板）- 与115相似
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(10, 101, 116, '学员116', 105, '2026-01-20', '14:00:00', '16:00:00', 300.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00'),
(14, 113, 116, '学员116', 109, '2026-01-20', '10:00:00', '11:30:00', 180.00, '1', '3', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户117：预约过教练108（单板）、109（单板）- 与115、116相似
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(13, 110, 117, '学员117', 108, '2026-01-20', '14:00:00', '16:00:00', 400.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00'),
(14, 114, 117, '学员117', 109, '2026-01-25', '09:00:00', '10:30:00', 180.00, '1', '3', '2026-01-24 20:00:00', '2', 'admin', '2026-01-24 20:00:00');

-- 用户118：预约过教练105（单板）、111（单板）- 与115、116、117相似
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(10, 102, 118, '学员118', 105, '2026-01-25', '09:00:00', '11:00:00', 300.00, '1', '2', '2026-01-24 20:00:00', '2', 'admin', '2026-01-24 20:00:00'),
(16, 119, 118, '学员118', 111, '2026-01-20', '15:00:00', '16:30:00', 220.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户119：预约过教练108（单板）、111（单板）- 与115、117、118相似
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(13, 111, 119, '学员119', 108, '2026-01-25', '09:00:00', '11:00:00', 400.00, '1', '2', '2026-01-24 20:00:00', '2', 'admin', '2026-01-24 20:00:00'),
(16, 120, 119, '学员119', 111, '2026-01-25', '09:00:00', '10:30:00', 220.00, '1', '3', '2026-01-24 20:00:00', '2', 'admin', '2026-01-24 20:00:00');

-- 用户120：预约过教练106（双板）、107（双板）- 双板用户组
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(11, 103, 120, '学员120', 106, '2026-01-15', '09:00:00', '10:30:00', 200.00, '1', '2', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00'),
(12, 107, 120, '学员120', 107, '2026-01-20', '14:00:00', '16:00:00', 350.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户121：预约过教练106（双板）、110（双板）- 与120相似
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(11, 104, 121, '学员121', 106, '2026-01-20', '14:00:00', '15:30:00', 200.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00'),
(15, 116, 121, '学员121', 110, '2026-01-20', '10:00:00', '12:00:00', 320.00, '1', '3', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户122：预约过教练107（双板）、110（双板）- 与120、121相似
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(12, 108, 122, '学员122', 107, '2026-01-25', '09:00:00', '11:00:00', 350.00, '1', '2', '2026-01-24 20:00:00', '2', 'admin', '2026-01-24 20:00:00'),
(15, 117, 122, '学员122', 110, '2026-01-25', '09:00:00', '11:00:00', 320.00, '1', '3', '2026-01-24 20:00:00', '2', 'admin', '2026-01-24 20:00:00');

-- 用户123：预约过教练106（双板）、112（双板）- 与120、121相似
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(11, 105, 123, '学员123', 106, '2026-01-25', '09:00:00', '10:30:00', 200.00, '1', '2', '2026-01-24 20:00:00', '2', 'admin', '2026-01-24 20:00:00'),
(17, 122, 123, '学员123', 112, '2026-01-20', '15:00:00', '17:00:00', 380.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户124：预约过教练107（双板）、112（双板）- 与120、122、123相似
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(12, 107, 124, '学员124', 107, '2026-01-20', '14:00:00', '16:00:00', 350.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00'),
(17, 123, 124, '学员124', 112, '2026-01-25', '09:00:00', '11:00:00', 380.00, '1', '3', '2026-01-24 20:00:00', '2', 'admin', '2026-01-24 20:00:00');

-- 用户125：混合偏好 - 预约过教练105（单板）、106（双板）
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(10, 100, 125, '学员125', 105, '2026-01-15', '09:00:00', '11:00:00', 300.00, '1', '2', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00'),
(11, 104, 125, '学员125', 106, '2026-01-20', '14:00:00', '15:30:00', 200.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户126：混合偏好 - 预约过教练108（单板）、107（双板）
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(13, 110, 126, '学员126', 108, '2026-01-20', '14:00:00', '16:00:00', 400.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00'),
(12, 106, 126, '学员126', 107, '2026-01-15', '09:00:00', '11:00:00', 350.00, '1', '3', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00');

-- 用户127：混合偏好 - 预约过教练109（单板）、110（双板）
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(14, 112, 127, '学员127', 109, '2026-01-15', '09:00:00', '10:30:00', 180.00, '1', '2', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00'),
(15, 115, 127, '学员127', 110, '2026-01-15', '09:00:00', '11:00:00', 320.00, '1', '3', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00');

-- 用户128：混合偏好 - 预约过教练111（单板）、112（双板）
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(16, 118, 128, '学员128', 111, '2026-01-15', '09:00:00', '10:30:00', 220.00, '1', '2', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00'),
(17, 121, 128, '学员128', 112, '2026-01-15', '09:00:00', '11:00:00', 380.00, '1', '3', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00');

-- 用户129：混合偏好 - 预约过教练105（单板）、113（双板）
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(10, 101, 129, '学员129', 105, '2026-01-20', '14:00:00', '16:00:00', 300.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00'),
(18, 125, 129, '学员129', 113, '2026-01-20', '14:00:00', '15:30:00', 190.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户130：新用户 - 只预约过1个教练
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(10, 100, 130, '学员130', 105, '2026-01-15', '09:00:00', '11:00:00', 300.00, '1', '2', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00');

-- 用户131：新用户 - 只预约过1个教练
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(11, 103, 131, '学员131', 106, '2026-01-15', '09:00:00', '10:30:00', 200.00, '1', '2', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00');

-- 用户132：新用户 - 只预约过1个教练
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(13, 110, 132, '学员132', 108, '2026-01-20', '14:00:00', '16:00:00', 400.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户133：新用户 - 只预约过1个教练
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(12, 107, 133, '学员133', 107, '2026-01-20', '14:00:00', '16:00:00', 350.00, '1', '2', '2026-01-19 20:00:00', '2', 'admin', '2026-01-19 20:00:00');

-- 用户134：新用户 - 只预约过1个教练
INSERT INTO `ski_course_appointment` (`course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `payment_method`, `payment_time`, `status`, `create_by`, `create_time`) VALUES
(15, 115, 134, '学员134', 110, '2026-01-15', '09:00:00', '11:00:00', 320.00, '1', '3', '2026-01-14 20:00:00', '2', 'admin', '2026-01-14 20:00:00');

-- 6. 更新教练的累计学员数（根据预约记录统计）
UPDATE `ski_coach_info` SET `total_students` = (
    SELECT COUNT(DISTINCT `student_id`) 
    FROM `ski_course_appointment` 
    WHERE `coach_id` = `ski_coach_info`.`user_id` 
    AND `payment_status` = '1'
) WHERE `user_id` BETWEEN 105 AND 114;

-- ============================================
-- 数据说明：
-- ============================================
-- 1. 用户组A（115-119）：都喜欢单板教练
--    - 用户115、116、117、118、119都预约过单板教练（105、108、109、111）
--    - 这些用户之间相似度高，会互相推荐单板教练
--
-- 2. 用户组B（120-124）：都喜欢双板教练
--    - 用户120、121、122、123、124都预约过双板教练（106、107、110、112）
--    - 这些用户之间相似度高，会互相推荐双板教练
--
-- 3. 用户组C（125-129）：混合偏好
--    - 这些用户既预约过单板教练，也预约过双板教练
--    - 推荐结果会比较多样化
--
-- 4. 用户组D（130-134）：新用户
--    - 每个用户只预约过1个教练
--    - 数据较少，主要用于测试冷启动场景
--
-- 5. 教练相似性：
--    - 教练105、108、109、111都是单板教练，有共同学员（115、116、117、118、119）
--    - 教练106、107、110、112都是双板教练，有共同学员（120、121、122、123、124）
--    - 这些教练之间相似度高，会互相推荐
--
-- ============================================
-- 测试场景：
-- ============================================
-- 场景1：用户115登录，查看推荐
--   预期：推荐单板教练（109、111），因为相似用户116、117、118、119都喜欢这些教练
--
-- 场景2：用户120登录，查看推荐
--   预期：推荐双板教练（107、110、112），因为相似用户121、122、123、124都喜欢这些教练
--
-- 场景3：用户125登录，查看推荐
--   预期：推荐结果会比较多样化，因为该用户既有单板也有双板偏好
--
-- 场景4：用户130登录，查看推荐
--   预期：可能推荐热门教练，因为该用户数据较少（冷启动问题）
-- ============================================
