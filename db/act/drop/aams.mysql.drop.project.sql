-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: 139.224.1.36    Database: chengtou
-- ------------------------------------------------------
-- Server version	5.7.17-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aams_estimate`
--

DROP TABLE IF EXISTS `aams_estimate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aams_estimate` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `project_id` varchar(64) DEFAULT NULL COMMENT '项目外建',
  `fraction` int(11) DEFAULT NULL COMMENT '分数',
  `evolve` varchar(255) DEFAULT NULL COMMENT '进展情况',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT NULL COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='执行评估表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aams_project`
--

DROP TABLE IF EXISTS `aams_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aams_project` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `num` varchar(20) DEFAULT NULL COMMENT '项目编号',
  `level` varchar(500) DEFAULT NULL,
  `items` text COMMENT '督办事项',
  `source` varchar(100) DEFAULT NULL COMMENT '来源',
  `office_id` varchar(64) DEFAULT NULL COMMENT '责任部门',
  `job_plain` text COMMENT '工作计划',
  `will_finish_time` date DEFAULT NULL COMMENT '办结时限',
  `evolve` varchar(500) DEFAULT NULL COMMENT '进展情况',
  `estimate` varchar(255) DEFAULT NULL COMMENT '执行评估',
  `estimate_time` date DEFAULT NULL COMMENT '评估时间',
  `comments` text COMMENT '备注',
  `end_time` date DEFAULT NULL COMMENT '项目结束日期',
  `files` varchar(500) DEFAULT NULL COMMENT '附件',
  `order_num` int(11) DEFAULT NULL COMMENT '列表排序',
  `status` char(1) DEFAULT NULL COMMENT '状态（1项目建立；2进行中；3需督促；4已结项；）',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT NULL COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='督办项目表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aams_project_user`
--

DROP TABLE IF EXISTS `aams_project_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aams_project_user` (
  `id` varchar(64) NOT NULL,
  `project_id` varchar(64) NOT NULL,
  `user_id` varchar(64) NOT NULL COMMENT '项目负责人',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT NULL COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='项目负责人';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oa_estimate_approve`
--

DROP TABLE IF EXISTS `oa_estimate_approve`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oa_estimate_approve` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `proc_ins_id` varchar(64) DEFAULT NULL COMMENT '流程实例编号',
  `estimate_id` varchar(64) DEFAULT NULL COMMENT '评分表外键',
  `approve_user_id` varchar(64) DEFAULT NULL COMMENT '评分申请人',
  `old_fraction` int(11) DEFAULT NULL COMMENT '原来评分',
  `fraction_approve` int(11) DEFAULT NULL COMMENT '申请评分',
  `reason` varchar(500) DEFAULT NULL COMMENT '申请原因',
  `bumen_user_id` varchar(64) DEFAULT NULL COMMENT '部门长',
  `bumen_suggest` varchar(500) DEFAULT NULL COMMENT '部门长意见',
  `bumen_time` datetime DEFAULT NULL COMMENT '部门长操作时间',
  `admin_user_id` varchar(64) DEFAULT NULL COMMENT '管理员',
  `admin_suggest` varchar(500) DEFAULT NULL COMMENT '管理员流转备注',
  `admin_time` datetime DEFAULT NULL COMMENT '管理员操作时间',
  `leader_user_id` varchar(64) DEFAULT NULL COMMENT '分管领导',
  `leader_suggest` varchar(500) DEFAULT NULL COMMENT '分管领导意见',
  `leader_time` datetime DEFAULT NULL COMMENT '分管领导操作时间',
  `boss_user_id` varchar(64) DEFAULT NULL COMMENT '单位负责人',
  `boss_suggest` varchar(500) DEFAULT NULL COMMENT '单位负责人审批意见',
  `boss_time` datetime DEFAULT NULL COMMENT '单位负责人审批时间',
  `boss_result` char(1) DEFAULT NULL COMMENT '审批结果（1同意；2驳回）',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT NULL COMMENT '删除标记',
  `status` char(1) DEFAULT NULL COMMENT '状态（1提出改分申请；2部门长已批注；3管理员已分配分管领导；4分管领导已批注；4单位负责人审批通过；5单位负责人审批驳回）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='申请评分表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_god`
--

DROP TABLE IF EXISTS `sys_god`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_god` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day_count` int(11) DEFAULT '1' COMMENT '一天内的数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'chengtou'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `event_sys_god_day_count` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `event_sys_god_day_count` ON SCHEDULE EVERY 1 DAY STARTS '2017-07-12 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO update sys_god set day_count = 1 where id = 1 */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'chengtou'
--
/*!50003 DROP PROCEDURE IF EXISTS `new_procedure` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_procedure`()
  BEGIN
    declare x int;
    select 1 as x from dual;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-07-17 10:31:21
