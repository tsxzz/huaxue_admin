/*
 Navicat Premium Dump SQL

 Source Server         : data
 Source Server Type    : MySQL
 Source Server Version : 80045 (8.0.45)
 Source Host           : localhost:3306
 Source Schema         : ry-vue

 Target Server Type    : MySQL
 Target Server Version : 80045 (8.0.45)
 File Encoding         : 65001

 Date: 13/02/2026 20:21:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for ski_coach_info
-- ----------------------------
DROP TABLE IF EXISTS `ski_coach_info`;
CREATE TABLE `ski_coach_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '教练信息ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（关联sys_user表）',
  `coach_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '初级' COMMENT '教练等级（初级、中级、高级、专业）',
  `teaching_years` int NULL DEFAULT 0 COMMENT '教学年限',
  `specialty` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '擅长领域（如：单板、双板、儿童教学等）',
  `certificate` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '专业证书（JSON格式存储证书信息）',
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '个人简介',
  `hourly_rate` decimal(10, 2) NULL DEFAULT NULL COMMENT '课时费（元/小时）',
  `total_students` int NULL DEFAULT 0 COMMENT '累计学员数',
  `current_students` int NULL DEFAULT 0 COMMENT '当前学员数',
  `total_teaching_hours` int NULL DEFAULT 0 COMMENT '累计教学时长（小时）',
  `average_rating` decimal(3, 2) NULL DEFAULT 0.00 COMMENT '平均评分（0-5分）',
  `rating_count` int NULL DEFAULT 0 COMMENT '评价数量',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_coach_level`(`coach_level` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '教练信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_coach_info
-- ----------------------------
INSERT INTO `ski_coach_info` VALUES (1, 101, '高级', 3, '单板滑雪 双板滑雪 特技滑雪 ', '国家滑雪教练证书', '我将用我毕生所学 教会你', 288.00, 0, 0, 0, 0.00, 0, '0', '', NULL, '', NULL, NULL);

-- ----------------------------
-- Table structure for ski_course
-- ----------------------------
DROP TABLE IF EXISTS `ski_course`;
CREATE TABLE `ski_course`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `coach_id` bigint NOT NULL COMMENT '教练ID（关联sys_user表）',
  `course_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课程名称',
  `course_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '课程类型（如：初级滑雪、中级滑雪、高级技巧等）',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '课程描述',
  `duration` int NULL DEFAULT 60 COMMENT '课程时长（分钟）',
  `price` decimal(10, 2) NOT NULL COMMENT '课程价格（元）',
  `max_students` int NULL DEFAULT 1 COMMENT '最大学员数',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coach_id`(`coach_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_course
-- ----------------------------
INSERT INTO `ski_course` VALUES (1, 3, '初级滑雪入门', '初级滑雪', '适合零基础学员，学习基本滑雪姿势和平衡技巧', 60, 200.00, 3, '0', 'coach1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course` VALUES (2, 3, '中级滑雪进阶', '中级滑雪', '适合有一定基础的学员，学习转弯和速度控制', 90, 300.00, 2, '0', 'coach1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course` VALUES (3, 4, '高级技巧训练', '高级技巧', '适合高级学员，学习跳跃、旋转等高难度动作', 120, 500.00, 1, '0', 'coach2', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course` VALUES (4, 4, '自由式滑雪', '自由式滑雪', '学习自由式滑雪技巧，包括各种花式动作', 90, 400.00, 2, '0', 'coach2', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course` VALUES (5, 5, '单板滑雪基础', '单板滑雪', '单板滑雪入门课程，学习基本滑行和控制', 60, 250.00, 3, '0', 'coach3', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course` VALUES (6, 5, '双板滑雪进阶', '双板滑雪', '双板滑雪进阶课程，学习平行转弯和速度控制', 90, 350.00, 2, '0', 'coach3', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course` VALUES (8, 101, '儿童课程', '初级滑雪', '针对儿童的课程', 60, 200.00, 4, '0', '', NULL, '', NULL, NULL);
INSERT INTO `ski_course` VALUES (9, 101, '测试课程建设', '双板滑雪', '给一个字  夯', 60, 0.00, 4, '0', '', NULL, '', NULL, NULL);

-- ----------------------------
-- Table structure for ski_course_appointment
-- ----------------------------
DROP TABLE IF EXISTS `ski_course_appointment`;
CREATE TABLE `ski_course_appointment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `schedule_id` bigint NOT NULL COMMENT '时间表ID',
  `student_id` bigint NOT NULL COMMENT '学员ID（关联sys_user表）',
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学员姓名',
  `coach_id` bigint NOT NULL COMMENT '教练ID',
  `appointment_date` date NOT NULL COMMENT '预约日期',
  `start_time` time NOT NULL COMMENT '开始时间',
  `end_time` time NOT NULL COMMENT '结束时间',
  `price` decimal(10, 2) NOT NULL COMMENT '预约价格',
  `payment_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '支付状态（0未支付 1已支付 2已退款）',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付方式（1现金 2微信 3支付宝 4银行卡）',
  `payment_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '预约状态（0待确认 1已确认 2已完成 3已取消）',
  `cancel_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '取消原因',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course_id`(`course_id` ASC) USING BTREE,
  INDEX `idx_schedule_id`(`schedule_id` ASC) USING BTREE,
  INDEX `idx_student_id`(`student_id` ASC) USING BTREE,
  INDEX `idx_coach_id`(`coach_id` ASC) USING BTREE,
  INDEX `idx_appointment_date`(`appointment_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程预约表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_course_appointment
-- ----------------------------
INSERT INTO `ski_course_appointment` VALUES (1, 1, 2, 2, '游客1', 3, '2026-02-07', '14:00:00', '15:00:00', 200.00, '1', NULL, NULL, '1', NULL, 'student1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_appointment` VALUES (2, 2, 6, 2, '游客1', 3, '2026-02-10', '15:00:00', '16:30:00', 300.00, '1', NULL, NULL, '0', NULL, 'student1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_appointment` VALUES (3, 8, 15, 1, '若依', 101, '2026-02-01', '11:30:12', '11:30:12', 200.00, '1', '2', '2026-02-06 11:46:24', '2', NULL, '', NULL, '', NULL, NULL);
INSERT INTO `ski_course_appointment` VALUES (4, 9, 17, 100, 'yk001', 101, '2026-02-13', '19:44:06', '20:44:06', 0.00, '1', '2', '2026-02-13 19:46:29', '2', NULL, '', NULL, '', NULL, NULL);

-- ----------------------------
-- Table structure for ski_course_schedule
-- ----------------------------
DROP TABLE IF EXISTS `ski_course_schedule`;
CREATE TABLE `ski_course_schedule`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '时间表ID',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `schedule_date` date NOT NULL COMMENT '课程日期',
  `start_time` time NOT NULL COMMENT '开始时间',
  `end_time` time NOT NULL COMMENT '结束时间',
  `available_slots` int NULL DEFAULT 1 COMMENT '可预约名额',
  `booked_slots` int NULL DEFAULT 0 COMMENT '已预约名额',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0可预约 1已满 2已取消）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course_id`(`course_id` ASC) USING BTREE,
  INDEX `idx_schedule_date`(`schedule_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程时间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_course_schedule
-- ----------------------------
INSERT INTO `ski_course_schedule` VALUES (1, 1, '2026-02-07', '09:00:00', '10:00:00', 3, 0, '0', 'coach1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (2, 1, '2026-02-07', '14:00:00', '15:00:00', 3, 1, '0', 'coach1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (3, 1, '2026-02-09', '09:00:00', '10:00:00', 3, 0, '0', 'coach1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (4, 1, '2026-02-11', '14:00:00', '15:00:00', 3, 0, '0', 'coach1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (5, 2, '2026-02-08', '10:00:00', '11:30:00', 2, 0, '0', 'coach1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (6, 2, '2026-02-10', '15:00:00', '16:30:00', 2, 1, '0', 'coach1', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (7, 3, '2026-02-08', '13:00:00', '15:00:00', 1, 0, '0', 'coach2', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (8, 3, '2026-02-12', '13:00:00', '15:00:00', 1, 0, '0', 'coach2', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (9, 4, '2026-02-09', '10:00:00', '11:30:00', 2, 0, '0', 'coach2', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (10, 4, '2026-02-11', '15:00:00', '16:30:00', 2, 0, '0', 'coach2', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (11, 5, '2026-02-07', '11:00:00', '12:00:00', 3, 0, '0', 'coach3', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (12, 5, '2026-02-10', '09:00:00', '10:00:00', 3, 0, '0', 'coach3', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (13, 6, '2026-02-08', '14:00:00', '15:30:00', 2, 0, '0', 'coach3', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (14, 6, '2026-02-12', '10:00:00', '11:30:00', 2, 0, '0', 'coach3', '2026-02-06 11:15:45', '', '2026-02-06 11:15:45', NULL);
INSERT INTO `ski_course_schedule` VALUES (15, 8, '2026-02-01', '11:30:12', '11:30:12', 2, 1, '0', '', NULL, '', NULL, NULL);
INSERT INTO `ski_course_schedule` VALUES (16, 8, '2026-02-07', '11:30:37', '12:30:37', 2, 0, '0', '', NULL, '', NULL, NULL);
INSERT INTO `ski_course_schedule` VALUES (17, 9, '2026-02-13', '19:44:06', '20:44:06', 3, 1, '0', '', NULL, '', NULL, NULL);
INSERT INTO `ski_course_schedule` VALUES (18, 9, '2026-02-26', '19:45:20', '20:45:20', 1, 0, '0', '', NULL, '', NULL, NULL);

-- ----------------------------
-- Table structure for ski_equipment
-- ----------------------------
DROP TABLE IF EXISTS `ski_equipment`;
CREATE TABLE `ski_equipment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '雪具ID',
  `equipment_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '雪具编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '雪具名称',
  `category` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '雪具类型（1双板 2单板 3滑雪杖 4头盔 5护目镜 6滑雪服）',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '品牌',
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '型号',
  `size` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '尺寸/规格',
  `color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '颜色',
  `purchase_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '购买价格',
  `rental_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '租赁价格（按天）',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '雪具图片',
  `total_quantity` int NOT NULL DEFAULT 0 COMMENT '总库存数量',
  `available_quantity` int NULL DEFAULT 0 COMMENT '可用数量',
  `maintenance_quantity` int NULL DEFAULT 0 COMMENT '维修中数量',
  `rented_quantity` int NULL DEFAULT 0 COMMENT '已租数量',
  `scrap_quantity` int NULL DEFAULT 0 COMMENT '报废数量',
  `status` int NULL DEFAULT 1 COMMENT '状态（0缺货 1可用 2部分可用 3维修中）',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_equipment_code`(`equipment_code` ASC) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '雪具信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_equipment
-- ----------------------------
INSERT INTO `ski_equipment` VALUES (1, 'EQ001', '专业双板滑雪板', '1', 'Salomon', 'X-Pro 90', '165cm', '黑色', 3500.00, 80.00, '/profile/upload/2026/02/05/生成动漫雪道图片 (10)_20260205111959A013.png', 50, 46, 2, 2, 0, 2, '专业级双板，适合中高级滑雪者', 'admin', '2026-02-04 23:24:21', '', '2026-02-13 19:52:00', '');
INSERT INTO `ski_equipment` VALUES (2, 'EQ002', '入门双板滑雪板', '1', 'Rossignol', 'Experience 74', '160cm', '蓝色', 1800.00, 50.00, '/profile/upload/2026/02/05/生成动漫雪道图片 (8)_20260205111903A010.png', 80, 75, 1, 4, 0, 2, '入门级双板，适合初学者', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:19:05', '');
INSERT INTO `ski_equipment` VALUES (3, 'EQ003', '单板滑雪板', '2', 'Burton', 'Custom X', '158cm', '彩色', 4200.00, 100.00, '/profile/upload/2026/02/05/生成动漫雪道图片 (9)_20260205112007A014.png', 40, 36, 2, 2, 0, 2, '专业单板，适合高级玩家', 'admin', '2026-02-04 23:24:21', '', '2026-02-13 19:52:04', '');
INSERT INTO `ski_equipment` VALUES (4, 'EQ004', '碳纤维滑雪杖', '3', 'Leki', 'Carbon', '130cm', '黑色', 800.00, 20.00, '/profile/upload/2026/02/05/生成动漫雪道图片 (11)_20260205112014A015.png', 100, 95, 0, 5, 0, 2, '轻量级碳纤维滑雪杖', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:20:15', '');
INSERT INTO `ski_equipment` VALUES (5, 'EQ005', '专业滑雪头盔', '4', 'Giro', 'Range MIPS', 'M', '白色', 1200.00, 30.00, '/profile/upload/2026/02/05/生成动漫雪道图片 (12)_20260205112022A016.png', 60, 55, 1, 4, 0, 2, '带MIPS保护系统的专业头盔', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:20:23', '');
INSERT INTO `ski_equipment` VALUES (6, 'EQ006', '防雾滑雪护目镜', '5', 'Oakley', 'Flight Deck', 'L', '黑色', 1500.00, 25.00, '/profile/upload/2026/02/05/生成动漫雪道图片 (13)_20260205112028A017.png', 70, 68, 0, 2, 0, 2, '防雾防紫外线护目镜', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:20:29', '');
INSERT INTO `ski_equipment` VALUES (7, 'EQ007', '专业滑雪服套装', '6', 'Arc\'teryx', 'Rush', 'L', '红色', 3500.00, 60.00, '/profile/upload/2026/02/05/生成动漫雪道图片 (14)_20260205112036A018.png', 50, 48, 0, 2, 0, 2, '防水透气专业滑雪服', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:20:38', '');

-- ----------------------------
-- Table structure for ski_equipment_rental
-- ----------------------------
DROP TABLE IF EXISTS `ski_equipment_rental`;
CREATE TABLE `ski_equipment_rental`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '租赁ID',
  `rental_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '租赁单号',
  `equipment_id` bigint NOT NULL COMMENT '雪具ID',
  `equipment_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '雪具名称',
  `rental_quantity` int NOT NULL DEFAULT 1 COMMENT '租赁数量',
  `renter_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '租赁人姓名',
  `renter_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '租赁人电话',
  `renter_id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '租赁人身份证号',
  `rental_start_time` datetime NOT NULL COMMENT '租赁开始时间',
  `rental_end_time` datetime NULL DEFAULT NULL COMMENT '租赁结束时间',
  `expected_return_time` datetime NOT NULL COMMENT '预计归还时间',
  `actual_return_time` datetime NULL DEFAULT NULL COMMENT '实际归还时间',
  `rental_days` int NULL DEFAULT NULL COMMENT '租赁天数',
  `unit_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '单价（每天）',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '总金额',
  `paid_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '已付金额',
  `deposit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '押金',
  `status` int NULL DEFAULT 0 COMMENT '状态（0待支付 1租赁中 2已归还 3已取消 4逾期）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_rental_no`(`rental_no` ASC) USING BTREE,
  INDEX `idx_equipment_id`(`equipment_id` ASC) USING BTREE,
  INDEX `idx_renter_phone`(`renter_phone` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_rental_start_time`(`rental_start_time` ASC) USING BTREE,
  CONSTRAINT `fk_rental_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `ski_equipment` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '雪具租赁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_equipment_rental
-- ----------------------------
INSERT INTO `ski_equipment_rental` VALUES (1, 'RN20250101001', 1, '专业双板滑雪板', 1, '张三', '13800138001', '110101199001011234', '2025-01-01 09:00:00', '2026-02-13 19:52:00', '2025-01-03 18:00:00', '2026-02-13 19:52:00', 2, 80.00, 160.00, 160.00, 500.00, 2, 'admin', '2026-02-04 23:24:21', '', '2026-02-13 19:52:00', '');
INSERT INTO `ski_equipment_rental` VALUES (2, 'RN20250101002', 3, '单板滑雪板', 1, '李四', '13800138002', '110101199002021234', '2025-01-01 10:00:00', NULL, '2025-01-02 18:00:00', NULL, 1, 100.00, 100.00, 100.00, 600.00, 3, 'admin', '2026-02-04 23:24:21', '', '2026-02-13 19:52:04', '');
INSERT INTO `ski_equipment_rental` VALUES (3, 'RN20250101003', 5, '专业滑雪头盔', 1, '王五', '13800138003', '110101199003031234', '2025-01-01 11:00:00', '2025-01-01 18:00:00', '2025-01-01 18:00:00', '2025-01-01 18:00:00', 1, 30.00, 30.00, 30.00, 200.00, 2, 'admin', '2026-02-04 23:24:21', 'admin', '2026-02-04 23:24:21', '已归还');
INSERT INTO `ski_equipment_rental` VALUES (4, 'RN20250101004', 2, '入门双板滑雪板', 2, '赵六', '13800138004', '110101199004041234', '2025-01-01 14:00:00', NULL, '2025-01-05 18:00:00', NULL, 4, 50.00, 400.00, 0.00, 1000.00, 0, 'admin', '2026-02-04 23:24:21', '', NULL, '');

-- ----------------------------
-- Table structure for ski_material
-- ----------------------------
DROP TABLE IF EXISTS `ski_material`;
CREATE TABLE `ski_material`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '物资ID',
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物资编码',
  `material_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物资名称',
  `material_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物资类型（1急救药品 2医疗用品 3其他）',
  `specification` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格型号',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位（盒、瓶、支等）',
  `manufacturer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生产厂家',
  `batch_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '批次号',
  `production_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `expiry_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `safety_stock` int NULL DEFAULT 0 COMMENT '安全库存',
  `current_stock` int NULL DEFAULT 0 COMMENT '当前库存',
  `unit_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '单价',
  `storage_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '存放位置',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_material_code`(`material_code` ASC) USING BTREE,
  INDEX `idx_material_name`(`material_name` ASC) USING BTREE,
  INDEX `idx_material_type`(`material_type` ASC) USING BTREE,
  INDEX `idx_expiry_date`(`expiry_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物资管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_material
-- ----------------------------
INSERT INTO `ski_material` VALUES (1, 'MAT001', '创可贴', '2', '5cm×7cm', '盒', '云南白药', 'BATCH20260101', '2026-01-01', '2028-01-01', 50, 120, 15.00, 'A区-1号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);
INSERT INTO `ski_material` VALUES (2, 'MAT002', '碘伏', '2', '500ml', '瓶', '海氏海诺', 'BATCH20260115', '2026-01-15', '2028-01-15', 30, 45, 25.00, 'A区-1号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);
INSERT INTO `ski_material` VALUES (3, 'MAT003', '医用纱布', '2', '10cm×10cm', '包', '稳健医疗', 'BATCH20260201', '2026-02-01', '2028-02-01', 40, 60, 12.00, 'A区-2号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);
INSERT INTO `ski_material` VALUES (4, 'MAT004', '速效救心丸', '1', '30粒/盒', '盒', '天津中新药业', 'BATCH20251201', '2025-12-01', '2027-12-01', 20, 35, 28.00, 'B区-1号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);
INSERT INTO `ski_material` VALUES (5, 'MAT005', '硝酸甘油片', '1', '0.5mg×100片', '瓶', '北京益民', 'BATCH20251115', '2025-11-15', '2027-11-15', 15, 25, 35.00, 'B区-1号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);
INSERT INTO `ski_material` VALUES (6, 'MAT006', '云南白药气雾剂', '1', '85g', '瓶', '云南白药', 'BATCH20260120', '2026-01-20', '2028-01-20', 25, 8, 42.00, 'B区-2号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);
INSERT INTO `ski_material` VALUES (7, 'MAT007', '体温计', '2', '电子式', '支', '欧姆龙', 'BATCH20260205', '2026-02-05', '2028-02-05', 10, 15, 65.00, 'C区-1号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);
INSERT INTO `ski_material` VALUES (8, 'MAT008', '血压计', '2', '电子式', '台', '鱼跃医疗', 'BATCH20260110', '2026-01-10', '2028-01-10', 5, 8, 280.00, 'C区-1号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);
INSERT INTO `ski_material` VALUES (9, 'MAT009', '一次性注射器', '2', '5ml', '支', '三鑫医疗', 'BATCH20260210', '2026-02-10', '2028-02-10', 100, 150, 2.50, 'A区-3号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);
INSERT INTO `ski_material` VALUES (10, 'MAT010', '医用胶带', '2', '2.5cm×5m', '卷', '3M', 'BATCH20260125', '2026-01-25', '2028-01-25', 30, 50, 8.00, 'A区-2号柜', '0', 'admin', '2026-02-05 19:59:44', 'admin', '2026-02-05 19:59:44', NULL);

-- ----------------------------
-- Table structure for ski_material_stock
-- ----------------------------
DROP TABLE IF EXISTS `ski_material_stock`;
CREATE TABLE `ski_material_stock`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `material_id` bigint NOT NULL COMMENT '物资ID',
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物资编码（冗余）',
  `material_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物资名称（冗余）',
  `operation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型（1入库 2出库）',
  `quantity` int NOT NULL COMMENT '数量',
  `unit_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '单价',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '总金额',
  `batch_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '批次号',
  `production_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `expiry_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `operator_id` bigint NULL DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人姓名',
  `operation_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `supplier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商（入库时）',
  `purpose` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用途说明（出库时）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_material_id`(`material_id` ASC) USING BTREE,
  INDEX `idx_operation_type`(`operation_type` ASC) USING BTREE,
  INDEX `idx_operation_time`(`operation_time` ASC) USING BTREE,
  INDEX `idx_expiry_date`(`expiry_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '出入库记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_material_stock
-- ----------------------------
INSERT INTO `ski_material_stock` VALUES (1, 1, 'MAT001', '创可贴', '1', 100, 15.00, 1500.00, 'BATCH20260101', '2026-01-01', '2028-01-01', 1, 'admin', '2026-01-26 19:59:44', '医疗器械供应商A', NULL, NULL, 'admin', '2026-01-26 19:59:44', '', NULL);
INSERT INTO `ski_material_stock` VALUES (2, 1, 'MAT001', '创可贴', '2', 20, NULL, NULL, NULL, NULL, NULL, 1, 'admin', '2026-01-31 19:59:44', NULL, '日常使用', NULL, 'admin', '2026-01-31 19:59:44', '', NULL);
INSERT INTO `ski_material_stock` VALUES (3, 2, 'MAT002', '碘伏', '1', 50, 25.00, 1250.00, 'BATCH20260115', '2026-01-15', '2028-01-15', 1, 'admin', '2026-01-28 19:59:44', '医疗器械供应商A', NULL, NULL, 'admin', '2026-01-28 19:59:44', '', NULL);
INSERT INTO `ski_material_stock` VALUES (4, 2, 'MAT002', '碘伏', '2', 5, NULL, NULL, NULL, NULL, NULL, 1, 'admin', '2026-02-02 19:59:44', NULL, '急救使用', NULL, 'admin', '2026-02-02 19:59:44', '', NULL);
INSERT INTO `ski_material_stock` VALUES (5, 4, 'MAT004', '速效救心丸', '1', 30, 28.00, 840.00, 'BATCH20251201', '2025-12-01', '2027-12-01', 1, 'admin', '2026-01-21 19:59:44', '药品供应商B', NULL, NULL, 'admin', '2026-01-21 19:59:44', '', NULL);
INSERT INTO `ski_material_stock` VALUES (6, 4, 'MAT004', '速效救心丸', '2', 5, NULL, NULL, NULL, NULL, NULL, 1, 'admin', '2026-02-03 19:59:44', NULL, '紧急情况使用', NULL, 'admin', '2026-02-03 19:59:44', '', NULL);
INSERT INTO `ski_material_stock` VALUES (7, 6, 'MAT006', '云南白药气雾剂', '1', 30, 42.00, 1260.00, 'BATCH20260120', '2026-01-20', '2028-01-20', 1, 'admin', '2026-01-29 19:59:44', '药品供应商B', NULL, NULL, 'admin', '2026-01-29 19:59:44', '', NULL);
INSERT INTO `ski_material_stock` VALUES (8, 6, 'MAT006', '云南白药气雾剂', '2', 22, NULL, NULL, NULL, NULL, NULL, 1, 'admin', '2026-02-04 19:59:44', NULL, '运动损伤处理', NULL, 'admin', '2026-02-04 19:59:44', '', NULL);

-- ----------------------------
-- Table structure for ski_material_usage
-- ----------------------------
DROP TABLE IF EXISTS `ski_material_usage`;
CREATE TABLE `ski_material_usage`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '领用ID',
  `material_id` bigint NOT NULL COMMENT '物资ID',
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物资编码（冗余）',
  `material_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物资名称（冗余）',
  `quantity` int NOT NULL COMMENT '领用数量',
  `user_id` bigint NULL DEFAULT NULL COMMENT '领用人ID',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '领用人姓名',
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属部门',
  `usage_purpose` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用途说明',
  `usage_time` datetime NULL DEFAULT NULL COMMENT '领用时间',
  `return_time` datetime NULL DEFAULT NULL COMMENT '归还时间',
  `return_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '归还状态（0未归还 1已归还）',
  `approver_id` bigint NULL DEFAULT NULL COMMENT '审批人ID',
  `approver_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批人姓名',
  `approval_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '审批状态（0待审批 1已批准 2已拒绝）',
  `approval_time` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `approval_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批意见',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_material_id`(`material_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_usage_time`(`usage_time` ASC) USING BTREE,
  INDEX `idx_return_status`(`return_status` ASC) USING BTREE,
  INDEX `idx_approval_status`(`approval_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '领用记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_material_usage
-- ----------------------------
INSERT INTO `ski_material_usage` VALUES (1, 1, 'MAT001', '创可贴', 10, 2, '游客001', '前台', '日常急救使用', '2026-02-02 19:59:44', NULL, '0', NULL, NULL, '1', NULL, NULL, NULL, 'tourist001', '2026-02-02 19:59:44', '', NULL);
INSERT INTO `ski_material_usage` VALUES (2, 2, 'MAT002', '碘伏', 2, 3, '游客002', '前台', '伤口消毒', '2026-02-03 19:59:44', NULL, '0', NULL, NULL, '1', NULL, NULL, NULL, 'tourist002', '2026-02-03 19:59:44', '', NULL);
INSERT INTO `ski_material_usage` VALUES (3, 3, 'MAT003', '医用纱布', 5, 4, '游客003', '前台', '包扎使用', '2026-02-04 19:59:44', NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, 'tourist003', '2026-02-04 19:59:44', '', NULL);
INSERT INTO `ski_material_usage` VALUES (4, 7, 'MAT007', '体温计', 1, 5, '教练001', '教练部', '测量体温', '2026-01-31 19:59:44', NULL, '1', NULL, NULL, '1', NULL, NULL, NULL, 'coach001', '2026-01-31 19:59:44', '', NULL);

-- ----------------------------
-- Table structure for ski_message_board
-- ----------------------------
DROP TABLE IF EXISTS `ski_message_board`;
CREATE TABLE `ski_message_board`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '留言ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（发布者）',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名（冗余字段，方便查询）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '留言内容',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父留言ID（用于回复，NULL表示主留言）',
  `like_count` int NULL DEFAULT 0 COMMENT '点赞数',
  `reply_count` int NULL DEFAULT 0 COMMENT '回复数',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '留言板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_message_board
-- ----------------------------
INSERT INTO `ski_message_board` VALUES (1, 2, '游客001', '今天滑雪场天气真好！雪质也很棒，推荐大家来玩！', NULL, 5, 3, '0', 'tourist001', '2026-02-05 19:44:36', 'tourist001', '2026-02-05 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (2, 3, '游客002', '请问滑雪场有教练可以预约吗？我是初学者，想找个教练指导一下。', NULL, 2, 2, '0', 'tourist002', '2026-02-04 19:44:36', 'tourist002', '2026-02-04 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (3, 4, '游客003', '昨天在这里玩了一天，体验非常棒！工作人员服务态度也很好，点赞！', NULL, 8, 1, '0', 'tourist003', '2026-02-03 19:44:36', 'tourist003', '2026-02-03 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (4, 5, '教练001', '大家好，我是滑雪教练，有需要预约课程的可以联系我。我会根据学员的水平制定合适的教学计划。', NULL, 12, 5, '0', 'coach001', '2026-02-02 19:44:36', 'coach001', '2026-02-02 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (5, 2, '游客001', '雪具租赁的价格是多少？需要提前预约吗？', NULL, 3, 2, '0', 'tourist001', '2026-02-01 19:44:36', 'tourist001', '2026-02-01 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (6, 6, '前台001', '感谢大家的支持！我们会继续努力为大家提供更好的服务。如有任何问题，欢迎随时咨询前台。', NULL, 15, 4, '0', 'frontdesk001', '2026-01-31 19:44:36', 'frontdesk001', '2026-01-31 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (7, 3, '游客002', '是的，今天天气确实不错！我也在，要不要一起滑？', 1, 1, 0, '0', 'tourist002', '2026-02-05 18:44:36', 'tourist002', '2026-02-05 18:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (8, 4, '游客003', '同感！雪质确实很好，我已经滑了好几圈了。', 1, 0, 0, '0', 'tourist003', '2026-02-05 17:44:36', 'tourist003', '2026-02-05 17:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (9, 5, '教练001', '可以预约的，您可以在系统中预约，或者直接到前台咨询。', 2, 2, 0, '0', 'coach001', '2026-02-04 19:44:36', 'coach001', '2026-02-04 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (10, 6, '前台001', '是的，我们有专业的教练团队，可以为您提供一对一的指导服务。', 2, 1, 0, '0', 'frontdesk001', '2026-02-04 19:44:36', 'frontdesk001', '2026-02-04 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (11, 2, '游客001', '谢谢分享！我也准备去试试。', 3, 0, 0, '0', 'tourist001', '2026-02-03 19:44:36', 'tourist001', '2026-02-03 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (12, 3, '游客002', '请问教练，初学者一般需要几节课？', 4, 1, 0, '0', 'tourist002', '2026-02-02 19:44:36', 'tourist002', '2026-02-02 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (13, 4, '游客003', '我也想了解雪具租赁的信息，同问！', 5, 0, 0, '0', 'tourist003', '2026-02-01 19:44:36', 'tourist003', '2026-02-01 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (14, 6, '前台001', '雪具租赁价格根据类型不同，单次租赁8折优惠，全天租赁7折优惠。可以提前预约，也可以现场租赁。', 5, 2, 0, '0', 'frontdesk001', '2026-02-01 19:44:36', 'frontdesk001', '2026-02-01 19:44:36', NULL);
INSERT INTO `ski_message_board` VALUES (15, 1, 'admin', '测试管理员留言', NULL, 0, 0, '0', '', NULL, '', NULL, NULL);
INSERT INTO `ski_message_board` VALUES (16, 100, 'yk001', '今天天气很好  滑雪场很棒  并且教练很帅', NULL, 0, 0, '0', '', NULL, '', NULL, NULL);

-- ----------------------------
-- Table structure for ski_message_like
-- ----------------------------
DROP TABLE IF EXISTS `ski_message_like`;
CREATE TABLE `ski_message_like`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
  `message_id` bigint NOT NULL COMMENT '留言ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（点赞者）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_message_user`(`message_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_message_id`(`message_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '留言点赞表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_message_like
-- ----------------------------
INSERT INTO `ski_message_like` VALUES (1, 1, 3, '2026-02-05 18:44:36');
INSERT INTO `ski_message_like` VALUES (2, 1, 4, '2026-02-05 17:44:36');
INSERT INTO `ski_message_like` VALUES (3, 1, 5, '2026-02-05 16:44:36');
INSERT INTO `ski_message_like` VALUES (4, 1, 6, '2026-02-05 15:44:36');
INSERT INTO `ski_message_like` VALUES (5, 1, 2, '2026-02-05 14:44:36');
INSERT INTO `ski_message_like` VALUES (6, 2, 4, '2026-02-04 19:44:36');
INSERT INTO `ski_message_like` VALUES (7, 2, 5, '2026-02-04 19:44:36');
INSERT INTO `ski_message_like` VALUES (8, 3, 2, '2026-02-03 19:44:36');
INSERT INTO `ski_message_like` VALUES (9, 3, 3, '2026-02-03 19:44:36');
INSERT INTO `ski_message_like` VALUES (10, 3, 4, '2026-02-03 19:44:36');
INSERT INTO `ski_message_like` VALUES (11, 3, 5, '2026-02-03 19:44:36');
INSERT INTO `ski_message_like` VALUES (12, 3, 6, '2026-02-03 19:44:36');
INSERT INTO `ski_message_like` VALUES (13, 4, 2, '2026-02-02 19:44:36');
INSERT INTO `ski_message_like` VALUES (14, 4, 3, '2026-02-02 19:44:36');
INSERT INTO `ski_message_like` VALUES (15, 4, 4, '2026-02-02 19:44:36');
INSERT INTO `ski_message_like` VALUES (16, 4, 5, '2026-02-02 19:44:36');
INSERT INTO `ski_message_like` VALUES (17, 4, 6, '2026-02-02 19:44:36');
INSERT INTO `ski_message_like` VALUES (18, 5, 3, '2026-02-01 19:44:36');
INSERT INTO `ski_message_like` VALUES (19, 5, 4, '2026-02-01 19:44:36');
INSERT INTO `ski_message_like` VALUES (20, 5, 5, '2026-02-01 19:44:36');
INSERT INTO `ski_message_like` VALUES (21, 6, 2, '2026-01-31 19:44:36');
INSERT INTO `ski_message_like` VALUES (22, 6, 3, '2026-01-31 19:44:36');
INSERT INTO `ski_message_like` VALUES (23, 6, 4, '2026-01-31 19:44:36');
INSERT INTO `ski_message_like` VALUES (24, 6, 5, '2026-01-31 19:44:36');
INSERT INTO `ski_message_like` VALUES (25, 6, 6, '2026-01-31 19:44:36');

-- ----------------------------
-- Table structure for ski_notice
-- ----------------------------
DROP TABLE IF EXISTS `ski_notice`;
CREATE TABLE `ski_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `notice_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知标题',
  `notice_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '通知类型（1通知 2公告）',
  `notice_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '通知内容',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1关闭）',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  `priority` int NULL DEFAULT 0 COMMENT '优先级（0普通 1重要 2紧急）',
  `read_count` int NULL DEFAULT 0 COMMENT '阅读次数',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_notice_type`(`notice_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_publish_time`(`publish_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_notice
-- ----------------------------
INSERT INTO `ski_notice` VALUES (1, '开业第一天', '2', '今天正式开业', '0', '2026-02-05 00:00:00', '2026-02-28 00:00:00', 0, 0, '', NULL, '', NULL, '');
INSERT INTO `ski_notice` VALUES (2, '欢迎来到滑雪场！', '2', '尊敬的游客朋友们，欢迎来到我们的滑雪场！为了确保您的安全，请务必遵守以下规定：\n1. 请佩戴好安全帽和护具\n2. 遵守雪道规则，不要逆行\n3. 初学者请在指定区域练习\n4. 如遇紧急情况，请及时联系工作人员\n\n祝您滑雪愉快！', '0', '2026-02-05 17:30:53', '2026-03-07 17:30:53', 1, 256, 'admin', '2026-02-05 17:30:53', 'admin', '2026-02-05 17:30:53', '欢迎公告');
INSERT INTO `ski_notice` VALUES (3, '雪道维护通知', '1', '各位游客请注意，由于天气原因，1号雪道将于明天（2026-02-06）上午8:00-12:00进行维护作业，期间将暂停开放。\n\n给您带来的不便，我们深表歉意。其他雪道正常开放，欢迎您前往其他雪道体验。\n\n如有疑问，请联系客服热线：400-123-4567', '0', '2026-02-05 17:30:53', '2026-02-08 17:30:53', 2, 190, 'admin', '2026-02-05 17:30:53', 'admin', '2026-02-05 17:30:53', '紧急维护通知');
INSERT INTO `ski_notice` VALUES (4, '春节优惠活动', '2', '🎉 春节特惠活动开始啦！\n\n活动时间：2026-02-08 至 2026-02-15\n\n活动内容：\n1. 全天票享受8折优惠\n2. 购买季票赠送雪具租赁券\n3. 家庭套餐（2大1小）立减100元\n4. 会员充值满500送100\n\n数量有限，先到先得！详情请咨询前台或致电客服。', '0', '2026-02-03 17:30:53', '2026-02-15 17:30:53', 1, 342, 'admin', '2026-02-03 17:30:53', 'admin', '2026-02-03 17:30:53', '春节活动公告');
INSERT INTO `ski_notice` VALUES (5, '安全提示', '1', '重要安全提示：\n\n近日天气转暖，部分雪道可能出现结冰现象。请各位游客：\n1. 减速慢行，注意安全\n2. 保持安全距离\n3. 如发现危险情况，请立即报告工作人员\n4. 建议佩戴护目镜，防止雪盲\n\n安全第一，快乐滑雪！', '0', '2026-02-04 17:30:53', '2026-02-12 17:30:53', 2, 157, 'admin', '2026-02-04 17:30:53', 'admin', '2026-02-04 17:30:53', '安全提示');
INSERT INTO `ski_notice` VALUES (6, '教练预约服务上线', '2', '好消息！我们的在线教练预约服务正式上线了！\n\n现在您可以通过以下方式预约专业滑雪教练：\n1. 登录系统，进入\"教练预约\"模块\n2. 选择您心仪的教练和时间段\n3. 在线支付预约费用\n4. 按时到达指定地点上课\n\n教练团队介绍：\n- 初级教练：适合零基础学员\n- 中级教练：适合有一定基础的学员\n- 高级教练：适合进阶提升\n\n预约热线：400-123-4567', '0', '2026-01-31 17:30:53', '2026-04-06 17:30:53', 0, 89, 'admin', '2026-01-31 17:30:53', 'admin', '2026-01-31 17:30:53', '服务上线公告');
INSERT INTO `ski_notice` VALUES (7, '雪具租赁优惠', '1', '雪具租赁优惠活动：\n\n即日起至本月底，雪具租赁享受以下优惠：\n- 单次租赁：8折优惠\n- 全天租赁：7折优惠\n- 连续租赁3天以上：6折优惠\n\n租赁物品包括：\n- 滑雪板（单板/双板）\n- 滑雪杖\n- 滑雪靴\n- 安全帽\n- 护具套装\n\n所有设备均经过专业维护，安全可靠！', '0', '2026-02-02 17:30:53', '2026-02-25 17:30:53', 0, 124, 'admin', '2026-02-02 17:30:53', 'admin', '2026-02-02 17:30:53', '租赁优惠通知');
INSERT INTO `ski_notice` VALUES (8, '天气预警', '1', '⚠️ 天气预警通知\n\n根据气象部门预报，未来3天将有大风天气，风力可达6-7级。\n\n为确保游客安全，我们将采取以下措施：\n1. 部分高难度雪道可能临时关闭\n2. 缆车运营时间可能调整\n3. 建议游客关注天气变化，合理安排行程\n\n我们会根据实际情况及时调整运营安排，请关注最新通知。\n\n给您带来的不便，敬请谅解！', '0', '2026-02-05 17:30:53', '2026-02-08 17:30:53', 2, 79, 'admin', '2026-02-05 17:30:53', 'admin', '2026-02-05 17:30:53', '天气预警');
INSERT INTO `ski_notice` VALUES (9, '会员积分系统升级', '2', '会员积分系统全新升级！\n\n新功能：\n1. 消费即可获得积分，1元=1积分\n2. 积分可兑换雪票、租赁券等\n3. 生日月双倍积分\n4. 推荐好友注册，双方各得100积分\n\n积分兑换规则：\n- 100积分 = 10元优惠券\n- 500积分 = 全天票一张\n- 1000积分 = 季票8折优惠\n\n更多优惠，敬请期待！', '0', '2026-01-29 17:30:53', '2026-05-06 17:30:53', 0, 201, 'admin', '2026-01-29 17:30:53', 'admin', '2026-01-29 17:30:53', '会员系统升级');
INSERT INTO `ski_notice` VALUES (10, '停车场使用说明', '1', '停车场使用说明：\n\n1. 停车场位置：滑雪场正门右侧，可容纳200辆车\n2. 收费标准：\n   - 前2小时：免费\n   - 2-6小时：10元\n   - 6小时以上：20元\n   - 会员车辆：免费（需提前登记）\n3. 停车时间：每日6:00-22:00\n4. 注意事项：\n   - 请锁好车门，贵重物品请随身携带\n   - 按指定位置停车，不要占用消防通道\n   - 如遇问题，请联系停车场管理员\n\n感谢您的配合！', '0', '2026-01-26 17:30:53', '2026-08-04 17:30:53', 0, 67, 'admin', '2026-01-26 17:30:53', 'admin', '2026-01-26 17:30:53', '停车场说明');
INSERT INTO `ski_notice` VALUES (11, '雪场开放时间调整', '1', '雪场开放时间调整通知：\n\n自2026年2月1日起，雪场开放时间调整为：\n\n平日（周一至周五）：\n- 开放时间：8:00-18:00\n- 夜场时间：18:00-22:00（仅限指定雪道）\n\n周末及节假日：\n- 开放时间：7:00-20:00\n- 夜场时间：20:00-23:00（仅限指定雪道）\n\n请各位游客合理安排时间，祝您滑雪愉快！', '0', '2026-01-31 17:30:53', '2026-04-06 17:30:53', 0, 145, 'admin', '2026-01-31 17:30:53', 'admin', '2026-01-31 17:30:53', '时间调整通知');
INSERT INTO `ski_notice` VALUES (12, '测试发布公告功能', '2', '顶顶顶顶顶 ', '0', '2026-02-13 00:00:00', '2026-02-28 00:00:00', 2, 1, '', NULL, '', NULL, '');

-- ----------------------------
-- Table structure for ski_slope
-- ----------------------------
DROP TABLE IF EXISTS `ski_slope`;
CREATE TABLE `ski_slope`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '雪道ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '雪道名称',
  `slope_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '雪道编号',
  `difficulty` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '难度等级（1初级 2中级 3高级）',
  `length` int NOT NULL COMMENT '长度（米）',
  `width` int NOT NULL COMMENT '宽度（米）',
  `max_capacity` int NOT NULL COMMENT '最大容量（人）',
  `status` int NULL DEFAULT 1 COMMENT '状态（0关闭 1开放）',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '雪道图片',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_slope_code`(`slope_code` ASC) USING BTREE,
  INDEX `idx_difficulty`(`difficulty` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '雪道信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_slope
-- ----------------------------
INSERT INTO `ski_slope` VALUES (1, '初级雪道A', 'SLOPE001', '1', 300, 25, 80, 1, '适合初学者的平缓雪道，坡度较小，安全性高', '/profile/upload/2026/02/05/生成动漫雪道图片_20260205110858A001.png', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:09:00', '');
INSERT INTO `ski_slope` VALUES (2, '初级雪道B', 'SLOPE002', '1', 350, 30, 100, 1, '初级雪道，适合有一定基础的初学者', '/profile/upload/2026/02/05/生成动漫雪道图片 (1)_20260205110905A002.png', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:09:06', '');
INSERT INTO `ski_slope` VALUES (3, '中级雪道A', 'SLOPE003', '2', 500, 35, 120, 1, '中级雪道，坡度适中，适合中级滑雪者', '/profile/upload/2026/02/05/生成动漫雪道图片 (2)_20260205110910A003.png', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:09:11', '');
INSERT INTO `ski_slope` VALUES (4, '中级雪道B', 'SLOPE004', '2', 600, 40, 150, 1, '中级雪道，有一定挑战性', '/profile/upload/2026/02/05/生成动漫雪道图片 (3)_20260205110916A004.png', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:09:17', '');
INSERT INTO `ski_slope` VALUES (5, '高级雪道A', 'SLOPE005', '3', 800, 30, 80, 1, '高级雪道，坡度大，适合高级滑雪者', '/profile/upload/2026/02/05/生成动漫雪道图片 (4)_20260205110922A005.png', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:09:23', '');
INSERT INTO `ski_slope` VALUES (6, '高级雪道B', 'SLOPE006', '3', 1000, 35, 100, 1, '专业级雪道，极具挑战性', '/profile/upload/2026/02/05/生成动漫雪道图片 (5)_20260205110941A007.png', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:09:43', '');
INSERT INTO `ski_slope` VALUES (7, '练习雪道', 'SLOPE007', '1', 200, 20, 50, 1, '短距离练习雪道，适合新手练习', '/profile/upload/2026/02/05/生成动漫雪道图片 (6)_20260205110946A008.png', 'admin', '2026-02-04 23:24:21', '', '2026-02-05 11:09:47', '');
INSERT INTO `ski_slope` VALUES (8, '维修中雪道', 'SLOPE008', '2', 450, 30, 100, 0, '正在维修中，暂时关闭', '/profile/upload/2026/02/05/生成动漫雪道图片 (7)_20260205110952A009.png', 'admin', '2026-02-04 23:24:21', '', '2026-02-13 19:54:45', '维修中');

-- ----------------------------
-- Table structure for ski_ticket_order
-- ----------------------------
DROP TABLE IF EXISTS `ski_ticket_order`;
CREATE TABLE `ski_ticket_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单号',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID（订单所属用户）',
  `ticket_type_id` bigint NOT NULL COMMENT '票种ID',
  `ticket_type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '票种名称',
  `visitor_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '游客姓名',
  `visitor_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '游客手机号',
  `visitor_id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '游客身份证号',
  `ticket_count` int NOT NULL DEFAULT 1 COMMENT '购票数量',
  `unit_price` decimal(10, 2) NOT NULL COMMENT '单价',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '总金额',
  `paid_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '已支付金额',
  `booking_date` date NOT NULL COMMENT '预订日期',
  `use_date` date NULL DEFAULT NULL COMMENT '使用日期',
  `order_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '订单状态（0待支付 1已支付 2已使用 3已退票 4已取消）',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付方式（1现金 2微信 3支付宝 4银行卡）',
  `payment_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `refund_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '退款原因',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `refund_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '退款状态（0无退款 1退款中 2已退款 3退款失败）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_ticket_type_id`(`ticket_type_id` ASC) USING BTREE,
  INDEX `idx_visitor_phone`(`visitor_phone` ASC) USING BTREE,
  INDEX `idx_order_status`(`order_status` ASC) USING BTREE,
  INDEX `idx_booking_date`(`booking_date` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_ticket_order_type` FOREIGN KEY (`ticket_type_id`) REFERENCES `ski_ticket_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门票订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_ticket_order
-- ----------------------------
INSERT INTO `ski_ticket_order` VALUES (12, 'T20260205762329', 100, 5, '季票', '测试游客个人票', '14255556666', '', 1, 3500.00, 3500.00, 0.00, '2026-02-05', NULL, '4', NULL, NULL, 0.00, NULL, NULL, '0', '', NULL, '', NULL, NULL);
INSERT INTO `ski_ticket_order` VALUES (13, 'T20260205851254', 100, 5, '季票', '测试游客个人票', '14255556666', '', 1, 3500.00, 3500.00, 3500.00, '2026-02-05', NULL, '3', '2', '2026-02-05 16:08:41', 3500.00, '不用了\n', '2026-02-13 19:59:41', '2', '', NULL, '', NULL, NULL);
INSERT INTO `ski_ticket_order` VALUES (14, 'T20260205880598', 100, 6, '年票', '测测测', '13209515871', '', 1, 12000.00, 12000.00, 12000.00, '2026-02-05', NULL, '1', '2', '2026-02-05 20:41:39', 0.00, NULL, NULL, '0', '', NULL, '', NULL, NULL);
INSERT INTO `ski_ticket_order` VALUES (15, 'T20260213758538', 100, 6, '年票', '测试订票', '13200000000', '', 1, 12000.00, 12000.00, 12000.00, '2026-02-20', NULL, '1', '4', '2026-02-13 19:41:40', 0.00, NULL, NULL, '0', '', NULL, '', NULL, NULL);

-- ----------------------------
-- Table structure for ski_ticket_type
-- ----------------------------
DROP TABLE IF EXISTS `ski_ticket_type`;
CREATE TABLE `ski_ticket_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '票种ID',
  `ticket_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '票种编码',
  `ticket_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '票种名称',
  `ticket_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '票种类型（1全天票 2半天票 3夜场票 4季票 5年票）',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `valid_days` int NULL DEFAULT 1 COMMENT '有效期（天）',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '票种描述',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '票种图片',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ticket_code`(`ticket_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门票类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ski_ticket_type
-- ----------------------------
INSERT INTO `ski_ticket_type` VALUES (1, 'TT001', '全天票', '1', 280.00, 1, '全天滑雪票，营业时间内可无限次使用', '/upload/2026/02/05/生成动漫雪道图片_20260205151829A013.png', '0', 1, 'admin', '2026-02-04 23:24:21', '', NULL, '');
INSERT INTO `ski_ticket_type` VALUES (2, 'TT002', '半天票（上午）', '2', 180.00, 1, '上午半天票，9:00-13:00有效', '/upload/2026/02/05/生成动漫雪道图片 (1)_20260205153134A001.png', '0', 2, 'admin', '2026-02-04 23:24:21', '', NULL, '');
INSERT INTO `ski_ticket_type` VALUES (3, 'TT003', '半天票（下午）', '2', 180.00, 1, '下午半天票，13:00-18:00有效', '/upload/2026/02/05/生成动漫雪道图片 (2)_20260205153141A002.png', '0', 3, 'admin', '2026-02-04 23:24:21', '', NULL, '');
INSERT INTO `ski_ticket_type` VALUES (4, 'TT004', '夜场票', '3', 120.00, 1, '夜场票，18:00-22:00有效', '/upload/2026/02/05/生成动漫雪道图片 (3)_20260205153147A003.png', '0', 4, 'admin', '2026-02-04 23:24:21', '', NULL, '');
INSERT INTO `ski_ticket_type` VALUES (5, 'TT005', '季票', '4', 3500.00, 90, '季度票，90天内无限次使用', '/upload/2026/02/05/生成动漫雪道图片 (4)_20260205153200A004.png', '0', 5, 'admin', '2026-02-04 23:24:21', '', NULL, '');
INSERT INTO `ski_ticket_type` VALUES (6, 'TT006', '年票', '5', 12000.00, 365, '年度票，一年内无限次使用', '/upload/2026/02/05/生成动漫雪道图片 (5)_20260205153205A005.png', '0', 6, 'admin', '2026-02-04 23:24:21', '', NULL, '');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-02-04 23:18:06', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-02-04 23:18:06', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-02-04 23:18:06', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-02-04 23:18:06', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-02-04 23:18:06', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-02-04 23:18:06', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-02-04 23:18:06', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-02-04 23:18:06', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 203 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL);
INSERT INTO `sys_dept` VALUES (200, 100, '0,100', '教练', 3, NULL, NULL, NULL, '0', '0', 'admin', '2026-02-05 21:30:24', '', NULL);
INSERT INTO `sys_dept` VALUES (201, 100, '0,100', '前台', 4, NULL, NULL, NULL, '0', '0', 'admin', '2026-02-05 21:30:34', '', NULL);
INSERT INTO `sys_dept` VALUES (202, 100, '0,100', '后勤', 5, NULL, NULL, NULL, '0', '0', 'admin', '2026-02-05 21:30:44', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-02-04 23:18:06', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 23:28:06');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 09:21:43');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 10:04:12');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 11:21:16');
INSERT INTO `sys_logininfor` VALUES (104, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 11:21:32');
INSERT INTO `sys_logininfor` VALUES (105, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 11:21:37');
INSERT INTO `sys_logininfor` VALUES (106, 'hq001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 11:21:41');
INSERT INTO `sys_logininfor` VALUES (107, 'hq001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 11:21:44');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 11:21:47');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 15:13:48');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 15:58:15');
INSERT INTO `sys_logininfor` VALUES (111, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '用户不存在/密码错误', '2026-02-05 15:58:20');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 15:58:36');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 15:58:49');
INSERT INTO `sys_logininfor` VALUES (114, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 15:58:57');
INSERT INTO `sys_logininfor` VALUES (115, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 15:59:11');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 15:59:15');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 16:06:41');
INSERT INTO `sys_logininfor` VALUES (118, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 16:06:46');
INSERT INTO `sys_logininfor` VALUES (119, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 16:09:03');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 16:09:04');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 16:09:39');
INSERT INTO `sys_logininfor` VALUES (122, 'yk002', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 16:09:43');
INSERT INTO `sys_logininfor` VALUES (123, 'yk002', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 16:23:59');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 16:23:59');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 16:24:09');
INSERT INTO `sys_logininfor` VALUES (126, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码错误', '2026-02-05 16:24:14');
INSERT INTO `sys_logininfor` VALUES (127, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 16:24:16');
INSERT INTO `sys_logininfor` VALUES (128, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 16:24:23');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码已失效', '2026-02-05 16:30:53');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 16:30:56');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 17:22:48');
INSERT INTO `sys_logininfor` VALUES (132, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 17:22:51');
INSERT INTO `sys_logininfor` VALUES (133, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 17:23:09');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码错误', '2026-02-05 17:23:15');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 17:23:22');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 17:42:25');
INSERT INTO `sys_logininfor` VALUES (137, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 17:42:30');
INSERT INTO `sys_logininfor` VALUES (138, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 17:43:39');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 17:43:43');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 19:28:37');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 20:41:18');
INSERT INTO `sys_logininfor` VALUES (142, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 20:41:19');
INSERT INTO `sys_logininfor` VALUES (143, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-05 20:41:48');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-05 20:41:52');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 08:47:10');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 09:14:16');
INSERT INTO `sys_logininfor` VALUES (147, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 09:14:21');
INSERT INTO `sys_logininfor` VALUES (148, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 09:24:53');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 09:24:53');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 09:33:21');
INSERT INTO `sys_logininfor` VALUES (151, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 09:33:27');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 10:20:37');
INSERT INTO `sys_logininfor` VALUES (153, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 10:20:38');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 10:20:48');
INSERT INTO `sys_logininfor` VALUES (155, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 10:20:52');
INSERT INTO `sys_logininfor` VALUES (156, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 10:23:54');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 10:23:57');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 10:28:38');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 10:28:41');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 10:28:45');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 10:28:49');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 10:28:53');
INSERT INTO `sys_logininfor` VALUES (163, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 10:28:58');
INSERT INTO `sys_logininfor` VALUES (164, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 10:30:09');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 10:30:11');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 10:31:31');
INSERT INTO `sys_logininfor` VALUES (167, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 10:31:36');
INSERT INTO `sys_logininfor` VALUES (168, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 10:32:44');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 10:32:47');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 11:16:09');
INSERT INTO `sys_logininfor` VALUES (171, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 11:16:09');
INSERT INTO `sys_logininfor` VALUES (172, 'jl001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 11:21:14');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 11:21:17');
INSERT INTO `sys_logininfor` VALUES (174, 'jl001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-02-06 11:22:22');
INSERT INTO `sys_logininfor` VALUES (175, 'jl001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-02-06 11:22:28');
INSERT INTO `sys_logininfor` VALUES (176, 'jl001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-06 11:22:48');
INSERT INTO `sys_logininfor` VALUES (177, 'jl001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-06 16:16:23');
INSERT INTO `sys_logininfor` VALUES (178, 'jl001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-02-06 16:20:05');
INSERT INTO `sys_logininfor` VALUES (179, 'hq001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-06 16:20:13');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 16:21:08');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 16:28:34');
INSERT INTO `sys_logininfor` VALUES (182, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 16:28:38');
INSERT INTO `sys_logininfor` VALUES (183, 'yk001', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 16:29:03');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 16:29:06');
INSERT INTO `sys_logininfor` VALUES (185, 'hq001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-02-06 16:34:50');
INSERT INTO `sys_logininfor` VALUES (186, 'qt001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-06 16:34:59');
INSERT INTO `sys_logininfor` VALUES (187, 'qt001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-02-06 16:36:11');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-06 16:36:16');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-02-06 16:58:21');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-06 16:58:44');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码已失效', '2026-02-13 19:37:24');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码已失效', '2026-02-13 19:37:24');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-13 19:37:30');
INSERT INTO `sys_logininfor` VALUES (194, 'yk001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-13 19:38:51');
INSERT INTO `sys_logininfor` VALUES (195, 'jl001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-13 19:40:15');
INSERT INTO `sys_logininfor` VALUES (196, 'yk002', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-13 19:48:56');
INSERT INTO `sys_logininfor` VALUES (197, 'jl001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-02-13 19:50:47');
INSERT INTO `sys_logininfor` VALUES (198, 'qt001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-13 19:50:59');
INSERT INTO `sys_logininfor` VALUES (199, 'qt001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-02-13 19:52:16');
INSERT INTO `sys_logininfor` VALUES (200, 'hq001', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-02-13 19:52:37');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2029 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-02-04 23:18:06', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-02-04 23:18:06', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '1', '1', '', 'tool', 'admin', '2026-02-04 23:18:06', 'admin', '2026-02-06 16:36:49', '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '1', '1', '', 'guide', 'admin', '2026-02-04 23:18:06', 'admin', '2026-02-06 16:36:33', '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-02-04 23:18:06', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-02-04 23:18:06', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-02-04 23:18:06', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-02-04 23:18:06', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-02-04 23:18:06', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '1', '1', 'system:dict:list', 'dict', 'admin', '2026-02-04 23:18:06', 'admin', '2026-02-13 20:01:59', '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-02-04 23:18:06', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-02-04 23:18:06', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-02-04 23:18:06', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-02-04 23:18:06', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-02-04 23:18:06', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-02-04 23:18:06', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-02-04 23:18:06', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-02-04 23:18:06', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-02-04 23:18:06', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-02-04 23:18:06', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-02-04 23:18:06', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-02-04 23:18:06', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-02-04 23:18:06', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-02-04 23:18:06', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '雪道信息查询', 0, 5, 'SkiSlopeInformationInquiry', 'SkiSlopeInformationInquiry/index', NULL, '', 1, 0, 'C', '0', '0', '', 'road', 'admin', '2026-02-05 09:29:30', 'admin', '2026-02-05 10:52:43', '');
INSERT INTO `sys_menu` VALUES (2001, '教练信息查询', 0, 6, 'CoachInformationInquiry', 'CoachInformationInquiry/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'Scout-Trooper', 'admin', '2026-02-05 10:04:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2002, '门票预订', 0, 7, 'TicketBooking', 'TicketBooking/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'tick', 'admin', '2026-02-05 10:06:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, '教练预约', 0, 8, 'CoachAppointment', 'CoachAppointment/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'guide', 'admin', '2026-02-05 10:12:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '留言版', 0, 9, 'MessageBoard', 'MessageBoard/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'edit', 'admin', '2026-02-05 10:13:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, '课程设置', 0, 10, 'Curriculum', 'Curriculum/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'Course', 'admin', '2026-02-05 10:26:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '约课管理', 0, 11, 'AppointmentManagement', 'AppointmentManagement/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'table', 'admin', '2026-02-05 10:28:35', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, '业绩明细', 0, 12, 'PerformanceDetails', 'PerformanceDetails/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'monitor', 'admin', '2026-02-05 10:30:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '门票销售', 0, 13, 'TicketSales', 'TicketSales/index', NULL, '', 1, 0, 'C', '0', '0', '', 'TicketSales', 'admin', '2026-02-05 10:32:48', 'admin', '2026-02-05 10:43:19', '');
INSERT INTO `sys_menu` VALUES (2009, '雪具租赁', 0, 14, 'SkiEquipmentRental', 'SkiEquipmentRental/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'Skiequipment', 'admin', '2026-02-05 10:35:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '雪具管理', 0, 15, 'SkiEquipmentManagement', 'SkiEquipmentManagement/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'PerformanceDetails', 'admin', '2026-02-05 10:37:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '雪道维护', 0, 16, 'Slopemaintenance', 'Slopemaintenance/index', NULL, '', 1, 0, 'C', '0', '0', 'system:slope:list', 'system', 'admin', '2026-02-05 10:39:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '公告管理', 0, 17, 'NoticeManagement', 'NoticeManagement/index', NULL, '', 1, 0, 'C', '0', '0', '', 'checkbox', 'admin', '2026-02-05 10:40:20', 'admin', '2026-02-05 10:41:33', '');
INSERT INTO `sys_menu` VALUES (2013, '员工管理', 0, 18, 'EmployeeManagement', 'EmployeeManagement/index', NULL, '', 1, 0, 'C', '0', '0', 'system:employee:list', 'peoples', 'admin', '2026-02-05 10:41:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2014, '物资管理', 0, 19, 'MaterialManagement', 'MaterialManagement/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'shopping', 'admin', '2026-02-05 10:43:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '财务统计', 0, 20, 'FinancialStatistics', 'FinancialStatistics/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'money', 'admin', '2026-02-05 10:45:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '订单处理查看', 0, 21, 'OrderProcessingView', 'OrderProcessingView/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'chart', 'admin', '2026-02-05 10:49:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, '运营数据统计', 0, 22, 'OperationalDataStatistics', 'OperationalDataStatistics/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'redis-list', 'admin', '2026-02-05 10:51:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '雪道查询', 2011, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:slope:query', '#', 'admin', '2026-02-06 16:24:14', '', NULL, '雪道查询按钮');
INSERT INTO `sys_menu` VALUES (2019, '雪道新增', 2011, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:slope:add', '#', 'admin', '2026-02-06 16:24:14', '', NULL, '雪道新增按钮');
INSERT INTO `sys_menu` VALUES (2020, '雪道修改', 2011, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:slope:edit', '#', 'admin', '2026-02-06 16:24:14', '', NULL, '雪道修改按钮');
INSERT INTO `sys_menu` VALUES (2021, '雪道删除', 2011, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:slope:remove', '#', 'admin', '2026-02-06 16:24:14', '', NULL, '雪道删除按钮');
INSERT INTO `sys_menu` VALUES (2022, '雪道导出', 2011, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:slope:export', '#', 'admin', '2026-02-06 16:24:14', '', NULL, '雪道导出按钮');
INSERT INTO `sys_menu` VALUES (2023, '员工查询', 2013, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:employee:query', '#', 'admin', '2026-02-06 16:27:29', '', NULL, '员工查询按钮');
INSERT INTO `sys_menu` VALUES (2024, '员工新增', 2013, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:employee:add', '#', 'admin', '2026-02-06 16:27:29', '', NULL, '员工新增按钮');
INSERT INTO `sys_menu` VALUES (2025, '员工修改', 2013, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:employee:edit', '#', 'admin', '2026-02-06 16:27:29', '', NULL, '员工修改按钮');
INSERT INTO `sys_menu` VALUES (2026, '员工删除', 2013, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:employee:remove', '#', 'admin', '2026-02-06 16:27:29', '', NULL, '员工删除按钮');
INSERT INTO `sys_menu` VALUES (2027, '重置密码', 2013, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:employee:resetPwd', '#', 'admin', '2026-02-06 16:27:29', '', NULL, '重置密码按钮');
INSERT INTO `sys_menu` VALUES (2028, '员工导出', 2013, 6, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:employee:export', '#', 'admin', '2026-02-06 16:27:29', '', NULL, '员工导出按钮');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-02-04 23:18:06', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-02-04 23:18:06', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 240 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":100,\"roleKey\":\"Tourist\",\"roleName\":\"游客\",\"roleSort\":3,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:23:06', 50);
INSERT INTO `sys_oper_log` VALUES (101, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":101,\"roleKey\":\"Coach\",\"roleName\":\"教练\",\"roleSort\":4,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:23:24', 42);
INSERT INTO `sys_oper_log` VALUES (102, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":102,\"roleKey\":\"Front desk\",\"roleName\":\"雪场前台\",\"roleSort\":5,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:23:54', 44);
INSERT INTO `sys_oper_log` VALUES (103, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":103,\"roleKey\":\"后勤人员\",\"roleName\":\"后勤人员\",\"roleSort\":6,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:24:07', 28);
INSERT INTO `sys_oper_log` VALUES (104, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"yk001\",\"params\":{},\"postIds\":[],\"roleIds\":[100],\"status\":\"0\",\"userId\":100,\"userName\":\"yk001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:24:40', 99);
INSERT INTO `sys_oper_log` VALUES (105, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"jl001\",\"params\":{},\"postIds\":[],\"roleIds\":[101],\"status\":\"0\",\"userId\":101,\"userName\":\"jl001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:25:00', 92);
INSERT INTO `sys_oper_log` VALUES (106, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-02-05 09:24:39\",\"delFlag\":\"0\",\"email\":\"\",\"loginIp\":\"\",\"nickName\":\"yk001\",\"params\":{},\"phonenumber\":\"13200000000\",\"postIds\":[],\"roleIds\":[100],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"Tourist\",\"roleName\":\"游客\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":100,\"userName\":\"yk001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:25:47', 40);
INSERT INTO `sys_oper_log` VALUES (107, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-02-05 09:25:00\",\"delFlag\":\"0\",\"email\":\"\",\"loginIp\":\"\",\"nickName\":\"jl001\",\"params\":{},\"phonenumber\":\"19544444444\",\"postIds\":[],\"roleIds\":[101],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":101,\"roleKey\":\"Coach\",\"roleName\":\"教练\",\"roleSort\":4,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"jl001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:25:55', 23);
INSERT INTO `sys_oper_log` VALUES (108, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"qt001\",\"params\":{},\"phonenumber\":\"14255555555\",\"postIds\":[],\"roleIds\":[102],\"status\":\"0\",\"userId\":102,\"userName\":\"qt001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:26:15', 101);
INSERT INTO `sys_oper_log` VALUES (109, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"hq001\",\"params\":{},\"phonenumber\":\"17233333333\",\"postIds\":[],\"roleIds\":[103],\"status\":\"0\",\"userId\":103,\"userName\":\"hq001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:26:40', 98);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"SkiSlopeInformationInquiry/index\",\"createBy\":\"admin\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"雪道信息查询\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"SkiSlopeInformationInquiry\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 09:29:30', 69);
INSERT INTO `sys_oper_log` VALUES (111, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"CoachInformationInquiry/index\",\"createBy\":\"admin\",\"icon\":\"Scout-Trooper\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"教练信息查询\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"CoachInformationInquiry\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:04:51', 34);
INSERT INTO `sys_oper_log` VALUES (112, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"TicketBooking/index\",\"createBy\":\"admin\",\"icon\":\"tick\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"门票预订\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":0,\"path\":\"TicketBooking\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:06:16', 24);
INSERT INTO `sys_oper_log` VALUES (113, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"CoachAppointment/index\",\"createBy\":\"admin\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"教练预约\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":0,\"path\":\"CoachAppointment\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:12:53', 40);
INSERT INTO `sys_oper_log` VALUES (114, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"MessageBoard/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"留言版\",\"menuType\":\"C\",\"orderNum\":9,\"params\":{},\"parentId\":0,\"path\":\"MessageBoard\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:13:51', 15);
INSERT INTO `sys_oper_log` VALUES (115, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"Curriculum/index\",\"createBy\":\"admin\",\"icon\":\"Course\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课程设置\",\"menuType\":\"C\",\"orderNum\":10,\"params\":{},\"parentId\":0,\"path\":\"Curriculum\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:26:59', 25);
INSERT INTO `sys_oper_log` VALUES (116, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"AppointmentManagement/index\",\"createBy\":\"admin\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"约课管理\",\"menuType\":\"C\",\"orderNum\":11,\"params\":{},\"parentId\":0,\"path\":\"AppointmentManagement\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:28:35', 21);
INSERT INTO `sys_oper_log` VALUES (117, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"PerformanceDetails/index\",\"createBy\":\"admin\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"业绩明细\",\"menuType\":\"C\",\"orderNum\":12,\"params\":{},\"parentId\":0,\"path\":\"PerformanceDetails\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:30:33', 28);
INSERT INTO `sys_oper_log` VALUES (118, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"TicketSales/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"门票销售\",\"menuType\":\"C\",\"orderNum\":13,\"params\":{},\"parentId\":0,\"path\":\"TicketSales\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:32:48', 14);
INSERT INTO `sys_oper_log` VALUES (119, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"SkiEquipmentRental/index\",\"createBy\":\"admin\",\"icon\":\"Skiequipment\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"雪具租赁\",\"menuType\":\"C\",\"orderNum\":14,\"params\":{},\"parentId\":0,\"path\":\"SkiEquipmentRental\",\"perms\":\"\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:35:48', 20);
INSERT INTO `sys_oper_log` VALUES (120, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"SkiEquipmentManagement/index\",\"createBy\":\"admin\",\"icon\":\"PerformanceDetails\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"雪具管理\",\"menuType\":\"C\",\"orderNum\":15,\"params\":{},\"parentId\":0,\"path\":\"SkiEquipmentManagement\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:37:15', 25);
INSERT INTO `sys_oper_log` VALUES (121, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"Slopemaintenance/index\",\"createBy\":\"admin\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"雪道维护\",\"menuType\":\"C\",\"orderNum\":16,\"params\":{},\"parentId\":0,\"path\":\"Slopemaintenance\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:39:22', 14);
INSERT INTO `sys_oper_log` VALUES (122, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"NoticeManagement/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"公告管理\",\"menuType\":\"C\",\"orderNum\":17,\"params\":{},\"parentId\":0,\"path\":\"NoticeManagement\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:40:20', 15);
INSERT INTO `sys_oper_log` VALUES (123, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"EmployeeManagement/index\",\"createBy\":\"admin\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"员工管理\",\"menuType\":\"C\",\"orderNum\":18,\"params\":{},\"parentId\":0,\"path\":\"EmployeeManagement\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:41:15', 14);
INSERT INTO `sys_oper_log` VALUES (124, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"NoticeManagement/index\",\"createTime\":\"2026-02-05 10:40:20\",\"icon\":\"checkbox\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2012,\"menuName\":\"公告管理\",\"menuType\":\"C\",\"orderNum\":17,\"params\":{},\"parentId\":0,\"path\":\"NoticeManagement\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:41:33', 20);
INSERT INTO `sys_oper_log` VALUES (125, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"MaterialManagement/index\",\"createBy\":\"admin\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"物资管理\",\"menuType\":\"C\",\"orderNum\":19,\"params\":{},\"parentId\":0,\"path\":\"MaterialManagement\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:43:03', 27);
INSERT INTO `sys_oper_log` VALUES (126, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"TicketSales/index\",\"createTime\":\"2026-02-05 10:32:48\",\"icon\":\"TicketSales\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2008,\"menuName\":\"门票销售\",\"menuType\":\"C\",\"orderNum\":13,\"params\":{},\"parentId\":0,\"path\":\"TicketSales\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:43:19', 21);
INSERT INTO `sys_oper_log` VALUES (127, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"FinancialStatistics/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"财务统计\",\"menuType\":\"C\",\"orderNum\":20,\"params\":{},\"parentId\":0,\"path\":\"FinancialStatistics\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:45:26', 14);
INSERT INTO `sys_oper_log` VALUES (128, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"OrderProcessingView/index\",\"createBy\":\"admin\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"订单处理查看\",\"menuType\":\"C\",\"orderNum\":21,\"params\":{},\"parentId\":0,\"path\":\"OrderProcessingView\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:49:59', 33);
INSERT INTO `sys_oper_log` VALUES (129, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"OperationalDataStatistics/index\",\"createBy\":\"admin\",\"icon\":\"redis-list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"运营数据统计\",\"menuType\":\"C\",\"orderNum\":22,\"params\":{},\"parentId\":0,\"path\":\"OperationalDataStatistics\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:51:15', 14);
INSERT INTO `sys_oper_log` VALUES (130, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"SkiSlopeInformationInquiry/index\",\"createTime\":\"2026-02-05 09:29:30\",\"icon\":\"road\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"雪道信息查询\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"SkiSlopeInformationInquiry\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 10:52:43', 14);
INSERT INTO `sys_oper_log` VALUES (131, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.edit()', 'POST', 1, 'admin', '研发部门', '/system/slope/edit', '127.0.0.1', '内网IP', '{\"description\":\"适合初学者的平缓雪道，坡度较小，安全性高\",\"difficulty\":\"1\",\"id\":1,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片_20260205110858A001.png\",\"length\":300,\"maxCapacity\":80,\"name\":\"初级雪道A\",\"params\":{},\"slopeCode\":\"SLOPE001\",\"status\":1,\"updateTime\":\"2026-02-05 11:08:59\",\"width\":25} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:08:59', 54);
INSERT INTO `sys_oper_log` VALUES (132, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.edit()', 'POST', 1, 'admin', '研发部门', '/system/slope/edit', '127.0.0.1', '内网IP', '{\"description\":\"初级雪道，适合有一定基础的初学者\",\"difficulty\":\"1\",\"id\":2,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (1)_20260205110905A002.png\",\"length\":350,\"maxCapacity\":100,\"name\":\"初级雪道B\",\"params\":{},\"slopeCode\":\"SLOPE002\",\"status\":1,\"updateTime\":\"2026-02-05 11:09:05\",\"width\":30} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:09:05', 13);
INSERT INTO `sys_oper_log` VALUES (133, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.edit()', 'POST', 1, 'admin', '研发部门', '/system/slope/edit', '127.0.0.1', '内网IP', '{\"description\":\"中级雪道，坡度适中，适合中级滑雪者\",\"difficulty\":\"2\",\"id\":3,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (2)_20260205110910A003.png\",\"length\":500,\"maxCapacity\":120,\"name\":\"中级雪道A\",\"params\":{},\"slopeCode\":\"SLOPE003\",\"status\":1,\"updateTime\":\"2026-02-05 11:09:10\",\"width\":35} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:09:10', 16);
INSERT INTO `sys_oper_log` VALUES (134, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.edit()', 'POST', 1, 'admin', '研发部门', '/system/slope/edit', '127.0.0.1', '内网IP', '{\"description\":\"中级雪道，有一定挑战性\",\"difficulty\":\"2\",\"id\":4,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (3)_20260205110916A004.png\",\"length\":600,\"maxCapacity\":150,\"name\":\"中级雪道B\",\"params\":{},\"slopeCode\":\"SLOPE004\",\"status\":1,\"updateTime\":\"2026-02-05 11:09:17\",\"width\":40} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:09:17', 12);
INSERT INTO `sys_oper_log` VALUES (135, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.edit()', 'POST', 1, 'admin', '研发部门', '/system/slope/edit', '127.0.0.1', '内网IP', '{\"description\":\"高级雪道，坡度大，适合高级滑雪者\",\"difficulty\":\"3\",\"id\":5,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (4)_20260205110922A005.png\",\"length\":800,\"maxCapacity\":80,\"name\":\"高级雪道A\",\"params\":{},\"slopeCode\":\"SLOPE005\",\"status\":1,\"updateTime\":\"2026-02-05 11:09:23\",\"width\":30} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:09:23', 12);
INSERT INTO `sys_oper_log` VALUES (136, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.edit()', 'POST', 1, 'admin', '研发部门', '/system/slope/edit', '127.0.0.1', '内网IP', '{\"description\":\"专业级雪道，极具挑战性\",\"difficulty\":\"3\",\"id\":6,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (6)_20260205110931A006.png\",\"length\":1000,\"maxCapacity\":100,\"name\":\"高级雪道B\",\"params\":{},\"slopeCode\":\"SLOPE006\",\"status\":1,\"updateTime\":\"2026-02-05 11:09:32\",\"width\":35} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:09:32', 17);
INSERT INTO `sys_oper_log` VALUES (137, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.edit()', 'POST', 1, 'admin', '研发部门', '/system/slope/edit', '127.0.0.1', '内网IP', '{\"description\":\"专业级雪道，极具挑战性\",\"difficulty\":\"3\",\"id\":6,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (5)_20260205110941A007.png\",\"length\":1000,\"maxCapacity\":100,\"name\":\"高级雪道B\",\"params\":{},\"slopeCode\":\"SLOPE006\",\"status\":1,\"updateTime\":\"2026-02-05 11:09:42\",\"width\":35} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:09:42', 7);
INSERT INTO `sys_oper_log` VALUES (138, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.edit()', 'POST', 1, 'admin', '研发部门', '/system/slope/edit', '127.0.0.1', '内网IP', '{\"description\":\"短距离练习雪道，适合新手练习\",\"difficulty\":\"1\",\"id\":7,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (6)_20260205110946A008.png\",\"length\":200,\"maxCapacity\":50,\"name\":\"练习雪道\",\"params\":{},\"slopeCode\":\"SLOPE007\",\"status\":1,\"updateTime\":\"2026-02-05 11:09:47\",\"width\":20} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:09:47', 11);
INSERT INTO `sys_oper_log` VALUES (139, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.edit()', 'POST', 1, 'admin', '研发部门', '/system/slope/edit', '127.0.0.1', '内网IP', '{\"description\":\"正在维修中，暂时关闭\",\"difficulty\":\"2\",\"id\":8,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (7)_20260205110952A009.png\",\"length\":450,\"maxCapacity\":100,\"name\":\"维修中雪道\",\"params\":{},\"slopeCode\":\"SLOPE008\",\"status\":0,\"updateTime\":\"2026-02-05 11:09:52\",\"width\":30} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:09:52', 0);
INSERT INTO `sys_oper_log` VALUES (140, '雪具信息', 2, 'com.ruoyi.system.controller.SkiEquipmentController.edit()', 'POST', 1, 'admin', '研发部门', '/system/equipment/edit', '127.0.0.1', '内网IP', '{\"availableQuantity\":75,\"brand\":\"Rossignol\",\"category\":\"1\",\"color\":\"蓝色\",\"description\":\"入门级双板，适合初学者\",\"equipmentCode\":\"EQ002\",\"id\":2,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (8)_20260205111903A010.png\",\"maintenanceQuantity\":1,\"model\":\"Experience 74\",\"name\":\"入门双板滑雪板\",\"purchasePrice\":1800,\"rentalPrice\":50,\"scrapQuantity\":0,\"size\":\"160cm\",\"status\":2,\"totalQuantity\":80,\"updateTime\":\"2026-02-05 11:19:04\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:19:04', 28);
INSERT INTO `sys_oper_log` VALUES (141, '雪具信息', 2, 'com.ruoyi.system.controller.SkiEquipmentController.edit()', 'POST', 1, 'admin', '研发部门', '/system/equipment/edit', '127.0.0.1', '内网IP', '{\"availableQuantity\":45,\"brand\":\"Salomon\",\"category\":\"1\",\"color\":\"黑色\",\"description\":\"专业级双板，适合中高级滑雪者\",\"equipmentCode\":\"EQ001\",\"id\":1,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (9)_20260205111909A011.png\",\"maintenanceQuantity\":2,\"model\":\"X-Pro 90\",\"name\":\"专业双板滑雪板\",\"purchasePrice\":3500,\"rentalPrice\":80,\"scrapQuantity\":0,\"size\":\"165cm\",\"status\":2,\"totalQuantity\":50,\"updateTime\":\"2026-02-05 11:19:09\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:19:10', 12);
INSERT INTO `sys_oper_log` VALUES (142, '雪具信息', 2, 'com.ruoyi.system.controller.SkiEquipmentController.edit()', 'POST', 1, 'admin', '研发部门', '/system/equipment/edit', '127.0.0.1', '内网IP', '{\"availableQuantity\":45,\"brand\":\"Salomon\",\"category\":\"1\",\"color\":\"黑色\",\"description\":\"专业级双板，适合中高级滑雪者\",\"equipmentCode\":\"EQ001\",\"id\":1,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (9)_20260205111934A012.png\",\"maintenanceQuantity\":2,\"model\":\"X-Pro 90\",\"name\":\"专业双板滑雪板\",\"purchasePrice\":3500,\"rentalPrice\":80,\"scrapQuantity\":0,\"size\":\"165cm\",\"status\":2,\"totalQuantity\":50,\"updateTime\":\"2026-02-05 11:19:35\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:19:35', 11);
INSERT INTO `sys_oper_log` VALUES (143, '雪具信息', 2, 'com.ruoyi.system.controller.SkiEquipmentController.edit()', 'POST', 1, 'admin', '研发部门', '/system/equipment/edit', '127.0.0.1', '内网IP', '{\"availableQuantity\":45,\"brand\":\"Salomon\",\"category\":\"1\",\"color\":\"黑色\",\"description\":\"专业级双板，适合中高级滑雪者\",\"equipmentCode\":\"EQ001\",\"id\":1,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (10)_20260205111959A013.png\",\"maintenanceQuantity\":2,\"model\":\"X-Pro 90\",\"name\":\"专业双板滑雪板\",\"purchasePrice\":3500,\"rentalPrice\":80,\"scrapQuantity\":0,\"size\":\"165cm\",\"status\":2,\"totalQuantity\":50,\"updateTime\":\"2026-02-05 11:20:00\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:20:00', 19);
INSERT INTO `sys_oper_log` VALUES (144, '雪具信息', 2, 'com.ruoyi.system.controller.SkiEquipmentController.edit()', 'POST', 1, 'admin', '研发部门', '/system/equipment/edit', '127.0.0.1', '内网IP', '{\"availableQuantity\":35,\"brand\":\"Burton\",\"category\":\"2\",\"color\":\"彩色\",\"description\":\"专业单板，适合高级玩家\",\"equipmentCode\":\"EQ003\",\"id\":3,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (9)_20260205112007A014.png\",\"maintenanceQuantity\":2,\"model\":\"Custom X\",\"name\":\"单板滑雪板\",\"purchasePrice\":4200,\"rentalPrice\":100,\"scrapQuantity\":0,\"size\":\"158cm\",\"status\":2,\"totalQuantity\":40,\"updateTime\":\"2026-02-05 11:20:07\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:20:07', 19);
INSERT INTO `sys_oper_log` VALUES (145, '雪具信息', 2, 'com.ruoyi.system.controller.SkiEquipmentController.edit()', 'POST', 1, 'admin', '研发部门', '/system/equipment/edit', '127.0.0.1', '内网IP', '{\"availableQuantity\":95,\"brand\":\"Leki\",\"category\":\"3\",\"color\":\"黑色\",\"description\":\"轻量级碳纤维滑雪杖\",\"equipmentCode\":\"EQ004\",\"id\":4,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (11)_20260205112014A015.png\",\"maintenanceQuantity\":0,\"model\":\"Carbon\",\"name\":\"碳纤维滑雪杖\",\"purchasePrice\":800,\"rentalPrice\":20,\"scrapQuantity\":0,\"size\":\"130cm\",\"status\":2,\"totalQuantity\":100,\"updateTime\":\"2026-02-05 11:20:15\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:20:15', 18);
INSERT INTO `sys_oper_log` VALUES (146, '雪具信息', 2, 'com.ruoyi.system.controller.SkiEquipmentController.edit()', 'POST', 1, 'admin', '研发部门', '/system/equipment/edit', '127.0.0.1', '内网IP', '{\"availableQuantity\":55,\"brand\":\"Giro\",\"category\":\"4\",\"color\":\"白色\",\"description\":\"带MIPS保护系统的专业头盔\",\"equipmentCode\":\"EQ005\",\"id\":5,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (12)_20260205112022A016.png\",\"maintenanceQuantity\":1,\"model\":\"Range MIPS\",\"name\":\"专业滑雪头盔\",\"purchasePrice\":1200,\"rentalPrice\":30,\"scrapQuantity\":0,\"size\":\"M\",\"status\":2,\"totalQuantity\":60,\"updateTime\":\"2026-02-05 11:20:22\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:20:22', 15);
INSERT INTO `sys_oper_log` VALUES (147, '雪具信息', 2, 'com.ruoyi.system.controller.SkiEquipmentController.edit()', 'POST', 1, 'admin', '研发部门', '/system/equipment/edit', '127.0.0.1', '内网IP', '{\"availableQuantity\":68,\"brand\":\"Oakley\",\"category\":\"5\",\"color\":\"黑色\",\"description\":\"防雾防紫外线护目镜\",\"equipmentCode\":\"EQ006\",\"id\":6,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (13)_20260205112028A017.png\",\"maintenanceQuantity\":0,\"model\":\"Flight Deck\",\"name\":\"防雾滑雪护目镜\",\"purchasePrice\":1500,\"rentalPrice\":25,\"scrapQuantity\":0,\"size\":\"L\",\"status\":2,\"totalQuantity\":70,\"updateTime\":\"2026-02-05 11:20:29\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:20:29', 19);
INSERT INTO `sys_oper_log` VALUES (148, '雪具信息', 2, 'com.ruoyi.system.controller.SkiEquipmentController.edit()', 'POST', 1, 'admin', '研发部门', '/system/equipment/edit', '127.0.0.1', '内网IP', '{\"availableQuantity\":48,\"brand\":\"Arc\'teryx\",\"category\":\"6\",\"color\":\"红色\",\"description\":\"防水透气专业滑雪服\",\"equipmentCode\":\"EQ007\",\"id\":7,\"imageUrl\":\"/profile/upload/2026/02/05/生成动漫雪道图片 (14)_20260205112036A018.png\",\"maintenanceQuantity\":0,\"model\":\"Rush\",\"name\":\"专业滑雪服套装\",\"purchasePrice\":3500,\"rentalPrice\":60,\"scrapQuantity\":0,\"size\":\"L\",\"status\":2,\"totalQuantity\":50,\"updateTime\":\"2026-02-05 11:20:38\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:20:38', 18);
INSERT INTO `sys_oper_log` VALUES (149, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-02-05 09:23:06\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2001,2002,2003,2004],\"params\":{},\"roleId\":100,\"roleKey\":\"Tourist\",\"roleName\":\"游客\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:22:10', 28);
INSERT INTO `sys_oper_log` VALUES (150, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-02-05 09:23:24\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2005,2006,2007],\"params\":{},\"roleId\":101,\"roleKey\":\"Coach\",\"roleName\":\"教练\",\"roleSort\":4,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:22:21', 29);
INSERT INTO `sys_oper_log` VALUES (151, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-02-05 09:23:54\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2008,2009],\"params\":{},\"roleId\":102,\"roleKey\":\"Front desk\",\"roleName\":\"雪场前台\",\"roleSort\":5,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:22:26', 20);
INSERT INTO `sys_oper_log` VALUES (152, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-02-05 09:24:07\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2010,2011,2012,2013,2014,2015,2016],\"params\":{},\"roleId\":103,\"roleKey\":\"后勤人员\",\"roleName\":\"后勤人员\",\"roleSort\":6,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:22:47', 26);
INSERT INTO `sys_oper_log` VALUES (153, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"全天滑雪票，营业时间内可无限次使用\",\"id\":1,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (14)_20260205115540A001.png\",\"params\":{},\"price\":280,\"remark\":\"\",\"sortOrder\":1,\"status\":\"0\",\"ticketCode\":\"TT001\",\"ticketName\":\"全天票\",\"ticketType\":\"1\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:55:41', 67);
INSERT INTO `sys_oper_log` VALUES (154, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"全天滑雪票，营业时间内可无限次使用\",\"id\":1,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (15)_20260205115604A002.png\",\"params\":{},\"price\":280,\"remark\":\"\",\"sortOrder\":1,\"status\":\"0\",\"ticketCode\":\"TT001\",\"ticketName\":\"全天票\",\"ticketType\":\"1\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:56:05', 26);
INSERT INTO `sys_oper_log` VALUES (155, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"上午半天票，9:00-13:00有效\",\"id\":2,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (16)_20260205115610A003.png\",\"params\":{},\"price\":180,\"remark\":\"\",\"sortOrder\":2,\"status\":\"0\",\"ticketCode\":\"TT002\",\"ticketName\":\"半天票（上午）\",\"ticketType\":\"2\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:56:10', 15);
INSERT INTO `sys_oper_log` VALUES (156, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"下午半天票，13:00-18:00有效\",\"id\":3,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (17)_20260205115615A004.png\",\"params\":{},\"price\":180,\"remark\":\"\",\"sortOrder\":3,\"status\":\"0\",\"ticketCode\":\"TT003\",\"ticketName\":\"半天票（下午）\",\"ticketType\":\"2\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:56:16', 8);
INSERT INTO `sys_oper_log` VALUES (157, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"夜场票，18:00-22:00有效\",\"id\":4,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (18)_20260205115620A005.png\",\"params\":{},\"price\":120,\"remark\":\"\",\"sortOrder\":4,\"status\":\"0\",\"ticketCode\":\"TT004\",\"ticketName\":\"夜场票\",\"ticketType\":\"3\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:56:21', 21);
INSERT INTO `sys_oper_log` VALUES (158, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"季度票，90天内无限次使用\",\"id\":5,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (19)_20260205115625A006.png\",\"params\":{},\"price\":3500,\"remark\":\"\",\"sortOrder\":5,\"status\":\"0\",\"ticketCode\":\"TT005\",\"ticketName\":\"季票\",\"ticketType\":\"4\",\"updateBy\":\"\",\"validDays\":90} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:56:25', 12);
INSERT INTO `sys_oper_log` VALUES (159, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"年度票，一年内无限次使用\",\"id\":6,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (20)_20260205115629A007.png\",\"params\":{},\"price\":12000,\"remark\":\"\",\"sortOrder\":6,\"status\":\"0\",\"ticketCode\":\"TT006\",\"ticketName\":\"年票\",\"ticketType\":\"5\",\"updateBy\":\"\",\"validDays\":365} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:56:29', 25);
INSERT INTO `sys_oper_log` VALUES (160, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"全天滑雪票，营业时间内可无限次使用\",\"id\":1,\"imageUrl\":\"\",\"params\":{},\"price\":280,\"remark\":\"\",\"sortOrder\":1,\"status\":\"0\",\"ticketCode\":\"TT001\",\"ticketName\":\"全天票\",\"ticketType\":\"1\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:57:45', 14);
INSERT INTO `sys_oper_log` VALUES (161, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"全天滑雪票，营业时间内可无限次使用\",\"id\":1,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (12)_20260205115750A008.png\",\"params\":{},\"price\":280,\"remark\":\"\",\"sortOrder\":1,\"status\":\"0\",\"ticketCode\":\"TT001\",\"ticketName\":\"全天票\",\"ticketType\":\"1\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 11:57:51', 17);
INSERT INTO `sys_oper_log` VALUES (162, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"全天滑雪票，营业时间内可无限次使用\",\"id\":1,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片_20260205120257A009.png\",\"params\":{},\"price\":280,\"remark\":\"\",\"sortOrder\":1,\"status\":\"0\",\"ticketCode\":\"TT001\",\"ticketName\":\"全天票\",\"ticketType\":\"1\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 12:02:57', 12);
INSERT INTO `sys_oper_log` VALUES (163, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"全天滑雪票，营业时间内可无限次使用\",\"id\":1,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片_20260205151515A010.png\",\"params\":{},\"price\":280,\"remark\":\"\",\"sortOrder\":1,\"status\":\"0\",\"ticketCode\":\"TT001\",\"ticketName\":\"全天票\",\"ticketType\":\"1\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:15:16', 9);
INSERT INTO `sys_oper_log` VALUES (164, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"全天滑雪票，营业时间内可无限次使用\",\"id\":1,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片_20260205151515A010.png,/profile/upload/2026/02/05/屏幕截图 2025-06-09 103004_20260205151550A011.png\",\"params\":{},\"price\":280,\"remark\":\"\",\"sortOrder\":1,\"status\":\"0\",\"ticketCode\":\"TT001\",\"ticketName\":\"全天票\",\"ticketType\":\"1\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:15:51', 17);
INSERT INTO `sys_oper_log` VALUES (165, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"全天滑雪票，营业时间内可无限次使用\",\"id\":1,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片_20260205151814A012.png\",\"params\":{},\"price\":280,\"remark\":\"\",\"sortOrder\":1,\"status\":\"0\",\"ticketCode\":\"TT001\",\"ticketName\":\"全天票\",\"ticketType\":\"1\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:18:15', 19);
INSERT INTO `sys_oper_log` VALUES (166, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"全天滑雪票，营业时间内可无限次使用\",\"id\":1,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片_20260205151829A013.png\",\"params\":{},\"price\":280,\"remark\":\"\",\"sortOrder\":1,\"status\":\"0\",\"ticketCode\":\"TT001\",\"ticketName\":\"全天票\",\"ticketType\":\"1\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:18:52', 18);
INSERT INTO `sys_oper_log` VALUES (167, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"上午半天票，9:00-13:00有效\",\"id\":2,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (1)_20260205153134A001.png\",\"params\":{},\"price\":180,\"remark\":\"\",\"sortOrder\":2,\"status\":\"0\",\"ticketCode\":\"TT002\",\"ticketName\":\"半天票（上午）\",\"ticketType\":\"2\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:31:36', 100);
INSERT INTO `sys_oper_log` VALUES (168, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"下午半天票，13:00-18:00有效\",\"id\":3,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (2)_20260205153141A002.png\",\"params\":{},\"price\":180,\"remark\":\"\",\"sortOrder\":3,\"status\":\"0\",\"ticketCode\":\"TT003\",\"ticketName\":\"半天票（下午）\",\"ticketType\":\"2\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:31:42', 16);
INSERT INTO `sys_oper_log` VALUES (169, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"夜场票，18:00-22:00有效\",\"id\":4,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (3)_20260205153147A003.png\",\"params\":{},\"price\":120,\"remark\":\"\",\"sortOrder\":4,\"status\":\"0\",\"ticketCode\":\"TT004\",\"ticketName\":\"夜场票\",\"ticketType\":\"3\",\"updateBy\":\"\",\"validDays\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:31:48', 18);
INSERT INTO `sys_oper_log` VALUES (170, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"季度票，90天内无限次使用\",\"id\":5,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (4)_20260205153200A004.png\",\"params\":{},\"price\":3500,\"remark\":\"\",\"sortOrder\":5,\"status\":\"0\",\"ticketCode\":\"TT005\",\"ticketName\":\"季票\",\"ticketType\":\"4\",\"updateBy\":\"\",\"validDays\":90} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:32:00', 30);
INSERT INTO `sys_oper_log` VALUES (171, '门票类型', 2, 'com.ruoyi.system.controller.SkiTicketTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/ticketType', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-02-04 23:24:21\",\"description\":\"年度票，一年内无限次使用\",\"id\":6,\"imageUrl\":\"/upload/2026/02/05/生成动漫雪道图片 (5)_20260205153205A005.png\",\"params\":{},\"price\":12000,\"remark\":\"\",\"sortOrder\":6,\"status\":\"0\",\"ticketCode\":\"TT006\",\"ticketName\":\"年票\",\"ticketType\":\"5\",\"updateBy\":\"\",\"validDays\":365} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:32:06', 20);
INSERT INTO `sys_oper_log` VALUES (172, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'admin', '研发部门', '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-05\",\"id\":6,\"orderNo\":\"T20260205300781\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"visitorIdCard\":\"\",\"visitorName\":\"崔博阳\",\"visitorPhone\":\"13209515871\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:32:41', 36);
INSERT INTO `sys_oper_log` VALUES (173, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'admin', '研发部门', '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-05\",\"id\":7,\"orderNo\":\"T20260205633177\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"visitorIdCard\":\"\",\"visitorName\":\"崔博阳\",\"visitorPhone\":\"13209515871\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:32:54', 20);
INSERT INTO `sys_oper_log` VALUES (174, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'admin', '研发部门', '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-05\",\"id\":8,\"orderNo\":\"T20260205927450\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"visitorIdCard\":\"\",\"visitorName\":\"崔博阳\",\"visitorPhone\":\"13209515871\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:33:18', 21);
INSERT INTO `sys_oper_log` VALUES (175, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'admin', '研发部门', '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-05\",\"id\":9,\"orderNo\":\"T20260205460534\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"visitorIdCard\":\"640324200009091037\",\"visitorName\":\"崔博阳\",\"visitorPhone\":\"13209515871\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:34:04', 16);
INSERT INTO `sys_oper_log` VALUES (176, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'admin', '研发部门', '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-05\",\"id\":10,\"orderNo\":\"T20260205420826\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"visitorIdCard\":\"\",\"visitorName\":\"崔博洋\",\"visitorPhone\":\"13200000000\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"bookingDate\":\"2026-02-05\",\"id\":10,\"orderNo\":\"T20260205420826\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"visitorName\":\"崔博洋\",\"visitorPhone\":\"13200000000\"}}', 0, NULL, '2026-02-05 15:42:11', 241);
INSERT INTO `sys_oper_log` VALUES (177, '门票订单', 2, 'com.ruoyi.system.controller.SkiTicketOrderController.pay()', 'POST', 1, 'admin', '研发部门', '/system/ticketOrder/pay/10', '127.0.0.1', '内网IP', '10 {\"paymentMethod\":\"2\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:42:14', 26);
INSERT INTO `sys_oper_log` VALUES (178, '门票订单', 2, 'com.ruoyi.system.controller.SkiTicketOrderController.refund()', 'POST', 1, 'admin', '研发部门', '/system/ticketOrder/refund/10', '127.0.0.1', '内网IP', '10 {\"refundReason\":\"不想给你\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:42:41', 28);
INSERT INTO `sys_oper_log` VALUES (179, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'admin', '研发部门', '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-05\",\"id\":11,\"orderNo\":\"T20260205877458\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"visitorIdCard\":\"\",\"visitorName\":\"毒打都\",\"visitorPhone\":\"14256474444\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"bookingDate\":\"2026-02-05\",\"id\":11,\"orderNo\":\"T20260205877458\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"visitorName\":\"毒打都\",\"visitorPhone\":\"14256474444\"}}', 0, NULL, '2026-02-05 15:43:19', 21);
INSERT INTO `sys_oper_log` VALUES (180, '门票订单', 2, 'com.ruoyi.system.controller.SkiTicketOrderController.pay()', 'POST', 1, 'admin', '研发部门', '/system/ticketOrder/pay/11', '127.0.0.1', '内网IP', '11 {\"paymentMethod\":\"3\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 15:43:22', 16);
INSERT INTO `sys_oper_log` VALUES (181, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'yk001', NULL, '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-05\",\"id\":12,\"orderNo\":\"T20260205762329\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"userId\":100,\"visitorIdCard\":\"\",\"visitorName\":\"测试游客个人票\",\"visitorPhone\":\"14255556666\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"bookingDate\":\"2026-02-05\",\"id\":12,\"orderNo\":\"T20260205762329\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"userId\":100,\"visitorName\":\"测试游客个人票\",\"visitorPhone\":\"14255556666\"}}', 0, NULL, '2026-02-05 16:08:34', 200);
INSERT INTO `sys_oper_log` VALUES (182, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'yk001', NULL, '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-05\",\"id\":13,\"orderNo\":\"T20260205851254\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"userId\":100,\"visitorIdCard\":\"\",\"visitorName\":\"测试游客个人票\",\"visitorPhone\":\"14255556666\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"bookingDate\":\"2026-02-05\",\"id\":13,\"orderNo\":\"T20260205851254\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":5,\"ticketTypeName\":\"季票\",\"totalAmount\":3500,\"unitPrice\":3500,\"userId\":100,\"visitorName\":\"测试游客个人票\",\"visitorPhone\":\"14255556666\"}}', 0, NULL, '2026-02-05 16:08:39', 13);
INSERT INTO `sys_oper_log` VALUES (183, '门票订单', 2, 'com.ruoyi.system.controller.SkiTicketOrderController.pay()', 'POST', 1, 'yk001', NULL, '/system/ticketOrder/pay/13', '127.0.0.1', '内网IP', '13 {\"paymentMethod\":\"2\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 16:08:40', 38);
INSERT INTO `sys_oper_log` VALUES (184, '门票订单', 2, 'com.ruoyi.system.controller.SkiTicketOrderController.cancel()', 'POST', 1, 'yk001', NULL, '/system/ticketOrder/cancel/12', '127.0.0.1', '内网IP', '12 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 16:08:47', 42);
INSERT INTO `sys_oper_log` VALUES (185, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"yk002\",\"params\":{},\"postIds\":[],\"roleIds\":[100],\"status\":\"0\",\"userId\":104,\"userName\":\"yk002\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 16:09:34', 90);
INSERT INTO `sys_oper_log` VALUES (186, '通知管理', 1, 'com.ruoyi.system.controller.SkiNoticeController.add()', 'POST', 1, 'admin', '研发部门', '/system/skiNotice', '127.0.0.1', '内网IP', '{\"expireTime\":\"2026-02-28 00:00:00\",\"id\":1,\"noticeContent\":\"今天正式开业\",\"noticeTitle\":\"开业第一天\",\"noticeType\":\"2\",\"params\":{},\"priority\":0,\"publishTime\":\"2026-02-05 00:00:00\",\"readCount\":0,\"remark\":\"\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"expireTime\":\"2026-02-28 00:00:00\",\"id\":1,\"noticeContent\":\"今天正式开业\",\"noticeTitle\":\"开业第一天\",\"noticeType\":\"2\",\"params\":{},\"priority\":0,\"publishTime\":\"2026-02-05 00:00:00\",\"readCount\":0,\"status\":\"0\"}}', 0, NULL, '2026-02-05 17:19:59', 244);
INSERT INTO `sys_oper_log` VALUES (187, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-02-05 09:24:07\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2010,2011,2012,2013,2014,2015,2016],\"params\":{},\"roleId\":103,\"roleKey\":\"houqing\",\"roleName\":\"后勤人员\",\"roleSort\":6,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 17:35:20', 85);
INSERT INTO `sys_oper_log` VALUES (188, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-02-05 09:23:54\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2008,2009],\"params\":{},\"roleId\":102,\"roleKey\":\"Frontdesk\",\"roleName\":\"雪场前台\",\"roleSort\":5,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 17:35:26', 79);
INSERT INTO `sys_oper_log` VALUES (189, '留言板', 1, 'com.ruoyi.system.controller.SkiMessageBoardController.add()', 'POST', 1, 'admin', '研发部门', '/system/messageBoard', '127.0.0.1', '内网IP', '{\"content\":\"测试管理员留言\",\"id\":15,\"likeCount\":0,\"params\":{},\"replyCount\":0,\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 19:45:20', 193);
INSERT INTO `sys_oper_log` VALUES (190, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'yk001', NULL, '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-05\",\"id\":14,\"orderNo\":\"T20260205880598\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":6,\"ticketTypeName\":\"年票\",\"totalAmount\":12000,\"unitPrice\":12000,\"userId\":100,\"visitorIdCard\":\"\",\"visitorName\":\"测测测\",\"visitorPhone\":\"13209515871\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"bookingDate\":\"2026-02-05\",\"id\":14,\"orderNo\":\"T20260205880598\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":6,\"ticketTypeName\":\"年票\",\"totalAmount\":12000,\"unitPrice\":12000,\"userId\":100,\"visitorName\":\"测测测\",\"visitorPhone\":\"13209515871\"}}', 0, NULL, '2026-02-05 20:41:37', 42);
INSERT INTO `sys_oper_log` VALUES (191, '门票订单', 2, 'com.ruoyi.system.controller.SkiTicketOrderController.pay()', 'POST', 1, 'yk001', NULL, '/system/ticketOrder/pay/14', '127.0.0.1', '内网IP', '14 {\"paymentMethod\":\"2\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 20:41:39', 32);
INSERT INTO `sys_oper_log` VALUES (192, '部门管理', 1, 'com.ruoyi.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"教练\",\"orderNum\":3,\"params\":{},\"parentId\":100,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 21:30:24', 211);
INSERT INTO `sys_oper_log` VALUES (193, '部门管理', 1, 'com.ruoyi.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"前台\",\"orderNum\":4,\"params\":{},\"parentId\":100,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 21:30:34', 17);
INSERT INTO `sys_oper_log` VALUES (194, '部门管理', 1, 'com.ruoyi.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"后勤\",\"orderNum\":5,\"params\":{},\"parentId\":100,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 21:30:44', 18);
INSERT INTO `sys_oper_log` VALUES (195, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-02-05 09:25:00\",\"delFlag\":\"0\",\"deptId\":200,\"email\":\"\",\"loginDate\":\"2026-02-05 11:21:33\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"jl001\",\"params\":{},\"phonenumber\":\"19544444444\",\"postIds\":[],\"roleIds\":[101],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":101,\"roleKey\":\"Coach\",\"roleName\":\"教练\",\"roleSort\":4,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"jl001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 21:30:59', 51);
INSERT INTO `sys_oper_log` VALUES (196, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-02-05 09:26:15\",\"delFlag\":\"0\",\"deptId\":201,\"email\":\"\",\"loginIp\":\"\",\"nickName\":\"qt001\",\"params\":{},\"phonenumber\":\"14255555555\",\"postIds\":[],\"roleIds\":[102],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":102,\"roleKey\":\"Frontdesk\",\"roleName\":\"雪场前台\",\"roleSort\":5,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":102,\"userName\":\"qt001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 21:31:03', 24);
INSERT INTO `sys_oper_log` VALUES (197, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-02-05 09:26:40\",\"delFlag\":\"0\",\"deptId\":202,\"email\":\"\",\"loginDate\":\"2026-02-05 11:21:42\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"hq001\",\"params\":{},\"phonenumber\":\"17233333333\",\"postIds\":[],\"roleIds\":[103],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":103,\"roleKey\":\"houqing\",\"roleName\":\"后勤人员\",\"roleSort\":6,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":103,\"userName\":\"hq001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-05 21:31:07', 35);
INSERT INTO `sys_oper_log` VALUES (198, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'jl001', '教练', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/02/06/7250079ffaa64689850e1fca5e2f2978.png\",\"code\":200}', 0, NULL, '2026-02-06 09:35:18', 211);
INSERT INTO `sys_oper_log` VALUES (199, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'jl001', '教练', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"/profile/upload/2026/02/06/生成动漫雪道图片 (6)_20260206094636A001.png\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 09:46:37', 28);
INSERT INTO `sys_oper_log` VALUES (200, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'jl001', '教练', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"/profile/upload/2026/02/06/生成动漫雪道图片 (6)_20260206094658A002.png\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 09:46:58', 28);
INSERT INTO `sys_oper_log` VALUES (201, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'jl001', '教练', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"/profile/upload/2026/02/06/生成动漫雪道图片 (6)_20260206095632A003.png\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 09:56:32', 14);
INSERT INTO `sys_oper_log` VALUES (202, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'jl001', '教练', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"/profile/upload/2026/02/06/生成动漫雪道图片 (6)_20260206101936A004.png\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 10:19:36', 97);
INSERT INTO `sys_oper_log` VALUES (203, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'jl001', '教练', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"/profile/upload/2026/02/06/生成动漫雪道图片 (6)_20260206101949A005.png\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 10:19:49', 39);
INSERT INTO `sys_oper_log` VALUES (204, '教练信息', 2, 'com.ruoyi.system.controller.SkiCoachInfoController.edit()', 'PUT', 1, 'jl001', '教练', '/system/coachInfo', '127.0.0.1', '内网IP', '{\"averageRating\":0,\"certificate\":\"国家滑雪教练证书\",\"coachLevel\":\"高级\",\"currentStudents\":0,\"hourlyRate\":288,\"id\":1,\"introduction\":\"我将用我毕生所学 教会你\",\"params\":{},\"ratingCount\":0,\"specialty\":\"单板滑雪 双板滑雪 特技滑雪 \",\"teachingYears\":3,\"totalStudents\":0,\"totalTeachingHours\":0,\"userId\":101} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 10:29:55', 36);
INSERT INTO `sys_oper_log` VALUES (205, '课程', 1, 'com.ruoyi.system.controller.SkiCourseController.add()', 'POST', 1, 'admin', '研发部门', '/system/course', '127.0.0.1', '内网IP', '{\"coachId\":1,\"courseName\":\"的\",\"courseType\":\"初级滑雪\",\"description\":\"\",\"duration\":60,\"id\":7,\"maxStudents\":1,\"params\":{},\"price\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 11:21:29', 48);
INSERT INTO `sys_oper_log` VALUES (206, '课程', 3, 'com.ruoyi.system.controller.SkiCourseController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/course/7', '127.0.0.1', '内网IP', '[7] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 11:21:31', 19);
INSERT INTO `sys_oper_log` VALUES (207, '课程', 1, 'com.ruoyi.system.controller.SkiCourseController.add()', 'POST', 1, 'jl001', '教练', '/system/course', '127.0.0.1', '内网IP', '{\"coachId\":101,\"courseName\":\"儿童课程\",\"courseType\":\"初级滑雪\",\"description\":\"针对儿童的课程\",\"duration\":60,\"id\":8,\"maxStudents\":4,\"params\":{},\"price\":200,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 11:29:41', 274);
INSERT INTO `sys_oper_log` VALUES (208, '课程时间表', 1, 'com.ruoyi.system.controller.SkiCourseScheduleController.add()', 'POST', 1, 'jl001', '教练', '/system/courseSchedule', '127.0.0.1', '内网IP', '{\"availableSlots\":2,\"bookedSlots\":0,\"courseId\":8,\"endTime\":\"11:30:12\",\"id\":15,\"params\":{},\"scheduleDate\":\"2026-02-01\",\"startTime\":\"11:30:12\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 11:30:36', 34);
INSERT INTO `sys_oper_log` VALUES (209, '课程时间表', 1, 'com.ruoyi.system.controller.SkiCourseScheduleController.add()', 'POST', 1, 'jl001', '教练', '/system/courseSchedule', '127.0.0.1', '内网IP', '{\"availableSlots\":2,\"bookedSlots\":0,\"courseId\":8,\"endTime\":\"12:30:37\",\"id\":16,\"params\":{},\"scheduleDate\":\"2026-02-07\",\"startTime\":\"11:30:37\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 11:30:48', 28);
INSERT INTO `sys_oper_log` VALUES (210, '课程预约', 1, 'com.ruoyi.system.controller.SkiCourseAppointmentController.add()', 'POST', 1, 'admin', '研发部门', '/system/courseAppointment', '127.0.0.1', '内网IP', '{\"appointmentDate\":\"2026-02-01\",\"coachId\":101,\"courseId\":8,\"endTime\":\"11:30:12\",\"id\":3,\"params\":{},\"paymentStatus\":\"0\",\"price\":200,\"scheduleId\":15,\"startTime\":\"11:30:12\",\"status\":\"0\",\"studentId\":1,\"studentName\":\"若依\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 11:30:56', 51);
INSERT INTO `sys_oper_log` VALUES (211, '支付预约', 2, 'com.ruoyi.system.controller.SkiCourseAppointmentController.pay()', 'PUT', 1, 'admin', '研发部门', '/system/courseAppointment/pay/3', '127.0.0.1', '内网IP', '{\"paymentMethod\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 11:46:24', 63);
INSERT INTO `sys_oper_log` VALUES (212, '确认预约', 2, 'com.ruoyi.system.controller.SkiCourseAppointmentController.confirm()', 'PUT', 1, 'jl001', '教练', '/system/courseAppointment/confirm/3', '127.0.0.1', '内网IP', '3 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 11:56:06', 65);
INSERT INTO `sys_oper_log` VALUES (213, '完成预约', 2, 'com.ruoyi.system.controller.SkiCourseAppointmentController.complete()', 'PUT', 1, 'jl001', '教练', '/system/courseAppointment/complete/3', '127.0.0.1', '内网IP', '3 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 11:56:09', 38);
INSERT INTO `sys_oper_log` VALUES (214, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-02-04 23:18:06\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 16:36:33', 18);
INSERT INTO `sys_oper_log` VALUES (215, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-02-04 23:18:06\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-06 16:36:49', 20);
INSERT INTO `sys_oper_log` VALUES (216, '门票订单', 1, 'com.ruoyi.system.controller.SkiTicketOrderController.add()', 'POST', 1, 'yk001', NULL, '/system/ticketOrder', '127.0.0.1', '内网IP', '{\"bookingDate\":\"2026-02-20\",\"id\":15,\"orderNo\":\"T20260213758538\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":6,\"ticketTypeName\":\"年票\",\"totalAmount\":12000,\"unitPrice\":12000,\"userId\":100,\"visitorIdCard\":\"\",\"visitorName\":\"测试订票\",\"visitorPhone\":\"13200000000\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"bookingDate\":\"2026-02-20\",\"id\":15,\"orderNo\":\"T20260213758538\",\"orderStatus\":\"0\",\"paidAmount\":0,\"params\":{},\"refundAmount\":0,\"refundStatus\":\"0\",\"ticketCount\":1,\"ticketTypeId\":6,\"ticketTypeName\":\"年票\",\"totalAmount\":12000,\"unitPrice\":12000,\"userId\":100,\"visitorName\":\"测试订票\",\"visitorPhone\":\"13200000000\"}}', 0, NULL, '2026-02-13 19:41:35', 213);
INSERT INTO `sys_oper_log` VALUES (217, '门票订单', 2, 'com.ruoyi.system.controller.SkiTicketOrderController.pay()', 'POST', 1, 'yk001', NULL, '/system/ticketOrder/pay/15', '127.0.0.1', '内网IP', '15 {\"paymentMethod\":\"4\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:41:40', 56);
INSERT INTO `sys_oper_log` VALUES (218, '课程', 1, 'com.ruoyi.system.controller.SkiCourseController.add()', 'POST', 1, 'jl001', '教练', '/system/course', '127.0.0.1', '内网IP', '{\"coachId\":101,\"courseName\":\"测试课程建设\",\"courseType\":\"双板滑雪\",\"description\":\"给一个字  夯\",\"duration\":60,\"id\":9,\"maxStudents\":4,\"params\":{},\"price\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:43:34', 39);
INSERT INTO `sys_oper_log` VALUES (219, '课程时间表', 1, 'com.ruoyi.system.controller.SkiCourseScheduleController.add()', 'POST', 1, 'jl001', '教练', '/system/courseSchedule', '127.0.0.1', '内网IP', '{\"availableSlots\":3,\"bookedSlots\":0,\"courseId\":9,\"endTime\":\"20:44:06\",\"id\":17,\"params\":{},\"scheduleDate\":\"2026-02-13\",\"startTime\":\"19:44:06\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:44:14', 38);
INSERT INTO `sys_oper_log` VALUES (220, '课程时间表', 1, 'com.ruoyi.system.controller.SkiCourseScheduleController.add()', 'POST', 1, 'jl001', '教练', '/system/courseSchedule', '127.0.0.1', '内网IP', '{\"availableSlots\":1,\"bookedSlots\":0,\"courseId\":9,\"endTime\":\"20:45:20\",\"id\":18,\"params\":{},\"scheduleDate\":\"2026-02-26\",\"startTime\":\"19:45:20\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:45:36', 32);
INSERT INTO `sys_oper_log` VALUES (221, '课程预约', 1, 'com.ruoyi.system.controller.SkiCourseAppointmentController.add()', 'POST', 1, 'yk001', NULL, '/system/courseAppointment', '127.0.0.1', '内网IP', '{\"appointmentDate\":\"2026-02-13\",\"coachId\":101,\"courseId\":9,\"endTime\":\"20:44:06\",\"id\":4,\"params\":{},\"paymentStatus\":\"0\",\"price\":0,\"scheduleId\":17,\"startTime\":\"19:44:06\",\"status\":\"0\",\"studentId\":100,\"studentName\":\"yk001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:46:12', 65);
INSERT INTO `sys_oper_log` VALUES (222, '支付预约', 2, 'com.ruoyi.system.controller.SkiCourseAppointmentController.pay()', 'PUT', 1, 'yk001', NULL, '/system/courseAppointment/pay/4', '127.0.0.1', '内网IP', '{\"paymentMethod\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:46:29', 28);
INSERT INTO `sys_oper_log` VALUES (223, '确认预约', 2, 'com.ruoyi.system.controller.SkiCourseAppointmentController.confirm()', 'PUT', 1, 'jl001', '教练', '/system/courseAppointment/confirm/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:47:11', 39);
INSERT INTO `sys_oper_log` VALUES (224, '完成预约', 2, 'com.ruoyi.system.controller.SkiCourseAppointmentController.complete()', 'PUT', 1, 'jl001', '教练', '/system/courseAppointment/complete/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:47:32', 30);
INSERT INTO `sys_oper_log` VALUES (225, '留言板', 1, 'com.ruoyi.system.controller.SkiMessageBoardController.add()', 'POST', 1, 'yk001', NULL, '/system/messageBoard', '127.0.0.1', '内网IP', '{\"content\":\"今天天气很好  滑雪场很棒  并且教练很帅\",\"id\":16,\"likeCount\":0,\"params\":{},\"replyCount\":0,\"status\":\"0\",\"userId\":100,\"userName\":\"yk001\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:48:22', 34);
INSERT INTO `sys_oper_log` VALUES (226, '雪具租赁信息', 2, 'com.ruoyi.system.controller.SkiEquipmentRentalController.returnEquipment()', 'POST', 1, 'qt001', '前台', '/system/equipmentRental/return', '127.0.0.1', '内网IP', '{\"id\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:52:00', 284);
INSERT INTO `sys_oper_log` VALUES (227, '雪具租赁信息', 2, 'com.ruoyi.system.controller.SkiEquipmentRentalController.cancelRental()', 'POST', 1, 'qt001', '前台', '/system/equipmentRental/cancel', '127.0.0.1', '内网IP', '{\"id\":2} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:52:04', 111);
INSERT INTO `sys_oper_log` VALUES (228, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.changeStatus()', 'POST', 1, 'hq001', '后勤', '/system/slope/changeStatus', '127.0.0.1', '内网IP', '{\"id\":8,\"params\":{},\"status\":1,\"updateTime\":\"2026-02-13 19:54:05\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:54:05', 41);
INSERT INTO `sys_oper_log` VALUES (229, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.changeStatus()', 'POST', 1, 'hq001', '后勤', '/system/slope/changeStatus', '127.0.0.1', '内网IP', '{\"id\":8,\"params\":{},\"status\":0,\"updateTime\":\"2026-02-13 19:54:13\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:54:13', 24);
INSERT INTO `sys_oper_log` VALUES (230, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.changeStatus()', 'POST', 1, 'hq001', '后勤', '/system/slope/changeStatus', '127.0.0.1', '内网IP', '{\"id\":8,\"params\":{},\"status\":1,\"updateTime\":\"2026-02-13 19:54:34\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:54:34', 21);
INSERT INTO `sys_oper_log` VALUES (231, '雪道信息', 2, 'com.ruoyi.system.controller.SkiSlopeController.changeStatus()', 'POST', 1, 'hq001', '后勤', '/system/slope/changeStatus', '127.0.0.1', '内网IP', '{\"id\":8,\"params\":{},\"status\":0,\"updateTime\":\"2026-02-13 19:54:45\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:54:45', 23);
INSERT INTO `sys_oper_log` VALUES (232, '通知管理', 1, 'com.ruoyi.system.controller.SkiNoticeController.add()', 'POST', 1, 'hq001', '后勤', '/system/skiNotice', '127.0.0.1', '内网IP', '{\"expireTime\":\"2026-02-28 00:00:00\",\"id\":12,\"noticeContent\":\"顶顶顶顶顶 \",\"noticeTitle\":\"测试发布公告功能\",\"noticeType\":\"2\",\"params\":{},\"priority\":2,\"publishTime\":\"2026-02-13 00:00:00\",\"readCount\":0,\"remark\":\"\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"expireTime\":\"2026-02-28 00:00:00\",\"id\":12,\"noticeContent\":\"顶顶顶顶顶 \",\"noticeTitle\":\"测试发布公告功能\",\"noticeType\":\"2\",\"params\":{},\"priority\":2,\"publishTime\":\"2026-02-13 00:00:00\",\"readCount\":0,\"status\":\"0\"}}', 0, NULL, '2026-02-13 19:55:34', 28);
INSERT INTO `sys_oper_log` VALUES (233, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/101', '127.0.0.1', '内网IP', '101 ', '{\"msg\":\"存在下级部门,不允许删除\",\"code\":601}', 0, NULL, '2026-02-13 19:57:41', 19);
INSERT INTO `sys_oper_log` VALUES (234, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/103', '127.0.0.1', '内网IP', '103 ', '{\"msg\":\"部门存在用户,不允许删除\",\"code\":601}', 0, NULL, '2026-02-13 19:57:45', 21);
INSERT INTO `sys_oper_log` VALUES (235, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/107', '127.0.0.1', '内网IP', '107 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:57:51', 35);
INSERT INTO `sys_oper_log` VALUES (236, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/106', '127.0.0.1', '内网IP', '106 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:57:54', 51);
INSERT INTO `sys_oper_log` VALUES (237, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/105', '127.0.0.1', '内网IP', '105 ', '{\"msg\":\"部门存在用户,不允许删除\",\"code\":601}', 0, NULL, '2026-02-13 19:57:55', 25);
INSERT INTO `sys_oper_log` VALUES (238, '门票订单', 2, 'com.ruoyi.system.controller.SkiTicketOrderController.refund()', 'POST', 1, 'hq001', '后勤', '/system/ticketOrder/refund/13', '127.0.0.1', '内网IP', '13 {\"refundReason\":\"不用了\\n\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 19:59:41', 36);
INSERT INTO `sys_oper_log` VALUES (239, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/dict/index\",\"createTime\":\"2026-02-04 23:18:06\",\"icon\":\"dict\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":105,\"menuName\":\"字典管理\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":1,\"path\":\"dict\",\"perms\":\"system:dict:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 20:01:59', 34);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-02-04 23:18:06', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-02-04 23:18:06', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-02-04 23:18:06', '', NULL, '普通角色');
INSERT INTO `sys_role` VALUES (100, '游客', 'Tourist', 3, '1', 1, 1, '0', '0', 'admin', '2026-02-05 09:23:06', 'admin', '2026-02-05 11:22:10', NULL);
INSERT INTO `sys_role` VALUES (101, '教练', 'Coach', 4, '1', 1, 1, '0', '0', 'admin', '2026-02-05 09:23:24', 'admin', '2026-02-05 11:22:21', NULL);
INSERT INTO `sys_role` VALUES (102, '雪场前台', 'Frontdesk', 5, '1', 1, 1, '0', '0', 'admin', '2026-02-05 09:23:54', 'admin', '2026-02-05 17:35:25', NULL);
INSERT INTO `sys_role` VALUES (103, '后勤人员', 'houqing', 6, '1', 1, 1, '0', '0', 'admin', '2026-02-05 09:24:07', 'admin', '2026-02-05 17:35:20', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (100, 2000);
INSERT INTO `sys_role_menu` VALUES (100, 2001);
INSERT INTO `sys_role_menu` VALUES (100, 2002);
INSERT INTO `sys_role_menu` VALUES (100, 2003);
INSERT INTO `sys_role_menu` VALUES (100, 2004);
INSERT INTO `sys_role_menu` VALUES (101, 2005);
INSERT INTO `sys_role_menu` VALUES (101, 2006);
INSERT INTO `sys_role_menu` VALUES (101, 2007);
INSERT INTO `sys_role_menu` VALUES (102, 2008);
INSERT INTO `sys_role_menu` VALUES (102, 2009);
INSERT INTO `sys_role_menu` VALUES (103, 2010);
INSERT INTO `sys_role_menu` VALUES (103, 2011);
INSERT INTO `sys_role_menu` VALUES (103, 2012);
INSERT INTO `sys_role_menu` VALUES (103, 2013);
INSERT INTO `sys_role_menu` VALUES (103, 2014);
INSERT INTO `sys_role_menu` VALUES (103, 2015);
INSERT INTO `sys_role_menu` VALUES (103, 2016);
INSERT INTO `sys_role_menu` VALUES (103, 2018);
INSERT INTO `sys_role_menu` VALUES (103, 2019);
INSERT INTO `sys_role_menu` VALUES (103, 2020);
INSERT INTO `sys_role_menu` VALUES (103, 2021);
INSERT INTO `sys_role_menu` VALUES (103, 2022);
INSERT INTO `sys_role_menu` VALUES (103, 2023);
INSERT INTO `sys_role_menu` VALUES (103, 2024);
INSERT INTO `sys_role_menu` VALUES (103, 2025);
INSERT INTO `sys_role_menu` VALUES (103, 2026);
INSERT INTO `sys_role_menu` VALUES (103, 2027);
INSERT INTO `sys_role_menu` VALUES (103, 2028);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 105 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-02-13 19:37:31', '2026-02-04 23:18:06', 'admin', '2026-02-04 23:18:06', '', NULL, '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-02-04 23:18:06', '2026-02-04 23:18:06', 'admin', '2026-02-04 23:18:06', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (100, NULL, 'yk001', 'yk001', '00', '', '13200000000', '0', '', '$2a$10$dW.yfRe7p//esEx7VFvnC.OzAKkfTEMuoCXvarpWf2LuawRwlvMku', '0', '0', '127.0.0.1', '2026-02-13 19:38:52', NULL, 'admin', '2026-02-05 09:24:39', 'admin', '2026-02-05 09:25:47', NULL);
INSERT INTO `sys_user` VALUES (101, 200, 'jl001', 'jl001', '00', '', '19544444444', '0', '/profile/upload/2026/02/06/生成动漫雪道图片 (6)_20260206101949A005.png', '$2a$10$vsJwgqNlE.pHOGNXIkt/TO5L1JTinbNDYd3r8LSg2vUvKzty4mD0.', '0', '0', '127.0.0.1', '2026-02-13 19:40:16', NULL, 'admin', '2026-02-05 09:25:00', 'admin', '2026-02-06 10:19:49', NULL);
INSERT INTO `sys_user` VALUES (102, 201, 'qt001', 'qt001', '00', '', '14255555555', '0', '', '$2a$10$G144WOPJRxCX.W1SXmBK3Oh2yFi.idxvSQPQC8HBMd0WtmXOtTZoi', '0', '0', '127.0.0.1', '2026-02-13 19:50:59', NULL, 'admin', '2026-02-05 09:26:15', 'admin', '2026-02-05 21:31:03', NULL);
INSERT INTO `sys_user` VALUES (103, 202, 'hq001', 'hq001', '00', '', '17233333333', '0', '', '$2a$10$NW8fxT8wc.GsaO9qouAx5uxDSsHdbcFykBp0ZgFASe6iJC3eZZtWK', '0', '0', '127.0.0.1', '2026-02-13 19:52:37', NULL, 'admin', '2026-02-05 09:26:40', 'admin', '2026-02-05 21:31:07', NULL);
INSERT INTO `sys_user` VALUES (104, NULL, 'yk002', 'yk002', '00', '', '', '0', '', '$2a$10$7k6hGFp1uuF3whm8892yMO0naCaUEaVsiR0kVGCIsDZMZzYgR9Rm.', '0', '0', '127.0.0.1', '2026-02-13 19:48:56', NULL, 'admin', '2026-02-05 16:09:34', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (100, 100);
INSERT INTO `sys_user_role` VALUES (101, 101);
INSERT INTO `sys_user_role` VALUES (102, 102);
INSERT INTO `sys_user_role` VALUES (103, 103);
INSERT INTO `sys_user_role` VALUES (104, 100);

SET FOREIGN_KEY_CHECKS = 1;
