-- 物资管理模拟数据
-- 注意：执行前请确保已创建相关表

-- 插入物资数据
INSERT INTO `ski_material` (`material_code`, `material_name`, `material_type`, `specification`, `unit`, `manufacturer`, `batch_number`, `production_date`, `expiry_date`, `safety_stock`, `current_stock`, `unit_price`, `storage_location`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
('MAT001', '创可贴', '2', '5cm×7cm', '盒', '云南白药', 'BATCH20260101', '2026-01-01', '2028-01-01', 50, 120, 15.00, 'A区-1号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL),
('MAT002', '碘伏', '2', '500ml', '瓶', '海氏海诺', 'BATCH20260115', '2026-01-15', '2028-01-15', 30, 45, 25.00, 'A区-1号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL),
('MAT003', '医用纱布', '2', '10cm×10cm', '包', '稳健医疗', 'BATCH20260201', '2026-02-01', '2028-02-01', 40, 60, 12.00, 'A区-2号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL),
('MAT004', '速效救心丸', '1', '30粒/盒', '盒', '天津中新药业', 'BATCH20251201', '2025-12-01', '2027-12-01', 20, 35, 28.00, 'B区-1号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL),
('MAT005', '硝酸甘油片', '1', '0.5mg×100片', '瓶', '北京益民', 'BATCH20251115', '2025-11-15', '2027-11-15', 15, 25, 35.00, 'B区-1号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL),
('MAT006', '云南白药气雾剂', '1', '85g', '瓶', '云南白药', 'BATCH20260120', '2026-01-20', '2028-01-20', 25, 8, 42.00, 'B区-2号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL),
('MAT007', '体温计', '2', '电子式', '支', '欧姆龙', 'BATCH20260205', '2026-02-05', '2028-02-05', 10, 15, 65.00, 'C区-1号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL),
('MAT008', '血压计', '2', '电子式', '台', '鱼跃医疗', 'BATCH20260110', '2026-01-10', '2028-01-10', 5, 8, 280.00, 'C区-1号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL),
('MAT009', '一次性注射器', '2', '5ml', '支', '三鑫医疗', 'BATCH20260210', '2026-02-10', '2028-02-10', 100, 150, 2.50, 'A区-3号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL),
('MAT010', '医用胶带', '2', '2.5cm×5m', '卷', '3M', 'BATCH20260125', '2026-01-25', '2028-01-25', 30, 50, 8.00, 'A区-2号柜', '0', 'admin', NOW(), 'admin', NOW(), NULL);

-- 插入出入库记录数据
INSERT INTO `ski_material_stock` (`material_id`, `material_code`, `material_name`, `operation_type`, `quantity`, `unit_price`, `total_amount`, `batch_number`, `production_date`, `expiry_date`, `operator_id`, `operator_name`, `operation_time`, `supplier`, `purpose`, `create_by`, `create_time`) VALUES
(1, 'MAT001', '创可贴', '1', 100, 15.00, 1500.00, 'BATCH20260101', '2026-01-01', '2028-01-01', 1, 'admin', DATE_SUB(NOW(), INTERVAL 10 DAY), '医疗器械供应商A', NULL, 'admin', DATE_SUB(NOW(), INTERVAL 10 DAY)),
(1, 'MAT001', '创可贴', '2', 20, NULL, NULL, NULL, NULL, NULL, 1, 'admin', DATE_SUB(NOW(), INTERVAL 5 DAY), NULL, '日常使用', 'admin', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(2, 'MAT002', '碘伏', '1', 50, 25.00, 1250.00, 'BATCH20260115', '2026-01-15', '2028-01-15', 1, 'admin', DATE_SUB(NOW(), INTERVAL 8 DAY), '医疗器械供应商A', NULL, 'admin', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(2, 'MAT002', '碘伏', '2', 5, NULL, NULL, NULL, NULL, NULL, 1, 'admin', DATE_SUB(NOW(), INTERVAL 3 DAY), NULL, '急救使用', 'admin', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, 'MAT004', '速效救心丸', '1', 30, 28.00, 840.00, 'BATCH20251201', '2025-12-01', '2027-12-01', 1, 'admin', DATE_SUB(NOW(), INTERVAL 15 DAY), '药品供应商B', NULL, 'admin', DATE_SUB(NOW(), INTERVAL 15 DAY)),
(4, 'MAT004', '速效救心丸', '2', 5, NULL, NULL, NULL, NULL, NULL, 1, 'admin', DATE_SUB(NOW(), INTERVAL 2 DAY), NULL, '紧急情况使用', 'admin', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(6, 'MAT006', '云南白药气雾剂', '1', 30, 42.00, 1260.00, 'BATCH20260120', '2026-01-20', '2028-01-20', 1, 'admin', DATE_SUB(NOW(), INTERVAL 7 DAY), '药品供应商B', NULL, 'admin', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(6, 'MAT006', '云南白药气雾剂', '2', 22, NULL, NULL, NULL, NULL, NULL, 1, 'admin', DATE_SUB(NOW(), INTERVAL 1 DAY), NULL, '运动损伤处理', 'admin', DATE_SUB(NOW(), INTERVAL 1 DAY));

-- 插入领用记录数据
INSERT INTO `ski_material_usage` (`material_id`, `material_code`, `material_name`, `quantity`, `user_id`, `user_name`, `department`, `usage_purpose`, `usage_time`, `return_status`, `approval_status`, `create_by`, `create_time`) VALUES
(1, 'MAT001', '创可贴', 10, 2, '游客001', '前台', '日常急救使用', DATE_SUB(NOW(), INTERVAL 3 DAY), '0', '1', 'tourist001', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 'MAT002', '碘伏', 2, 3, '游客002', '前台', '伤口消毒', DATE_SUB(NOW(), INTERVAL 2 DAY), '0', '1', 'tourist002', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 'MAT003', '医用纱布', 5, 4, '游客003', '前台', '包扎使用', DATE_SUB(NOW(), INTERVAL 1 DAY), '0', '0', 'tourist003', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(7, 'MAT007', '体温计', 1, 5, '教练001', '教练部', '测量体温', DATE_SUB(NOW(), INTERVAL 5 DAY), '1', '1', 'coach001', DATE_SUB(NOW(), INTERVAL 5 DAY));
