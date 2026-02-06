-- 课程模拟数据
INSERT INTO `ski_course` (`id`, `coach_id`, `course_name`, `course_type`, `description`, `duration`, `price`, `max_students`, `status`, `create_by`, `create_time`, `update_time`, `remark`) VALUES
(1, 3, '初级滑雪入门', '初级滑雪', '适合零基础学员，学习基本滑雪姿势和平衡技巧', 60, 200.00, 3, '0', 'coach1', NOW(), NOW(), NULL),
(2, 3, '中级滑雪进阶', '中级滑雪', '适合有一定基础的学员，学习转弯和速度控制', 90, 300.00, 2, '0', 'coach1', NOW(), NOW(), NULL),
(3, 4, '高级技巧训练', '高级技巧', '适合高级学员，学习跳跃、旋转等高难度动作', 120, 500.00, 1, '0', 'coach2', NOW(), NOW(), NULL),
(4, 4, '自由式滑雪', '自由式滑雪', '学习自由式滑雪技巧，包括各种花式动作', 90, 400.00, 2, '0', 'coach2', NOW(), NOW(), NULL),
(5, 5, '单板滑雪基础', '单板滑雪', '单板滑雪入门课程，学习基本滑行和控制', 60, 250.00, 3, '0', 'coach3', NOW(), NOW(), NULL),
(6, 5, '双板滑雪进阶', '双板滑雪', '双板滑雪进阶课程，学习平行转弯和速度控制', 90, 350.00, 2, '0', 'coach3', NOW(), NOW(), NULL);

-- 课程时间表模拟数据（未来7天的课程安排）
INSERT INTO `ski_course_schedule` (`id`, `course_id`, `schedule_date`, `start_time`, `end_time`, `available_slots`, `booked_slots`, `status`, `create_by`, `create_time`, `update_time`, `remark`) VALUES
-- 课程1的时间安排
(1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '10:00:00', 3, 0, '0', 'coach1', NOW(), NOW(), NULL),
(2, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', '15:00:00', 3, 1, '0', 'coach1', NOW(), NOW(), NULL),
(3, 1, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '09:00:00', '10:00:00', 3, 0, '0', 'coach1', NOW(), NOW(), NULL),
(4, 1, DATE_ADD(CURDATE(), INTERVAL 5 DAY), '14:00:00', '15:00:00', 3, 0, '0', 'coach1', NOW(), NOW(), NULL),
-- 课程2的时间安排
(5, 2, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '10:00:00', '11:30:00', 2, 0, '0', 'coach1', NOW(), NOW(), NULL),
(6, 2, DATE_ADD(CURDATE(), INTERVAL 4 DAY), '15:00:00', '16:30:00', 2, 1, '0', 'coach1', NOW(), NOW(), NULL),
-- 课程3的时间安排
(7, 3, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '13:00:00', '15:00:00', 1, 0, '0', 'coach2', NOW(), NOW(), NULL),
(8, 3, DATE_ADD(CURDATE(), INTERVAL 6 DAY), '13:00:00', '15:00:00', 1, 0, '0', 'coach2', NOW(), NOW(), NULL),
-- 课程4的时间安排
(9, 4, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '10:00:00', '11:30:00', 2, 0, '0', 'coach2', NOW(), NOW(), NULL),
(10, 4, DATE_ADD(CURDATE(), INTERVAL 5 DAY), '15:00:00', '16:30:00', 2, 0, '0', 'coach2', NOW(), NOW(), NULL),
-- 课程5的时间安排
(11, 5, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:00:00', '12:00:00', 3, 0, '0', 'coach3', NOW(), NOW(), NULL),
(12, 5, DATE_ADD(CURDATE(), INTERVAL 4 DAY), '09:00:00', '10:00:00', 3, 0, '0', 'coach3', NOW(), NOW(), NULL),
-- 课程6的时间安排
(13, 6, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '14:00:00', '15:30:00', 2, 0, '0', 'coach3', NOW(), NOW(), NULL),
(14, 6, DATE_ADD(CURDATE(), INTERVAL 6 DAY), '10:00:00', '11:30:00', 2, 0, '0', 'coach3', NOW(), NOW(), NULL);

-- 课程预约模拟数据
INSERT INTO `ski_course_appointment` (`id`, `course_id`, `schedule_id`, `student_id`, `student_name`, `coach_id`, `appointment_date`, `start_time`, `end_time`, `price`, `payment_status`, `status`, `create_by`, `create_time`, `update_time`, `remark`) VALUES
(1, 1, 2, 2, '游客1', 3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', '15:00:00', 200.00, '1', '1', 'student1', NOW(), NOW(), NULL),
(2, 2, 6, 2, '游客1', 3, DATE_ADD(CURDATE(), INTERVAL 4 DAY), '15:00:00', '16:30:00', 300.00, '1', '0', 'student1', NOW(), NOW(), NULL);
