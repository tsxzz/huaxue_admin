-- 课程表
CREATE TABLE IF NOT EXISTS `ski_course` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `coach_id` bigint(20) NOT NULL COMMENT '教练ID（关联sys_user表）',
  `course_name` varchar(100) NOT NULL COMMENT '课程名称',
  `course_type` varchar(50) DEFAULT NULL COMMENT '课程类型（如：初级滑雪、中级滑雪、高级技巧等）',
  `description` text COMMENT '课程描述',
  `duration` int(11) DEFAULT 60 COMMENT '课程时长（分钟）',
  `price` decimal(10,2) NOT NULL COMMENT '课程价格（元）',
  `max_students` int(11) DEFAULT 1 COMMENT '最大学员数',
  `status` varchar(20) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_coach_id` (`coach_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表';

-- 课程时间表
CREATE TABLE IF NOT EXISTS `ski_course_schedule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '时间表ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `schedule_date` date NOT NULL COMMENT '课程日期',
  `start_time` time NOT NULL COMMENT '开始时间',
  `end_time` time NOT NULL COMMENT '结束时间',
  `available_slots` int(11) DEFAULT 1 COMMENT '可预约名额',
  `booked_slots` int(11) DEFAULT 0 COMMENT '已预约名额',
  `status` varchar(20) DEFAULT '0' COMMENT '状态（0可预约 1已满 2已取消）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_schedule_date` (`schedule_date`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程时间表';

-- 课程预约表
CREATE TABLE IF NOT EXISTS `ski_course_appointment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `schedule_id` bigint(20) NOT NULL COMMENT '时间表ID',
  `student_id` bigint(20) NOT NULL COMMENT '学员ID（关联sys_user表）',
  `student_name` varchar(50) DEFAULT NULL COMMENT '学员姓名',
  `coach_id` bigint(20) NOT NULL COMMENT '教练ID',
  `appointment_date` date NOT NULL COMMENT '预约日期',
  `start_time` time NOT NULL COMMENT '开始时间',
  `end_time` time NOT NULL COMMENT '结束时间',
  `price` decimal(10,2) NOT NULL COMMENT '预约价格',
  `payment_status` varchar(20) DEFAULT '0' COMMENT '支付状态（0未支付 1已支付 2已退款）',
  `status` varchar(20) DEFAULT '0' COMMENT '预约状态（0待确认 1已确认 2已完成 3已取消）',
  `cancel_reason` varchar(500) DEFAULT NULL COMMENT '取消原因',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_schedule_id` (`schedule_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_coach_id` (`coach_id`),
  KEY `idx_appointment_date` (`appointment_date`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程预约表';
