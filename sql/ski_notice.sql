-- 通知管理表
CREATE TABLE IF NOT EXISTS `ski_notice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `notice_title` varchar(200) NOT NULL COMMENT '通知标题',
  `notice_type` varchar(20) NOT NULL DEFAULT '1' COMMENT '通知类型（1通知 2公告）',
  `notice_content` text COMMENT '通知内容',
  `status` varchar(20) DEFAULT '0' COMMENT '状态（0正常 1关闭）',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `priority` int(11) DEFAULT '0' COMMENT '优先级（0普通 1重要 2紧急）',
  `read_count` int(11) DEFAULT '0' COMMENT '阅读次数',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_notice_type` (`notice_type`),
  KEY `idx_status` (`status`),
  KEY `idx_publish_time` (`publish_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知管理表';
