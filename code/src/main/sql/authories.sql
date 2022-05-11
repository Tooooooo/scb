-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: project_base
-- ------------------------------------------------------
-- Server version	5.7.17-log

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
-- Table structure for table `api_url_prefix`
--

DROP TABLE IF EXISTS `api_url_prefix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_url_prefix` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '行标识',
  `url_prefix` varchar(64) NOT NULL COMMENT '接口前缀. 除非权限控制的要求特别精细(如某用户只能添加操作而不能删除), 一般而言只需要记录一类操作的url前缀, 例如: article/m 前缀语义上包含了 article/m/add  , article/m/remove 等接口的url. \n当然也可以记录一个接口的全url, 但这只在需求特别要求的情况下采用.',
  `naming` varchar(32) NOT NULL COMMENT '接口的名称或某类接口的名称',
  PRIMARY KEY (`id`),
  UNIQUE KEY `url_UNIQUE` (`url_prefix`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COMMENT='记录系统需要受管控的接口前缀. 最大支持64个受管控接口前缀. 注意这里通常只记录需要权限管控的接口"前缀"而不是全名';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_url_prefix`
--

LOCK TABLES `api_url_prefix` WRITE;
/*!40000 ALTER TABLE `api_url_prefix` DISABLE KEYS */;
INSERT INTO `api_url_prefix` VALUES (1,'/city/changan','进入长安'),(2,'/city/xuchang','进入许昌'),(3,'/city/chengdu','进入成都'),(4,'/city/hanzhong','进入汉中'),(5,'/city/jianye','进入建业'),(6,'/city/changsha','进入长沙'),(7,'/general/zhangliao','武将-张辽'),(8,'/general/zhanghe','武将-张郃'),(9,'/general/xunyu','武将-荀彧'),(10,'/general/guojia','武将-郭嘉'),(11,'/general/guanyu','武将-关羽'),(12,'/general/zhaoyun','武将-赵云'),(13,'/general/zhugeliang','武将-诸葛亮'),(14,'/general/fazheng','武将-法正'),(15,'/general/taishici','武将-太史慈'),(16,'/general/ganning','武将-甘宁'),(17,'/general/zhangzhao','武将-张昭'),(18,'/general/luxun','武将-陆逊');
/*!40000 ALTER TABLE `api_url_prefix` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrance`
--

DROP TABLE IF EXISTS `entrance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entrance` (
  `mask` bigint(20) unsigned NOT NULL COMMENT '掩码,用于计算受权限管控的主体的是否可以进入, 同时也作为标识符',
  `code` varchar(128) DEFAULT NULL COMMENT '如有必要记录接口的代号',
  `menu` int(8) unsigned NOT NULL COMMENT '对应menu',
  `api` int(8) DEFAULT NULL COMMENT '对应的api_url,表明该功能入口对应的api_url, -1 表示不对应任何url',
  `upper` bigint(20) unsigned DEFAULT NULL COMMENT '上级入口的掩码(标识), 最上层为0(不是null)',
  `naming` varchar(32) NOT NULL COMMENT '命名',
  `sort` int(11) DEFAULT NULL COMMENT '在同一个上级选单范围内排序,数字小的排在前面.默认为0',
  `entrance_level` int(10) unsigned NOT NULL COMMENT '菜单树的层次，以便于查询指定层级的菜单',
  `path` varchar(254) NOT NULL COMMENT '树id的路径，主要用于存放从根节点到当前树的父节点的路径，以斜线表示层级,如: foo/bar/baz，想要找父节点会特别快',
  `disabled` int(10) unsigned DEFAULT '0' COMMENT '禁用标志位, 1:已禁用, 0:未禁用',
  PRIMARY KEY (`mask`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='将选单Menu和api_url统一的抽象概念,便于前端通过此概念进行大粒度的权限和视图定制';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrance`
--

LOCK TABLES `entrance` WRITE;
/*!40000 ALTER TABLE `entrance` DISABLE KEYS */;
INSERT INTO `entrance` VALUES (1,'weiguo',1,-1,0,'三国志-魏国',NULL,1,'/weiguo',0),(2,'shuguo',2,-1,0,'三国志-蜀国',NULL,1,'/shuguo',0),(4,'wuguo',3,-1,0,'三国志-吴国',NULL,1,'/wuguo',0),(8,'changan',4,1,1,'进入长安',NULL,2,'/weiguo/changan',0),(16,'xuchang',5,2,1,'进入许都',NULL,2,'/weiguo/xuchang',0),(32,'chengdu',6,3,2,'进入成都',NULL,2,'/shuguo/chengdu',0),(64,'hanzhong',7,4,2,'进入汉中',NULL,2,'/shuguo/hanzhong',0),(128,'jianye',8,5,4,'进入建业',NULL,2,'/wuguo/jianye',0),(256,'changsha',9,6,4,'进入长沙',NULL,2,'/wuguo/changsha',0),(512,'zhangliao',10,7,8,'武将-张辽',NULL,3,'/weiguo/changan/zhangliao',0),(1024,'xunyu',11,9,8,'谋臣-荀彧',NULL,3,'/weiguo/changan/xunyu',0),(2048,'guojia',12,10,16,'谋臣-郭嘉',NULL,3,'/weiguo/xuchang/guojia',0),(4096,'zhugeliang',13,13,32,'军师-诸葛亮',NULL,3,'/shuguo/chengdu/zhugeliang',0),(8192,'fazheng',14,14,64,'军师-法正',NULL,3,'/shuguo/hanzhong/fazheng',0),(16384,'zhangzhao',15,17,128,'谋臣-张昭',NULL,3,'/wuguo/jianye/zhangzhao',0),(32768,'luxun',16,18,256,'都督-陆逊',NULL,3,'/wuguo/changsha/luxun',0),(65536,'zhanghe',17,8,16,'武将-张郃',NULL,3,'/weiguo/xuchang/zhanghe',0),(131072,'guanyu',18,11,32,'世之虎将-关羽',NULL,3,'/shuguo/chengdu/guanyu',0),(262144,'zhaoyun',19,12,64,'世之虎将-赵云',NULL,3,'/shuguo/hanzhong/zhaoyun',0),(524288,'taishici',20,15,128,'武将-太史慈',NULL,3,'/wuguo/jianye/taishici',0),(1048576,'ganning',21,16,256,'武将-甘宁',NULL,3,'/wuguo/changsha/ganning',0);
/*!40000 ALTER TABLE `entrance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '标识',
  `username` varchar(32) NOT NULL COMMENT '登录用户名',
  `password` varchar(64) NOT NULL COMMENT '登录密码',
  `wx_openid` char(28) DEFAULT NULL COMMENT '微信 openid',
  `phone_no` varchar(255) DEFAULT NULL COMMENT '当用手机号码登录时的判断',
  `employee_no` varchar(32) DEFAULT NULL COMMENT '工号',
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登录数据的最后修改日期',
  `freeze` int(1) NOT NULL DEFAULT '0' COMMENT '用户是否被冻结 0-否 1-是',
  `roles` varchar(128) NOT NULL COMMENT '以逗号分隔的角色code',
  `deleted` int(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标志位, 1:已删除, 0:未删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `wx_openid_UNIQUE` (`wx_openid`),
  UNIQUE KEY `employee_no_UNIQUE` (`employee_no`)
) ENGINE=InnoDB AUTO_INCREMENT=700 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户登录信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_entrance_auth`
--

DROP TABLE IF EXISTS `login_entrance_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_entrance_auth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '标识',
  `username` varchar(32) DEFAULT NULL COMMENT '用户账号',
  `entrance_bin` bigint(10) DEFAULT NULL COMMENT '权限位码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='选以用户为参照的入口可见性 ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_entrance_auth`
--

LOCK TABLES `login_entrance_auth` WRITE;
/*!40000 ALTER TABLE `login_entrance_auth` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_entrance_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '标识',
  `naming` varchar(32) NOT NULL COMMENT '命名',
  `type` int(10) unsigned NOT NULL COMMENT '选单类型: 1-文件夹;2-链接;3-按钮(js交互);4-页面内按钮;5-非交互式',
  `txt` varchar(32) DEFAULT NULL COMMENT '选单文本',
  `url` varchar(256) DEFAULT NULL COMMENT '选单链接',
  `foreground_color` varchar(32) DEFAULT NULL COMMENT '选单文本颜色',
  `menu_style` varchar(128) DEFAULT NULL COMMENT '选单个体样式',
  `txt_style` varchar(128) DEFAULT NULL COMMENT '选单文本样式',
  `tip` varchar(128) DEFAULT NULL COMMENT '鼠标悬停提示文字',
  `background_image` varchar(128) DEFAULT NULL COMMENT '背景图',
  `background_color` varchar(32) DEFAULT NULL COMMENT '背景色',
  `icon` varchar(128) DEFAULT NULL COMMENT '图标',
  `prompt` varchar(128) DEFAULT NULL COMMENT '点击弹出提示',
  `click_action` varchar(1024) DEFAULT NULL COMMENT '点击后的响应内容',
  `hover_action` varchar(1024) DEFAULT NULL COMMENT '鼠标悬停的响应内容',
  `open_mode` varchar(32) DEFAULT NULL COMMENT '跳转模式',
  `sort` int(11) DEFAULT NULL COMMENT '在同一个上级选单范围内排序,数字小的排在前面.默认为0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COMMENT='选单 ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'三国志-魏国',1,'魏国',NULL,NULL,'font=12pt;color=white','color=red;weight=bold','威武雄风','http://foo.bar.com/wei.png','#121212','/p/pic/wei.gif','good or no good','open(\'some panel\')','open(\'any panel\')','new',1),(2,'三国志-蜀国',1,'蜀国',NULL,NULL,'font=13pt;color=white','color=green;weight=bold','励精图治','shu.png','#232323','/p/pic/shu.gif','危急存亡之秋也','open(\'some pane2\')','open(\'any pane2\')','old',2),(3,'三国志-吴国',1,'吴国',NULL,NULL,'font=13pt;color=gray','color=blue;weight=bold','千古江山,英雄无觅孙仲谋处','wu.png','#555555','/p/pic/wu.gif','江东基业已历三世','open(\'some pane3\')','open(\'any pane3\')','self',3),(4,'进入长安',3,'长安',NULL,NULL,NULL,NULL,'长安城','changan.png',NULL,'city.gif','西北望长安可怜无数山',NULL,NULL,'self',1),(5,'进入许都',3,'许昌',NULL,NULL,NULL,NULL,'河南许昌市','xuchang.png',NULL,'city.gif','世祖之发迹',NULL,NULL,'self',2),(6,'进入成都',3,'成都',NULL,NULL,NULL,NULL,'锦官城','chengdu.png',NULL,'city.gif','天府之国',NULL,NULL,'self',1),(7,'进入汉中',3,'汉中',NULL,NULL,NULL,NULL,'汉中王','hanzhong.png',NULL,'city.gif','王霸之地',NULL,NULL,'self',2),(8,'进入建业',3,'建业',NULL,NULL,NULL,NULL,'建国大业','jianye.png',NULL,'city.gif','南京',NULL,NULL,'self',1),(9,'进入长沙',3,'长沙',NULL,NULL,NULL,NULL,'长沙韩玄','changsha.png',NULL,'city.gif','江东六郡之',NULL,NULL,'self',2),(10,'武将-张辽',4,'张辽',NULL,NULL,NULL,NULL,'突袭','flat.png',NULL,'general.gif','张文远','openDiglog()',NULL,NULL,1),(11,'谋臣-荀彧',4,'荀彧',NULL,NULL,NULL,NULL,'驱虎节命','flat.png',NULL,'general.gif','荀文若','openDiglog(\'xunyu\')',NULL,NULL,2),(12,'谋臣-郭嘉',4,'郭嘉',NULL,NULL,NULL,NULL,'天妒遗计','flat.png',NULL,'general.gif','荀奉孝','openDiglog(\'guojia\')',NULL,NULL,2),(13,'军师-诸葛亮',4,'诸葛亮',NULL,NULL,NULL,NULL,'观星空城','flat.png',NULL,'general.gif','诸葛孔明起陇中','openDiglog(\'zhugeliang\')',NULL,NULL,2),(14,'军师-法正',4,'法正',NULL,NULL,NULL,NULL,'恩怨眩惑','flat.png',NULL,'general.gif','法孝直','openDiglog(\'fazheng\')',NULL,NULL,2),(15,'谋臣-张昭',4,'张昭',NULL,NULL,NULL,NULL,'直谏固政','flat.png',NULL,'general.gif','张子布','openDiglog(\'zhangzhao\')',NULL,NULL,2),(16,'都督-陆逊',4,'陆逊',NULL,NULL,NULL,NULL,'谦逊连营','flat.png',NULL,'general.gif','陆伯言','openDiglog(\'luxun\')',NULL,NULL,2),(17,'武将-张郃',4,'张郃',NULL,NULL,NULL,NULL,'巧变','flat.png',NULL,'general.gif','张隽乂','openDiglog(\'zhanghe\')',NULL,NULL,1),(18,'世之虎将-关羽',4,'关羽',NULL,NULL,NULL,NULL,'武圣','flat.png',NULL,'general.gif','关云长','openDiglog(\'guanyu\')',NULL,NULL,1),(19,'世之虎将-赵云',4,'赵云',NULL,NULL,NULL,NULL,'龙胆','flat.png',NULL,'general.gif','赵子龙','openDiglog(\'zhaoyun\')',NULL,NULL,1),(20,'武将-太史慈',4,'太史慈',NULL,NULL,NULL,NULL,'天义','flat.png',NULL,'general.gif','太史子义','openDiglog(\'taishici\')',NULL,NULL,1),(21,'武将-甘宁',4,'甘宁',NULL,NULL,NULL,NULL,'奇袭奋威','flat.png',NULL,'general.gif','甘兴霸','openDiglog(\'ganning\')',NULL,NULL,1);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `code` varchar(32) NOT NULL COMMENT '角色标识,如:admin,limited',
  `brief` varchar(128) DEFAULT NULL COMMENT '角色的描述',
  `creator` varchar(32) DEFAULT NULL COMMENT '创建人',
  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='角色';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES ('cpuplayer','电脑模拟玩家','koei','2021-07-23 11:19:40'),('shuplayer','蜀国玩家','koei','2021-07-23 10:40:39'),('superplayer','超级玩家','koei','2021-07-23 11:22:07'),('weiplayer','魏国玩家','koei','2021-07-23 10:37:27'),('wuplayer','吴国玩家','koei','2021-07-23 10:40:58');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_entrance_auth`
--

DROP TABLE IF EXISTS `role_entrance_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_entrance_auth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '标识',
  `role` varchar(32) DEFAULT NULL COMMENT '角色',
  `entrance_bin` bigint(10) DEFAULT NULL COMMENT '权限位码',
  PRIMARY KEY (`id`),
  KEY `idx_role_entrance_auth_role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='以角色为参照的入口可见性 ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_entrance_auth`
--

LOCK TABLES `role_entrance_auth` WRITE;
/*!40000 ALTER TABLE `role_entrance_auth` DISABLE KEYS */;
INSERT INTO `role_entrance_auth` VALUES (2,'shuplayer',405602),(3,'wuplayer',1622404),(5,'superplayer',2031615),(6,'weiplayer',69145),(7,'cpuplayer',1691549);
/*!40000 ALTER TABLE `role_entrance_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'project_base'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-23 17:14:54
