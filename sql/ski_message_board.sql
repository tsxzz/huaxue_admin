-- 留言板表
CREATE TABLE IF NOT EXISTS `ski_message_board` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '留言ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID（发布者）',
  `user_name` varchar(64) DEFAULT NULL COMMENT '用户名（冗余字段，方便查询）',
  `content` text NOT NULL COMMENT '留言内容',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父留言ID（用于回复，NULL表示主留言）',
  `like_count` int(11) DEFAULT '0' COMMENT '点赞数',
  `reply_count` int(11) DEFAULT '0' COMMENT '回复数',
  `status` varchar(20) DEFAULT '0' COMMENT '状态（0正常 1删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='留言板表';

-- 留言点赞表（记录用户点赞情况，防止重复点赞）
CREATE TABLE IF NOT EXISTS `ski_message_like` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
  `message_id` bigint(20) NOT NULL COMMENT '留言ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID（点赞者）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_message_user` (`message_id`, `user_id`),
  KEY `idx_message_id` (`message_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='留言点赞表';
