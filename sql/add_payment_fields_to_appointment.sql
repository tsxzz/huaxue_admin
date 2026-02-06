-- 为课程预约表添加支付相关字段
ALTER TABLE `ski_course_appointment` 
ADD COLUMN `payment_method` varchar(20) DEFAULT NULL COMMENT '支付方式（1现金 2微信 3支付宝 4银行卡）' AFTER `payment_status`,
ADD COLUMN `payment_time` datetime DEFAULT NULL COMMENT '支付时间' AFTER `payment_method`;
