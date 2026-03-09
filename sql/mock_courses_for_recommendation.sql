-- ============================================
-- 创建推荐算法测试所需的课程和时间表数据
-- ============================================

-- 1. 删除可能存在的测试课程数据
DELETE FROM `ski_course_schedule` WHERE `course_id` BETWEEN 10 AND 19;
DELETE FROM `ski_course` WHERE `id` BETWEEN 10 AND 19;

-- 2. 为每个教练创建课程（course_id: 10-19）
INSERT INTO `ski_course` (`id`, `coach_id`, `course_name`, `course_type`, `description`, `duration`, `price`, `max_students`, `status`, `create_by`, `create_time`) VALUES
-- 教练105（张教练-单板高级）的课程
(10, 105, '单板滑雪高级课程', '单板滑雪', '专业单板滑雪教学，适合有一定基础的学员', 120, 300.00, 2, '0', 'admin', NOW()),

-- 教练106（李教练-双板中级）的课程
(11, 106, '双板滑雪中级课程', '双板滑雪', '双板滑雪中级教学，特别适合儿童', 90, 200.00, 3, '0', 'admin', NOW()),

-- 教练107（王教练-双板高级）的课程
(12, 107, '双板滑雪高级课程', '双板滑雪', '双板滑雪高级技巧教学', 120, 350.00, 2, '0', 'admin', NOW()),

-- 教练108（刘教练-单板专业）的课程
(13, 108, '单板自由式滑雪', '单板滑雪', '自由式单板滑雪专业教学', 120, 400.00, 1, '0', 'admin', NOW()),

-- 教练109（陈教练-单板中级）的课程
(14, 109, '单板滑雪基础课程', '单板滑雪', '单板滑雪基础教学，适合初学者', 90, 180.00, 3, '0', 'admin', NOW()),

-- 教练110（赵教练-双板高级）的课程
(15, 110, '双板竞速滑雪', '双板滑雪', '双板竞速滑雪专业训练', 120, 320.00, 2, '0', 'admin', NOW()),

-- 教练111（孙教练-单板中级）的课程
(16, 111, '单板滑雪儿童课程', '单板滑雪', '单板滑雪儿童教学，耐心细致', 90, 220.00, 3, '0', 'admin', NOW()),

-- 教练112（周教练-双板高级）的课程
(17, 112, '双板特技滑雪', '双板滑雪', '双板特技滑雪高级教学', 120, 380.00, 1, '0', 'admin', NOW()),

-- 教练113（吴教练-双板中级）的课程
(18, 113, '双板滑雪基础课程', '双板滑雪', '双板滑雪基础教学', 90, 190.00, 3, '0', 'admin', NOW()),

-- 教练114（郑教练-双板专业）的课程
(19, 114, '双板全能课程', '双板滑雪', '双板滑雪全能教学，涵盖各种技巧', 120, 450.00, 1, '0', 'admin', NOW());

-- 3. 为每个课程创建多个时间表（schedule_id: 100-199）
-- 为课程10（教练105）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(100, 10, '2026-01-15', '09:00:00', '11:00:00', 2, 0, '0', 'admin', NOW()),
(101, 10, '2026-01-20', '14:00:00', '16:00:00', 2, 0, '0', 'admin', NOW()),
(102, 10, '2026-01-25', '09:00:00', '11:00:00', 2, 0, '0', 'admin', NOW());

-- 为课程11（教练106）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(103, 11, '2026-01-15', '09:00:00', '10:30:00', 3, 0, '0', 'admin', NOW()),
(104, 11, '2026-01-20', '14:00:00', '15:30:00', 3, 0, '0', 'admin', NOW()),
(105, 11, '2026-01-25', '09:00:00', '10:30:00', 3, 0, '0', 'admin', NOW());

-- 为课程12（教练107）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(106, 12, '2026-01-15', '09:00:00', '11:00:00', 2, 0, '0', 'admin', NOW()),
(107, 12, '2026-01-20', '14:00:00', '16:00:00', 2, 0, '0', 'admin', NOW()),
(108, 12, '2026-01-25', '09:00:00', '11:00:00', 2, 0, '0', 'admin', NOW());

-- 为课程13（教练108）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(109, 13, '2026-01-15', '09:00:00', '11:00:00', 1, 0, '0', 'admin', NOW()),
(110, 13, '2026-01-20', '14:00:00', '16:00:00', 1, 0, '0', 'admin', NOW()),
(111, 13, '2026-01-25', '09:00:00', '11:00:00', 1, 0, '0', 'admin', NOW());

-- 为课程14（教练109）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(112, 14, '2026-01-15', '09:00:00', '10:30:00', 3, 0, '0', 'admin', NOW()),
(113, 14, '2026-01-20', '10:00:00', '11:30:00', 3, 0, '0', 'admin', NOW()),
(114, 14, '2026-01-25', '09:00:00', '10:30:00', 3, 0, '0', 'admin', NOW());

-- 为课程15（教练110）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(115, 15, '2026-01-15', '09:00:00', '11:00:00', 2, 0, '0', 'admin', NOW()),
(116, 15, '2026-01-20', '10:00:00', '12:00:00', 2, 0, '0', 'admin', NOW()),
(117, 15, '2026-01-25', '09:00:00', '11:00:00', 2, 0, '0', 'admin', NOW());

-- 为课程16（教练111）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(118, 16, '2026-01-15', '09:00:00', '10:30:00', 3, 0, '0', 'admin', NOW()),
(119, 16, '2026-01-20', '15:00:00', '16:30:00', 3, 0, '0', 'admin', NOW()),
(120, 16, '2026-01-25', '09:00:00', '10:30:00', 3, 0, '0', 'admin', NOW());

-- 为课程17（教练112）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(121, 17, '2026-01-15', '09:00:00', '11:00:00', 1, 0, '0', 'admin', NOW()),
(122, 17, '2026-01-20', '15:00:00', '17:00:00', 1, 0, '0', 'admin', NOW()),
(123, 17, '2026-01-25', '09:00:00', '11:00:00', 1, 0, '0', 'admin', NOW());

-- 为课程18（教练113）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(124, 18, '2026-01-15', '09:00:00', '10:30:00', 3, 0, '0', 'admin', NOW()),
(125, 18, '2026-01-20', '14:00:00', '15:30:00', 3, 0, '0', 'admin', NOW()),
(126, 18, '2026-01-25', '09:00:00', '10:30:00', 3, 0, '0', 'admin', NOW());

-- 为课程19（教练114）创建时间表
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`) VALUES
(127, 19, '2026-01-15', '09:00:00', '11:00:00', 1, 0, '0', 'admin', NOW()),
(128, 19, '2026-01-20', '14:00:00', '16:00:00', 1, 0, '0', 'admin', NOW()),
(129, 19, '2026-01-25', '09:00:00', '11:00:00', 1, 0, '0', 'admin', NOW());

-- ============================================
-- 注意：此脚本需要配合 mock_data_for_recommendation.sql 使用
-- 请确保先执行此脚本创建课程和时间表，再执行预约数据脚本
-- ============================================
