-- 教练信息模拟数据
-- 注意：需要先有对应的用户ID，这里假设用户ID 101 是教练

INSERT INTO `ski_coach_info` (`user_id`, `coach_level`, `teaching_years`, `specialty`, `certificate`, `introduction`, `hourly_rate`, `total_students`, `current_students`, `total_teaching_hours`, `average_rating`, `rating_count`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(101, '高级', 8, '单板滑雪、双板滑雪、儿童教学', '{"certificates": ["国家滑雪教练证书", "国际滑雪教练认证", "儿童滑雪教学证书"]}', '我是一名经验丰富的滑雪教练，拥有8年的教学经验。擅长单板、双板滑雪教学，特别专注于儿童滑雪启蒙教育。我的教学理念是安全第一，循序渐进，让每个学员都能在轻松愉快的氛围中掌握滑雪技能。', 200.00, 156, 12, 1240, 4.85, 89, '0', 'admin', NOW(), 'admin', NOW(), '资深滑雪教练'),
(102, '中级', 5, '双板滑雪、进阶技巧', '{"certificates": ["国家滑雪教练证书", "双板滑雪高级认证"]}', '专注于双板滑雪教学，帮助学员从基础到进阶全面提升。', 150.00, 98, 8, 780, 4.72, 65, '0', 'admin', NOW(), 'admin', NOW(), NULL),
(103, '初级', 2, '单板滑雪、初学者指导', '{"certificates": ["国家滑雪教练证书"]}', '热情耐心的年轻教练，擅长单板滑雪教学，特别适合初学者。', 100.00, 45, 5, 320, 4.65, 32, '0', 'admin', NOW(), 'admin', NOW(), NULL);
