-- ============================================
-- 创建推荐算法测试所需的用户数据
-- 包括教练用户和学员用户
-- ============================================

-- 注意：密码都是 '123456' 的加密值（使用BCrypt加密）
-- 如果需要修改密码，请使用系统提供的密码加密工具

-- 1. 创建教练用户（user_id: 105-114，共10个）
-- 删除可能存在的测试用户
DELETE FROM `sys_user_role` WHERE `user_id` BETWEEN 105 AND 134;
DELETE FROM `sys_user` WHERE `user_id` BETWEEN 105 AND 134;

-- 插入教练用户
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
-- 教练1：张教练（单板高级）
(105, NULL, 'coach_zhang', '张教练', '00', 'coach_zhang@example.com', '13800000105', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 教练2：李教练（双板中级）
(106, NULL, 'coach_li', '李教练', '00', 'coach_li@example.com', '13800000106', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 教练3：王教练（双板高级）
(107, NULL, 'coach_wang', '王教练', '00', 'coach_wang@example.com', '13800000107', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 教练4：刘教练（单板专业）
(108, NULL, 'coach_liu', '刘教练', '00', 'coach_liu@example.com', '13800000108', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 教练5：陈教练（单板中级）
(109, NULL, 'coach_chen', '陈教练', '00', 'coach_chen@example.com', '13800000109', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 教练6：赵教练（双板高级）
(110, NULL, 'coach_zhao', '赵教练', '00', 'coach_zhao@example.com', '13800000110', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 教练7：孙教练（单板中级）
(111, NULL, 'coach_sun', '孙教练', '00', 'coach_sun@example.com', '13800000111', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 教练8：周教练（双板高级）
(112, NULL, 'coach_zhou', '周教练', '00', 'coach_zhou@example.com', '13800000112', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 教练9：吴教练（双板中级）
(113, NULL, 'coach_wu', '吴教练', '00', 'coach_wu@example.com', '13800000113', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 教练10：郑教练（双板专业）
(114, NULL, 'coach_zheng', '郑教练', '00', 'coach_zheng@example.com', '13800000114', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 2. 创建学员用户（user_id: 115-134，共20个）
-- 学员115-119：单板偏好组
(115, NULL, 'student115', '学员115', '00', 'student115@example.com', '13900000115', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(116, NULL, 'student116', '学员116', '00', 'student116@example.com', '13900000116', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(117, NULL, 'student117', '学员117', '00', 'student117@example.com', '13900000117', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(118, NULL, 'student118', '学员118', '00', 'student118@example.com', '13900000118', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(119, NULL, 'student119', '学员119', '00', 'student119@example.com', '13900000119', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 学员120-124：双板偏好组
(120, NULL, 'student120', '学员120', '00', 'student120@example.com', '13900000120', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(121, NULL, 'student121', '学员121', '00', 'student121@example.com', '13900000121', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(122, NULL, 'student122', '学员122', '00', 'student122@example.com', '13900000122', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(123, NULL, 'student123', '学员123', '00', 'student123@example.com', '13900000123', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(124, NULL, 'student124', '学员124', '00', 'student124@example.com', '13900000124', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 学员125-129：混合偏好组
(125, NULL, 'student125', '学员125', '00', 'student125@example.com', '13900000125', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(126, NULL, 'student126', '学员126', '00', 'student126@example.com', '13900000126', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(127, NULL, 'student127', '学员127', '00', 'student127@example.com', '13900000127', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(128, NULL, 'student128', '学员128', '00', 'student128@example.com', '13900000128', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(129, NULL, 'student129', '学员129', '00', 'student129@example.com', '13900000129', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),

-- 学员130-134：新用户组（数据较少）
(130, NULL, 'student130', '学员130', '00', 'student130@example.com', '13900000130', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(131, NULL, 'student131', '学员131', '00', 'student131@example.com', '13900000131', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(132, NULL, 'student132', '学员132', '00', 'student132@example.com', '13900000132', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(133, NULL, 'student133', '学员133', '00', 'student133@example.com', '13900000133', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL),
(134, NULL, 'student134', '学员134', '00', 'student134@example.com', '13900000134', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', NULL, NULL, 'admin', NOW(), '', NULL, NULL);

-- 3. 分配角色（假设角色ID 100是游客角色，101是教练角色）
-- 注意：请根据实际的角色ID调整
-- 教练用户分配教练角色
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(105, 101), (106, 101), (107, 101), (108, 101), (109, 101),
(110, 101), (111, 101), (112, 101), (113, 101), (114, 101);

-- 学员用户分配游客角色
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(115, 100), (116, 100), (117, 100), (118, 100), (119, 100),
(120, 100), (121, 100), (122, 100), (123, 100), (124, 100),
(125, 100), (126, 100), (127, 100), (128, 100), (129, 100),
(130, 100), (131, 100), (132, 100), (133, 100), (134, 100);

-- ============================================
-- 使用说明：
-- ============================================
-- 1. 先执行此脚本创建用户数据
-- 2. 再执行 mock_data_for_recommendation.sql 创建教练信息和预约数据
-- 3. 所有用户的默认密码都是：123456
-- 4. 如果需要修改角色ID，请根据实际的sys_role表中的role_id调整
-- ============================================
