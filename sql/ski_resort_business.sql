-- ----------------------------
-- 滑雪场管理系统业务表SQL
-- 包含：雪具管理、雪具租赁、门票类型、门票订单、雪道管理
-- ----------------------------

-- ----------------------------
-- 1、雪具信息表
-- ----------------------------
DROP TABLE IF EXISTS `ski_equipment`;
CREATE TABLE `ski_equipment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '雪具ID',
  `equipment_code` varchar(50) NOT NULL COMMENT '雪具编号',
  `name` varchar(100) NOT NULL COMMENT '雪具名称',
  `category` char(1) NOT NULL COMMENT '雪具类型（1双板 2单板 3滑雪杖 4头盔 5护目镜 6滑雪服）',
  `brand` varchar(50) DEFAULT NULL COMMENT '品牌',
  `model` varchar(50) DEFAULT NULL COMMENT '型号',
  `size` varchar(50) DEFAULT NULL COMMENT '尺寸/规格',
  `color` varchar(20) DEFAULT NULL COMMENT '颜色',
  `purchase_price` decimal(10,2) DEFAULT NULL COMMENT '购买价格',
  `rental_price` decimal(10,2) DEFAULT NULL COMMENT '租赁价格（按天）',
  `image_url` varchar(500) DEFAULT NULL COMMENT '雪具图片',
  `total_quantity` int(11) NOT NULL DEFAULT '0' COMMENT '总库存数量',
  `available_quantity` int(11) DEFAULT '0' COMMENT '可用数量',
  `maintenance_quantity` int(11) DEFAULT '0' COMMENT '维修中数量',
  `rented_quantity` int(11) DEFAULT '0' COMMENT '已租数量',
  `scrap_quantity` int(11) DEFAULT '0' COMMENT '报废数量',
  `status` int(1) DEFAULT '1' COMMENT '状态（0缺货 1可用 2部分可用 3维修中）',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_code` (`equipment_code`),
  KEY `idx_category` (`category`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='雪具信息表';

-- ----------------------------
-- 初始化-雪具信息表数据
-- ----------------------------
INSERT INTO `ski_equipment` VALUES 
(1, 'EQ001', '专业双板滑雪板', '1', 'Salomon', 'X-Pro 90', '165cm', '黑色', 3500.00, 80.00, NULL, 50, 45, 2, 3, 0, 1, '专业级双板，适合中高级滑雪者', 'admin', NOW(), '', NULL, ''),
(2, 'EQ002', '入门双板滑雪板', '1', 'Rossignol', 'Experience 74', '160cm', '蓝色', 1800.00, 50.00, NULL, 80, 75, 1, 4, 0, 1, '入门级双板，适合初学者', 'admin', NOW(), '', NULL, ''),
(3, 'EQ003', '单板滑雪板', '2', 'Burton', 'Custom X', '158cm', '彩色', 4200.00, 100.00, NULL, 40, 35, 2, 3, 0, 1, '专业单板，适合高级玩家', 'admin', NOW(), '', NULL, ''),
(4, 'EQ004', '碳纤维滑雪杖', '3', 'Leki', 'Carbon', '130cm', '黑色', 800.00, 20.00, NULL, 100, 95, 0, 5, 0, 1, '轻量级碳纤维滑雪杖', 'admin', NOW(), '', NULL, ''),
(5, 'EQ005', '专业滑雪头盔', '4', 'Giro', 'Range MIPS', 'M', '白色', 1200.00, 30.00, NULL, 60, 55, 1, 4, 0, 1, '带MIPS保护系统的专业头盔', 'admin', NOW(), '', NULL, ''),
(6, 'EQ006', '防雾滑雪护目镜', '5', 'Oakley', 'Flight Deck', 'L', '黑色', 1500.00, 25.00, NULL, 70, 68, 0, 2, 0, 1, '防雾防紫外线护目镜', 'admin', NOW(), '', NULL, ''),
(7, 'EQ007', '专业滑雪服套装', '6', 'Arc''teryx', 'Rush', 'L', '红色', 3500.00, 60.00, NULL, 50, 48, 0, 2, 0, 1, '防水透气专业滑雪服', 'admin', NOW(), '', NULL, '');

-- ----------------------------
-- 2、雪具租赁表
-- ----------------------------
DROP TABLE IF EXISTS `ski_equipment_rental`;
CREATE TABLE `ski_equipment_rental` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '租赁ID',
  `rental_no` varchar(50) NOT NULL COMMENT '租赁单号',
  `equipment_id` bigint(20) NOT NULL COMMENT '雪具ID',
  `equipment_name` varchar(100) DEFAULT NULL COMMENT '雪具名称',
  `rental_quantity` int(11) NOT NULL DEFAULT '1' COMMENT '租赁数量',
  `renter_name` varchar(50) NOT NULL COMMENT '租赁人姓名',
  `renter_phone` varchar(20) NOT NULL COMMENT '租赁人电话',
  `renter_id_card` varchar(18) DEFAULT NULL COMMENT '租赁人身份证号',
  `rental_start_time` datetime NOT NULL COMMENT '租赁开始时间',
  `rental_end_time` datetime DEFAULT NULL COMMENT '租赁结束时间',
  `expected_return_time` datetime NOT NULL COMMENT '预计归还时间',
  `actual_return_time` datetime DEFAULT NULL COMMENT '实际归还时间',
  `rental_days` int(11) DEFAULT NULL COMMENT '租赁天数',
  `unit_price` decimal(10,2) DEFAULT NULL COMMENT '单价（每天）',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '总金额',
  `paid_amount` decimal(10,2) DEFAULT '0.00' COMMENT '已付金额',
  `deposit` decimal(10,2) DEFAULT '0.00' COMMENT '押金',
  `status` int(1) DEFAULT '0' COMMENT '状态（0待支付 1租赁中 2已归还 3已取消 4逾期）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_rental_no` (`rental_no`),
  KEY `idx_equipment_id` (`equipment_id`),
  KEY `idx_renter_phone` (`renter_phone`),
  KEY `idx_status` (`status`),
  KEY `idx_rental_start_time` (`rental_start_time`),
  CONSTRAINT `fk_rental_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `ski_equipment` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='雪具租赁表';

-- ----------------------------
-- 初始化-雪具租赁表数据
-- ----------------------------
INSERT INTO `ski_equipment_rental` VALUES 
(1, 'RN20250101001', 1, '专业双板滑雪板', 1, '张三', '13800138001', '110101199001011234', '2025-01-01 09:00:00', NULL, '2025-01-03 18:00:00', NULL, 2, 80.00, 160.00, 160.00, 500.00, 1, 'admin', NOW(), '', NULL, ''),
(2, 'RN20250101002', 3, '单板滑雪板', 1, '李四', '13800138002', '110101199002021234', '2025-01-01 10:00:00', NULL, '2025-01-02 18:00:00', NULL, 1, 100.00, 100.00, 100.00, 600.00, 1, 'admin', NOW(), '', NULL, ''),
(3, 'RN20250101003', 5, '专业滑雪头盔', 1, '王五', '13800138003', '110101199003031234', '2025-01-01 11:00:00', '2025-01-01 18:00:00', '2025-01-01 18:00:00', '2025-01-01 18:00:00', 1, 30.00, 30.00, 30.00, 200.00, 2, 'admin', NOW(), 'admin', NOW(), '已归还'),
(4, 'RN20250101004', 2, '入门双板滑雪板', 2, '赵六', '13800138004', '110101199004041234', '2025-01-01 14:00:00', NULL, '2025-01-05 18:00:00', NULL, 4, 50.00, 400.00, 0.00, 1000.00, 0, 'admin', NOW(), '', NULL, '');

-- ----------------------------
-- 3、门票类型表
-- ----------------------------
DROP TABLE IF EXISTS `ski_ticket_type`;
CREATE TABLE `ski_ticket_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '票种ID',
  `ticket_code` varchar(50) NOT NULL COMMENT '票种编码',
  `ticket_name` varchar(100) NOT NULL COMMENT '票种名称',
  `ticket_type` varchar(20) NOT NULL COMMENT '票种类型（1全天票 2半天票 3夜场票 4季票 5年票）',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `valid_days` int(11) DEFAULT 1 COMMENT '有效期（天）',
  `description` text COMMENT '票种描述',
  `image_url` varchar(500) DEFAULT NULL COMMENT '票种图片',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `sort_order` int(11) DEFAULT 0 COMMENT '排序',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ticket_code` (`ticket_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='门票类型表';

-- ----------------------------
-- 初始化-门票类型表数据
-- ----------------------------
INSERT INTO `ski_ticket_type` VALUES 
(1, 'TT001', '全天票', '1', 280.00, 1, '全天滑雪票，营业时间内可无限次使用', NULL, '0', 1, 'admin', NOW(), '', NULL, ''),
(2, 'TT002', '半天票（上午）', '2', 180.00, 1, '上午半天票，9:00-13:00有效', NULL, '0', 2, 'admin', NOW(), '', NULL, ''),
(3, 'TT003', '半天票（下午）', '2', 180.00, 1, '下午半天票，13:00-18:00有效', NULL, '0', 3, 'admin', NOW(), '', NULL, ''),
(4, 'TT004', '夜场票', '3', 120.00, 1, '夜场票，18:00-22:00有效', NULL, '0', 4, 'admin', NOW(), '', NULL, ''),
(5, 'TT005', '季票', '4', 3500.00, 90, '季度票，90天内无限次使用', NULL, '0', 5, 'admin', NOW(), '', NULL, ''),
(6, 'TT006', '年票', '5', 12000.00, 365, '年度票，一年内无限次使用', NULL, '0', 6, 'admin', NOW(), '', NULL, '');

-- ----------------------------
-- 4、门票订单表
-- ----------------------------
DROP TABLE IF EXISTS `ski_ticket_order`;
CREATE TABLE `ski_ticket_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) NOT NULL COMMENT '订单号',
  `ticket_type_id` bigint(20) NOT NULL COMMENT '票种ID',
  `ticket_type_name` varchar(100) DEFAULT NULL COMMENT '票种名称',
  `visitor_name` varchar(50) NOT NULL COMMENT '游客姓名',
  `visitor_phone` varchar(20) NOT NULL COMMENT '游客手机号',
  `visitor_id_card` varchar(18) DEFAULT NULL COMMENT '游客身份证号',
  `ticket_count` int(11) NOT NULL DEFAULT 1 COMMENT '购票数量',
  `unit_price` decimal(10,2) NOT NULL COMMENT '单价',
  `total_amount` decimal(10,2) NOT NULL COMMENT '总金额',
  `paid_amount` decimal(10,2) DEFAULT '0.00' COMMENT '已支付金额',
  `booking_date` date NOT NULL COMMENT '预订日期',
  `use_date` date DEFAULT NULL COMMENT '使用日期',
  `order_status` varchar(20) DEFAULT '0' COMMENT '订单状态（0待支付 1已支付 2已使用 3已退票 4已取消）',
  `payment_method` varchar(20) DEFAULT NULL COMMENT '支付方式（1现金 2微信 3支付宝 4银行卡）',
  `payment_time` datetime DEFAULT NULL COMMENT '支付时间',
  `refund_amount` decimal(10,2) DEFAULT '0.00' COMMENT '退款金额',
  `refund_reason` varchar(500) DEFAULT NULL COMMENT '退款原因',
  `refund_time` datetime DEFAULT NULL COMMENT '退款时间',
  `refund_status` varchar(20) DEFAULT '0' COMMENT '退款状态（0无退款 1退款中 2已退款 3退款失败）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_ticket_type_id` (`ticket_type_id`),
  KEY `idx_visitor_phone` (`visitor_phone`),
  KEY `idx_order_status` (`order_status`),
  KEY `idx_booking_date` (`booking_date`),
  CONSTRAINT `fk_ticket_order_type` FOREIGN KEY (`ticket_type_id`) REFERENCES `ski_ticket_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='门票订单表';

-- ----------------------------
-- 初始化-门票订单表数据
-- ----------------------------
INSERT INTO `ski_ticket_order` VALUES 
(1, 'TO20250101001', 1, '全天票', '张三', '13800138001', '110101199001011234', 2, 280.00, 560.00, 560.00, '2025-01-01', '2025-01-01', '2', '2', '2025-01-01 08:30:00', 0.00, NULL, NULL, '0', 'admin', NOW(), 'admin', NOW(), ''),
(2, 'TO20250101002', 2, '半天票（上午）', '李四', '13800138002', '110101199002021234', 1, 180.00, 180.00, 180.00, '2025-01-01', '2025-01-01', '2', '3', '2025-01-01 08:45:00', 0.00, NULL, NULL, '0', 'admin', NOW(), 'admin', NOW(), ''),
(3, 'TO20250101003', 1, '全天票', '王五', '13800138003', '110101199003031234', 1, 280.00, 280.00, 280.00, '2025-01-02', NULL, '1', '2', '2025-01-01 20:00:00', 0.00, NULL, NULL, '0', 'admin', NOW(), 'admin', NOW(), ''),
(4, 'TO20250101004', 4, '夜场票', '赵六', '13800138004', '110101199004041234', 3, 120.00, 360.00, 0.00, '2025-01-01', NULL, '0', NULL, NULL, 0.00, NULL, NULL, '0', 'admin', NOW(), '', NULL, ''),
(5, 'TO20250101005', 1, '全天票', '钱七', '13800138005', '110101199005051234', 1, 280.00, 280.00, 280.00, '2024-12-30', '2024-12-30', '3', '1', '2024-12-30 09:00:00', 280.00, '临时有事无法使用', '2024-12-30 10:00:00', '2', 'admin', NOW(), 'admin', NOW(), '已退票');

-- ----------------------------
-- 5、雪道信息表
-- ----------------------------
DROP TABLE IF EXISTS `ski_slope`;
CREATE TABLE `ski_slope` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '雪道ID',
  `name` varchar(100) NOT NULL COMMENT '雪道名称',
  `slope_code` varchar(50) NOT NULL COMMENT '雪道编号',
  `difficulty` varchar(20) NOT NULL COMMENT '难度等级（1初级 2中级 3高级）',
  `length` int(11) NOT NULL COMMENT '长度（米）',
  `width` int(11) NOT NULL COMMENT '宽度（米）',
  `max_capacity` int(11) NOT NULL COMMENT '最大容量（人）',
  `status` int(1) DEFAULT '1' COMMENT '状态（0关闭 1开放）',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `image_url` varchar(500) DEFAULT NULL COMMENT '雪道图片',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_slope_code` (`slope_code`),
  KEY `idx_difficulty` (`difficulty`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='雪道信息表';

-- ----------------------------
-- 初始化-雪道信息表数据
-- ----------------------------
INSERT INTO `ski_slope` VALUES 
(1, '初级雪道A', 'SLOPE001', '1', 300, 25, 80, 1, '适合初学者的平缓雪道，坡度较小，安全性高', NULL, 'admin', NOW(), '', NULL, ''),
(2, '初级雪道B', 'SLOPE002', '1', 350, 30, 100, 1, '初级雪道，适合有一定基础的初学者', NULL, 'admin', NOW(), '', NULL, ''),
(3, '中级雪道A', 'SLOPE003', '2', 500, 35, 120, 1, '中级雪道，坡度适中，适合中级滑雪者', NULL, 'admin', NOW(), '', NULL, ''),
(4, '中级雪道B', 'SLOPE004', '2', 600, 40, 150, 1, '中级雪道，有一定挑战性', NULL, 'admin', NOW(), '', NULL, ''),
(5, '高级雪道A', 'SLOPE005', '3', 800, 30, 80, 1, '高级雪道，坡度大，适合高级滑雪者', NULL, 'admin', NOW(), '', NULL, ''),
(6, '高级雪道B', 'SLOPE006', '3', 1000, 35, 100, 1, '专业级雪道，极具挑战性', NULL, 'admin', NOW(), '', NULL, ''),
(7, '练习雪道', 'SLOPE007', '1', 200, 20, 50, 1, '短距离练习雪道，适合新手练习', NULL, 'admin', NOW(), '', NULL, ''),
(8, '维修中雪道', 'SLOPE008', '2', 450, 30, 100, 0, '正在维修中，暂时关闭', NULL, 'admin', NOW(), '', NULL, '维修中');

COMMIT;
