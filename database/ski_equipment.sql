-- ----------------------------
-- 雪具信息表
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
  `scrap_quantity` int(11) DEFAULT '0' COMMENT '报废数量',
  `status` char(1) DEFAULT '1' COMMENT '状态（0缺货 1可用 2部分可用 3维修中）',
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
