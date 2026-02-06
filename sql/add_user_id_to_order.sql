-- 为订单表添加用户ID字段
-- 用于区分不同用户的订单

ALTER TABLE `ski_ticket_order` 
ADD COLUMN `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户ID（订单所属用户）' AFTER `order_no`;

-- 添加索引以提高查询性能
ALTER TABLE `ski_ticket_order` 
ADD INDEX `idx_user_id` (`user_id`);

-- 如果已有订单数据，可以将 create_by 对应的用户ID更新到 user_id 字段
-- 注意：这需要根据实际情况调整，因为 create_by 存储的是用户名，需要关联 sys_user 表获取用户ID
-- UPDATE ski_ticket_order sto 
-- INNER JOIN sys_user su ON sto.create_by = su.user_name 
-- SET sto.user_id = su.user_id 
-- WHERE sto.user_id IS NULL;
