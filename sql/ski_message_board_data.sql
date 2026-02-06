-- 留言板模拟数据
-- 注意：执行前请确保已创建 ski_message_board 和 ski_message_like 表

-- 插入主留言数据
INSERT INTO `ski_message_board` (`user_id`, `user_name`, `content`, `parent_id`, `like_count`, `reply_count`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2, '游客001', '今天滑雪场天气真好！雪质也很棒，推荐大家来玩！', NULL, 5, 3, '0', 'tourist001', NOW(), 'tourist001', NOW(), NULL),
(3, '游客002', '请问滑雪场有教练可以预约吗？我是初学者，想找个教练指导一下。', NULL, 2, 2, '0', 'tourist002', DATE_SUB(NOW(), INTERVAL 1 DAY), 'tourist002', DATE_SUB(NOW(), INTERVAL 1 DAY), NULL),
(4, '游客003', '昨天在这里玩了一天，体验非常棒！工作人员服务态度也很好，点赞！', NULL, 8, 1, '0', 'tourist003', DATE_SUB(NOW(), INTERVAL 2 DAY), 'tourist003', DATE_SUB(NOW(), INTERVAL 2 DAY), NULL),
(5, '教练001', '大家好，我是滑雪教练，有需要预约课程的可以联系我。我会根据学员的水平制定合适的教学计划。', NULL, 12, 5, '0', 'coach001', DATE_SUB(NOW(), INTERVAL 3 DAY), 'coach001', DATE_SUB(NOW(), INTERVAL 3 DAY), NULL),
(2, '游客001', '雪具租赁的价格是多少？需要提前预约吗？', NULL, 3, 2, '0', 'tourist001', DATE_SUB(NOW(), INTERVAL 4 DAY), 'tourist001', DATE_SUB(NOW(), INTERVAL 4 DAY), NULL),
(6, '前台001', '感谢大家的支持！我们会继续努力为大家提供更好的服务。如有任何问题，欢迎随时咨询前台。', NULL, 15, 4, '0', 'frontdesk001', DATE_SUB(NOW(), INTERVAL 5 DAY), 'frontdesk001', DATE_SUB(NOW(), INTERVAL 5 DAY), NULL);

-- 插入回复数据（假设上面插入的主留言ID从1开始）
-- 注意：实际执行时，parent_id需要根据实际插入后的主留言ID进行调整
INSERT INTO `ski_message_board` (`user_id`, `user_name`, `content`, `parent_id`, `like_count`, `reply_count`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(3, '游客002', '是的，今天天气确实不错！我也在，要不要一起滑？', 1, 1, 0, '0', 'tourist002', DATE_SUB(NOW(), INTERVAL 1 HOUR), 'tourist002', DATE_SUB(NOW(), INTERVAL 1 HOUR), NULL),
(4, '游客003', '同感！雪质确实很好，我已经滑了好几圈了。', 1, 0, 0, '0', 'tourist003', DATE_SUB(NOW(), INTERVAL 2 HOUR), 'tourist003', DATE_SUB(NOW(), INTERVAL 2 HOUR), NULL),
(5, '教练001', '可以预约的，您可以在系统中预约，或者直接到前台咨询。', 2, 2, 0, '0', 'coach001', DATE_SUB(NOW(), INTERVAL 1 DAY), 'coach001', DATE_SUB(NOW(), INTERVAL 1 DAY), NULL),
(6, '前台001', '是的，我们有专业的教练团队，可以为您提供一对一的指导服务。', 2, 1, 0, '0', 'frontdesk001', DATE_SUB(NOW(), INTERVAL 1 DAY), 'frontdesk001', DATE_SUB(NOW(), INTERVAL 1 DAY), NULL),
(2, '游客001', '谢谢分享！我也准备去试试。', 3, 0, 0, '0', 'tourist001', DATE_SUB(NOW(), INTERVAL 2 DAY), 'tourist001', DATE_SUB(NOW(), INTERVAL 2 DAY), NULL),
(3, '游客002', '请问教练，初学者一般需要几节课？', 4, 1, 0, '0', 'tourist002', DATE_SUB(NOW(), INTERVAL 3 DAY), 'tourist002', DATE_SUB(NOW(), INTERVAL 3 DAY), NULL),
(4, '游客003', '我也想了解雪具租赁的信息，同问！', 5, 0, 0, '0', 'tourist003', DATE_SUB(NOW(), INTERVAL 4 DAY), 'tourist003', DATE_SUB(NOW(), INTERVAL 4 DAY), NULL),
(6, '前台001', '雪具租赁价格根据类型不同，单次租赁8折优惠，全天租赁7折优惠。可以提前预约，也可以现场租赁。', 5, 2, 0, '0', 'frontdesk001', DATE_SUB(NOW(), INTERVAL 4 DAY), 'frontdesk001', DATE_SUB(NOW(), INTERVAL 4 DAY), NULL);

-- 插入点赞数据（模拟用户点赞）
-- 注意：message_id和user_id需要根据实际情况调整
INSERT INTO `ski_message_like` (`message_id`, `user_id`, `create_time`) VALUES
(1, 3, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(1, 4, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(1, 5, DATE_SUB(NOW(), INTERVAL 3 HOUR)),
(1, 6, DATE_SUB(NOW(), INTERVAL 4 HOUR)),
(1, 2, DATE_SUB(NOW(), INTERVAL 5 HOUR)),
(2, 4, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 5, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(3, 2, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 3, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 4, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 5, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 6, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(4, 2, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, 3, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, 4, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, 5, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, 6, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(5, 3, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(5, 4, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(5, 5, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(6, 2, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(6, 3, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(6, 4, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(6, 5, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(6, 6, DATE_SUB(NOW(), INTERVAL 5 DAY));
