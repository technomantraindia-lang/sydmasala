-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: syd_spices_backend
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addresses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address_type` varchar(255) NOT NULL,
  `parent_address_id` int(10) unsigned DEFAULT NULL,
  `customer_id` int(10) unsigned DEFAULT NULL COMMENT 'null if guest checkout',
  `cart_id` int(10) unsigned DEFAULT NULL COMMENT 'only for cart_addresses',
  `order_id` int(10) unsigned DEFAULT NULL COMMENT 'only for order_addresses',
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `postcode` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `vat_id` varchar(255) DEFAULT NULL,
  `default_address` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'only for customer_addresses',
  `use_for_shipping` tinyint(1) NOT NULL DEFAULT 0,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `addresses_customer_id_foreign` (`customer_id`),
  KEY `addresses_cart_id_foreign` (`cart_id`),
  KEY `addresses_order_id_foreign` (`order_id`),
  KEY `addresses_parent_address_id_foreign` (`parent_address_id`),
  CONSTRAINT `addresses_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  CONSTRAINT `addresses_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `addresses_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `addresses_parent_address_id_foreign` FOREIGN KEY (`parent_address_id`) REFERENCES `addresses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,'order_shipping',NULL,3,NULL,1,'Aarav','Patel',NULL,NULL,'Flat 402, Shivalik High Street, Bodakdev','Ahmedabad','Gujarat','IN','380054','aarav@sydspices.com','+91 98765 43210',NULL,0,0,NULL,'2026-11-02 10:35:12','2026-11-02 10:35:12'),(2,'order_billing',NULL,3,NULL,1,'Aarav','Patel',NULL,NULL,'Flat 402, Shivalik High Street, Bodakdev','Ahmedabad','Gujarat','IN','380054','aarav@sydspices.com','+91 98765 43210',NULL,0,0,NULL,'2026-11-02 10:35:12','2026-11-02 10:35:12'),(3,'order_shipping',NULL,3,NULL,2,'Aarav','Patel',NULL,NULL,'Flat 402, Shivalik High Street, Bodakdev','Ahmedabad','Gujarat','IN','380054','aarav@sydspices.com','+91 98765 43210',NULL,0,0,NULL,'2026-11-02 10:38:14','2026-11-02 10:38:14'),(4,'order_billing',NULL,3,NULL,2,'Aarav','Patel',NULL,NULL,'Flat 402, Shivalik High Street, Bodakdev','Ahmedabad','Gujarat','IN','380054','aarav@sydspices.com','+91 98765 43210',NULL,0,0,NULL,'2026-11-02 10:38:14','2026-11-02 10:38:14'),(5,'order_shipping',NULL,4,NULL,3,'Vikram','Singhania',NULL,NULL,'42 Heritage Bungalows, Satellite','Ahmedabad','Gujarat','IN','380015','vikram@example.com','+91 98200 12345',NULL,0,0,NULL,'2026-11-06 10:55:41','2026-11-06 10:55:41'),(6,'order_billing',NULL,4,NULL,3,'Vikram','Singhania',NULL,NULL,'42 Heritage Bungalows, Satellite','Ahmedabad','Gujarat','IN','380015','vikram@example.com','+91 98200 12345',NULL,0,0,NULL,'2026-11-06 10:55:41','2026-11-06 10:55:41'),(7,'order_shipping',NULL,3,NULL,4,'Vivek','Test',NULL,NULL,'Gala 12, Spice Park Mandi Road','Ahmedabad','Gujarat','IN','384170','test.order@sydspices.com','+91 98765 43210',NULL,0,0,NULL,'2026-11-13 06:43:46','2026-11-13 06:43:46'),(8,'order_billing',NULL,3,NULL,4,'Vivek','Test',NULL,NULL,'Gala 12, Spice Park Mandi Road','Ahmedabad','Gujarat','IN','384170','test.order@sydspices.com','+91 98765 43210',NULL,0,0,NULL,'2026-11-13 06:43:46','2026-11-13 06:43:46'),(9,'order_shipping',NULL,3,NULL,5,'Test','Customer (Vivek)',NULL,NULL,'Gala No. 12, Spice Park Mandi Road','Ahmedabad, Gujarat','Gujarat','IN','384170','test.buyer@sydspices.com','+91 98765 43210',NULL,0,0,NULL,'2026-11-13 06:49:09','2026-11-13 06:49:09'),(10,'order_billing',NULL,3,NULL,5,'Test','Customer (Vivek)',NULL,NULL,'Gala No. 12, Spice Park Mandi Road','Ahmedabad, Gujarat','Gujarat','IN','384170','test.buyer@sydspices.com','+91 98765 43210',NULL,0,0,NULL,'2026-11-13 06:49:09','2026-11-13 06:49:09'),(11,'customer',NULL,3,NULL,NULL,'Aarav','Patel',NULL,NULL,'Gala No. 12, Spice Park Mandi Road','Ahmedabad, Gujarat','Gujarat','IN','384170','aarav@sydspices.com','+91 98765 43210',NULL,1,1,NULL,NULL,'2026-11-13 07:23:55'),(12,'customer',NULL,9,NULL,NULL,'Vivek','Test Account',NULL,NULL,'Gala No. 12, Spice Park Mandi Road','Ahmedabad, Gujarat','Gujarat','IN','384170','vivek.developer@sydspices.com','+91 97777 55555',NULL,1,1,NULL,NULL,'2026-11-13 07:54:12'),(13,'customer',NULL,10,NULL,NULL,'Raxesh','patel',NULL,NULL,'Survey No -60, Near Haripura Village','Ahmedabad, Gujarat','Gujarat','IN','384170','superadmin@amezproducts.com','+918733898966',NULL,1,1,NULL,NULL,'2026-11-13 08:01:27'),(14,'order_shipping',NULL,10,NULL,6,'Raxesh','patel',NULL,NULL,'Survey No -60, Near Haripura Village','Ahmedabad, Gujarat','Gujarat','IN','384170','superadmin@amezproducts.com','+918733898966',NULL,0,0,NULL,'2026-11-13 08:02:06','2026-11-13 08:02:06'),(15,'order_billing',NULL,10,NULL,6,'Raxesh','patel',NULL,NULL,'Survey No -60, Near Haripura Village','Ahmedabad, Gujarat','Gujarat','IN','384170','superadmin@amezproducts.com','+918733898966',NULL,0,0,NULL,'2026-11-13 08:02:06','2026-11-13 08:02:06');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_password_resets`
--

DROP TABLE IF EXISTS `admin_password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `admin_password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_password_resets`
--

LOCK TABLES `admin_password_resets` WRITE;
/*!40000 ALTER TABLE `admin_password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `api_token` varchar(80) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `role_id` int(10) unsigned NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `two_factor_secret` text DEFAULT NULL,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `two_factor_backup_codes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`two_factor_backup_codes`)),
  `two_factor_verified_at` timestamp NULL DEFAULT NULL,
  `two_factor_last_used_window` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admins_email_unique` (`email`),
  UNIQUE KEY `admins_api_token_unique` (`api_token`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'Admin','admin@admin.com','$2y$10$LgnEPQmr5s8RTujJ7mS4PeUiEvNOTiZZ7IPSpP90RaC.IMkwmfywK','u4pdKvDznvlgVd1Uca4LqAcb4UFHmVCIwKUONoW9XTnjhd3CDoYdIQ5mInhUeJuHrtAxL81J1ajLIh4Q',1,1,NULL,'ViZUZpNCsSnG7IOPfVw3Y5SWfELq7xO8jOVH53AI9imfc2JzMnnzCDkq8t0I',NULL,0,NULL,NULL,NULL,'2026-10-06 13:16:21','2026-10-06 13:16:21'),(2,'Admin Backup','admin@example.com','$2y$12$O0RYfFRWuYZH5/I1QbvIguAdzbIAqWiNkeWpxBTNzEGALr3p2m9MG',NULL,1,1,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-10-09 04:58:17','2026-11-02 09:45:50');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_conversation_messages`
--

DROP TABLE IF EXISTS `agent_conversation_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agent_conversation_messages` (
  `id` varchar(36) NOT NULL,
  `conversation_id` varchar(36) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `agent` varchar(255) NOT NULL,
  `role` varchar(25) NOT NULL,
  `content` text NOT NULL,
  `attachments` text NOT NULL,
  `tool_calls` text NOT NULL,
  `tool_results` text NOT NULL,
  `usage` text NOT NULL,
  `meta` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `conversation_index` (`conversation_id`,`user_id`,`updated_at`),
  KEY `agent_conversation_messages_user_id_index` (`user_id`),
  KEY `agent_conversation_messages_conversation_id_index` (`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_conversation_messages`
--

LOCK TABLES `agent_conversation_messages` WRITE;
/*!40000 ALTER TABLE `agent_conversation_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `agent_conversation_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_conversations`
--

DROP TABLE IF EXISTS `agent_conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agent_conversations` (
  `id` varchar(36) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `agent_conversations_user_id_updated_at_index` (`user_id`,`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_conversations`
--

LOCK TABLES `agent_conversations` WRITE;
/*!40000 ALTER TABLE `agent_conversations` DISABLE KEYS */;
/*!40000 ALTER TABLE `agent_conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_families`
--

DROP TABLE IF EXISTS `attribute_families`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_families` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_families`
--

LOCK TABLES `attribute_families` WRITE;
/*!40000 ALTER TABLE `attribute_families` DISABLE KEYS */;
INSERT INTO `attribute_families` VALUES (1,'default','Default',0,1);
/*!40000 ALTER TABLE `attribute_families` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_group_mappings`
--

DROP TABLE IF EXISTS `attribute_group_mappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_group_mappings` (
  `attribute_id` int(10) unsigned NOT NULL,
  `attribute_group_id` int(10) unsigned NOT NULL,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`attribute_id`,`attribute_group_id`),
  KEY `attribute_group_mappings_attribute_group_id_foreign` (`attribute_group_id`),
  CONSTRAINT `attribute_group_mappings_attribute_group_id_foreign` FOREIGN KEY (`attribute_group_id`) REFERENCES `attribute_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `attribute_group_mappings_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_group_mappings`
--

LOCK TABLES `attribute_group_mappings` WRITE;
/*!40000 ALTER TABLE `attribute_group_mappings` DISABLE KEYS */;
INSERT INTO `attribute_group_mappings` VALUES (1,1,1),(2,1,3),(3,1,4),(4,1,5),(5,6,1),(6,6,2),(7,6,3),(8,6,4),(9,2,1),(10,2,2),(11,4,1),(12,4,2),(13,4,3),(14,4,4),(15,4,5),(16,3,1),(17,3,2),(18,3,3),(19,5,1),(20,5,2),(21,5,3),(22,5,4),(23,1,6),(24,1,7),(25,1,8),(26,6,5),(27,1,2),(28,7,1),(29,8,1),(30,8,2);
/*!40000 ALTER TABLE `attribute_group_mappings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_groups`
--

DROP TABLE IF EXISTS `attribute_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `attribute_family_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `column` int(11) NOT NULL DEFAULT 1,
  `position` int(11) NOT NULL,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attribute_groups_attribute_family_id_name_unique` (`attribute_family_id`,`name`),
  CONSTRAINT `attribute_groups_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_groups`
--

LOCK TABLES `attribute_groups` WRITE;
/*!40000 ALTER TABLE `attribute_groups` DISABLE KEYS */;
INSERT INTO `attribute_groups` VALUES (1,'general',1,'General',1,1,0),(2,'description',1,'Description',1,2,0),(3,'meta_description',1,'Meta Description',1,3,0),(4,'price',1,'Price',2,1,0),(5,'shipping',1,'Shipping',2,2,0),(6,'settings',1,'Settings',2,3,0),(7,'inventories',1,'Inventories',2,4,0),(8,'rma',1,'RMA',2,5,0);
/*!40000 ALTER TABLE `attribute_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_option_translations`
--

DROP TABLE IF EXISTS `attribute_option_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_option_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_option_id` int(10) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `label` text DEFAULT NULL,
  `swatch_alt` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attribute_option_locale_unique` (`attribute_option_id`,`locale`),
  CONSTRAINT `attribute_option_translations_attribute_option_id_foreign` FOREIGN KEY (`attribute_option_id`) REFERENCES `attribute_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_option_translations`
--

LOCK TABLES `attribute_option_translations` WRITE;
/*!40000 ALTER TABLE `attribute_option_translations` DISABLE KEYS */;
INSERT INTO `attribute_option_translations` VALUES (1,1,'en','Red',NULL),(2,2,'en','Green',NULL),(3,3,'en','Yellow',NULL),(4,4,'en','Black',NULL),(5,5,'en','White',NULL),(6,6,'en','S',NULL),(7,7,'en','M',NULL),(8,8,'en','L',NULL),(9,9,'en','XL',NULL);
/*!40000 ALTER TABLE `attribute_option_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_options`
--

DROP TABLE IF EXISTS `attribute_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_options` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` int(10) unsigned NOT NULL,
  `admin_name` varchar(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `swatch_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attribute_options_attribute_id_foreign` (`attribute_id`),
  CONSTRAINT `attribute_options_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_options`
--

LOCK TABLES `attribute_options` WRITE;
/*!40000 ALTER TABLE `attribute_options` DISABLE KEYS */;
INSERT INTO `attribute_options` VALUES (1,23,'Red',1,NULL),(2,23,'Green',2,NULL),(3,23,'Yellow',3,NULL),(4,23,'Black',4,NULL),(5,23,'White',5,NULL),(6,24,'S',1,NULL),(7,24,'M',2,NULL),(8,24,'L',3,NULL),(9,24,'XL',4,NULL);
/*!40000 ALTER TABLE `attribute_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_translations`
--

DROP TABLE IF EXISTS `attribute_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` int(10) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `name` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attribute_translations_attribute_id_locale_unique` (`attribute_id`,`locale`),
  CONSTRAINT `attribute_translations_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_translations`
--

LOCK TABLES `attribute_translations` WRITE;
/*!40000 ALTER TABLE `attribute_translations` DISABLE KEYS */;
INSERT INTO `attribute_translations` VALUES (1,1,'en','SKU'),(2,2,'en','Name'),(3,3,'en','URL Key'),(4,4,'en','Tax Category'),(5,5,'en','New'),(6,6,'en','Featured'),(7,7,'en','Visible Individually'),(8,8,'en','Status'),(9,9,'en','Short Description'),(10,10,'en','Description'),(11,11,'en','Price'),(12,12,'en','Cost'),(13,13,'en','Special Price'),(14,14,'en','Special Price From'),(15,15,'en','Special Price To'),(16,16,'en','Meta Title'),(17,17,'en','Meta Keywords'),(18,18,'en','Meta Description'),(19,19,'en','Length'),(20,20,'en','Width'),(21,21,'en','Height'),(22,22,'en','Weight'),(23,23,'en','Color'),(24,24,'en','Size'),(25,25,'en','Brand'),(26,26,'en','Guest Checkout'),(27,27,'en','Product Number'),(28,28,'en','Manage Stock'),(29,29,'en','Allow RMA'),(30,30,'en','RMA Rules');
/*!40000 ALTER TABLE `attribute_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attributes`
--

DROP TABLE IF EXISTS `attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attributes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `admin_name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `swatch_type` varchar(255) DEFAULT NULL,
  `validation` varchar(255) DEFAULT NULL,
  `regex` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 0,
  `is_unique` tinyint(1) NOT NULL DEFAULT 0,
  `is_filterable` tinyint(1) NOT NULL DEFAULT 0,
  `is_comparable` tinyint(1) NOT NULL DEFAULT 0,
  `is_configurable` tinyint(1) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `is_visible_on_front` tinyint(1) NOT NULL DEFAULT 0,
  `value_per_locale` tinyint(1) NOT NULL DEFAULT 0,
  `value_per_channel` tinyint(1) NOT NULL DEFAULT 0,
  `default_value` int(11) DEFAULT NULL,
  `enable_wysiwyg` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attributes_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attributes`
--

LOCK TABLES `attributes` WRITE;
/*!40000 ALTER TABLE `attributes` DISABLE KEYS */;
INSERT INTO `attributes` VALUES (1,'sku','SKU','text',NULL,NULL,NULL,1,1,1,0,0,0,0,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(2,'name','Name','text',NULL,NULL,NULL,3,1,0,0,1,0,0,0,1,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(3,'url_key','URL Key','text',NULL,NULL,NULL,4,1,1,0,0,0,0,0,1,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(4,'tax_category_id','Tax Category','select',NULL,NULL,NULL,5,0,0,0,0,0,0,0,0,1,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(5,'new','New','boolean',NULL,NULL,NULL,6,0,0,0,0,0,0,0,0,0,1,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(6,'featured','Featured','boolean',NULL,NULL,NULL,7,0,0,0,0,0,0,0,0,0,1,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(7,'visible_individually','Visible Individually','boolean',NULL,NULL,NULL,9,1,0,0,0,0,0,0,0,0,1,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(8,'status','Status','boolean',NULL,NULL,NULL,10,1,0,0,0,0,0,0,0,1,1,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(9,'short_description','Short Description','textarea',NULL,NULL,NULL,11,1,0,0,0,0,0,0,1,0,NULL,1,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(10,'description','Description','textarea',NULL,NULL,NULL,12,1,0,0,1,0,0,0,1,0,NULL,1,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(11,'price','Price','price',NULL,'decimal',NULL,13,1,0,1,1,0,0,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(12,'cost','Cost','price',NULL,'decimal',NULL,14,0,0,0,0,0,1,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(13,'special_price','Special Price','price',NULL,'decimal',NULL,15,0,0,0,0,0,0,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(14,'special_price_from','Special Price From','date',NULL,NULL,NULL,16,0,0,0,0,0,0,0,0,1,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(15,'special_price_to','Special Price To','date',NULL,NULL,NULL,17,0,0,0,0,0,0,0,0,1,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(16,'meta_title','Meta Title','textarea',NULL,NULL,NULL,18,0,0,0,0,0,0,0,1,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(17,'meta_keywords','Meta Keywords','textarea',NULL,NULL,NULL,20,0,0,0,0,0,0,0,1,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(18,'meta_description','Meta Description','textarea',NULL,NULL,NULL,21,0,0,0,0,0,1,0,1,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(19,'length','Length','text',NULL,'decimal',NULL,22,0,0,0,0,0,1,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(20,'width','Width','text',NULL,'decimal',NULL,23,0,0,0,0,0,1,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(21,'height','Height','text',NULL,'decimal',NULL,24,0,0,0,0,0,1,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(22,'weight','Weight','text',NULL,'decimal',NULL,25,1,0,0,0,0,0,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(23,'color','Color','select',NULL,NULL,NULL,26,0,0,1,0,1,1,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(24,'size','Size','select',NULL,NULL,NULL,27,0,0,1,0,1,1,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(25,'brand','Brand','select',NULL,NULL,NULL,28,0,0,1,0,0,1,1,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(26,'guest_checkout','Guest Checkout','boolean',NULL,NULL,NULL,8,1,0,0,0,0,0,0,0,0,1,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(27,'product_number','Product Number','text',NULL,NULL,NULL,2,0,1,0,0,0,0,0,0,0,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(28,'manage_stock','Manage Stock','boolean',NULL,NULL,NULL,1,0,0,0,0,0,0,0,0,1,1,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(29,'allow_rma','Allow RMA','boolean',NULL,NULL,NULL,1,0,0,0,0,0,0,0,0,1,0,0,'2026-10-06 13:16:16','2026-10-06 13:16:16'),(30,'rma_rule_id','RMA Rules','select',NULL,NULL,NULL,5,0,0,0,0,0,0,0,0,1,NULL,0,'2026-10-06 13:16:16','2026-10-06 13:16:16');
/*!40000 ALTER TABLE `attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_appointment_slots`
--

DROP TABLE IF EXISTS `booking_product_appointment_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_appointment_slots` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int(10) unsigned NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `break_time` int(11) DEFAULT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`slots`)),
  `allow_slot_overlap` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `booking_product_appointment_slots_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_appointment_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_appointment_slots`
--

LOCK TABLES `booking_product_appointment_slots` WRITE;
/*!40000 ALTER TABLE `booking_product_appointment_slots` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_appointment_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_default_slots`
--

DROP TABLE IF EXISTS `booking_product_default_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_default_slots` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int(10) unsigned NOT NULL,
  `booking_type` varchar(255) NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `break_time` int(11) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`slots`)),
  `allow_slot_overlap` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `booking_product_default_slots_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_default_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_default_slots`
--

LOCK TABLES `booking_product_default_slots` WRITE;
/*!40000 ALTER TABLE `booking_product_default_slots` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_default_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_event_ticket_translations`
--

DROP TABLE IF EXISTS `booking_product_event_ticket_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_event_ticket_translations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_event_ticket_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `name` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bpet_locale_unique` (`booking_product_event_ticket_id`,`locale`),
  CONSTRAINT `bpet_translations_fk` FOREIGN KEY (`booking_product_event_ticket_id`) REFERENCES `booking_product_event_tickets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_event_ticket_translations`
--

LOCK TABLES `booking_product_event_ticket_translations` WRITE;
/*!40000 ALTER TABLE `booking_product_event_ticket_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_event_ticket_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_event_tickets`
--

DROP TABLE IF EXISTS `booking_product_event_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_event_tickets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int(10) unsigned NOT NULL,
  `price` decimal(12,4) DEFAULT 0.0000,
  `qty` int(11) DEFAULT 0,
  `special_price` decimal(12,4) DEFAULT NULL,
  `special_price_from` datetime DEFAULT NULL,
  `special_price_to` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_product_event_tickets_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_event_tickets_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_event_tickets`
--

LOCK TABLES `booking_product_event_tickets` WRITE;
/*!40000 ALTER TABLE `booking_product_event_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_event_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_rental_slots`
--

DROP TABLE IF EXISTS `booking_product_rental_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_rental_slots` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int(10) unsigned NOT NULL,
  `renting_type` varchar(255) NOT NULL,
  `daily_price` decimal(12,4) DEFAULT 0.0000,
  `hourly_price` decimal(12,4) DEFAULT 0.0000,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`slots`)),
  PRIMARY KEY (`id`),
  KEY `booking_product_rental_slots_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_rental_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_rental_slots`
--

LOCK TABLES `booking_product_rental_slots` WRITE;
/*!40000 ALTER TABLE `booking_product_rental_slots` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_rental_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_table_slots`
--

DROP TABLE IF EXISTS `booking_product_table_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_table_slots` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int(10) unsigned NOT NULL,
  `price_type` varchar(255) NOT NULL,
  `guest_limit` int(11) NOT NULL DEFAULT 0,
  `duration` int(11) NOT NULL,
  `break_time` int(11) NOT NULL,
  `prevent_scheduling_before` int(11) NOT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`slots`)),
  `allow_slot_overlap` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_product_table_slots_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_table_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_table_slots`
--

LOCK TABLES `booking_product_table_slots` WRITE;
/*!40000 ALTER TABLE `booking_product_table_slots` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_table_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_products`
--

DROP TABLE IF EXISTS `booking_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `type` varchar(255) NOT NULL,
  `qty` int(11) DEFAULT 0,
  `location` varchar(255) DEFAULT NULL,
  `show_location` tinyint(1) NOT NULL DEFAULT 0,
  `available_every_week` tinyint(1) DEFAULT NULL,
  `available_from` datetime DEFAULT NULL,
  `available_to` datetime DEFAULT NULL,
  `allow_cancellation` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_products_product_id_foreign` (`product_id`),
  CONSTRAINT `booking_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_products`
--

LOCK TABLES `booking_products` WRITE;
/*!40000 ALTER TABLE `booking_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned DEFAULT NULL,
  `order_item_id` int(10) unsigned DEFAULT NULL,
  `order_id` int(10) unsigned DEFAULT NULL,
  `qty` int(11) DEFAULT 0,
  `from` int(11) DEFAULT NULL,
  `to` int(11) DEFAULT NULL,
  `allow_cancellation` tinyint(1) NOT NULL DEFAULT 1,
  `booking_product_event_ticket_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bookings_order_item_id_foreign` (`order_item_id`),
  KEY `bookings_booking_product_event_ticket_id_foreign` (`booking_product_event_ticket_id`),
  KEY `bookings_order_id_foreign` (`order_id`),
  KEY `bookings_product_id_foreign` (`product_id`),
  CONSTRAINT `bookings_booking_product_event_ticket_id_foreign` FOREIGN KEY (`booking_product_event_ticket_id`) REFERENCES `booking_product_event_tickets` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bookings_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bookings_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bookings_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_email` varchar(255) DEFAULT NULL,
  `customer_first_name` varchar(255) DEFAULT NULL,
  `customer_last_name` varchar(255) DEFAULT NULL,
  `shipping_method` varchar(255) DEFAULT NULL,
  `coupon_code` varchar(255) DEFAULT NULL,
  `is_gift` tinyint(1) NOT NULL DEFAULT 0,
  `items_count` int(11) DEFAULT NULL,
  `items_qty` decimal(12,4) DEFAULT NULL,
  `exchange_rate` decimal(12,4) DEFAULT NULL,
  `global_currency_code` varchar(255) DEFAULT NULL,
  `base_currency_code` varchar(255) DEFAULT NULL,
  `channel_currency_code` varchar(255) DEFAULT NULL,
  `cart_currency_code` varchar(255) DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `tax_total` decimal(12,4) DEFAULT 0.0000,
  `base_tax_total` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `checkout_method` varchar(255) DEFAULT NULL,
  `is_guest` tinyint(1) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `applied_cart_rule_ids` varchar(255) DEFAULT NULL,
  `customer_id` int(10) unsigned DEFAULT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_customer_id_foreign` (`customer_id`),
  KEY `cart_channel_id_foreign` (`channel_id`),
  CONSTRAINT `cart_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,'pyash5231@gmail.com','yash','Pawar',NULL,NULL,0,NULL,NULL,NULL,'INR','INR','INR','INR',0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,NULL,0,0,NULL,2,1,'2026-11-02 10:13:50','2026-11-02 10:13:50'),(2,'vikram@example.com','Vikram','Singhania',NULL,NULL,0,3,5.0000,NULL,NULL,NULL,NULL,NULL,970.0000,970.0000,970.0000,970.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,NULL,NULL,1,NULL,4,1,'2026-11-13 06:48:54','2026-11-13 06:49:02'),(3,'superadmin@amezproducts.com','Raxesh','patel',NULL,NULL,0,3,4.0000,NULL,NULL,NULL,NULL,NULL,785.0000,785.0000,785.0000,785.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,NULL,NULL,0,NULL,10,1,'2026-11-13 08:02:03','2026-11-13 08:02:03');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_item_inventories`
--

DROP TABLE IF EXISTS `cart_item_inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_item_inventories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qty` int(10) unsigned NOT NULL DEFAULT 0,
  `inventory_source_id` int(10) unsigned DEFAULT NULL,
  `cart_item_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_item_inventories`
--

LOCK TABLES `cart_item_inventories` WRITE;
/*!40000 ALTER TABLE `cart_item_inventories` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_item_inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `quantity` int(10) unsigned NOT NULL DEFAULT 0,
  `sku` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `coupon_code` varchar(255) DEFAULT NULL,
  `weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `price` decimal(12,4) NOT NULL DEFAULT 1.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `custom_price` decimal(12,4) DEFAULT NULL,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_percent` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `applied_tax_rate` varchar(255) DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `cart_id` int(10) unsigned NOT NULL,
  `tax_category_id` int(10) unsigned DEFAULT NULL,
  `applied_cart_rule_ids` varchar(255) DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_items_parent_id_foreign` (`parent_id`),
  KEY `cart_items_product_id_foreign` (`product_id`),
  KEY `cart_items_cart_id_foreign` (`cart_id`),
  KEY `cart_items_tax_category_id_foreign` (`tax_category_id`),
  CONSTRAINT `cart_items_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `cart_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_payment`
--

DROP TABLE IF EXISTS `cart_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_payment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(255) NOT NULL,
  `method_title` varchar(255) DEFAULT NULL,
  `cart_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_payment_cart_id_foreign` (`cart_id`),
  CONSTRAINT `cart_payment_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_payment`
--

LOCK TABLES `cart_payment` WRITE;
/*!40000 ALTER TABLE `cart_payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_channels`
--

DROP TABLE IF EXISTS `cart_rule_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_channels` (
  `cart_rule_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`cart_rule_id`,`channel_id`),
  KEY `cart_rule_channels_channel_id_foreign` (`channel_id`),
  CONSTRAINT `cart_rule_channels_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_rule_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_channels`
--

LOCK TABLES `cart_rule_channels` WRITE;
/*!40000 ALTER TABLE `cart_rule_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_coupon_usage`
--

DROP TABLE IF EXISTS `cart_rule_coupon_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_coupon_usage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `times_used` int(11) NOT NULL DEFAULT 0,
  `cart_rule_coupon_id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_rule_coupon_usage_cart_rule_coupon_id_foreign` (`cart_rule_coupon_id`),
  KEY `cart_rule_coupon_usage_customer_id_foreign` (`customer_id`),
  CONSTRAINT `cart_rule_coupon_usage_cart_rule_coupon_id_foreign` FOREIGN KEY (`cart_rule_coupon_id`) REFERENCES `cart_rule_coupons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_rule_coupon_usage_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_coupon_usage`
--

LOCK TABLES `cart_rule_coupon_usage` WRITE;
/*!40000 ALTER TABLE `cart_rule_coupon_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_coupon_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_coupons`
--

DROP TABLE IF EXISTS `cart_rule_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_coupons` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `usage_limit` int(10) unsigned NOT NULL DEFAULT 0,
  `usage_per_customer` int(10) unsigned NOT NULL DEFAULT 0,
  `times_used` int(10) unsigned NOT NULL DEFAULT 0,
  `type` int(10) unsigned NOT NULL DEFAULT 0,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `expired_at` date DEFAULT NULL,
  `cart_rule_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_rule_coupons_cart_rule_id_foreign` (`cart_rule_id`),
  CONSTRAINT `cart_rule_coupons_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_coupons`
--

LOCK TABLES `cart_rule_coupons` WRITE;
/*!40000 ALTER TABLE `cart_rule_coupons` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_customer_groups`
--

DROP TABLE IF EXISTS `cart_rule_customer_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_customer_groups` (
  `cart_rule_id` int(10) unsigned NOT NULL,
  `customer_group_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`cart_rule_id`,`customer_group_id`),
  KEY `cart_rule_customer_groups_customer_group_id_foreign` (`customer_group_id`),
  CONSTRAINT `cart_rule_customer_groups_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_rule_customer_groups_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_customer_groups`
--

LOCK TABLES `cart_rule_customer_groups` WRITE;
/*!40000 ALTER TABLE `cart_rule_customer_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_customer_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_customers`
--

DROP TABLE IF EXISTS `cart_rule_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_customers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `times_used` bigint(20) unsigned NOT NULL DEFAULT 0,
  `customer_id` int(10) unsigned NOT NULL,
  `cart_rule_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_rule_customers_cart_rule_id_foreign` (`cart_rule_id`),
  KEY `cart_rule_customers_customer_id_foreign` (`customer_id`),
  CONSTRAINT `cart_rule_customers_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_rule_customers_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_customers`
--

LOCK TABLES `cart_rule_customers` WRITE;
/*!40000 ALTER TABLE `cart_rule_customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_translations`
--

DROP TABLE IF EXISTS `cart_rule_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `locale` varchar(255) NOT NULL,
  `label` text DEFAULT NULL,
  `cart_rule_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cart_rule_translations_cart_rule_id_locale_unique` (`cart_rule_id`,`locale`),
  CONSTRAINT `cart_rule_translations_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_translations`
--

LOCK TABLES `cart_rule_translations` WRITE;
/*!40000 ALTER TABLE `cart_rule_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rules`
--

DROP TABLE IF EXISTS `cart_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `coupon_type` int(11) NOT NULL DEFAULT 1,
  `use_auto_generation` tinyint(1) NOT NULL DEFAULT 0,
  `usage_per_customer` int(11) NOT NULL DEFAULT 0,
  `uses_per_coupon` int(11) NOT NULL DEFAULT 0,
  `times_used` int(10) unsigned NOT NULL DEFAULT 0,
  `condition_type` tinyint(1) NOT NULL DEFAULT 1,
  `conditions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`conditions`)),
  `end_other_rules` tinyint(1) NOT NULL DEFAULT 0,
  `uses_attribute_conditions` tinyint(1) NOT NULL DEFAULT 0,
  `action_type` varchar(255) DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_quantity` int(11) NOT NULL DEFAULT 1,
  `discount_step` varchar(255) NOT NULL DEFAULT '1',
  `apply_to_shipping` tinyint(1) NOT NULL DEFAULT 0,
  `free_shipping` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rules`
--

LOCK TABLES `cart_rules` WRITE;
/*!40000 ALTER TABLE `cart_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_shipping_rates`
--

DROP TABLE IF EXISTS `cart_shipping_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_shipping_rates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `carrier` varchar(255) NOT NULL,
  `carrier_title` varchar(255) NOT NULL,
  `method` varchar(255) NOT NULL,
  `method_title` varchar(255) NOT NULL,
  `method_description` varchar(255) DEFAULT NULL,
  `price` double DEFAULT 0,
  `base_price` double DEFAULT 0,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_percent` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `applied_tax_rate` varchar(255) DEFAULT NULL,
  `is_calculate_tax` tinyint(1) NOT NULL DEFAULT 1,
  `cart_address_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `cart_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_shipping_rates_cart_id_foreign` (`cart_id`),
  CONSTRAINT `cart_shipping_rates_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_shipping_rates`
--

LOCK TABLES `cart_shipping_rates` WRITE;
/*!40000 ALTER TABLE `cart_shipping_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_shipping_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rule_channels`
--

DROP TABLE IF EXISTS `catalog_rule_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rule_channels` (
  `catalog_rule_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`catalog_rule_id`,`channel_id`),
  KEY `catalog_rule_channels_channel_id_foreign` (`channel_id`),
  CONSTRAINT `catalog_rule_channels_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rule_channels`
--

LOCK TABLES `catalog_rule_channels` WRITE;
/*!40000 ALTER TABLE `catalog_rule_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_rule_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rule_customer_groups`
--

DROP TABLE IF EXISTS `catalog_rule_customer_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rule_customer_groups` (
  `catalog_rule_id` int(10) unsigned NOT NULL,
  `customer_group_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`catalog_rule_id`,`customer_group_id`),
  KEY `catalog_rule_customer_groups_customer_group_id_foreign` (`customer_group_id`),
  CONSTRAINT `catalog_rule_customer_groups_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_customer_groups_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rule_customer_groups`
--

LOCK TABLES `catalog_rule_customer_groups` WRITE;
/*!40000 ALTER TABLE `catalog_rule_customer_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_rule_customer_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rule_product_prices`
--

DROP TABLE IF EXISTS `catalog_rule_product_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rule_product_prices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `rule_date` date NOT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `customer_group_id` int(10) unsigned NOT NULL,
  `catalog_rule_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `catalog_rule_product_prices_product_id_foreign` (`product_id`),
  KEY `catalog_rule_product_prices_customer_group_id_foreign` (`customer_group_id`),
  KEY `catalog_rule_product_prices_catalog_rule_id_foreign` (`catalog_rule_id`),
  KEY `catalog_rule_product_prices_channel_id_foreign` (`channel_id`),
  CONSTRAINT `catalog_rule_product_prices_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_product_prices_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_product_prices_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_product_prices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rule_product_prices`
--

LOCK TABLES `catalog_rule_product_prices` WRITE;
/*!40000 ALTER TABLE `catalog_rule_product_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_rule_product_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rule_products`
--

DROP TABLE IF EXISTS `catalog_rule_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rule_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `end_other_rules` tinyint(1) NOT NULL DEFAULT 0,
  `action_type` varchar(255) DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `product_id` int(10) unsigned NOT NULL,
  `customer_group_id` int(10) unsigned NOT NULL,
  `catalog_rule_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `catalog_rule_products_product_id_foreign` (`product_id`),
  KEY `catalog_rule_products_customer_group_id_foreign` (`customer_group_id`),
  KEY `catalog_rule_products_catalog_rule_id_foreign` (`catalog_rule_id`),
  KEY `catalog_rule_products_channel_id_foreign` (`channel_id`),
  CONSTRAINT `catalog_rule_products_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_products_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_products_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rule_products`
--

LOCK TABLES `catalog_rule_products` WRITE;
/*!40000 ALTER TABLE `catalog_rule_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_rule_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rules`
--

DROP TABLE IF EXISTS `catalog_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `starts_from` date DEFAULT NULL,
  `ends_till` date DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `condition_type` tinyint(1) NOT NULL DEFAULT 1,
  `conditions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`conditions`)),
  `end_other_rules` tinyint(1) NOT NULL DEFAULT 0,
  `action_type` varchar(255) DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rules`
--

LOCK TABLES `catalog_rules` WRITE;
/*!40000 ALTER TABLE `catalog_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `position` int(11) NOT NULL DEFAULT 0,
  `logo_path` text DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `display_mode` varchar(255) DEFAULT 'products_and_description',
  `_lft` int(10) unsigned NOT NULL DEFAULT 0,
  `_rgt` int(10) unsigned NOT NULL DEFAULT 0,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `banner_path` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories__lft__rgt_parent_id_index` (`_lft`,`_rgt`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,1,NULL,1,'products_and_description',1,8,NULL,NULL,NULL,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(2,1,NULL,1,'products_and_description',2,3,1,NULL,NULL,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(3,2,NULL,1,'products_and_description',4,5,1,NULL,NULL,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(4,3,NULL,1,'products_and_description',6,7,1,NULL,NULL,'2026-11-04 07:05:56','2026-11-04 07:05:56');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_filterable_attributes`
--

DROP TABLE IF EXISTS `category_filterable_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_filterable_attributes` (
  `category_id` int(10) unsigned NOT NULL,
  `attribute_id` int(10) unsigned NOT NULL,
  KEY `category_filterable_attributes_category_id_foreign` (`category_id`),
  KEY `category_filterable_attributes_attribute_id_foreign` (`attribute_id`),
  CONSTRAINT `category_filterable_attributes_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `category_filterable_attributes_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_filterable_attributes`
--

LOCK TABLES `category_filterable_attributes` WRITE;
/*!40000 ALTER TABLE `category_filterable_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `category_filterable_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_translations`
--

DROP TABLE IF EXISTS `category_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned NOT NULL,
  `name` text NOT NULL,
  `slug` varchar(255) NOT NULL,
  `url_path` varchar(2048) NOT NULL,
  `description` text DEFAULT NULL,
  `meta_title` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `meta_keywords` text DEFAULT NULL,
  `logo_alt` text DEFAULT NULL,
  `banner_alt` text DEFAULT NULL,
  `locale_id` int(10) unsigned DEFAULT NULL,
  `locale` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_translations_category_id_slug_locale_unique` (`category_id`,`slug`,`locale`),
  KEY `category_translations_locale_id_foreign` (`locale_id`),
  CONSTRAINT `category_translations_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `category_translations_locale_id_foreign` FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_translations`
--

LOCK TABLES `category_translations` WRITE;
/*!40000 ALTER TABLE `category_translations` DISABLE KEYS */;
INSERT INTO `category_translations` VALUES (1,1,'Root','root','','SYD Spices Root Category','SYD Spices','Pure Indian Spices','spices, indian spices',NULL,NULL,NULL,'en'),(25,2,'Whole Spices','whole-spices','','Single-origin unpolished whole seeds handpicked from India APMC mandis. Rich in natural volatile oils.','Whole Spices | SYD Spices','100% natural, bold, single-origin whole seeds with crisp crackle and natural aromatics.','whole spices, cumin seeds, fennel seeds, jeera, variyali, authentic spices',NULL,NULL,NULL,'en'),(26,3,'Blended Spices','blended-spices','','Royal court secret formulas and cast-iron roasted masalas crafted in small batches for everyday dishes and festive curries.','Blended Spices | SYD Spices','Master kitchen king secret formulas, royal garam masala, and artisan spice blends.','blended spices, magic blend, garam masala, curry powder, royal spices',NULL,NULL,NULL,'en'),(27,4,'Grinded Spices','grinded-spices','','Single-origin sun-dried chillies and golden turmeric roots cold-pulverized below 40°C to lock in vivid color and vital terpenes.','Grinded Spices | SYD Spices','Cold-pulverized turmeric, stemless red chilli, and coriander powders with zero adulteration.','grinded spices, red chilli powder, turmeric powder, coriander powder, haldi, dhaniya',NULL,NULL,NULL,'en');
/*!40000 ALTER TABLE `category_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_currencies`
--

DROP TABLE IF EXISTS `channel_currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_currencies` (
  `channel_id` int(10) unsigned NOT NULL,
  `currency_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`channel_id`,`currency_id`),
  KEY `channel_currencies_currency_id_foreign` (`currency_id`),
  CONSTRAINT `channel_currencies_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `channel_currencies_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_currencies`
--

LOCK TABLES `channel_currencies` WRITE;
/*!40000 ALTER TABLE `channel_currencies` DISABLE KEYS */;
INSERT INTO `channel_currencies` VALUES (1,1);
/*!40000 ALTER TABLE `channel_currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_inventory_sources`
--

DROP TABLE IF EXISTS `channel_inventory_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_inventory_sources` (
  `channel_id` int(10) unsigned NOT NULL,
  `inventory_source_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `channel_inventory_source_unique` (`channel_id`,`inventory_source_id`),
  KEY `channel_inventory_sources_inventory_source_id_foreign` (`inventory_source_id`),
  CONSTRAINT `channel_inventory_sources_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `channel_inventory_sources_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_inventory_sources`
--

LOCK TABLES `channel_inventory_sources` WRITE;
/*!40000 ALTER TABLE `channel_inventory_sources` DISABLE KEYS */;
INSERT INTO `channel_inventory_sources` VALUES (1,1);
/*!40000 ALTER TABLE `channel_inventory_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_locales`
--

DROP TABLE IF EXISTS `channel_locales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_locales` (
  `channel_id` int(10) unsigned NOT NULL,
  `locale_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`channel_id`,`locale_id`),
  KEY `channel_locales_locale_id_foreign` (`locale_id`),
  CONSTRAINT `channel_locales_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `channel_locales_locale_id_foreign` FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_locales`
--

LOCK TABLES `channel_locales` WRITE;
/*!40000 ALTER TABLE `channel_locales` DISABLE KEYS */;
INSERT INTO `channel_locales` VALUES (1,1);
/*!40000 ALTER TABLE `channel_locales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_translations`
--

DROP TABLE IF EXISTS `channel_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_translations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` int(10) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `maintenance_mode_text` text DEFAULT NULL,
  `logo_alt` text DEFAULT NULL,
  `home_seo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`home_seo`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel_translations_channel_id_locale_unique` (`channel_id`,`locale`),
  KEY `channel_translations_locale_index` (`locale`),
  CONSTRAINT `channel_translations_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_translations`
--

LOCK TABLES `channel_translations` WRITE;
/*!40000 ALTER TABLE `channel_translations` DISABLE KEYS */;
INSERT INTO `channel_translations` VALUES (1,1,'en','SYD Spices','Pure, Natural, and Authentic Indian Spices and Blends.',NULL,NULL,'{\"meta_title\":\"SYD Spices - Pure Indian Spices\",\"meta_description\":\"100% pure single-origin Indian spices and blends.\",\"meta_keywords\":\"spices, gujarat spices, turmeric, garam masala\"}',NULL,'2026-10-08 12:14:51');
/*!40000 ALTER TABLE `channel_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channels`
--

DROP TABLE IF EXISTS `channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `timezone` varchar(255) DEFAULT NULL,
  `theme` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `favicon` varchar(255) DEFAULT NULL,
  `home_seo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`home_seo`)),
  `is_maintenance_on` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_ips` text DEFAULT NULL,
  `root_category_id` int(10) unsigned DEFAULT NULL,
  `default_locale_id` int(10) unsigned NOT NULL,
  `base_currency_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `channels_root_category_id_foreign` (`root_category_id`),
  KEY `channels_default_locale_id_foreign` (`default_locale_id`),
  KEY `channels_base_currency_id_foreign` (`base_currency_id`),
  KEY `channels_hostname_idx` (`hostname`),
  CONSTRAINT `channels_base_currency_id_foreign` FOREIGN KEY (`base_currency_id`) REFERENCES `currencies` (`id`),
  CONSTRAINT `channels_default_locale_id_foreign` FOREIGN KEY (`default_locale_id`) REFERENCES `locales` (`id`),
  CONSTRAINT `channels_root_category_id_foreign` FOREIGN KEY (`root_category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channels`
--

LOCK TABLES `channels` WRITE;
/*!40000 ALTER TABLE `channels` DISABLE KEYS */;
INSERT INTO `channels` VALUES (1,'default',NULL,'default','http://localhost:8000',NULL,NULL,'{\"meta_title\":\"VIZE | Advanced Specialty Polymers & Resin Studio\",\"meta_description\":\"Engineered casting epoxies, polyaspartics, metallic pigments, live-edge river tables, and masterclasses in Pune, India.\",\"meta_keywords\":\"epoxy resin, resin casting, live edge river table, metallic pigments, vize resin, resin courses pune\"}',0,NULL,1,1,1,'2026-10-06 13:16:18','2026-10-08 12:14:51');
/*!40000 ALTER TABLE `channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_page_channels`
--

DROP TABLE IF EXISTS `cms_page_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page_channels` (
  `cms_page_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `cms_page_channels_cms_page_id_channel_id_unique` (`cms_page_id`,`channel_id`),
  KEY `cms_page_channels_channel_id_foreign` (`channel_id`),
  CONSTRAINT `cms_page_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cms_page_channels_cms_page_id_foreign` FOREIGN KEY (`cms_page_id`) REFERENCES `cms_pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_page_channels`
--

LOCK TABLES `cms_page_channels` WRITE;
/*!40000 ALTER TABLE `cms_page_channels` DISABLE KEYS */;
INSERT INTO `cms_page_channels` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1);
/*!40000 ALTER TABLE `cms_page_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_page_translations`
--

DROP TABLE IF EXISTS `cms_page_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `page_title` varchar(255) NOT NULL,
  `url_key` varchar(255) NOT NULL,
  `html_content` longtext DEFAULT NULL,
  `meta_title` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `meta_keywords` text DEFAULT NULL,
  `locale` varchar(255) NOT NULL,
  `cms_page_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cms_page_translations_cms_page_id_url_key_locale_unique` (`cms_page_id`,`url_key`,`locale`),
  CONSTRAINT `cms_page_translations_cms_page_id_foreign` FOREIGN KEY (`cms_page_id`) REFERENCES `cms_pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_page_translations`
--

LOCK TABLES `cms_page_translations` WRITE;
/*!40000 ALTER TABLE `cms_page_translations` DISABLE KEYS */;
INSERT INTO `cms_page_translations` VALUES (1,'About Us','about-us','<div class=\"static-container\"><div class=\"mb-5\">About Us Page Content</div></div>','about us','','aboutus','en',1),(2,'Return Policy','return-policy','<div class=\"static-container\"><div class=\"mb-5\">Return Policy Page Content</div></div>','return policy','','return, policy','en',2),(3,'Refund Policy','refund-policy','<div class=\"static-container\"><div class=\"mb-5\">Refund Policy Page Content</div></div>','Refund policy','','refund, policy','en',3),(4,'Terms & Conditions','terms-conditions','<div class=\"static-container\"><div class=\"mb-5\">Terms & Conditions Page Content</div></div>','Terms & Conditions','','term, conditions','en',4),(5,'Terms of Use','terms-of-use','<div class=\"static-container\"><div class=\"mb-5\">Terms of Use Page Content</div></div>','Terms of use','','term, use','en',5),(6,'Customer Service','customer-service','<div class=\"static-container\"><div class=\"mb-5\">Customer Service Page Content</div></div>','Customer Service','','customer, service','en',6),(7,'What\'s New','whats-new','<div class=\"static-container\"><div class=\"mb-5\">What\'s New page content</div></div>','What\'s New','','new','en',7),(8,'Payment Policy','payment-policy','<div class=\"static-container\"><div class=\"mb-5\">Payment Policy Page Content</div></div>','Payment Policy','','payment, policy','en',8),(9,'Shipping Policy','shipping-policy','<div class=\"static-container\"><div class=\"mb-5\">Shipping Policy Page Content</div></div>','Shipping Policy','','shipping, policy','en',9),(10,'Privacy Policy','privacy-policy','<div class=\"static-container\"><div class=\"mb-5\">Privacy Policy Page Content</div></div>','Privacy Policy','','privacy, policy','en',10);
/*!40000 ALTER TABLE `cms_page_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_pages`
--

DROP TABLE IF EXISTS `cms_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_pages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `layout` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_pages`
--

LOCK TABLES `cms_pages` WRITE;
/*!40000 ALTER TABLE `cms_pages` DISABLE KEYS */;
INSERT INTO `cms_pages` VALUES (1,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(2,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(3,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(4,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(5,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(6,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(7,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(8,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(9,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(10,NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19');
/*!40000 ALTER TABLE `cms_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compare_items`
--

DROP TABLE IF EXISTS `compare_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `compare_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `compare_items_product_id_foreign` (`product_id`),
  KEY `compare_items_customer_id_foreign` (`customer_id`),
  CONSTRAINT `compare_items_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compare_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compare_items`
--

LOCK TABLES `compare_items` WRITE;
/*!40000 ALTER TABLE `compare_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `compare_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_config`
--

DROP TABLE IF EXISTS `core_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `channel_code` varchar(255) DEFAULT NULL,
  `locale_code` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_config`
--

LOCK TABLES `core_config` WRITE;
/*!40000 ALTER TABLE `core_config` DISABLE KEYS */;
INSERT INTO `core_config` VALUES (1,'sales.checkout.shopping_cart.allow_guest_checkout','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(2,'emails.general.notifications.emails.general.notifications.registration','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(3,'emails.general.notifications.emails.general.notifications.customer_registration_confirmation_mail_to_admin','0',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(4,'emails.general.notifications.emails.general.notifications.customer_account_credentials','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(5,'emails.general.notifications.emails.general.notifications.new_order','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(6,'emails.general.notifications.emails.general.notifications.new_order_mail_to_admin','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(7,'emails.general.notifications.emails.general.notifications.new_invoice','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(8,'emails.general.notifications.emails.general.notifications.new_invoice_mail_to_admin','0',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(9,'emails.general.notifications.emails.general.notifications.new_refund','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(10,'emails.general.notifications.emails.general.notifications.new_refund_mail_to_admin','0',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(11,'emails.general.notifications.emails.general.notifications.new_shipment','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(12,'emails.general.notifications.emails.general.notifications.new_shipment_mail_to_admin','0',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(13,'emails.general.notifications.emails.general.notifications.new_inventory_source','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(14,'emails.general.notifications.emails.general.notifications.cancel_order','1',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(15,'emails.general.notifications.emails.general.notifications.cancel_order_mail_to_admin','0',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(16,'general.design.categories.category_view','sidebar',NULL,NULL,'2026-10-06 13:16:18','2026-10-06 13:16:18'),(17,'customer.settings.social_login.enable_facebook','1','default',NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(18,'customer.settings.social_login.enable_twitter','1','default',NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(19,'customer.settings.social_login.enable_google','1','default',NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(20,'customer.settings.social_login.enable_linkedin','1','default',NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(21,'customer.settings.social_login.enable_github','1','default',NULL,'2026-10-06 13:16:19','2026-10-06 13:16:19');
/*!40000 ALTER TABLE `core_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `countries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (1,'AF','Afghanistan'),(2,'AX','Åland Islands'),(3,'AL','Albania'),(4,'DZ','Algeria'),(5,'AS','American Samoa'),(6,'AD','Andorra'),(7,'AO','Angola'),(8,'AI','Anguilla'),(9,'AQ','Antarctica'),(10,'AG','Antigua & Barbuda'),(11,'AR','Argentina'),(12,'AM','Armenia'),(13,'AW','Aruba'),(14,'AC','Ascension Island'),(15,'AU','Australia'),(16,'AT','Austria'),(17,'AZ','Azerbaijan'),(18,'BS','Bahamas'),(19,'BH','Bahrain'),(20,'BD','Bangladesh'),(21,'BB','Barbados'),(22,'BY','Belarus'),(23,'BE','Belgium'),(24,'BZ','Belize'),(25,'BJ','Benin'),(26,'BM','Bermuda'),(27,'BT','Bhutan'),(28,'BO','Bolivia'),(29,'BA','Bosnia & Herzegovina'),(30,'BW','Botswana'),(31,'BR','Brazil'),(32,'IO','British Indian Ocean Territory'),(33,'VG','British Virgin Islands'),(34,'BN','Brunei'),(35,'BG','Bulgaria'),(36,'BF','Burkina Faso'),(37,'BI','Burundi'),(38,'KH','Cambodia'),(39,'CM','Cameroon'),(40,'CA','Canada'),(41,'IC','Canary Islands'),(42,'CV','Cape Verde'),(43,'BQ','Caribbean Netherlands'),(44,'KY','Cayman Islands'),(45,'CF','Central African Republic'),(46,'EA','Ceuta & Melilla'),(47,'TD','Chad'),(48,'CL','Chile'),(49,'CN','China'),(50,'CX','Christmas Island'),(51,'CC','Cocos (Keeling) Islands'),(52,'CO','Colombia'),(53,'KM','Comoros'),(54,'CG','Congo - Brazzaville'),(55,'CD','Congo - Kinshasa'),(56,'CK','Cook Islands'),(57,'CR','Costa Rica'),(58,'CI','Côte d’Ivoire'),(59,'HR','Croatia'),(60,'CU','Cuba'),(61,'CW','Curaçao'),(62,'CY','Cyprus'),(63,'CZ','Czechia'),(64,'DK','Denmark'),(65,'DG','Diego Garcia'),(66,'DJ','Djibouti'),(67,'DM','Dominica'),(68,'DO','Dominican Republic'),(69,'EC','Ecuador'),(70,'EG','Egypt'),(71,'SV','El Salvador'),(72,'GQ','Equatorial Guinea'),(73,'ER','Eritrea'),(74,'EE','Estonia'),(75,'ET','Ethiopia'),(76,'EZ','Eurozone'),(77,'FK','Falkland Islands'),(78,'FO','Faroe Islands'),(79,'FJ','Fiji'),(80,'FI','Finland'),(81,'FR','France'),(82,'GF','French Guiana'),(83,'PF','French Polynesia'),(84,'TF','French Southern Territories'),(85,'GA','Gabon'),(86,'GM','Gambia'),(87,'GE','Georgia'),(88,'DE','Germany'),(89,'GH','Ghana'),(90,'GI','Gibraltar'),(91,'GR','Greece'),(92,'GL','Greenland'),(93,'GD','Grenada'),(94,'GP','Guadeloupe'),(95,'GU','Guam'),(96,'GT','Guatemala'),(97,'GG','Guernsey'),(98,'GN','Guinea'),(99,'GW','Guinea-Bissau'),(100,'GY','Guyana'),(101,'HT','Haiti'),(102,'HN','Honduras'),(103,'HK','Hong Kong SAR China'),(104,'HU','Hungary'),(105,'IS','Iceland'),(106,'IN','India'),(107,'ID','Indonesia'),(108,'IR','Iran'),(109,'IQ','Iraq'),(110,'IE','Ireland'),(111,'IM','Isle of Man'),(112,'IL','Israel'),(113,'IT','Italy'),(114,'JM','Jamaica'),(115,'JP','Japan'),(116,'JE','Jersey'),(117,'JO','Jordan'),(118,'KZ','Kazakhstan'),(119,'KE','Kenya'),(120,'KI','Kiribati'),(121,'XK','Kosovo'),(122,'KW','Kuwait'),(123,'KG','Kyrgyzstan'),(124,'LA','Laos'),(125,'LV','Latvia'),(126,'LB','Lebanon'),(127,'LS','Lesotho'),(128,'LR','Liberia'),(129,'LY','Libya'),(130,'LI','Liechtenstein'),(131,'LT','Lithuania'),(132,'LU','Luxembourg'),(133,'MO','Macau SAR China'),(134,'MK','Macedonia'),(135,'MG','Madagascar'),(136,'MW','Malawi'),(137,'MY','Malaysia'),(138,'MV','Maldives'),(139,'ML','Mali'),(140,'MT','Malta'),(141,'MH','Marshall Islands'),(142,'MQ','Martinique'),(143,'MR','Mauritania'),(144,'MU','Mauritius'),(145,'YT','Mayotte'),(146,'MX','Mexico'),(147,'FM','Micronesia'),(148,'MD','Moldova'),(149,'MC','Monaco'),(150,'MN','Mongolia'),(151,'ME','Montenegro'),(152,'MS','Montserrat'),(153,'MA','Morocco'),(154,'MZ','Mozambique'),(155,'MM','Myanmar (Burma)'),(156,'NA','Namibia'),(157,'NR','Nauru'),(158,'NP','Nepal'),(159,'NL','Netherlands'),(160,'NC','New Caledonia'),(161,'NZ','New Zealand'),(162,'NI','Nicaragua'),(163,'NE','Niger'),(164,'NG','Nigeria'),(165,'NU','Niue'),(166,'NF','Norfolk Island'),(167,'KP','North Korea'),(168,'MP','Northern Mariana Islands'),(169,'NO','Norway'),(170,'OM','Oman'),(171,'PK','Pakistan'),(172,'PW','Palau'),(173,'PS','Palestinian Territories'),(174,'PA','Panama'),(175,'PG','Papua New Guinea'),(176,'PY','Paraguay'),(177,'PE','Peru'),(178,'PH','Philippines'),(179,'PN','Pitcairn Islands'),(180,'PL','Poland'),(181,'PT','Portugal'),(182,'PR','Puerto Rico'),(183,'QA','Qatar'),(184,'RE','Réunion'),(185,'RO','Romania'),(186,'RU','Russia'),(187,'RW','Rwanda'),(188,'WS','Samoa'),(189,'SM','San Marino'),(190,'ST','São Tomé & Príncipe'),(191,'SA','Saudi Arabia'),(192,'SN','Senegal'),(193,'RS','Serbia'),(194,'SC','Seychelles'),(195,'SL','Sierra Leone'),(196,'SG','Singapore'),(197,'SX','Sint Maarten'),(198,'SK','Slovakia'),(199,'SI','Slovenia'),(200,'SB','Solomon Islands'),(201,'SO','Somalia'),(202,'ZA','South Africa'),(203,'GS','South Georgia & South Sandwich Islands'),(204,'KR','South Korea'),(205,'SS','South Sudan'),(206,'ES','Spain'),(207,'LK','Sri Lanka'),(208,'BL','St. Barthélemy'),(209,'SH','St. Helena'),(210,'KN','St. Kitts & Nevis'),(211,'LC','St. Lucia'),(212,'MF','St. Martin'),(213,'PM','St. Pierre & Miquelon'),(214,'VC','St. Vincent & Grenadines'),(215,'SD','Sudan'),(216,'SR','Suriname'),(217,'SJ','Svalbard & Jan Mayen'),(218,'SZ','Swaziland'),(219,'SE','Sweden'),(220,'CH','Switzerland'),(221,'SY','Syria'),(222,'TW','Taiwan'),(223,'TJ','Tajikistan'),(224,'TZ','Tanzania'),(225,'TH','Thailand'),(226,'TL','Timor-Leste'),(227,'TG','Togo'),(228,'TK','Tokelau'),(229,'TO','Tonga'),(230,'TT','Trinidad & Tobago'),(231,'TA','Tristan da Cunha'),(232,'TN','Tunisia'),(233,'TR','Turkey'),(234,'TM','Turkmenistan'),(235,'TC','Turks & Caicos Islands'),(236,'TV','Tuvalu'),(237,'UM','U.S. Outlying Islands'),(238,'VI','U.S. Virgin Islands'),(239,'UG','Uganda'),(240,'UA','Ukraine'),(241,'AE','United Arab Emirates'),(242,'GB','United Kingdom'),(244,'US','United States'),(245,'UY','Uruguay'),(246,'UZ','Uzbekistan'),(247,'VU','Vanuatu'),(248,'VA','Vatican City'),(249,'VE','Venezuela'),(250,'VN','Vietnam'),(251,'WF','Wallis & Futuna'),(252,'EH','Western Sahara'),(253,'YE','Yemen'),(254,'ZM','Zambia'),(255,'ZW','Zimbabwe');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_state_translations`
--

DROP TABLE IF EXISTS `country_state_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_state_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `country_state_id` int(10) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `default_name` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `country_state_translations_country_state_id_foreign` (`country_state_id`),
  CONSTRAINT `country_state_translations_country_state_id_foreign` FOREIGN KEY (`country_state_id`) REFERENCES `country_states` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_state_translations`
--

LOCK TABLES `country_state_translations` WRITE;
/*!40000 ALTER TABLE `country_state_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `country_state_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_states`
--

DROP TABLE IF EXISTS `country_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_states` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` int(10) unsigned DEFAULT NULL,
  `country_code` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `default_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `country_states_country_id_foreign` (`country_id`),
  CONSTRAINT `country_states_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=587 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_states`
--

LOCK TABLES `country_states` WRITE;
/*!40000 ALTER TABLE `country_states` DISABLE KEYS */;
INSERT INTO `country_states` VALUES (1,244,'US','AL','Alabama'),(2,244,'US','AK','Alaska'),(3,244,'US','AS','American Samoa'),(4,244,'US','AZ','Arizona'),(5,244,'US','AR','Arkansas'),(6,244,'US','AE','Armed Forces Africa'),(7,244,'US','AA','Armed Forces Americas'),(8,244,'US','AE','Armed Forces Canada'),(9,244,'US','AE','Armed Forces Europe'),(10,244,'US','AE','Armed Forces Middle East'),(11,244,'US','AP','Armed Forces Pacific'),(12,244,'US','CA','California'),(13,244,'US','CO','Colorado'),(14,244,'US','CT','Connecticut'),(15,244,'US','DE','Delaware'),(16,244,'US','DC','District of Columbia'),(17,244,'US','FM','Federated States Of Micronesia'),(18,244,'US','FL','Florida'),(19,244,'US','GA','Georgia'),(20,244,'US','GU','Guam'),(21,244,'US','HI','Hawaii'),(22,244,'US','ID','Idaho'),(23,244,'US','IL','Illinois'),(24,244,'US','IN','Indiana'),(25,244,'US','IA','Iowa'),(26,244,'US','KS','Kansas'),(27,244,'US','KY','Kentucky'),(28,244,'US','LA','Louisiana'),(29,244,'US','ME','Maine'),(30,244,'US','MH','Marshall Islands'),(31,244,'US','MD','Maryland'),(32,244,'US','MA','Massachusetts'),(33,244,'US','MI','Michigan'),(34,244,'US','MN','Minnesota'),(35,244,'US','MS','Mississippi'),(36,244,'US','MO','Missouri'),(37,244,'US','MT','Montana'),(38,244,'US','NE','Nebraska'),(39,244,'US','NV','Nevada'),(40,244,'US','NH','New Hampshire'),(41,244,'US','NJ','New Jersey'),(42,244,'US','NM','New Mexico'),(43,244,'US','NY','New York'),(44,244,'US','NC','North Carolina'),(45,244,'US','ND','North Dakota'),(46,244,'US','MP','Northern Mariana Islands'),(47,244,'US','OH','Ohio'),(48,244,'US','OK','Oklahoma'),(49,244,'US','OR','Oregon'),(50,244,'US','PW','Palau'),(51,244,'US','PA','Pennsylvania'),(52,244,'US','PR','Puerto Rico'),(53,244,'US','RI','Rhode Island'),(54,244,'US','SC','South Carolina'),(55,244,'US','SD','South Dakota'),(56,244,'US','TN','Tennessee'),(57,244,'US','TX','Texas'),(58,244,'US','UT','Utah'),(59,244,'US','VT','Vermont'),(60,244,'US','VI','Virgin Islands'),(61,244,'US','VA','Virginia'),(62,244,'US','WA','Washington'),(63,244,'US','WV','West Virginia'),(64,244,'US','WI','Wisconsin'),(65,244,'US','WY','Wyoming'),(66,40,'CA','AB','Alberta'),(67,40,'CA','BC','British Columbia'),(68,40,'CA','MB','Manitoba'),(69,40,'CA','NL','Newfoundland and Labrador'),(70,40,'CA','NB','New Brunswick'),(71,40,'CA','NS','Nova Scotia'),(72,40,'CA','NT','Northwest Territories'),(73,40,'CA','NU','Nunavut'),(74,40,'CA','ON','Ontario'),(75,40,'CA','PE','Prince Edward Island'),(76,40,'CA','QC','Quebec'),(77,40,'CA','SK','Saskatchewan'),(78,40,'CA','YT','Yukon Territory'),(79,88,'DE','NDS','Niedersachsen'),(80,88,'DE','BAW','Baden-Württemberg'),(81,88,'DE','BAY','Bayern'),(82,88,'DE','BER','Berlin'),(83,88,'DE','BRG','Brandenburg'),(84,88,'DE','BRE','Bremen'),(85,88,'DE','HAM','Hamburg'),(86,88,'DE','HES','Hessen'),(87,88,'DE','MEC','Mecklenburg-Vorpommern'),(88,88,'DE','NRW','Nordrhein-Westfalen'),(89,88,'DE','RHE','Rheinland-Pfalz'),(90,88,'DE','SAR','Saarland'),(91,88,'DE','SAS','Sachsen'),(92,88,'DE','SAC','Sachsen-Anhalt'),(93,88,'DE','SCN','Schleswig-Holstein'),(94,88,'DE','THE','Thüringen'),(95,16,'AT','WI','Wien'),(96,16,'AT','NO','Niederösterreich'),(97,16,'AT','OO','Oberösterreich'),(98,16,'AT','SB','Salzburg'),(99,16,'AT','KN','Kärnten'),(100,16,'AT','ST','Steiermark'),(101,16,'AT','TI','Tirol'),(102,16,'AT','BL','Burgenland'),(103,16,'AT','VB','Vorarlberg'),(104,220,'CH','AG','Aargau'),(105,220,'CH','AI','Appenzell Innerrhoden'),(106,220,'CH','AR','Appenzell Ausserrhoden'),(107,220,'CH','BE','Bern'),(108,220,'CH','BL','Basel-Landschaft'),(109,220,'CH','BS','Basel-Stadt'),(110,220,'CH','FR','Freiburg'),(111,220,'CH','GE','Genf'),(112,220,'CH','GL','Glarus'),(113,220,'CH','GR','Graubünden'),(114,220,'CH','JU','Jura'),(115,220,'CH','LU','Luzern'),(116,220,'CH','NE','Neuenburg'),(117,220,'CH','NW','Nidwalden'),(118,220,'CH','OW','Obwalden'),(119,220,'CH','SG','St. Gallen'),(120,220,'CH','SH','Schaffhausen'),(121,220,'CH','SO','Solothurn'),(122,220,'CH','SZ','Schwyz'),(123,220,'CH','TG','Thurgau'),(124,220,'CH','TI','Tessin'),(125,220,'CH','UR','Uri'),(126,220,'CH','VD','Waadt'),(127,220,'CH','VS','Wallis'),(128,220,'CH','ZG','Zug'),(129,220,'CH','ZH','Zürich'),(130,206,'ES','A Coruсa','A Coruña'),(131,206,'ES','Alava','Alava'),(132,206,'ES','Albacete','Albacete'),(133,206,'ES','Alicante','Alicante'),(134,206,'ES','Almeria','Almeria'),(135,206,'ES','Asturias','Asturias'),(136,206,'ES','Avila','Avila'),(137,206,'ES','Badajoz','Badajoz'),(138,206,'ES','Baleares','Baleares'),(139,206,'ES','Barcelona','Barcelona'),(140,206,'ES','Burgos','Burgos'),(141,206,'ES','Caceres','Caceres'),(142,206,'ES','Cadiz','Cadiz'),(143,206,'ES','Cantabria','Cantabria'),(144,206,'ES','Castellon','Castellon'),(145,206,'ES','Ceuta','Ceuta'),(146,206,'ES','Ciudad Real','Ciudad Real'),(147,206,'ES','Cordoba','Cordoba'),(148,206,'ES','Cuenca','Cuenca'),(149,206,'ES','Girona','Girona'),(150,206,'ES','Granada','Granada'),(151,206,'ES','Guadalajara','Guadalajara'),(152,206,'ES','Guipuzcoa','Guipuzcoa'),(153,206,'ES','Huelva','Huelva'),(154,206,'ES','Huesca','Huesca'),(155,206,'ES','Jaen','Jaen'),(156,206,'ES','La Rioja','La Rioja'),(157,206,'ES','Las Palmas','Las Palmas'),(158,206,'ES','Leon','Leon'),(159,206,'ES','Lleida','Lleida'),(160,206,'ES','Lugo','Lugo'),(161,206,'ES','Madrid','Madrid'),(162,206,'ES','Malaga','Malaga'),(163,206,'ES','Melilla','Melilla'),(164,206,'ES','Murcia','Murcia'),(165,206,'ES','Navarra','Navarra'),(166,206,'ES','Ourense','Ourense'),(167,206,'ES','Palencia','Palencia'),(168,206,'ES','Pontevedra','Pontevedra'),(169,206,'ES','Salamanca','Salamanca'),(170,206,'ES','Santa Cruz de Tenerife','Santa Cruz de Tenerife'),(171,206,'ES','Segovia','Segovia'),(172,206,'ES','Sevilla','Sevilla'),(173,206,'ES','Soria','Soria'),(174,206,'ES','Tarragona','Tarragona'),(175,206,'ES','Teruel','Teruel'),(176,206,'ES','Toledo','Toledo'),(177,206,'ES','Valencia','Valencia'),(178,206,'ES','Valladolid','Valladolid'),(179,206,'ES','Vizcaya','Vizcaya'),(180,206,'ES','Zamora','Zamora'),(181,206,'ES','Zaragoza','Zaragoza'),(182,81,'FR','1','Ain'),(183,81,'FR','2','Aisne'),(184,81,'FR','3','Allier'),(185,81,'FR','4','Alpes-de-Haute-Provence'),(186,81,'FR','5','Hautes-Alpes'),(187,81,'FR','6','Alpes-Maritimes'),(188,81,'FR','7','Ardèche'),(189,81,'FR','8','Ardennes'),(190,81,'FR','9','Ariège'),(191,81,'FR','10','Aube'),(192,81,'FR','11','Aude'),(193,81,'FR','12','Aveyron'),(194,81,'FR','13','Bouches-du-Rhône'),(195,81,'FR','14','Calvados'),(196,81,'FR','15','Cantal'),(197,81,'FR','16','Charente'),(198,81,'FR','17','Charente-Maritime'),(199,81,'FR','18','Cher'),(200,81,'FR','19','Corrèze'),(201,81,'FR','2A','Corse-du-Sud'),(202,81,'FR','2B','Haute-Corse'),(203,81,'FR','21','Côte-d\'Or'),(204,81,'FR','22','Côtes-d\'Armor'),(205,81,'FR','23','Creuse'),(206,81,'FR','24','Dordogne'),(207,81,'FR','25','Doubs'),(208,81,'FR','26','Drôme'),(209,81,'FR','27','Eure'),(210,81,'FR','28','Eure-et-Loir'),(211,81,'FR','29','Finistère'),(212,81,'FR','30','Gard'),(213,81,'FR','31','Haute-Garonne'),(214,81,'FR','32','Gers'),(215,81,'FR','33','Gironde'),(216,81,'FR','34','Hérault'),(217,81,'FR','35','Ille-et-Vilaine'),(218,81,'FR','36','Indre'),(219,81,'FR','37','Indre-et-Loire'),(220,81,'FR','38','Isère'),(221,81,'FR','39','Jura'),(222,81,'FR','40','Landes'),(223,81,'FR','41','Loir-et-Cher'),(224,81,'FR','42','Loire'),(225,81,'FR','43','Haute-Loire'),(226,81,'FR','44','Loire-Atlantique'),(227,81,'FR','45','Loiret'),(228,81,'FR','46','Lot'),(229,81,'FR','47','Lot-et-Garonne'),(230,81,'FR','48','Lozère'),(231,81,'FR','49','Maine-et-Loire'),(232,81,'FR','50','Manche'),(233,81,'FR','51','Marne'),(234,81,'FR','52','Haute-Marne'),(235,81,'FR','53','Mayenne'),(236,81,'FR','54','Meurthe-et-Moselle'),(237,81,'FR','55','Meuse'),(238,81,'FR','56','Morbihan'),(239,81,'FR','57','Moselle'),(240,81,'FR','58','Nièvre'),(241,81,'FR','59','Nord'),(242,81,'FR','60','Oise'),(243,81,'FR','61','Orne'),(244,81,'FR','62','Pas-de-Calais'),(245,81,'FR','63','Puy-de-Dôme'),(246,81,'FR','64','Pyrénées-Atlantiques'),(247,81,'FR','65','Hautes-Pyrénées'),(248,81,'FR','66','Pyrénées-Orientales'),(249,81,'FR','67','Bas-Rhin'),(250,81,'FR','68','Haut-Rhin'),(251,81,'FR','69','Rhône'),(252,81,'FR','70','Haute-Saône'),(253,81,'FR','71','Saône-et-Loire'),(254,81,'FR','72','Sarthe'),(255,81,'FR','73','Savoie'),(256,81,'FR','74','Haute-Savoie'),(257,81,'FR','75','Paris'),(258,81,'FR','76','Seine-Maritime'),(259,81,'FR','77','Seine-et-Marne'),(260,81,'FR','78','Yvelines'),(261,81,'FR','79','Deux-Sèvres'),(262,81,'FR','80','Somme'),(263,81,'FR','81','Tarn'),(264,81,'FR','82','Tarn-et-Garonne'),(265,81,'FR','83','Var'),(266,81,'FR','84','Vaucluse'),(267,81,'FR','85','Vendée'),(268,81,'FR','86','Vienne'),(269,81,'FR','87','Haute-Vienne'),(270,81,'FR','88','Vosges'),(271,81,'FR','89','Yonne'),(272,81,'FR','90','Territoire-de-Belfort'),(273,81,'FR','91','Essonne'),(274,81,'FR','92','Hauts-de-Seine'),(275,81,'FR','93','Seine-Saint-Denis'),(276,81,'FR','94','Val-de-Marne'),(277,81,'FR','95','Val-d\'Oise'),(278,185,'RO','AB','Alba'),(279,185,'RO','AR','Arad'),(280,185,'RO','AG','Argeş'),(281,185,'RO','BC','Bacău'),(282,185,'RO','BH','Bihor'),(283,185,'RO','BN','Bistriţa-Năsăud'),(284,185,'RO','BT','Botoşani'),(285,185,'RO','BV','Braşov'),(286,185,'RO','BR','Brăila'),(287,185,'RO','B','Bucureşti'),(288,185,'RO','BZ','Buzău'),(289,185,'RO','CS','Caraş-Severin'),(290,185,'RO','CL','Călăraşi'),(291,185,'RO','CJ','Cluj'),(292,185,'RO','CT','Constanţa'),(293,185,'RO','CV','Covasna'),(294,185,'RO','DB','Dâmboviţa'),(295,185,'RO','DJ','Dolj'),(296,185,'RO','GL','Galaţi'),(297,185,'RO','GR','Giurgiu'),(298,185,'RO','GJ','Gorj'),(299,185,'RO','HR','Harghita'),(300,185,'RO','HD','Hunedoara'),(301,185,'RO','IL','Ialomiţa'),(302,185,'RO','IS','Iaşi'),(303,185,'RO','IF','Ilfov'),(304,185,'RO','MM','Maramureş'),(305,185,'RO','MH','Mehedinţi'),(306,185,'RO','MS','Mureş'),(307,185,'RO','NT','Neamţ'),(308,185,'RO','OT','Olt'),(309,185,'RO','PH','Prahova'),(310,185,'RO','SM','Satu-Mare'),(311,185,'RO','SJ','Sălaj'),(312,185,'RO','SB','Sibiu'),(313,185,'RO','SV','Suceava'),(314,185,'RO','TR','Teleorman'),(315,185,'RO','TM','Timiş'),(316,185,'RO','TL','Tulcea'),(317,185,'RO','VS','Vaslui'),(318,185,'RO','VL','Vâlcea'),(319,185,'RO','VN','Vrancea'),(320,80,'FI','Lappi','Lappi'),(321,80,'FI','Pohjois-Pohjanmaa','Pohjois-Pohjanmaa'),(322,80,'FI','Kainuu','Kainuu'),(323,80,'FI','Pohjois-Karjala','Pohjois-Karjala'),(324,80,'FI','Pohjois-Savo','Pohjois-Savo'),(325,80,'FI','Etelä-Savo','Etelä-Savo'),(326,80,'FI','Etelä-Pohjanmaa','Etelä-Pohjanmaa'),(327,80,'FI','Pohjanmaa','Pohjanmaa'),(328,80,'FI','Pirkanmaa','Pirkanmaa'),(329,80,'FI','Satakunta','Satakunta'),(330,80,'FI','Keski-Pohjanmaa','Keski-Pohjanmaa'),(331,80,'FI','Keski-Suomi','Keski-Suomi'),(332,80,'FI','Varsinais-Suomi','Varsinais-Suomi'),(333,80,'FI','Etelä-Karjala','Etelä-Karjala'),(334,80,'FI','Päijät-Häme','Päijät-Häme'),(335,80,'FI','Kanta-Häme','Kanta-Häme'),(336,80,'FI','Uusimaa','Uusimaa'),(337,80,'FI','Itä-Uusimaa','Itä-Uusimaa'),(338,80,'FI','Kymenlaakso','Kymenlaakso'),(339,80,'FI','Ahvenanmaa','Ahvenanmaa'),(340,74,'EE','EE-37','Harjumaa'),(341,74,'EE','EE-39','Hiiumaa'),(342,74,'EE','EE-44','Ida-Virumaa'),(343,74,'EE','EE-49','Jõgevamaa'),(344,74,'EE','EE-51','Järvamaa'),(345,74,'EE','EE-57','Läänemaa'),(346,74,'EE','EE-59','Lääne-Virumaa'),(347,74,'EE','EE-65','Põlvamaa'),(348,74,'EE','EE-67','Pärnumaa'),(349,74,'EE','EE-70','Raplamaa'),(350,74,'EE','EE-74','Saaremaa'),(351,74,'EE','EE-78','Tartumaa'),(352,74,'EE','EE-82','Valgamaa'),(353,74,'EE','EE-84','Viljandimaa'),(354,74,'EE','EE-86','Võrumaa'),(355,125,'LV','LV-DGV','Daugavpils'),(356,125,'LV','LV-JEL','Jelgava'),(357,125,'LV','Jēkabpils','Jēkabpils'),(358,125,'LV','LV-JUR','Jūrmala'),(359,125,'LV','LV-LPX','Liepāja'),(360,125,'LV','LV-LE','Liepājas novads'),(361,125,'LV','LV-REZ','Rēzekne'),(362,125,'LV','LV-RIX','Rīga'),(363,125,'LV','LV-RI','Rīgas novads'),(364,125,'LV','Valmiera','Valmiera'),(365,125,'LV','LV-VEN','Ventspils'),(366,125,'LV','Aglonas novads','Aglonas novads'),(367,125,'LV','LV-AI','Aizkraukles novads'),(368,125,'LV','Aizputes novads','Aizputes novads'),(369,125,'LV','Aknīstes novads','Aknīstes novads'),(370,125,'LV','Alojas novads','Alojas novads'),(371,125,'LV','Alsungas novads','Alsungas novads'),(372,125,'LV','LV-AL','Alūksnes novads'),(373,125,'LV','Amatas novads','Amatas novads'),(374,125,'LV','Apes novads','Apes novads'),(375,125,'LV','Auces novads','Auces novads'),(376,125,'LV','Babītes novads','Babītes novads'),(377,125,'LV','Baldones novads','Baldones novads'),(378,125,'LV','Baltinavas novads','Baltinavas novads'),(379,125,'LV','LV-BL','Balvu novads'),(380,125,'LV','LV-BU','Bauskas novads'),(381,125,'LV','Beverīnas novads','Beverīnas novads'),(382,125,'LV','Brocēnu novads','Brocēnu novads'),(383,125,'LV','Burtnieku novads','Burtnieku novads'),(384,125,'LV','Carnikavas novads','Carnikavas novads'),(385,125,'LV','Cesvaines novads','Cesvaines novads'),(386,125,'LV','Ciblas novads','Ciblas novads'),(387,125,'LV','LV-CE','Cēsu novads'),(388,125,'LV','Dagdas novads','Dagdas novads'),(389,125,'LV','LV-DA','Daugavpils novads'),(390,125,'LV','LV-DO','Dobeles novads'),(391,125,'LV','Dundagas novads','Dundagas novads'),(392,125,'LV','Durbes novads','Durbes novads'),(393,125,'LV','Engures novads','Engures novads'),(394,125,'LV','Garkalnes novads','Garkalnes novads'),(395,125,'LV','Grobiņas novads','Grobiņas novads'),(396,125,'LV','LV-GU','Gulbenes novads'),(397,125,'LV','Iecavas novads','Iecavas novads'),(398,125,'LV','Ikšķiles novads','Ikšķiles novads'),(399,125,'LV','Ilūkstes novads','Ilūkstes novads'),(400,125,'LV','Inčukalna novads','Inčukalna novads'),(401,125,'LV','Jaunjelgavas novads','Jaunjelgavas novads'),(402,125,'LV','Jaunpiebalgas novads','Jaunpiebalgas novads'),(403,125,'LV','Jaunpils novads','Jaunpils novads'),(404,125,'LV','LV-JL','Jelgavas novads'),(405,125,'LV','LV-JK','Jēkabpils novads'),(406,125,'LV','Kandavas novads','Kandavas novads'),(407,125,'LV','Kokneses novads','Kokneses novads'),(408,125,'LV','Krimuldas novads','Krimuldas novads'),(409,125,'LV','Krustpils novads','Krustpils novads'),(410,125,'LV','LV-KR','Krāslavas novads'),(411,125,'LV','LV-KU','Kuldīgas novads'),(412,125,'LV','Kārsavas novads','Kārsavas novads'),(413,125,'LV','Lielvārdes novads','Lielvārdes novads'),(414,125,'LV','LV-LM','Limbažu novads'),(415,125,'LV','Lubānas novads','Lubānas novads'),(416,125,'LV','LV-LU','Ludzas novads'),(417,125,'LV','Līgatnes novads','Līgatnes novads'),(418,125,'LV','Līvānu novads','Līvānu novads'),(419,125,'LV','LV-MA','Madonas novads'),(420,125,'LV','Mazsalacas novads','Mazsalacas novads'),(421,125,'LV','Mālpils novads','Mālpils novads'),(422,125,'LV','Mārupes novads','Mārupes novads'),(423,125,'LV','Naukšēnu novads','Naukšēnu novads'),(424,125,'LV','Neretas novads','Neretas novads'),(425,125,'LV','Nīcas novads','Nīcas novads'),(426,125,'LV','LV-OG','Ogres novads'),(427,125,'LV','Olaines novads','Olaines novads'),(428,125,'LV','Ozolnieku novads','Ozolnieku novads'),(429,125,'LV','LV-PR','Preiļu novads'),(430,125,'LV','Priekules novads','Priekules novads'),(431,125,'LV','Priekuļu novads','Priekuļu novads'),(432,125,'LV','Pārgaujas novads','Pārgaujas novads'),(433,125,'LV','Pāvilostas novads','Pāvilostas novads'),(434,125,'LV','Pļaviņu novads','Pļaviņu novads'),(435,125,'LV','Raunas novads','Raunas novads'),(436,125,'LV','Riebiņu novads','Riebiņu novads'),(437,125,'LV','Rojas novads','Rojas novads'),(438,125,'LV','Ropažu novads','Ropažu novads'),(439,125,'LV','Rucavas novads','Rucavas novads'),(440,125,'LV','Rugāju novads','Rugāju novads'),(441,125,'LV','Rundāles novads','Rundāles novads'),(442,125,'LV','LV-RE','Rēzeknes novads'),(443,125,'LV','Rūjienas novads','Rūjienas novads'),(444,125,'LV','Salacgrīvas novads','Salacgrīvas novads'),(445,125,'LV','Salas novads','Salas novads'),(446,125,'LV','Salaspils novads','Salaspils novads'),(447,125,'LV','LV-SA','Saldus novads'),(448,125,'LV','Saulkrastu novads','Saulkrastu novads'),(449,125,'LV','Siguldas novads','Siguldas novads'),(450,125,'LV','Skrundas novads','Skrundas novads'),(451,125,'LV','Skrīveru novads','Skrīveru novads'),(452,125,'LV','Smiltenes novads','Smiltenes novads'),(453,125,'LV','Stopiņu novads','Stopiņu novads'),(454,125,'LV','Strenču novads','Strenču novads'),(455,125,'LV','Sējas novads','Sējas novads'),(456,125,'LV','LV-TA','Talsu novads'),(457,125,'LV','LV-TU','Tukuma novads'),(458,125,'LV','Tērvetes novads','Tērvetes novads'),(459,125,'LV','Vaiņodes novads','Vaiņodes novads'),(460,125,'LV','LV-VK','Valkas novads'),(461,125,'LV','LV-VM','Valmieras novads'),(462,125,'LV','Varakļānu novads','Varakļānu novads'),(463,125,'LV','Vecpiebalgas novads','Vecpiebalgas novads'),(464,125,'LV','Vecumnieku novads','Vecumnieku novads'),(465,125,'LV','LV-VE','Ventspils novads'),(466,125,'LV','Viesītes novads','Viesītes novads'),(467,125,'LV','Viļakas novads','Viļakas novads'),(468,125,'LV','Viļānu novads','Viļānu novads'),(469,125,'LV','Vārkavas novads','Vārkavas novads'),(470,125,'LV','Zilupes novads','Zilupes novads'),(471,125,'LV','Ādažu novads','Ādažu novads'),(472,125,'LV','Ērgļu novads','Ērgļu novads'),(473,125,'LV','Ķeguma novads','Ķeguma novads'),(474,125,'LV','Ķekavas novads','Ķekavas novads'),(475,131,'LT','LT-AL','Alytaus Apskritis'),(476,131,'LT','LT-KU','Kauno Apskritis'),(477,131,'LT','LT-KL','Klaipėdos Apskritis'),(478,131,'LT','LT-MR','Marijampolės Apskritis'),(479,131,'LT','LT-PN','Panevėžio Apskritis'),(480,131,'LT','LT-SA','Šiaulių Apskritis'),(481,131,'LT','LT-TA','Tauragės Apskritis'),(482,131,'LT','LT-TE','Telšių Apskritis'),(483,131,'LT','LT-UT','Utenos Apskritis'),(484,131,'LT','LT-VL','Vilniaus Apskritis'),(485,31,'BR','AC','Acre'),(486,31,'BR','AL','Alagoas'),(487,31,'BR','AP','Amapá'),(488,31,'BR','AM','Amazonas'),(489,31,'BR','BA','Bahia'),(490,31,'BR','CE','Ceará'),(491,31,'BR','ES','Espírito Santo'),(492,31,'BR','GO','Goiás'),(493,31,'BR','MA','Maranhão'),(494,31,'BR','MT','Mato Grosso'),(495,31,'BR','MS','Mato Grosso do Sul'),(496,31,'BR','MG','Minas Gerais'),(497,31,'BR','PA','Pará'),(498,31,'BR','PB','Paraíba'),(499,31,'BR','PR','Paraná'),(500,31,'BR','PE','Pernambuco'),(501,31,'BR','PI','Piauí'),(502,31,'BR','RJ','Rio de Janeiro'),(503,31,'BR','RN','Rio Grande do Norte'),(504,31,'BR','RS','Rio Grande do Sul'),(505,31,'BR','RO','Rondônia'),(506,31,'BR','RR','Roraima'),(507,31,'BR','SC','Santa Catarina'),(508,31,'BR','SP','São Paulo'),(509,31,'BR','SE','Sergipe'),(510,31,'BR','TO','Tocantins'),(511,31,'BR','DF','Distrito Federal'),(512,59,'HR','HR-01','Zagrebačka županija'),(513,59,'HR','HR-02','Krapinsko-zagorska županija'),(514,59,'HR','HR-03','Sisačko-moslavačka županija'),(515,59,'HR','HR-04','Karlovačka županija'),(516,59,'HR','HR-05','Varaždinska županija'),(517,59,'HR','HR-06','Koprivničko-križevačka županija'),(518,59,'HR','HR-07','Bjelovarsko-bilogorska županija'),(519,59,'HR','HR-08','Primorsko-goranska županija'),(520,59,'HR','HR-09','Ličko-senjska županija'),(521,59,'HR','HR-10','Virovitičko-podravska županija'),(522,59,'HR','HR-11','Požeško-slavonska županija'),(523,59,'HR','HR-12','Brodsko-posavska županija'),(524,59,'HR','HR-13','Zadarska županija'),(525,59,'HR','HR-14','Osječko-baranjska županija'),(526,59,'HR','HR-15','Šibensko-kninska županija'),(527,59,'HR','HR-16','Vukovarsko-srijemska županija'),(528,59,'HR','HR-17','Splitsko-dalmatinska županija'),(529,59,'HR','HR-18','Istarska županija'),(530,59,'HR','HR-19','Dubrovačko-neretvanska županija'),(531,59,'HR','HR-20','Međimurska županija'),(532,59,'HR','HR-21','Grad Zagreb'),(533,106,'IN','AN','Andaman and Nicobar Islands'),(534,106,'IN','AP','Andhra Pradesh'),(535,106,'IN','AR','Arunachal Pradesh'),(536,106,'IN','AS','Assam'),(537,106,'IN','BR','Bihar'),(538,106,'IN','CH','Chandigarh'),(539,106,'IN','CT','Chhattisgarh'),(540,106,'IN','DN','Dadra and Nagar Haveli'),(541,106,'IN','DD','Daman and Diu'),(542,106,'IN','DL','Delhi'),(543,106,'IN','GA','Goa'),(544,106,'IN','GJ','Gujarat'),(545,106,'IN','HR','Haryana'),(546,106,'IN','HP','Himachal Pradesh'),(547,106,'IN','JK','Jammu and Kashmir'),(548,106,'IN','JH','Jharkhand'),(549,106,'IN','KA','Karnataka'),(550,106,'IN','KL','Kerala'),(551,106,'IN','LD','Lakshadweep'),(552,106,'IN','MP','Madhya Pradesh'),(553,106,'IN','MH','Maharashtra'),(554,106,'IN','MN','Manipur'),(555,106,'IN','ML','Meghalaya'),(556,106,'IN','MZ','Mizoram'),(557,106,'IN','NL','Nagaland'),(558,106,'IN','OR','Odisha'),(559,106,'IN','PY','Puducherry'),(560,106,'IN','PB','Punjab'),(561,106,'IN','RJ','Rajasthan'),(562,106,'IN','SK','Sikkim'),(563,106,'IN','TN','Tamil Nadu'),(564,106,'IN','TG','Telangana'),(565,106,'IN','TR','Tripura'),(566,106,'IN','UP','Uttar Pradesh'),(567,106,'IN','UT','Uttarakhand'),(568,106,'IN','WB','West Bengal'),(569,176,'PY','PY-16','Alto Paraguay'),(570,176,'PY','PY-10','Alto Paraná'),(571,176,'PY','PY-13','Amambay'),(572,176,'PY','PY-ASU','Asunción'),(573,176,'PY','PY-19','Boquerón'),(574,176,'PY','PY-5','Caaguazú'),(575,176,'PY','PY-6','Caazapá'),(576,176,'PY','PY-14','Canindeyú'),(577,176,'PY','PY-11','Central'),(578,176,'PY','PY-1','Concepción'),(579,176,'PY','PY-3','Cordillera'),(580,176,'PY','PY-4','Guairá'),(581,176,'PY','PY-7','Itapúa'),(582,176,'PY','PY-8','Misiones'),(583,176,'PY','PY-9','Paraguarí'),(584,176,'PY','PY-15','Presidente Hayes'),(585,176,'PY','PY-2','San Pedro'),(586,176,'PY','PY-12','Ñeembucú');
/*!40000 ALTER TABLE `country_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_translations`
--

DROP TABLE IF EXISTS `country_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` int(10) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `name` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `country_translations_country_id_foreign` (`country_id`),
  CONSTRAINT `country_translations_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_translations`
--

LOCK TABLES `country_translations` WRITE;
/*!40000 ALTER TABLE `country_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `country_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currencies`
--

DROP TABLE IF EXISTS `currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currencies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `decimal` int(10) unsigned NOT NULL DEFAULT 2,
  `group_separator` varchar(255) NOT NULL DEFAULT ',',
  `decimal_separator` varchar(255) NOT NULL DEFAULT '.',
  `currency_position` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currencies`
--

LOCK TABLES `currencies` WRITE;
/*!40000 ALTER TABLE `currencies` DISABLE KEYS */;
INSERT INTO `currencies` VALUES (1,'INR','Indian Rupee','₹',2,',','.',NULL,NULL,NULL);
/*!40000 ALTER TABLE `currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currency_exchange_rates`
--

DROP TABLE IF EXISTS `currency_exchange_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currency_exchange_rates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rate` decimal(24,12) NOT NULL,
  `target_currency` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `currency_exchange_rates_target_currency_unique` (`target_currency`),
  CONSTRAINT `currency_exchange_rates_target_currency_foreign` FOREIGN KEY (`target_currency`) REFERENCES `currencies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency_exchange_rates`
--

LOCK TABLES `currency_exchange_rates` WRITE;
/*!40000 ALTER TABLE `currency_exchange_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `currency_exchange_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_groups`
--

DROP TABLE IF EXISTS `customer_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_groups_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_groups`
--

LOCK TABLES `customer_groups` WRITE;
/*!40000 ALTER TABLE `customer_groups` DISABLE KEYS */;
INSERT INTO `customer_groups` VALUES (1,'guest','Guest',0,NULL,NULL),(2,'general','General',0,NULL,NULL),(3,'wholesale','Wholesale',0,NULL,NULL);
/*!40000 ALTER TABLE `customer_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_notes`
--

DROP TABLE IF EXISTS `customer_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_notes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned DEFAULT NULL,
  `note` text NOT NULL,
  `customer_notified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_notes_customer_id_foreign` (`customer_id`),
  CONSTRAINT `customer_notes_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_notes`
--

LOCK TABLES `customer_notes` WRITE;
/*!40000 ALTER TABLE `customer_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_password_resets`
--

DROP TABLE IF EXISTS `customer_password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `customer_password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_password_resets`
--

LOCK TABLES `customer_password_resets` WRITE;
/*!40000 ALTER TABLE `customer_password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_social_accounts`
--

DROP TABLE IF EXISTS `customer_social_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_social_accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL,
  `provider_name` varchar(255) DEFAULT NULL,
  `provider_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_social_accounts_provider_id_unique` (`provider_id`),
  KEY `customer_social_accounts_customer_id_foreign` (`customer_id`),
  CONSTRAINT `customer_social_accounts_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_social_accounts`
--

LOCK TABLES `customer_social_accounts` WRITE;
/*!40000 ALTER TABLE `customer_social_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_social_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `password` varchar(255) DEFAULT NULL,
  `api_token` varchar(80) DEFAULT NULL,
  `customer_group_id` int(10) unsigned DEFAULT NULL,
  `channel_id` int(10) unsigned DEFAULT NULL,
  `subscribed_to_news_letter` tinyint(1) NOT NULL DEFAULT 0,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `is_suspended` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `token` varchar(255) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customers_phone_unique` (`phone`),
  UNIQUE KEY `customers_api_token_unique` (`api_token`),
  UNIQUE KEY `customers_email_channel_unique` (`email`,`channel_id`),
  KEY `customers_customer_group_id_foreign` (`customer_group_id`),
  KEY `customers_channel_id_foreign` (`channel_id`),
  CONSTRAINT `customers_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  CONSTRAINT `customers_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Test','User',NULL,NULL,'user@user.com',NULL,NULL,1,'$2y$10$5ZyiGFmhxozUNwZZu.2YV.Rt90CsELTymupOXetB1SJVGX2nQwlO.',NULL,2,1,1,1,0,NULL,NULL,'2026-10-09 04:58:31','2026-10-09 04:58:31'),(2,'yash','Pawar','Female','2005-11-10','pyash5231@gmail.com','09512991970',NULL,1,'$2y$12$96kYFPBv1AmnNyLHzl8OgOLZBh805cL4zsKVo/FGVzoKXfrVqRygq',NULL,3,1,0,1,0,NULL,NULL,'2026-11-02 10:13:48','2026-11-02 10:13:48'),(3,'Aarav','Patel',NULL,NULL,'aarav@sydspices.com','+91 98765 43210',NULL,1,'$2y$12$N1Qei1OWk3C2bWmSw2CEE.0./Od76rF/t1am1H.CQmF3xUHDvSYH.',NULL,1,1,0,1,0,NULL,NULL,'2026-11-02 10:35:12','2026-11-13 07:23:55'),(4,'Vikram','Singhania',NULL,NULL,'vikram@example.com','+91 98200 12345',NULL,1,'$2y$12$x1N5PnGUCM2ktYVj4KYohuVe.ZcvAsfS/QGq6D.nQfg7AbYzCINim',NULL,1,1,0,1,0,NULL,NULL,'2026-11-06 10:55:41','2026-11-06 10:55:41'),(9,'Vivek','Test Account',NULL,NULL,'vivek.developer@sydspices.com','+91 97777 55555',NULL,1,'$2y$12$PLi5DGDaazAjIttw9HU3NuLqR4oSxu6OLuISlRgVWXpgngHOoYG6a',NULL,2,1,0,1,0,NULL,NULL,'2026-11-13 07:54:12','2026-11-13 07:54:12'),(10,'Raxesh','patel',NULL,NULL,'superadmin@amezproducts.com','+918733898966',NULL,1,'$2y$12$VO43qP1MGkU6YNTXH8VrS.X2WPVoMVxKPkTiFqbL29rbnYhxocpoC',NULL,2,1,0,1,0,NULL,NULL,'2026-11-13 08:01:27','2026-11-13 08:01:27');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datagrid_saved_filters`
--

DROP TABLE IF EXISTS `datagrid_saved_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datagrid_saved_filters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `src` varchar(255) NOT NULL,
  `applied` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`applied`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `datagrid_saved_filters_user_id_name_src_unique` (`user_id`,`name`,`src`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datagrid_saved_filters`
--

LOCK TABLES `datagrid_saved_filters` WRITE;
/*!40000 ALTER TABLE `datagrid_saved_filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `datagrid_saved_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadable_link_purchased`
--

DROP TABLE IF EXISTS `downloadable_link_purchased`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadable_link_purchased` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `download_bought` int(11) NOT NULL DEFAULT 0,
  `download_used` int(11) NOT NULL DEFAULT 0,
  `status` varchar(255) DEFAULT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `order_id` int(10) unsigned NOT NULL,
  `order_item_id` int(10) unsigned NOT NULL,
  `download_canceled` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `downloadable_link_purchased_customer_id_foreign` (`customer_id`),
  KEY `downloadable_link_purchased_order_id_foreign` (`order_id`),
  KEY `downloadable_link_purchased_order_item_id_foreign` (`order_item_id`),
  CONSTRAINT `downloadable_link_purchased_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `downloadable_link_purchased_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `downloadable_link_purchased_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadable_link_purchased`
--

LOCK TABLES `downloadable_link_purchased` WRITE;
/*!40000 ALTER TABLE `downloadable_link_purchased` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadable_link_purchased` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eu_withdrawals`
--

DROP TABLE IF EXISTS `eu_withdrawals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eu_withdrawals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `order_id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT 0,
  `customer_email` varchar(255) NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `locale` varchar(10) NOT NULL,
  `reason_text` text DEFAULT NULL,
  `received_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `confirmation_sent_at` timestamp NULL DEFAULT NULL,
  `final_confirmation_sent_at` timestamp NULL DEFAULT NULL,
  `confirmation_error` varchar(500) DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'received',
  `declined_at` timestamp NULL DEFAULT NULL,
  `declined_reason` varchar(500) DEFAULT NULL,
  `declined_by_user_id` int(10) unsigned DEFAULT NULL,
  `refunded_at` timestamp NULL DEFAULT NULL,
  `refunded_by_user_id` int(10) unsigned DEFAULT NULL,
  `refund_note` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eu_withdrawals_order_id_unique` (`order_id`),
  UNIQUE KEY `eu_withdrawals_uuid_unique` (`uuid`),
  KEY `eu_withdrawals_customer_id_index` (`customer_id`),
  KEY `eu_withdrawals_channel_id_status_index` (`channel_id`,`status`),
  KEY `eu_withdrawals_received_at_index` (`received_at`),
  KEY `eu_withdrawals_declined_by_user_id_foreign` (`declined_by_user_id`),
  KEY `eu_withdrawals_refunded_by_user_id_foreign` (`refunded_by_user_id`),
  CONSTRAINT `eu_withdrawals_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`),
  CONSTRAINT `eu_withdrawals_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `eu_withdrawals_declined_by_user_id_foreign` FOREIGN KEY (`declined_by_user_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL,
  CONSTRAINT `eu_withdrawals_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `eu_withdrawals_refunded_by_user_id_foreign` FOREIGN KEY (`refunded_by_user_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eu_withdrawals`
--

LOCK TABLES `eu_withdrawals` WRITE;
/*!40000 ALTER TABLE `eu_withdrawals` DISABLE KEYS */;
/*!40000 ALTER TABLE `eu_withdrawals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gdpr_data_request`
--

DROP TABLE IF EXISTS `gdpr_data_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gdpr_data_request` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL,
  `email` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `message` varchar(500) NOT NULL,
  `revoked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gdpr_data_request_customer_id_foreign` (`customer_id`),
  CONSTRAINT `gdpr_data_request_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gdpr_data_request`
--

LOCK TABLES `gdpr_data_request` WRITE;
/*!40000 ALTER TABLE `gdpr_data_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `gdpr_data_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_batches`
--

DROP TABLE IF EXISTS `import_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `import_batches` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `state` varchar(255) NOT NULL DEFAULT 'pending',
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`data`)),
  `summary` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`summary`)),
  `import_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `import_batches_import_id_foreign` (`import_id`),
  CONSTRAINT `import_batches_import_id_foreign` FOREIGN KEY (`import_id`) REFERENCES `imports` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_batches`
--

LOCK TABLES `import_batches` WRITE;
/*!40000 ALTER TABLE `import_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imports`
--

DROP TABLE IF EXISTS `imports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imports` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `state` varchar(255) NOT NULL DEFAULT 'pending',
  `process_in_queue` tinyint(1) NOT NULL DEFAULT 1,
  `type` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `validation_strategy` varchar(255) NOT NULL,
  `allowed_errors` int(11) NOT NULL DEFAULT 0,
  `processed_rows_count` int(11) NOT NULL DEFAULT 0,
  `invalid_rows_count` int(11) NOT NULL DEFAULT 0,
  `errors_count` int(11) NOT NULL DEFAULT 0,
  `errors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`errors`)),
  `field_separator` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `images_directory_path` varchar(255) DEFAULT NULL,
  `image_source` varchar(255) NOT NULL DEFAULT 'directory',
  `images_archive_name` varchar(255) DEFAULT NULL,
  `error_file_path` varchar(255) DEFAULT NULL,
  `summary` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`summary`)),
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imports`
--

LOCK TABLES `imports` WRITE;
/*!40000 ALTER TABLE `imports` DISABLE KEYS */;
/*!40000 ALTER TABLE `imports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inquiries`
--

DROP TABLE IF EXISTS `inquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inquiries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `inquiry_type` varchar(150) DEFAULT 'General Inquiry',
  `message` text DEFAULT NULL,
  `status` varchar(50) DEFAULT 'New',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inquiries`
--

LOCK TABLES `inquiries` WRITE;
/*!40000 ALTER TABLE `inquiries` DISABLE KEYS */;
INSERT INTO `inquiries` VALUES (1,'Aarav Patel','aarav@sydspices.com','+91 98765 43210','Wholesale Supply','Inquiry for 500kg Magic Blend monthly supply direct from Gujarat hub.\n\n[City: Ahmedabad | Organization: Gujarat Spice Traders]','New','2026-11-02 10:35:11','2026-11-02 10:35:11'),(2,'Aarav Patel','aarav@sydspices.com','+91 98765 43210','Wholesale Supply','Inquiry for 500kg Magic Blend monthly supply direct from Gujarat hub.\n\n[City: Ahmedabad | Organization: Gujarat Spice Traders]','New','2026-11-02 10:38:13','2026-11-02 10:38:13'),(3,'Chef Sanjeev Kapadia','chef.sanjeev@hotelgrand.com','+91 99887 76655','Wholesale & Mandi','Looking to procure 50kg monthly of SYD Magic Blend and Guntur Red Chilli powder for our hotel kitchen in Surat.\n\n[City: Surat | Organization: The Grand Heritage Hotel]','Contacted','2026-11-06 10:56:32','2026-11-06 10:56:46');
/*!40000 ALTER TABLE `inquiries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_sources`
--

DROP TABLE IF EXISTS `inventory_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory_sources` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `contact_name` varchar(255) NOT NULL,
  `contact_email` varchar(255) NOT NULL,
  `contact_number` varchar(255) NOT NULL,
  `contact_fax` varchar(255) DEFAULT NULL,
  `country` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `street` varchar(255) NOT NULL,
  `postcode` varchar(255) NOT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `latitude` decimal(10,5) DEFAULT NULL,
  `longitude` decimal(10,5) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inventory_sources_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_sources`
--

LOCK TABLES `inventory_sources` WRITE;
/*!40000 ALTER TABLE `inventory_sources` DISABLE KEYS */;
INSERT INTO `inventory_sources` VALUES (1,'syd-central','SYD Spices Central Warehouse','Gala No. 12, Spice Park, Gujarat - 384170, India','SYD Spices Logistics','care@sydspices.com','+91 98765 43210',NULL,'IN','GJ','Gujarat','Spice Park Gala No. 12','384170',0,NULL,NULL,1,'2026-10-08 12:14:51','2026-10-08 12:14:51');
/*!40000 ALTER TABLE `inventory_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `product_id` int(10) unsigned DEFAULT NULL,
  `product_type` varchar(255) DEFAULT NULL,
  `order_item_id` int(10) unsigned DEFAULT NULL,
  `invoice_id` int(10) unsigned DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_items_invoice_id_foreign` (`invoice_id`),
  KEY `invoice_items_parent_id_foreign` (`parent_id`),
  CONSTRAINT `invoice_items_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `invoice_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_items`
--

LOCK TABLES `invoice_items` WRITE;
/*!40000 ALTER TABLE `invoice_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `increment_id` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `total_qty` int(11) DEFAULT NULL,
  `base_currency_code` varchar(255) DEFAULT NULL,
  `channel_currency_code` varchar(255) DEFAULT NULL,
  `order_currency_code` varchar(255) DEFAULT NULL,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `order_id` int(10) unsigned DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `reminders` int(11) NOT NULL DEFAULT 0,
  `next_reminder_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoices_order_id_foreign` (`order_id`),
  CONSTRAINT `invoices_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` text NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locales`
--

DROP TABLE IF EXISTS `locales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locales` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `direction` enum('ltr','rtl') NOT NULL DEFAULT 'ltr',
  `logo_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `locales_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locales`
--

LOCK TABLES `locales` WRITE;
/*!40000 ALTER TABLE `locales` DISABLE KEYS */;
INSERT INTO `locales` VALUES (1,'en','English','ltr','locales/gTfu388SWr2r32m6jCKFMKzdS88iLgX1ufQlcJon.png',NULL,NULL);
/*!40000 ALTER TABLE `locales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_campaigns`
--

DROP TABLE IF EXISTS `marketing_campaigns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_campaigns` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `type` varchar(255) NOT NULL,
  `mail_to` varchar(255) NOT NULL,
  `spooling` varchar(255) DEFAULT NULL,
  `channel_id` int(10) unsigned DEFAULT NULL,
  `customer_group_id` int(10) unsigned DEFAULT NULL,
  `marketing_template_id` int(10) unsigned DEFAULT NULL,
  `marketing_event_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_campaigns_channel_id_foreign` (`channel_id`),
  KEY `marketing_campaigns_customer_group_id_foreign` (`customer_group_id`),
  KEY `marketing_campaigns_marketing_template_id_foreign` (`marketing_template_id`),
  KEY `marketing_campaigns_marketing_event_id_foreign` (`marketing_event_id`),
  CONSTRAINT `marketing_campaigns_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  CONSTRAINT `marketing_campaigns_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE SET NULL,
  CONSTRAINT `marketing_campaigns_marketing_event_id_foreign` FOREIGN KEY (`marketing_event_id`) REFERENCES `marketing_events` (`id`) ON DELETE SET NULL,
  CONSTRAINT `marketing_campaigns_marketing_template_id_foreign` FOREIGN KEY (`marketing_template_id`) REFERENCES `marketing_templates` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaigns`
--

LOCK TABLES `marketing_campaigns` WRITE;
/*!40000 ALTER TABLE `marketing_campaigns` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_campaigns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_events`
--

DROP TABLE IF EXISTS `marketing_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_events`
--

LOCK TABLES `marketing_events` WRITE;
/*!40000 ALTER TABLE `marketing_events` DISABLE KEYS */;
INSERT INTO `marketing_events` VALUES (1,'Birthday','Birthday',NULL,NULL,NULL);
/*!40000 ALTER TABLE `marketing_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_templates`
--

DROP TABLE IF EXISTS `marketing_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_templates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_templates`
--

LOCK TABLES `marketing_templates` WRITE;
/*!40000 ALTER TABLE `marketing_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2014_10_12_000000_create_users_table',1),(2,'2014_10_12_100000_create_admin_password_resets_table',1),(3,'2014_10_12_100000_create_password_resets_table',1),(4,'2018_06_12_111907_create_admins_table',1),(5,'2018_06_13_055341_create_roles_table',1),(6,'2018_07_05_130148_create_attributes_table',1),(7,'2018_07_05_132854_create_attribute_translations_table',1),(8,'2018_07_05_135150_create_attribute_families_table',1),(9,'2018_07_05_135152_create_attribute_groups_table',1),(10,'2018_07_05_140832_create_attribute_options_table',1),(11,'2018_07_05_140856_create_attribute_option_translations_table',1),(12,'2018_07_05_142820_create_categories_table',1),(13,'2018_07_10_055143_create_locales_table',1),(14,'2018_07_20_054426_create_countries_table',1),(15,'2018_07_20_054502_create_currencies_table',1),(16,'2018_07_20_054542_create_currency_exchange_rates_table',1),(17,'2018_07_20_064849_create_channels_table',1),(18,'2018_07_21_142836_create_category_translations_table',1),(19,'2018_07_23_110040_create_inventory_sources_table',1),(20,'2018_07_24_082635_create_customer_groups_table',1),(21,'2018_07_24_082930_create_customers_table',1),(22,'2018_07_27_065727_create_products_table',1),(23,'2018_07_27_070011_create_product_attribute_values_table',1),(24,'2018_07_27_092623_create_product_reviews_table',1),(25,'2018_07_27_113941_create_product_images_table',1),(26,'2018_07_27_113956_create_product_inventories_table',1),(27,'2018_08_30_064755_create_tax_categories_table',1),(28,'2018_08_30_065042_create_tax_rates_table',1),(29,'2018_08_30_065840_create_tax_mappings_table',1),(30,'2018_09_05_150444_create_cart_table',1),(31,'2018_09_05_150915_create_cart_items_table',1),(32,'2018_09_11_064045_customer_password_resets',1),(33,'2018_09_19_093453_create_cart_payment',1),(34,'2018_09_19_093508_create_cart_shipping_rates_table',1),(35,'2018_09_20_060658_create_core_config_table',1),(36,'2018_09_27_113154_create_orders_table',1),(37,'2018_09_27_113207_create_order_items_table',1),(38,'2018_09_27_115022_create_shipments_table',1),(39,'2018_09_27_115029_create_shipment_items_table',1),(40,'2018_09_27_115135_create_invoices_table',1),(41,'2018_09_27_115144_create_invoice_items_table',1),(42,'2018_10_01_095504_create_order_payment_table',1),(43,'2018_10_03_025230_create_wishlist_table',1),(44,'2018_10_12_101803_create_country_translations_table',1),(45,'2018_10_12_101913_create_country_states_table',1),(46,'2018_10_12_101923_create_country_state_translations_table',1),(47,'2018_11_16_173504_create_subscribers_list_table',1),(48,'2018_11_21_144411_create_cart_item_inventories_table',1),(49,'2018_12_06_185202_create_product_flat_table',1),(50,'2018_12_24_123812_create_channel_inventory_sources_table',1),(51,'2018_12_26_165327_create_product_ordered_inventories_table',1),(52,'2019_05_13_024321_create_cart_rules_table',1),(53,'2019_05_13_024322_create_cart_rule_channels_table',1),(54,'2019_05_13_024323_create_cart_rule_customer_groups_table',1),(55,'2019_05_13_024324_create_cart_rule_translations_table',1),(56,'2019_05_13_024325_create_cart_rule_customers_table',1),(57,'2019_05_13_024326_create_cart_rule_coupons_table',1),(58,'2019_05_13_024327_create_cart_rule_coupon_usage_table',1),(59,'2019_06_17_180258_create_product_downloadable_samples_table',1),(60,'2019_06_17_180314_create_product_downloadable_sample_translations_table',1),(61,'2019_06_17_180325_create_product_downloadable_links_table',1),(62,'2019_06_17_180346_create_product_downloadable_link_translations_table',1),(63,'2019_06_21_202249_create_downloadable_link_purchased_table',1),(64,'2019_07_02_180307_create_booking_products_table',1),(65,'2019_07_05_154415_create_booking_product_default_slots_table',1),(66,'2019_07_05_154429_create_booking_product_appointment_slots_table',1),(67,'2019_07_05_154440_create_booking_product_event_tickets_table',1),(68,'2019_07_05_154451_create_booking_product_rental_slots_table',1),(69,'2019_07_05_154502_create_booking_product_table_slots_table',1),(70,'2019_07_30_153530_create_cms_pages_table',1),(71,'2019_07_31_143339_create_category_filterable_attributes_table',1),(72,'2019_08_02_105320_create_product_grouped_products_table',1),(73,'2019_08_20_170510_create_product_bundle_options_table',1),(74,'2019_08_20_170520_create_product_bundle_option_translations_table',1),(75,'2019_08_20_170528_create_product_bundle_option_products_table',1),(76,'2019_09_11_184511_create_refunds_table',1),(77,'2019_09_11_184519_create_refund_items_table',1),(78,'2019_12_03_184613_create_catalog_rules_table',1),(79,'2019_12_03_184651_create_catalog_rule_channels_table',1),(80,'2019_12_03_184732_create_catalog_rule_customer_groups_table',1),(81,'2019_12_06_101110_create_catalog_rule_products_table',1),(82,'2019_12_06_110507_create_catalog_rule_product_prices_table',1),(83,'2019_12_14_000001_create_personal_access_tokens_table',1),(84,'2020_01_14_191854_create_cms_page_translations_table',1),(85,'2020_01_15_130209_create_cms_page_channels_table',1),(86,'2020_02_18_165639_create_bookings_table',1),(87,'2020_02_21_121201_create_booking_product_event_ticket_translations_table',1),(88,'2020_04_16_185147_add_table_addresses',1),(89,'2020_05_06_171638_create_order_comments_table',1),(90,'2020_05_21_171500_create_product_customer_group_prices_table',1),(91,'2020_06_25_162154_create_customer_social_accounts_table',1),(92,'2020_08_07_174804_create_gdpr_data_request_table',1),(93,'2020_11_19_112228_create_product_videos_table',1),(94,'2020_11_26_141455_create_marketing_templates_table',1),(95,'2020_11_26_150534_create_marketing_events_table',1),(96,'2020_11_26_150644_create_marketing_campaigns_table',1),(97,'2020_12_21_000200_create_channel_translations_table',1),(98,'2020_12_27_121950_create_jobs_table',1),(99,'2021_03_11_212124_create_order_transactions_table',1),(100,'2021_04_07_132010_create_product_review_images_table',1),(101,'2021_12_15_104544_notifications',1),(102,'2022_03_15_160510_create_failed_jobs_table',1),(103,'2022_04_01_094622_create_sitemaps_table',1),(104,'2022_10_03_144232_create_product_price_indices_table',1),(105,'2022_10_04_144444_create_job_batches_table',1),(106,'2022_10_08_134150_create_product_inventory_indices_table',1),(107,'2023_05_26_213105_create_wishlist_items_table',1),(108,'2023_05_26_213120_create_compare_items_table',1),(109,'2023_06_27_163529_rename_product_review_images_to_product_review_attachments',1),(110,'2023_07_06_140013_add_logo_path_column_to_locales',1),(111,'2023_07_10_184256_create_theme_customizations_table',1),(112,'2023_07_12_181722_remove_home_page_and_footer_content_column_from_channel_translations_table',1),(113,'2023_07_20_185324_add_column_column_in_attribute_groups_table',1),(114,'2023_07_25_145943_add_regex_column_in_attributes_table',1),(115,'2023_07_25_165945_drop_notes_column_from_customers_table',1),(116,'2023_07_25_171058_create_customer_notes_table',1),(117,'2023_07_31_125232_rename_image_and_category_banner_columns_from_categories_table',1),(118,'2023_09_15_170053_create_theme_customization_translations_table',1),(119,'2023_09_20_102031_add_default_value_column_in_attributes_table',1),(120,'2023_09_20_102635_add_inventories_group_in_attribute_groups_table',1),(121,'2023_09_26_155709_add_columns_to_currencies',1),(122,'2023_10_12_090446_add_tax_category_id_column_in_order_items_table',1),(123,'2023_11_08_054614_add_code_column_in_attribute_groups_table',1),(124,'2023_11_08_140116_create_search_terms_table',1),(125,'2023_11_09_162805_create_url_rewrites_table',1),(126,'2023_11_17_150401_create_search_synonyms_table',1),(127,'2023_12_11_054614_add_channel_id_column_in_product_price_indices_table',1),(128,'2024_01_11_154640_create_imports_table',1),(129,'2024_01_11_154741_create_import_batches_table',1),(130,'2024_01_19_170350_add_unique_id_column_in_product_attribute_values_table',1),(131,'2024_01_19_170350_add_unique_id_column_in_product_customer_group_prices_table',1),(132,'2024_01_22_170814_add_unique_index_in_mapping_tables',1),(133,'2024_02_26_153000_add_columns_to_addresses_table',1),(134,'2024_03_07_193421_rename_address1_column_in_addresses_table',1),(135,'2024_04_16_144400_add_cart_id_column_in_cart_shipping_rates_table',1),(136,'2024_04_19_102939_add_incl_tax_columns_in_orders_table',1),(137,'2024_04_19_135405_add_incl_tax_columns_in_cart_items_table',1),(138,'2024_04_19_144641_add_incl_tax_columns_in_order_items_table',1),(139,'2024_04_23_133154_add_incl_tax_columns_in_cart_table',1),(140,'2024_04_23_150945_add_incl_tax_columns_in_cart_shipping_rates_table',1),(141,'2024_04_24_102939_add_incl_tax_columns_in_invoices_table',1),(142,'2024_04_24_102939_add_incl_tax_columns_in_refunds_table',1),(143,'2024_04_24_144641_add_incl_tax_columns_in_invoice_items_table',1),(144,'2024_04_24_144641_add_incl_tax_columns_in_refund_items_table',1),(145,'2024_04_24_144641_add_incl_tax_columns_in_shipment_items_table',1),(146,'2024_05_10_152848_create_saved_filters_table',1),(147,'2024_06_03_174128_create_product_channels_table',1),(148,'2024_06_04_130527_add_channel_id_column_in_customers_table',1),(149,'2024_06_04_130600_make_email_unique_per_channel',1),(150,'2024_06_13_184426_add_theme_column_into_theme_customizations_table',1),(151,'2024_07_17_172645_add_additional_column_to_sitemaps_table',1),(152,'2024_10_11_135010_create_product_customizable_options_table',1),(153,'2024_10_11_135110_create_product_customizable_option_translations_table',1),(154,'2024_10_11_135228_create_product_customizable_option_prices_table',1),(155,'2025_05_07_121250_update_total_weight_columns_in_shipments_and_weight_shipment_items_tables',1),(156,'2025_09_05_000100_add_indexes_to_channels_tables',1),(157,'2025_09_05_000200_add_indexes_to_product_relation_tables',1),(158,'2025_09_05_000300_add_indexes_to_product_media_and_attributes',1),(159,'2025_09_05_000400_add_indexes_to_attributes_and_product_types',1),(160,'2025_09_05_000500_add_indexes_to_product_grouped_products_and_product_bundle_option_products',1),(161,'2025_09_05_000500_add_indexes_to_url_rewrites_and_visits',1),(162,'2025_09_11_140301_add_two_factor_to_admins',1),(163,'2025_11_14_173810_create_rma_statuses_table',1),(164,'2025_11_14_173812_create_rma_table',1),(165,'2025_11_14_173906_create_rma_reasons_table',1),(166,'2025_11_14_173959_create_rma_items_table',1),(167,'2025_11_14_174030_create_rma_images_table',1),(168,'2025_11_14_174059_create_rma_messages_table',1),(169,'2025_11_14_174134_create_rma_reason_resolutions_table',1),(170,'2025_11_14_174205_create_rma_rules_table',1),(171,'2025_11_14_174355_create_rma_custom_fields_table',1),(172,'2025_11_14_174426_create_rma_custom_field_options_table',1),(173,'2025_11_14_174509_create_rma_additional_fields_table',1),(174,'2026_02_03_151924_create_sessions_table',1),(175,'2026_02_11_095547_add_rma_return_period_to_order_items_table',1),(176,'2026_03_11_113926_create_agent_conversations_table',1),(177,'2026_04_09_120000_change_tax_category_id_fk_on_cart_items_to_null_on_delete',1),(178,'2026_04_09_120100_change_tax_category_id_fk_on_order_items_to_null_on_delete',1),(179,'2026_04_17_000001_add_booking_product_enhancements',1),(180,'2026_04_17_000002_add_allow_cancellation_snapshot_to_bookings',1),(181,'2026_05_27_114230_create_eu_withdrawals_table',1),(182,'2026_06_24_000000_rename_received_package_rma_status',1),(183,'2026_06_24_000001_rename_neutral_rma_statuses',1),(184,'2026_07_03_170000_create_sitemap_channels_table',1),(185,'2026_07_27_000001_add_image_source_to_imports_table',1),(186,'2026_08_10_000001_add_derived_columns_in_product_flat_table',1),(187,'2026_08_13_000001_make_images_count_nullable_in_product_flat_table',1),(188,'2026_08_15_000001_create_product_image_translations_table',1),(189,'2026_08_15_000002_add_alt_text_columns_to_category_translations_table',1),(190,'2026_08_15_000003_add_logo_alt_column_to_channel_translations_table',1),(191,'2026_08_15_000004_add_swatch_alt_column_to_attribute_option_translations_table',1),(192,'2026_08_15_000005_rename_theme_customizations_to_theme_sections',1),(193,'2026_08_15_000006_move_theme_uploads_to_section_directory',1),(194,'2026_08_15_000007_add_draft_options_to_theme_section_translations_table',1),(195,'2026_08_15_000008_make_options_nullable_on_theme_section_translations_table',1),(196,'2026_08_19_000002_add_draft_columns_to_theme_sections_table',1),(197,'2026_08_26_000001_rename_linkedin_social_login_config_code',1),(198,'2026_09_04_000001_drop_duplicate_channel_pivot_indexes',1),(199,'2026_09_04_000002_drop_duplicate_attributes_code_index',1),(200,'2026_09_23_120000_add_two_factor_last_used_window_to_admins',1),(201,'2026_10_05_000001_make_copyright_content_channel_based',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `read` tinyint(1) NOT NULL DEFAULT 0,
  `order_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_order_id_foreign` (`order_id`),
  CONSTRAINT `notifications_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_comments`
--

DROP TABLE IF EXISTS `order_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned DEFAULT NULL,
  `comment` text NOT NULL,
  `customer_notified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_comments_order_id_foreign` (`order_id`),
  CONSTRAINT `order_comments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_comments`
--

LOCK TABLES `order_comments` WRITE;
/*!40000 ALTER TABLE `order_comments` DISABLE KEYS */;
INSERT INTO `order_comments` VALUES (1,2,'Dispatched via Delhivery Express. AWB: DEL-889922',1,'2026-11-06 10:49:05','2026-11-06 10:49:05');
/*!40000 ALTER TABLE `order_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `coupon_code` varchar(255) DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT 0.0000,
  `total_weight` decimal(12,4) DEFAULT 0.0000,
  `qty_ordered` int(11) DEFAULT 0,
  `qty_shipped` int(11) DEFAULT 0,
  `qty_invoiced` int(11) DEFAULT 0,
  `qty_canceled` int(11) DEFAULT 0,
  `qty_refunded` int(11) DEFAULT 0,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_invoiced` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_invoiced` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `amount_refunded` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_amount_refunded` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `tax_percent` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `product_id` int(10) unsigned DEFAULT NULL,
  `product_type` varchar(255) DEFAULT NULL,
  `order_id` int(10) unsigned DEFAULT NULL,
  `tax_category_id` int(10) unsigned DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `rma_return_period` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  KEY `order_items_parent_id_foreign` (`parent_id`),
  KEY `order_items_tax_category_id_foreign` (`tax_category_id`),
  CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,'magic-blend-250g','simple','Magic Blend (250g)',NULL,0.0000,0.0000,2,0,0,0,0,195.0000,195.0000,390.0000,390.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,195.0000,195.0000,390.0000,390.0000,NULL,NULL,1,NULL,NULL,NULL,NULL,'2026-11-02 10:35:12','2026-11-02 10:35:12'),(2,'garam-masala-100g','simple','Royal Garam Masala (100g)',NULL,0.0000,0.0000,1,0,0,0,0,200.0000,200.0000,200.0000,200.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,200.0000,200.0000,200.0000,200.0000,NULL,NULL,1,NULL,NULL,NULL,NULL,'2026-11-02 10:35:12','2026-11-02 10:35:12'),(3,'magic-blend-250g','simple','Magic Blend (250g)',NULL,0.0000,0.0000,2,0,0,0,0,195.0000,195.0000,390.0000,390.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,195.0000,195.0000,390.0000,390.0000,NULL,NULL,2,NULL,NULL,'{\"token\":\"mlhJ8YfBiMFbUjuDiL6DPvHMM67IabDs\"}',NULL,'2026-11-02 10:38:14','2026-11-02 10:38:14'),(4,'garam-masala-100g','simple','Royal Garam Masala (100g)',NULL,0.0000,0.0000,1,0,0,0,0,200.0000,200.0000,200.0000,200.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,200.0000,200.0000,200.0000,200.0000,NULL,NULL,2,NULL,NULL,'{\"token\":\"nfbm89Q4oXe9cB1ejYvnltgLttZ1hcer\"}',NULL,'2026-11-02 10:38:14','2026-11-02 10:38:14'),(5,'magic-blend-250g','simple','Magic Blend (250g)',NULL,0.0000,0.0000,2,0,0,0,0,195.0000,195.0000,390.0000,390.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,195.0000,195.0000,390.0000,390.0000,1,'Webkul\\Product\\Models\\Product',3,NULL,NULL,'{\"token\":\"NVnITwSEqvb1spxXpxrFJeyVzJobGqwh\"}',NULL,'2026-11-06 10:55:41','2026-11-06 10:55:41'),(6,'1','simple','Royal Garam Masala (100g)',NULL,0.0000,0.0000,1,0,0,0,0,210.0000,210.0000,210.0000,210.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,210.0000,210.0000,210.0000,210.0000,1,'Webkul\\Product\\Models\\Product',4,NULL,NULL,'{\"token\":\"ZOwGobKEQN4bd8SRIBsAKXcAjQlnVF2e\"}',NULL,'2026-11-13 06:43:46','2026-11-13 06:43:46'),(7,'2','simple','Red Chilli Powder (250g)',NULL,0.0000,0.0000,1,0,0,0,0,185.0000,185.0000,185.0000,185.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,185.0000,185.0000,185.0000,185.0000,2,'Webkul\\Product\\Models\\Product',4,NULL,NULL,'{\"token\":\"BBjOdLylFaPkH0kEpxHtfxNnQFkuVGDv\"}',NULL,'2026-11-13 06:43:46','2026-11-13 06:43:46'),(8,'magic-blend-250g','simple','Magic Blend (250g)',NULL,0.0000,0.0000,2,0,0,0,0,195.0000,195.0000,390.0000,390.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,195.0000,195.0000,390.0000,390.0000,1,'Webkul\\Product\\Models\\Product',5,NULL,NULL,'{\"token\":\"mD5K9WPs8uomBzbxiSTkbXKMhEs6IN9W\"}',NULL,'2026-11-13 06:49:09','2026-11-13 06:49:09'),(9,'red-chilli-250g','simple','Premium Red Chilli Powder (250g)',NULL,0.0000,0.0000,2,0,0,0,0,185.0000,185.0000,370.0000,370.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,185.0000,185.0000,370.0000,370.0000,2,'Webkul\\Product\\Models\\Product',5,NULL,NULL,'{\"token\":\"ASk5iwDDWCg9S11lY6OLj12LVEQVLpsK\"}',NULL,'2026-11-13 06:49:09','2026-11-13 06:49:09'),(10,'garam-masala-100g','simple','Premium Garam Masala (100g)',NULL,0.0000,0.0000,1,0,0,0,0,210.0000,210.0000,210.0000,210.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,210.0000,210.0000,210.0000,210.0000,3,'Webkul\\Product\\Models\\Product',5,NULL,NULL,'{\"token\":\"WivFk3eQC0jbt7X2gnjiBZnR5tTxYXLu\"}',NULL,'2026-11-13 06:49:09','2026-11-13 06:49:09'),(11,'magic-blend-250g','simple','Magic Blend (250g)',NULL,0.0000,0.0000,2,0,0,0,0,195.0000,195.0000,390.0000,390.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,195.0000,195.0000,390.0000,390.0000,1,'Webkul\\Product\\Models\\Product',6,NULL,NULL,'{\"token\":\"htxken3wj9fg6PsuOikWtEAN3P4oxlWv\"}',NULL,'2026-11-13 08:02:06','2026-11-13 08:02:06'),(12,'red-chilli-250g','simple','Premium Red Chilli Powder (250g)',NULL,0.0000,0.0000,1,0,0,0,0,185.0000,185.0000,185.0000,185.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,185.0000,185.0000,185.0000,185.0000,2,'Webkul\\Product\\Models\\Product',6,NULL,NULL,'{\"token\":\"ftBKyJYCg7Qh16fALqWpiXnrTlyE1K28\"}',NULL,'2026-11-13 08:02:06','2026-11-13 08:02:06'),(13,'garam-masala-100g','simple','Premium Garam Masala (100g)',NULL,0.0000,0.0000,1,0,0,0,0,210.0000,210.0000,210.0000,210.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,210.0000,210.0000,210.0000,210.0000,3,'Webkul\\Product\\Models\\Product',6,NULL,NULL,'{\"token\":\"YCXa6OsH3QgXYXGvB1ktnndFOJeRmBbr\"}',NULL,'2026-11-13 08:02:06','2026-11-13 08:02:06');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_payment`
--

DROP TABLE IF EXISTS `order_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_payment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned DEFAULT NULL,
  `method` varchar(255) NOT NULL,
  `method_title` varchar(255) DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_payment_order_id_foreign` (`order_id`),
  CONSTRAINT `order_payment_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_payment`
--

LOCK TABLES `order_payment` WRITE;
/*!40000 ALTER TABLE `order_payment` DISABLE KEYS */;
INSERT INTO `order_payment` VALUES (1,1,'cashondelivery','Cash on Delivery (COD)',NULL,'2026-11-02 10:35:12','2026-11-02 10:35:12'),(2,2,'cashondelivery','Cash on Delivery (COD)',NULL,'2026-11-02 10:38:14','2026-11-02 10:38:14'),(3,3,'phonepe','UPI Instant Payment (PhonePe/GPay)',NULL,'2026-11-06 10:55:41','2026-11-06 10:55:41'),(4,4,'cashondelivery','⚡ Free Test Order (No Payment)',NULL,'2026-11-13 06:43:46','2026-11-13 06:43:46'),(5,5,'cashondelivery','⚡ Free Test Order (No Payment)',NULL,'2026-11-13 06:49:09','2026-11-13 06:49:09'),(6,6,'cashondelivery','⚡ Free Test Order (No Payment)',NULL,'2026-11-13 08:02:06','2026-11-13 08:02:06');
/*!40000 ALTER TABLE `order_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_transactions`
--

DROP TABLE IF EXISTS `order_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_transactions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(255) NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `amount` decimal(12,4) DEFAULT 0.0000,
  `payment_method` varchar(255) DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `invoice_id` int(10) unsigned NOT NULL,
  `order_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_transactions_order_id_foreign` (`order_id`),
  CONSTRAINT `order_transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_transactions`
--

LOCK TABLES `order_transactions` WRITE;
/*!40000 ALTER TABLE `order_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `increment_id` varchar(255) NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  `channel_name` varchar(255) DEFAULT NULL,
  `is_guest` tinyint(1) DEFAULT NULL,
  `customer_email` varchar(255) DEFAULT NULL,
  `customer_first_name` varchar(255) DEFAULT NULL,
  `customer_last_name` varchar(255) DEFAULT NULL,
  `shipping_method` varchar(255) DEFAULT NULL,
  `shipping_title` varchar(255) DEFAULT NULL,
  `shipping_description` varchar(255) DEFAULT NULL,
  `coupon_code` varchar(255) DEFAULT NULL,
  `is_gift` tinyint(1) NOT NULL DEFAULT 0,
  `total_item_count` int(11) DEFAULT NULL,
  `total_qty_ordered` int(11) DEFAULT NULL,
  `base_currency_code` varchar(255) DEFAULT NULL,
  `channel_currency_code` varchar(255) DEFAULT NULL,
  `order_currency_code` varchar(255) DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `grand_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `grand_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `sub_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `sub_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `shipping_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_invoiced` decimal(12,4) DEFAULT 0.0000,
  `shipping_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_refunded` decimal(12,4) DEFAULT 0.0000,
  `shipping_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `shipping_tax_refunded` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_shipping_tax_refunded` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `customer_id` int(10) unsigned DEFAULT NULL,
  `customer_type` varchar(255) DEFAULT NULL,
  `channel_id` int(10) unsigned DEFAULT NULL,
  `channel_type` varchar(255) DEFAULT NULL,
  `cart_id` int(11) DEFAULT NULL,
  `applied_cart_rule_ids` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `orders_increment_id_unique` (`increment_id`),
  KEY `orders_customer_id_foreign` (`customer_id`),
  KEY `orders_channel_id_foreign` (`channel_id`),
  CONSTRAINT `orders_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  CONSTRAINT `orders_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'SYD-9WQ-1886','processing','SYD Spices Official Store',0,'aarav@sydspices.com','Aarav','Patel','flatrate_flatrate','Gujarat Hub Fresh Delivery','Direct from Spice Park Mandi Logistics Hub',NULL,0,2,3,'INR','INR','INR',590.0000,590.0000,0.0000,0.0000,0.0000,0.0000,590.0000,590.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,3,'Webkul\\Customer\\Models\\Customer',1,'Webkul\\Core\\Models\\Channel',NULL,NULL,'2026-11-02 10:35:12','2026-11-02 10:35:12'),(2,'SYD-9R1-1812','dispatched','SYD Spices Official Store',0,'aarav@sydspices.com','Aarav','Patel','flatrate_flatrate','Gujarat Hub Fresh Delivery','Direct from Spice Park Mandi Logistics Hub',NULL,0,2,3,'INR','INR','INR',590.0000,590.0000,0.0000,0.0000,0.0000,0.0000,590.0000,590.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,3,'Webkul\\Customer\\Models\\Customer',1,'Webkul\\Core\\Models\\Channel',NULL,NULL,'2026-11-02 10:38:14','2026-11-06 10:49:05'),(3,'SYD-9G9-1996','processing','SYD Spices Official Store',0,'vikram@example.com','Vikram','Singhania','flatrate_flatrate','Gujarat Hub Fresh Delivery','Direct from Spice Park Mandi Logistics Hub',NULL,0,1,2,'INR','INR','INR',390.0000,390.0000,0.0000,0.0000,0.0000,0.0000,390.0000,390.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,4,'Webkul\\Customer\\Models\\Customer',1,'Webkul\\Core\\Models\\Channel',NULL,NULL,'2026-11-06 10:55:41','2026-11-06 10:55:41'),(4,'SYD-JR3-9660','processing','SYD Spices Official Store',0,'test.order@sydspices.com','Vivek','Test','flatrate_flatrate','Gujarat Hub Fresh Delivery','Direct from Spice Park Mandi Logistics Hub',NULL,0,2,2,'INR','INR','INR',395.0000,395.0000,0.0000,0.0000,0.0000,0.0000,395.0000,395.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,3,'Webkul\\Customer\\Models\\Customer',1,'Webkul\\Core\\Models\\Channel',NULL,NULL,'2026-11-13 06:43:46','2026-11-13 06:43:46'),(5,'SYD-M6O-1664','processing','SYD Spices Official Store',0,'test.buyer@sydspices.com','Test','Customer (Vivek)','flatrate_flatrate','Gujarat Hub Fresh Delivery','Direct from Spice Park Mandi Logistics Hub',NULL,0,3,5,'INR','INR','INR',970.0000,970.0000,0.0000,0.0000,0.0000,0.0000,970.0000,970.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,3,'Webkul\\Customer\\Models\\Customer',1,'Webkul\\Core\\Models\\Channel',NULL,NULL,'2026-11-13 06:49:09','2026-11-13 06:49:09'),(6,'SYD-NHD-1504','processing','SYD Spices Official Store',0,'superadmin@amezproducts.com','Raxesh','patel','flatrate_flatrate','Gujarat Hub Fresh Delivery','Direct from Spice Park Mandi Logistics Hub',NULL,0,3,4,'INR','INR','INR',785.0000,785.0000,0.0000,0.0000,0.0000,0.0000,785.0000,785.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,10,'Webkul\\Customer\\Models\\Customer',1,'Webkul\\Core\\Models\\Channel',NULL,NULL,'2026-11-13 08:02:06','2026-11-13 08:02:06');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_attribute_values`
--

DROP TABLE IF EXISTS `product_attribute_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_attribute_values` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `locale` varchar(255) DEFAULT NULL,
  `channel` varchar(255) DEFAULT NULL,
  `text_value` text DEFAULT NULL,
  `boolean_value` tinyint(1) DEFAULT NULL,
  `integer_value` int(11) DEFAULT NULL,
  `float_value` decimal(12,4) DEFAULT NULL,
  `datetime_value` datetime DEFAULT NULL,
  `date_value` date DEFAULT NULL,
  `json_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`json_value`)),
  `product_id` int(10) unsigned NOT NULL,
  `attribute_id` int(10) unsigned NOT NULL,
  `unique_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `chanel_locale_attribute_value_index_unique` (`channel`,`locale`,`attribute_id`,`product_id`),
  UNIQUE KEY `product_attribute_values_unique_id_unique` (`unique_id`),
  KEY `product_attribute_values_attribute_id_foreign` (`attribute_id`),
  KEY `prod_attr_product_id_idx` (`product_id`),
  CONSTRAINT `product_attribute_values_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_attribute_values_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_attribute_values`
--

LOCK TABLES `product_attribute_values` WRITE;
/*!40000 ALTER TABLE `product_attribute_values` DISABLE KEYS */;
INSERT INTO `product_attribute_values` VALUES (1,NULL,NULL,'magic-blend-250g',NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),(2,'en',NULL,'Magic Blend',NULL,NULL,NULL,NULL,NULL,NULL,1,2,NULL),(3,'en',NULL,'magic-blend',NULL,NULL,NULL,NULL,NULL,NULL,1,3,NULL),(4,'en',NULL,'Master Secret Blend',NULL,NULL,NULL,NULL,NULL,NULL,1,9,NULL),(5,'en',NULL,'Our signature 16-spice balanced aromatic blend, master-crafted in small batches to elevate everyday curries, dals, gravies, and paneer dishes with fragrant, warm sweetness.',NULL,NULL,NULL,NULL,NULL,NULL,1,10,NULL),(6,NULL,NULL,NULL,NULL,NULL,195.0000,NULL,NULL,NULL,1,11,NULL),(7,NULL,NULL,'250g',NULL,NULL,NULL,NULL,NULL,NULL,1,22,NULL),(8,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,1,8,NULL),(9,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,1,7,NULL),(10,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,1,5,NULL),(11,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,1,6,NULL),(12,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,1,28,NULL),(13,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,1,26,NULL),(14,NULL,NULL,'red-chilli-250g',NULL,NULL,NULL,NULL,NULL,NULL,2,1,NULL),(15,'en',NULL,'Red Chilli Powder',NULL,NULL,NULL,NULL,NULL,NULL,2,2,NULL),(16,'en',NULL,'red-chilli',NULL,NULL,NULL,NULL,NULL,NULL,2,3,NULL),(17,'en',NULL,'Handpicked stemless sun-dried Guntur and Byadgi chillies, cold-pulverized below 40°C.',NULL,NULL,NULL,NULL,NULL,NULL,2,9,NULL),(18,'en',NULL,'Handpicked stemless sun-dried Guntur and Byadgi chillies, cold-pulverized below 40°C. Delivers rich, vibrant vermilion red color and warm, layered piquancy without harsh synthetic additives.',NULL,NULL,NULL,NULL,NULL,NULL,2,10,NULL),(19,NULL,NULL,NULL,NULL,NULL,185.0000,NULL,NULL,NULL,2,11,NULL),(20,NULL,NULL,'0.25',NULL,NULL,NULL,NULL,NULL,NULL,2,22,NULL),(21,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,2,8,NULL),(22,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,2,7,NULL),(23,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,2,5,NULL),(24,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,2,6,NULL),(25,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,2,28,NULL),(26,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,2,26,NULL),(27,NULL,NULL,'garam-masala-100g',NULL,NULL,NULL,NULL,NULL,NULL,3,1,NULL),(28,'en',NULL,'Royal Garam Masala',NULL,NULL,NULL,NULL,NULL,NULL,3,2,NULL),(29,'en',NULL,'garam-masala',NULL,NULL,NULL,NULL,NULL,NULL,3,3,NULL),(30,'en',NULL,'Royal court formulation featuring high-grade Idukki green cardamom, bold Tellicherry peppercorns, cloves, mace, and royal cinnamon.',NULL,NULL,NULL,NULL,NULL,NULL,3,9,NULL),(31,'en',NULL,'Royal court formulation featuring high-grade Idukki green cardamom, bold Tellicherry peppercorns, cloves, mace, and royal cinnamon. Roasted in cast iron and coarse-ground for deep fragrance.',NULL,NULL,NULL,NULL,NULL,NULL,3,10,NULL),(32,NULL,NULL,NULL,NULL,NULL,210.0000,NULL,NULL,NULL,3,11,NULL),(33,NULL,NULL,'0.1',NULL,NULL,NULL,NULL,NULL,NULL,3,22,NULL),(34,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,3,8,NULL),(35,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,3,7,NULL),(36,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,3,5,NULL),(37,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,3,6,NULL),(38,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,3,28,NULL),(39,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,3,26,NULL),(40,NULL,NULL,'cumin-seeds-250g',NULL,NULL,NULL,NULL,NULL,NULL,4,1,NULL),(41,'en',NULL,'India Cumin Seeds',NULL,NULL,NULL,NULL,NULL,NULL,4,2,NULL),(42,'en',NULL,'cumin-seeds',NULL,NULL,NULL,NULL,NULL,NULL,4,3,NULL),(43,'en',NULL,'Hand-selected from India APMC mandi lots. Bold, elongated seeds with high 3.8% thymol essential oil concentration.',NULL,NULL,NULL,NULL,NULL,NULL,4,9,NULL),(44,'en',NULL,'Hand-selected from India APMC mandi lots. Bold, elongated seeds with high 3.8% thymol essential oil concentration. Crackles with crisp earthy sweetness.',NULL,NULL,NULL,NULL,NULL,NULL,4,10,NULL),(45,NULL,NULL,NULL,NULL,NULL,160.0000,NULL,NULL,NULL,4,11,NULL),(46,NULL,NULL,'0.25',NULL,NULL,NULL,NULL,NULL,NULL,4,22,NULL),(47,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,4,8,NULL),(48,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,4,7,NULL),(49,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,4,5,NULL),(50,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,4,6,NULL),(51,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,4,28,NULL),(52,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,4,26,NULL),(53,NULL,NULL,'fennel-seeds-250g',NULL,NULL,NULL,NULL,NULL,NULL,5,1,NULL),(54,'en',NULL,'Royal Fennel Seeds',NULL,NULL,NULL,NULL,NULL,NULL,5,2,NULL),(55,'en',NULL,'fennel-seeds',NULL,NULL,NULL,NULL,NULL,NULL,5,3,NULL),(56,'en',NULL,'Natural sun-dried green fennel from Gujarat\'s Saurashtra belt. Unpolished, chemical-free plump seeds.',NULL,NULL,NULL,NULL,NULL,NULL,5,9,NULL),(57,'en',NULL,'Natural sun-dried green fennel from Gujarat\'s Saurashtra belt. Unpolished, chemical-free plump seeds offering refreshing sweet anethole flavor.',NULL,NULL,NULL,NULL,NULL,NULL,5,10,NULL),(58,NULL,NULL,NULL,NULL,NULL,150.0000,NULL,NULL,NULL,5,11,NULL),(59,NULL,NULL,'0.25',NULL,NULL,NULL,NULL,NULL,NULL,5,22,NULL),(60,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,5,8,NULL),(61,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,5,7,NULL),(62,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,5,5,NULL),(63,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,5,6,NULL),(64,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,5,28,NULL),(65,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,5,26,NULL),(66,NULL,NULL,'turmeric-powder-250g',NULL,NULL,NULL,NULL,NULL,NULL,6,1,NULL),(67,'en',NULL,'Golden Turmeric Powder',NULL,NULL,NULL,NULL,NULL,NULL,6,2,NULL),(68,'en',NULL,'turmeric-powder',NULL,NULL,NULL,NULL,NULL,NULL,6,3,NULL),(69,'en',NULL,'Potent Salem finger rhizomes with 4.5%+ active curcumin content. Gently dehydrated and pulverized without heat degradation.',NULL,NULL,NULL,NULL,NULL,NULL,6,9,NULL),(70,'en',NULL,'Potent Salem finger rhizomes with 4.5%+ active curcumin content. Gently dehydrated and pulverized without heat degradation to retain its healing potency.',NULL,NULL,NULL,NULL,NULL,NULL,6,10,NULL),(71,NULL,NULL,NULL,NULL,NULL,140.0000,NULL,NULL,NULL,6,11,NULL),(72,NULL,NULL,'0.25',NULL,NULL,NULL,NULL,NULL,NULL,6,22,NULL),(73,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,6,8,NULL),(74,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,6,7,NULL),(75,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,6,5,NULL),(76,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,6,6,NULL),(77,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,6,28,NULL),(78,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,6,26,NULL),(79,NULL,NULL,'coriander-powder-250g',NULL,NULL,NULL,NULL,NULL,NULL,7,1,NULL),(80,'en',NULL,'Coriander Powder',NULL,NULL,NULL,NULL,NULL,NULL,7,2,NULL),(81,'en',NULL,'coriander-powder',NULL,NULL,NULL,NULL,NULL,NULL,7,3,NULL),(82,'en',NULL,'Eagle-grade coriander seeds cold-milled to preserve fragile linalool citrus notes.',NULL,NULL,NULL,NULL,NULL,NULL,7,9,NULL),(83,'en',NULL,'Eagle-grade coriander seeds cold-milled to preserve fragile linalool citrus notes. Imparts cooling fragrant body and thick richness to home-cooked gravies.',NULL,NULL,NULL,NULL,NULL,NULL,7,10,NULL),(84,NULL,NULL,NULL,NULL,NULL,130.0000,NULL,NULL,NULL,7,11,NULL),(85,NULL,NULL,'0.25',NULL,NULL,NULL,NULL,NULL,NULL,7,22,NULL),(86,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,7,8,NULL),(87,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,7,7,NULL),(88,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,7,5,NULL),(89,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,7,6,NULL),(90,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,7,28,NULL),(91,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,7,26,NULL),(92,NULL,NULL,'heritage-gift-box-1kg',NULL,NULL,NULL,NULL,NULL,NULL,8,1,NULL),(93,'en',NULL,'Heritage Grand Gift Box',NULL,NULL,NULL,NULL,NULL,NULL,8,2,NULL),(94,'en',NULL,'heritage-gift-box',NULL,NULL,NULL,NULL,NULL,NULL,8,3,NULL),(95,'en',NULL,'Collector\'s presentation wooden box with 5 luxury airtight glass jars.',NULL,NULL,NULL,NULL,NULL,NULL,8,9,NULL),(96,'en',NULL,'Collector\'s presentation wooden box with 5 luxury airtight glass jars: Magic Blend, Garam Masala, India Jeera, Salem Turmeric, and Red Chilli, plus an authentic brass measuring spoon.',NULL,NULL,NULL,NULL,NULL,NULL,8,10,NULL),(97,NULL,NULL,NULL,NULL,NULL,1199.0000,NULL,NULL,NULL,8,11,NULL),(98,NULL,NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,8,22,NULL),(99,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,8,8,NULL),(100,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,8,7,NULL),(101,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,8,5,NULL),(102,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,8,6,NULL),(103,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,8,28,NULL),(104,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,8,26,NULL),(105,NULL,NULL,'malabar-black-pepper-100g',NULL,NULL,NULL,NULL,NULL,NULL,10,1,NULL),(106,'en',NULL,'Malabar Black Pepper',NULL,NULL,NULL,NULL,NULL,NULL,10,2,NULL),(107,'en',NULL,'malabar-black-pepper',NULL,NULL,NULL,NULL,NULL,NULL,10,3,NULL),(108,'en',NULL,'Bold Whole Peppercorns',NULL,NULL,NULL,NULL,NULL,NULL,10,9,NULL),(109,'en',NULL,'Sun-dried bold Tellicherry and Malabar black peppercorns rich in natural piperine oils.',NULL,NULL,NULL,NULL,NULL,NULL,10,10,NULL),(110,NULL,NULL,NULL,NULL,NULL,220.0000,NULL,NULL,NULL,10,11,NULL),(111,NULL,NULL,'100g',NULL,NULL,NULL,NULL,NULL,NULL,10,22,NULL),(112,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,10,8,NULL),(113,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,10,7,NULL),(114,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,10,5,NULL),(115,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,10,6,NULL),(116,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,10,28,NULL),(117,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,10,26,NULL),(131,NULL,NULL,'royal-shahi-biryani-masala-856',NULL,NULL,NULL,NULL,NULL,NULL,14,1,NULL),(132,'en',NULL,'Royal Shahi Biryani Masala',NULL,NULL,NULL,NULL,NULL,NULL,14,2,NULL),(133,'en',NULL,'royal-shahi-biryani-masala',NULL,NULL,NULL,NULL,NULL,NULL,14,3,NULL),(134,'en',NULL,'Aromatic Mughal blend with saffron, mace and green cardamom.',NULL,NULL,NULL,NULL,NULL,NULL,14,9,NULL),(135,'en',NULL,'Authentic Nizami & Awadhi shahi biryani spice blend hand-roasted in small batches.',NULL,NULL,NULL,NULL,NULL,NULL,14,10,NULL),(136,NULL,NULL,NULL,NULL,NULL,230.0000,NULL,NULL,NULL,14,11,NULL),(137,NULL,NULL,'200g',NULL,NULL,NULL,NULL,NULL,NULL,14,22,NULL),(138,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,14,8,NULL),(139,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,14,7,NULL),(140,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,14,5,NULL),(141,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,14,6,NULL),(142,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,14,28,NULL),(143,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,14,26,NULL),(158,NULL,NULL,'dhruv-parekh-100',NULL,NULL,NULL,NULL,NULL,NULL,16,1,NULL),(159,'en',NULL,'dhruv parekh signature masala',NULL,NULL,NULL,NULL,NULL,NULL,16,2,NULL),(160,'en',NULL,'dhruv-parekh',NULL,NULL,NULL,NULL,NULL,NULL,16,3,NULL),(161,'en',NULL,'vivek patel',NULL,NULL,NULL,NULL,NULL,NULL,16,9,NULL),(162,'en',NULL,'A royal blend made with carefully selected whole spices and cold ground.',NULL,NULL,NULL,NULL,NULL,NULL,16,10,NULL),(163,NULL,NULL,NULL,NULL,NULL,220.0000,NULL,NULL,NULL,16,11,NULL),(164,NULL,NULL,'250g',NULL,NULL,NULL,NULL,NULL,NULL,16,22,NULL),(165,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,16,8,NULL),(166,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,16,7,NULL),(167,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,16,5,NULL),(168,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,16,6,NULL),(169,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,16,28,NULL),(170,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,16,26,NULL),(171,'en',NULL,'[{\"weight\":\"100g\",\"price\":110,\"strike\":138,\"active\":false},{\"weight\":\"250g\",\"price\":220,\"strike\":275,\"active\":true},{\"weight\":\"500g\",\"price\":410,\"strike\":513,\"active\":false}]',NULL,NULL,NULL,NULL,NULL,NULL,16,18,NULL),(172,'en',NULL,'[{\"weight\":\"100g\",\"price\":95,\"strike\":119,\"active\":false},{\"weight\":\"250g\",\"price\":195,\"strike\":244,\"active\":true},{\"weight\":\"500g\",\"price\":360,\"strike\":450,\"active\":false}]',NULL,NULL,NULL,NULL,NULL,NULL,1,18,NULL);
/*!40000 ALTER TABLE `product_attribute_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_bundle_option_products`
--

DROP TABLE IF EXISTS `product_bundle_option_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_bundle_option_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `product_bundle_option_id` int(10) unsigned NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bundle_option_products_product_id_bundle_option_id_unique` (`product_id`,`product_bundle_option_id`),
  KEY `pbop_option_id_idx` (`product_bundle_option_id`),
  CONSTRAINT `product_bundle_option_id_foreign` FOREIGN KEY (`product_bundle_option_id`) REFERENCES `product_bundle_options` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_bundle_option_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_bundle_option_products`
--

LOCK TABLES `product_bundle_option_products` WRITE;
/*!40000 ALTER TABLE `product_bundle_option_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_bundle_option_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_bundle_option_translations`
--

DROP TABLE IF EXISTS `product_bundle_option_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_bundle_option_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `locale` varchar(255) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `product_bundle_option_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_bundle_option_translations_option_id_locale_unique` (`product_bundle_option_id`,`locale`),
  UNIQUE KEY `bundle_option_translations_locale_label_bundle_option_id_unique` (`locale`,`label`,`product_bundle_option_id`),
  CONSTRAINT `product_bundle_option_translations_option_id_foreign` FOREIGN KEY (`product_bundle_option_id`) REFERENCES `product_bundle_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_bundle_option_translations`
--

LOCK TABLES `product_bundle_option_translations` WRITE;
/*!40000 ALTER TABLE `product_bundle_option_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_bundle_option_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_bundle_options`
--

DROP TABLE IF EXISTS `product_bundle_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_bundle_options` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `type` varchar(255) NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `product_bundle_options_product_id_foreign` (`product_id`),
  CONSTRAINT `product_bundle_options_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_bundle_options`
--

LOCK TABLES `product_bundle_options` WRITE;
/*!40000 ALTER TABLE `product_bundle_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_bundle_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_categories`
--

DROP TABLE IF EXISTS `product_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_categories` (
  `product_id` int(10) unsigned NOT NULL,
  `category_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `product_categories_product_id_category_id_unique` (`product_id`,`category_id`),
  KEY `product_categories_category_id_foreign` (`category_id`),
  CONSTRAINT `product_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_categories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_categories`
--

LOCK TABLES `product_categories` WRITE;
/*!40000 ALTER TABLE `product_categories` DISABLE KEYS */;
INSERT INTO `product_categories` VALUES (1,3),(2,4),(3,3),(4,2),(5,2),(6,4),(7,4),(8,3),(10,2),(14,3),(16,3);
/*!40000 ALTER TABLE `product_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_channels`
--

DROP TABLE IF EXISTS `product_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_channels` (
  `product_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `product_channels_product_id_channel_id_unique` (`product_id`,`channel_id`),
  KEY `product_channels_channel_id_foreign` (`channel_id`),
  KEY `pc_product_id_channel_id_idx` (`product_id`,`channel_id`),
  CONSTRAINT `product_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_channels_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_channels`
--

LOCK TABLES `product_channels` WRITE;
/*!40000 ALTER TABLE `product_channels` DISABLE KEYS */;
INSERT INTO `product_channels` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(10,1),(14,1),(16,1);
/*!40000 ALTER TABLE `product_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_cross_sells`
--

DROP TABLE IF EXISTS `product_cross_sells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_cross_sells` (
  `parent_id` int(10) unsigned NOT NULL,
  `child_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `product_cross_sells_parent_id_child_id_unique` (`parent_id`,`child_id`),
  KEY `product_cross_sells_child_id_foreign` (`child_id`),
  CONSTRAINT `product_cross_sells_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_cross_sells_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_cross_sells`
--

LOCK TABLES `product_cross_sells` WRITE;
/*!40000 ALTER TABLE `product_cross_sells` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_cross_sells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_customer_group_prices`
--

DROP TABLE IF EXISTS `product_customer_group_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_customer_group_prices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `qty` int(11) NOT NULL DEFAULT 0,
  `value_type` varchar(255) NOT NULL,
  `value` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `product_id` int(10) unsigned NOT NULL,
  `customer_group_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `unique_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_customer_group_prices_unique_id_unique` (`unique_id`),
  KEY `product_customer_group_prices_product_id_foreign` (`product_id`),
  KEY `product_customer_group_prices_customer_group_id_foreign` (`customer_group_id`),
  CONSTRAINT `product_customer_group_prices_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_customer_group_prices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_customer_group_prices`
--

LOCK TABLES `product_customer_group_prices` WRITE;
/*!40000 ALTER TABLE `product_customer_group_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_customer_group_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_customizable_option_prices`
--

DROP TABLE IF EXISTS `product_customizable_option_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_customizable_option_prices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `label` text DEFAULT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `product_customizable_option_id` int(10) unsigned NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `pcop_product_customizable_option_id_foreign` (`product_customizable_option_id`),
  CONSTRAINT `pcop_product_customizable_option_id_foreign` FOREIGN KEY (`product_customizable_option_id`) REFERENCES `product_customizable_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_customizable_option_prices`
--

LOCK TABLES `product_customizable_option_prices` WRITE;
/*!40000 ALTER TABLE `product_customizable_option_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_customizable_option_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_customizable_option_translations`
--

DROP TABLE IF EXISTS `product_customizable_option_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_customizable_option_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `locale` varchar(255) NOT NULL,
  `label` text DEFAULT NULL,
  `product_customizable_option_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_customizable_option_id_locale_unique` (`product_customizable_option_id`,`locale`),
  CONSTRAINT `pcot_product_customizable_option_id_foreign` FOREIGN KEY (`product_customizable_option_id`) REFERENCES `product_customizable_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_customizable_option_translations`
--

LOCK TABLES `product_customizable_option_translations` WRITE;
/*!40000 ALTER TABLE `product_customizable_option_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_customizable_option_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_customizable_options`
--

DROP TABLE IF EXISTS `product_customizable_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_customizable_options` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `type` varchar(255) NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `max_characters` text DEFAULT NULL,
  `supported_file_extensions` text DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `product_customizable_options_product_id_foreign` (`product_id`),
  CONSTRAINT `product_customizable_options_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_customizable_options`
--

LOCK TABLES `product_customizable_options` WRITE;
/*!40000 ALTER TABLE `product_customizable_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_customizable_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_downloadable_link_translations`
--

DROP TABLE IF EXISTS `product_downloadable_link_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_downloadable_link_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_downloadable_link_id` int(10) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `title` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `link_translations_link_id_foreign` (`product_downloadable_link_id`),
  CONSTRAINT `link_translations_link_id_foreign` FOREIGN KEY (`product_downloadable_link_id`) REFERENCES `product_downloadable_links` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_downloadable_link_translations`
--

LOCK TABLES `product_downloadable_link_translations` WRITE;
/*!40000 ALTER TABLE `product_downloadable_link_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_downloadable_link_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_downloadable_links`
--

DROP TABLE IF EXISTS `product_downloadable_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_downloadable_links` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sample_url` varchar(255) DEFAULT NULL,
  `sample_file` varchar(255) DEFAULT NULL,
  `sample_file_name` varchar(255) DEFAULT NULL,
  `sample_type` varchar(255) DEFAULT NULL,
  `downloads` int(11) NOT NULL DEFAULT 0,
  `sort_order` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_downloadable_links_product_id_foreign` (`product_id`),
  CONSTRAINT `product_downloadable_links_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_downloadable_links`
--

LOCK TABLES `product_downloadable_links` WRITE;
/*!40000 ALTER TABLE `product_downloadable_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_downloadable_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_downloadable_sample_translations`
--

DROP TABLE IF EXISTS `product_downloadable_sample_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_downloadable_sample_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_downloadable_sample_id` int(10) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `title` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sample_translations_sample_id_foreign` (`product_downloadable_sample_id`),
  CONSTRAINT `sample_translations_sample_id_foreign` FOREIGN KEY (`product_downloadable_sample_id`) REFERENCES `product_downloadable_samples` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_downloadable_sample_translations`
--

LOCK TABLES `product_downloadable_sample_translations` WRITE;
/*!40000 ALTER TABLE `product_downloadable_sample_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_downloadable_sample_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_downloadable_samples`
--

DROP TABLE IF EXISTS `product_downloadable_samples`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_downloadable_samples` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_downloadable_samples_product_id_foreign` (`product_id`),
  CONSTRAINT `product_downloadable_samples_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_downloadable_samples`
--

LOCK TABLES `product_downloadable_samples` WRITE;
/*!40000 ALTER TABLE `product_downloadable_samples` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_downloadable_samples` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_flat`
--

DROP TABLE IF EXISTS `product_flat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_flat` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `product_number` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `short_description` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `url_key` varchar(255) DEFAULT NULL,
  `new` tinyint(1) DEFAULT NULL,
  `featured` tinyint(1) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `meta_title` text DEFAULT NULL,
  `meta_keywords` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `price` decimal(12,4) DEFAULT NULL,
  `special_price` decimal(12,4) DEFAULT NULL,
  `special_price_from` date DEFAULT NULL,
  `special_price_to` date DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `images_count` int(11) DEFAULT 0,
  `manage_stock` tinyint(1) DEFAULT NULL,
  `base_image` varchar(255) DEFAULT NULL,
  `category_name` text DEFAULT NULL,
  `attribute_family_name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `locale` varchar(255) DEFAULT NULL,
  `channel` varchar(255) DEFAULT NULL,
  `attribute_family_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `visible_individually` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_flat_unique_index` (`product_id`,`channel`,`locale`),
  KEY `product_flat_attribute_family_id_foreign` (`attribute_family_id`),
  KEY `product_flat_parent_id_foreign` (`parent_id`),
  CONSTRAINT `product_flat_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`),
  CONSTRAINT `product_flat_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `product_flat` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_flat_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_flat`
--

LOCK TABLES `product_flat` WRITE;
/*!40000 ALTER TABLE `product_flat` DISABLE KEYS */;
INSERT INTO `product_flat` VALUES (1,'magic-blend-250g','simple',NULL,'Magic Blend','Master Secret Blend','Our signature 16-spice balanced aromatic blend, master-crafted in small batches to elevate everyday curries, dals, gravies, and paneer dishes with fragrant, warm sweetness.','magic-blend',1,1,1,NULL,NULL,'[{\"weight\":\"100g\",\"price\":95,\"strike\":119,\"active\":false},{\"weight\":\"250g\",\"price\":195,\"strike\":244,\"active\":true},{\"weight\":\"500g\",\"price\":360,\"strike\":450,\"active\":false}]',195.0000,NULL,NULL,NULL,0.2500,113,1,1,'assets/magicbland.png','Blended Spices','Default','2026-11-04 12:35:56','en','default',1,1,'2026-11-06 16:18:58',NULL,1),(2,'red-chilli-250g','simple',NULL,'Red Chilli Powder','Handpicked stemless sun-dried Guntur and Byadgi chillies, cold-pulverized below 40°C.','Handpicked stemless sun-dried Guntur and Byadgi chillies, cold-pulverized below 40°C. Delivers rich, vibrant vermilion red color and warm, layered piquancy without harsh synthetic additives.','red-chilli',1,1,1,NULL,NULL,NULL,185.0000,NULL,NULL,NULL,0.2500,96,1,1,'assets/chilli.png','Grinded Spices','Default','2026-11-04 12:35:56','en','default',1,2,'2026-11-04 16:39:47',NULL,1),(3,'garam-masala-100g','simple',NULL,'Royal Garam Masala','Royal court formulation featuring high-grade Idukki green cardamom, bold Tellicherry peppercorns, cloves, mace, and royal cinnamon.','Royal court formulation featuring high-grade Idukki green cardamom, bold Tellicherry peppercorns, cloves, mace, and royal cinnamon. Roasted in cast iron and coarse-ground for deep fragrance.','garam-masala',1,1,1,NULL,NULL,NULL,210.0000,NULL,NULL,NULL,0.1000,98,1,1,'assets/garammasala.png','Blended Spices','Default','2026-11-04 12:35:56','en','default',1,3,'2026-11-04 16:39:47',NULL,1),(4,'cumin-seeds-250g','simple',NULL,'India Cumin Seeds','Hand-selected from India APMC mandi lots. Bold, elongated seeds with high 3.8% thymol essential oil concentration.','Hand-selected from India APMC mandi lots. Bold, elongated seeds with high 3.8% thymol essential oil concentration. Crackles with crisp earthy sweetness.','cumin-seeds',1,1,1,NULL,NULL,NULL,160.0000,NULL,NULL,NULL,0.2500,100,1,1,'assets/step_01_sourced.png','Whole Spices','Default','2026-11-04 12:35:56','en','default',1,4,'2026-11-04 16:39:47',NULL,1),(5,'fennel-seeds-250g','simple',NULL,'Royal Fennel Seeds','Natural sun-dried green fennel from Gujarat\'s Saurashtra belt. Unpolished, chemical-free plump seeds.','Natural sun-dried green fennel from Gujarat\'s Saurashtra belt. Unpolished, chemical-free plump seeds offering refreshing sweet anethole flavor.','fennel-seeds',1,1,1,NULL,NULL,NULL,150.0000,NULL,NULL,NULL,0.2500,100,1,1,'assets/step_02_handpicked.png','Whole Spices','Default','2026-11-04 12:35:57','en','default',1,5,'2026-11-04 16:39:47',NULL,1),(6,'turmeric-powder-250g','simple',NULL,'Golden Turmeric Powder','Potent Salem finger rhizomes with 4.5%+ active curcumin content. Gently dehydrated and pulverized without heat degradation.','Potent Salem finger rhizomes with 4.5%+ active curcumin content. Gently dehydrated and pulverized without heat degradation to retain its healing potency.','turmeric-powder',1,1,1,NULL,NULL,NULL,140.0000,NULL,NULL,NULL,0.2500,100,1,1,'assets/step_04_ground.png','Grinded Spices','Default','2026-11-04 12:35:57','en','default',1,6,'2026-11-04 16:39:47',NULL,1),(7,'coriander-powder-250g','simple',NULL,'Coriander Powder','Eagle-grade coriander seeds cold-milled to preserve fragile linalool citrus notes.','Eagle-grade coriander seeds cold-milled to preserve fragile linalool citrus notes. Imparts cooling fragrant body and thick richness to home-cooked gravies.','coriander-powder',1,1,1,NULL,NULL,NULL,130.0000,NULL,NULL,NULL,0.2500,100,1,1,'assets/syd_pouch.jpg','Grinded Spices','Default','2026-11-04 12:35:57','en','default',1,7,'2026-11-04 16:39:47',NULL,1),(8,'heritage-gift-box-1kg','simple',NULL,'Heritage Grand Gift Box','Collector\'s presentation wooden box with 5 luxury airtight glass jars.','Collector\'s presentation wooden box with 5 luxury airtight glass jars: Magic Blend, Garam Masala, India Jeera, Salem Turmeric, and Red Chilli, plus an authentic brass measuring spoon.','heritage-gift-box',1,1,1,NULL,NULL,NULL,1199.0000,NULL,NULL,NULL,1.0000,100,1,1,'assets/card_magic_blend.png','Blended Spices','Default','2026-11-04 12:35:57','en','default',1,8,'2026-11-04 16:39:47',NULL,1),(9,'malabar-black-pepper-100g','simple',NULL,'Malabar Black Pepper','Bold Whole Peppercorns','Sun-dried bold Tellicherry and Malabar black peppercorns rich in natural piperine oils.','malabar-black-pepper',1,0,1,NULL,NULL,NULL,220.0000,NULL,NULL,NULL,100.0000,100,1,1,'assets/step_01_sourced.png','Whole Spices','Default','2026-11-04 13:39:45','en','default',1,10,'2026-11-04 16:39:47',NULL,1),(13,'royal-shahi-biryani-masala-856','simple',NULL,'Royal Shahi Biryani Masala','Aromatic Mughal blend with saffron, mace and green cardamom.','Authentic Nizami & Awadhi shahi biryani spice blend hand-roasted in small batches.','royal-shahi-biryani-masala',1,0,1,NULL,NULL,NULL,230.0000,NULL,NULL,NULL,200.0000,80,1,1,'assets/magicbland.png','Blended Spices','Default','2026-11-04 14:19:49','en','default',1,14,'2026-11-04 16:39:47',NULL,1),(15,'dhruv-parekh-100','simple',NULL,'dhruv parekh signature masala','vivek patel','A royal blend made with carefully selected whole spices and cold ground.','dhruv-parekh',1,0,1,NULL,NULL,'[{\"weight\":\"100g\",\"price\":110,\"strike\":138,\"active\":false},{\"weight\":\"250g\",\"price\":220,\"strike\":275,\"active\":true},{\"weight\":\"500g\",\"price\":410,\"strike\":513,\"active\":false}]',220.0000,NULL,NULL,NULL,250.0000,150,2,1,'assets/products/syd_1793786152_GUKtHj.png','Blended Spices','Default','2026-11-04 15:26:21','en','default',1,16,'2026-11-04 16:39:47',NULL,1);
/*!40000 ALTER TABLE `product_flat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_grouped_products`
--

DROP TABLE IF EXISTS `product_grouped_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_grouped_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `associated_product_id` int(10) unsigned NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `grouped_products_product_id_associated_product_id_unique` (`product_id`,`associated_product_id`),
  KEY `product_grouped_products_associated_product_id_foreign` (`associated_product_id`),
  KEY `pgp_product_id_idx` (`product_id`),
  CONSTRAINT `product_grouped_products_associated_product_id_foreign` FOREIGN KEY (`associated_product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_grouped_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_grouped_products`
--

LOCK TABLES `product_grouped_products` WRITE;
/*!40000 ALTER TABLE `product_grouped_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_grouped_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_image_translations`
--

DROP TABLE IF EXISTS `product_image_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_image_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_image_id` int(10) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `alt_text` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `image_translations_image_id_locale_unique` (`product_image_id`,`locale`),
  CONSTRAINT `image_translations_image_id_foreign` FOREIGN KEY (`product_image_id`) REFERENCES `product_images` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_image_translations`
--

LOCK TABLES `product_image_translations` WRITE;
/*!40000 ALTER TABLE `product_image_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_image_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_images` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `path` varchar(255) NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `position` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `prod_img_product_id_idx` (`product_id`),
  CONSTRAINT `product_images_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (2,'images','assets/chilli.png',2,1),(3,'images','assets/garammasala.png',3,1),(4,'images','assets/step_01_sourced.png',4,1),(5,'images','assets/step_02_handpicked.png',5,1),(6,'images','assets/step_04_ground.png',6,1),(7,'images','assets/syd_pouch.jpg',7,1),(8,'images','assets/card_magic_blend.png',8,1),(9,'images','assets/step_01_sourced.png',10,1),(11,'images','assets/magicbland.png',14,1),(22,'images','assets/products/syd_1793786152_GUKtHj.png',16,1),(23,'images','assets/products/syd_1793786161_iQOIkI.png',16,2),(24,'images','assets/magicbland.png',1,1);
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_inventories`
--

DROP TABLE IF EXISTS `product_inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_inventories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qty` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) unsigned NOT NULL,
  `vendor_id` int(11) NOT NULL DEFAULT 0,
  `inventory_source_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_source_vendor_index_unique` (`product_id`,`inventory_source_id`,`vendor_id`),
  KEY `product_inventories_inventory_source_id_foreign` (`inventory_source_id`),
  CONSTRAINT `product_inventories_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_inventories`
--

LOCK TABLES `product_inventories` WRITE;
/*!40000 ALTER TABLE `product_inventories` DISABLE KEYS */;
INSERT INTO `product_inventories` VALUES (1,113,1,0,1),(2,96,2,0,1),(3,98,3,0,1),(4,100,4,0,1),(5,100,5,0,1),(6,100,6,0,1),(7,100,7,0,1),(8,100,8,0,1),(9,100,10,0,1),(11,80,14,0,1),(13,150,16,0,1);
/*!40000 ALTER TABLE `product_inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_inventory_indices`
--

DROP TABLE IF EXISTS `product_inventory_indices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_inventory_indices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qty` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_inventory_indices_product_id_channel_id_unique` (`product_id`,`channel_id`),
  KEY `product_inventory_indices_channel_id_foreign` (`channel_id`),
  KEY `prod_inv_product_id_idx` (`product_id`),
  CONSTRAINT `product_inventory_indices_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_inventory_indices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_inventory_indices`
--

LOCK TABLES `product_inventory_indices` WRITE;
/*!40000 ALTER TABLE `product_inventory_indices` DISABLE KEYS */;
INSERT INTO `product_inventory_indices` VALUES (1,113,1,1,'2026-11-04 07:05:56','2026-11-06 10:48:57'),(2,96,2,1,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(3,98,3,1,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(4,100,4,1,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(5,100,5,1,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(6,100,6,1,'2026-11-04 07:05:57','2026-11-04 07:05:57'),(7,100,7,1,'2026-11-04 07:05:57','2026-11-04 07:05:57'),(8,100,8,1,'2026-11-04 07:05:57','2026-11-04 07:05:57'),(9,100,10,1,'2026-11-04 08:09:45','2026-11-04 08:09:45'),(10,80,14,1,'2026-11-04 08:49:49','2026-11-04 08:49:49'),(12,150,16,1,'2026-11-04 09:56:21','2026-11-04 11:09:46');
/*!40000 ALTER TABLE `product_inventory_indices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_ordered_inventories`
--

DROP TABLE IF EXISTS `product_ordered_inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_ordered_inventories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qty` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_ordered_inventories_product_id_channel_id_unique` (`product_id`,`channel_id`),
  KEY `product_ordered_inventories_channel_id_foreign` (`channel_id`),
  CONSTRAINT `product_ordered_inventories_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_ordered_inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_ordered_inventories`
--

LOCK TABLES `product_ordered_inventories` WRITE;
/*!40000 ALTER TABLE `product_ordered_inventories` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_ordered_inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_price_indices`
--

DROP TABLE IF EXISTS `product_price_indices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_price_indices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `customer_group_id` int(10) unsigned DEFAULT NULL,
  `channel_id` int(10) unsigned NOT NULL DEFAULT 1,
  `min_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `regular_min_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `max_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `regular_max_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `price_indices_product_id_customer_group_id_channel_id_unique` (`product_id`,`customer_group_id`,`channel_id`),
  KEY `product_price_indices_customer_group_id_foreign` (`customer_group_id`),
  KEY `product_price_indices_channel_id_foreign` (`channel_id`),
  KEY `ppi_product_id_customer_group_id_idx` (`product_id`,`customer_group_id`),
  CONSTRAINT `product_price_indices_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_price_indices_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_price_indices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_price_indices`
--

LOCK TABLES `product_price_indices` WRITE;
/*!40000 ALTER TABLE `product_price_indices` DISABLE KEYS */;
INSERT INTO `product_price_indices` VALUES (1,1,1,1,195.0000,195.0000,195.0000,195.0000,'2026-11-04 07:05:56','2026-11-06 10:48:57'),(2,2,1,1,185.0000,185.0000,185.0000,185.0000,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(3,3,1,1,210.0000,210.0000,210.0000,210.0000,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(4,4,1,1,160.0000,160.0000,160.0000,160.0000,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(5,5,1,1,150.0000,150.0000,150.0000,150.0000,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(6,6,1,1,140.0000,140.0000,140.0000,140.0000,'2026-11-04 07:05:57','2026-11-04 07:05:57'),(7,7,1,1,130.0000,130.0000,130.0000,130.0000,'2026-11-04 07:05:57','2026-11-04 07:05:57'),(8,8,1,1,1199.0000,1199.0000,1199.0000,1199.0000,'2026-11-04 07:05:57','2026-11-04 07:05:57'),(9,10,1,1,220.0000,220.0000,220.0000,220.0000,'2026-11-04 08:09:45','2026-11-04 08:09:45'),(10,14,1,1,230.0000,230.0000,230.0000,230.0000,'2026-11-04 08:49:49','2026-11-04 08:49:49'),(12,16,1,1,220.0000,220.0000,220.0000,220.0000,'2026-11-04 09:56:21','2026-11-04 11:09:46'),(13,16,2,1,220.0000,220.0000,220.0000,220.0000,NULL,NULL),(14,16,3,1,220.0000,220.0000,220.0000,220.0000,NULL,NULL);
/*!40000 ALTER TABLE `product_price_indices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_relations`
--

DROP TABLE IF EXISTS `product_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_relations` (
  `parent_id` int(10) unsigned NOT NULL,
  `child_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `product_relations_parent_id_child_id_unique` (`parent_id`,`child_id`),
  KEY `product_relations_child_id_foreign` (`child_id`),
  CONSTRAINT `product_relations_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_relations_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_relations`
--

LOCK TABLES `product_relations` WRITE;
/*!40000 ALTER TABLE `product_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_review_attachments`
--

DROP TABLE IF EXISTS `product_review_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_review_attachments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `review_id` int(10) unsigned NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'image',
  `mime_type` varchar(255) DEFAULT NULL,
  `path` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_review_images_review_id_foreign` (`review_id`),
  CONSTRAINT `product_review_images_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `product_reviews` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_review_attachments`
--

LOCK TABLES `product_review_attachments` WRITE;
/*!40000 ALTER TABLE `product_review_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_review_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_reviews`
--

DROP TABLE IF EXISTS `product_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_reviews` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prod_rev_product_id_idx` (`product_id`),
  CONSTRAINT `product_reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_reviews`
--

LOCK TABLES `product_reviews` WRITE;
/*!40000 ALTER TABLE `product_reviews` DISABLE KEYS */;
INSERT INTO `product_reviews` VALUES (1,'Pooja Sharma','Secret weapon in my everyday cooking!',5,'The aroma when opening the pouch is simply intoxicating. I tried it in simple dal tadka and aloo gobi - the flavor depth was unbelievable. 100% pure, you can immediately tell there is zero starch or filler.','approved',1,NULL,'2026-10-15 05:50:00','2026-10-15 05:50:00'),(2,'Chef Vikram Kulkarni','Restaurant quality aroma in home cooking',5,'As a chef, I am very picky about commercial spice blends. SYD Magic Blend preserves volatile oils because of low temperature milling. The balance between mace, stone flower, and roasted cumin is masterful.','approved',1,NULL,'2026-10-22 09:15:00','2026-10-22 09:15:00'),(3,'Ananya Desai','Never going back to supermarket brands',5,'Pure goodness. Sealed pouch keeps it fresh for months. Even just a quarter teaspoon makes paneer butter masala taste like luxury dining.','approved',1,NULL,'2026-11-01 04:00:00','2026-11-01 04:00:00'),(4,'Ramesh Nair','Rich natural red color without artificial sting',5,'Genuine stemless Byadgi & Guntur chillies! You get a glorious crimson color in your gravies without that burning artificial dye taste. Completely clean and authentic.','approved',2,NULL,'2026-10-18 10:45:00','2026-10-18 10:45:00'),(5,'Sunita Mehta','Purity you can test at home',5,'Tested in water - zero red color settling on bottom. Pure natural capsaicin oil aroma. Highly recommended for daily tadkas.','approved',2,NULL,'2026-10-29 12:35:00','2026-10-29 12:35:00'),(6,'Harpreet Singh','Royal formula indeed, zero cheap coriander filler!',5,'Most garam masalas in the market are 70% coriander powder. SYD Royal Garam Masala is pure whole spices - green cardamom, mace, Ceylon cinnamon. Fragrance fills the entire house.','approved',3,NULL,'2026-10-25 06:40:00','2026-10-25 06:40:00'),(7,'Dr. Ketan Joshi','Authentic traditional bouquet',5,'Reminds me of how spices used to be prepared in Saurashtra kitchens 40 years ago. Pure and potent.','approved',3,NULL,'2026-11-03 04:45:00','2026-11-03 04:45:00'),(8,'Bhavna Ben','Crisp crackling Gujarat Jeera',5,'Bold elongated cumin grains with high thymol oil. Crackles wonderfully in ghee tadka.','approved',4,NULL,'2026-10-28 10:10:00','2026-10-28 10:10:00'),(9,'Meera Shah','Loved the packaging too',5,'Exceptional aroma and purity!','approved',1,NULL,'2026-11-06 10:48:35','2026-11-06 10:48:35');
/*!40000 ALTER TABLE `product_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_super_attributes`
--

DROP TABLE IF EXISTS `product_super_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_super_attributes` (
  `product_id` int(10) unsigned NOT NULL,
  `attribute_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `product_super_attributes_product_id_attribute_id_unique` (`product_id`,`attribute_id`),
  KEY `product_super_attributes_attribute_id_foreign` (`attribute_id`),
  CONSTRAINT `product_super_attributes_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`),
  CONSTRAINT `product_super_attributes_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_super_attributes`
--

LOCK TABLES `product_super_attributes` WRITE;
/*!40000 ALTER TABLE `product_super_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_super_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_up_sells`
--

DROP TABLE IF EXISTS `product_up_sells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_up_sells` (
  `parent_id` int(10) unsigned NOT NULL,
  `child_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `product_up_sells_parent_id_child_id_unique` (`parent_id`,`child_id`),
  KEY `product_up_sells_child_id_foreign` (`child_id`),
  CONSTRAINT `product_up_sells_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_up_sells_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_up_sells`
--

LOCK TABLES `product_up_sells` WRITE;
/*!40000 ALTER TABLE `product_up_sells` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_up_sells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_videos`
--

DROP TABLE IF EXISTS `product_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_videos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `path` varchar(255) NOT NULL,
  `position` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `prod_vid_product_id_idx` (`product_id`),
  CONSTRAINT `product_videos_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_videos`
--

LOCK TABLES `product_videos` WRITE;
/*!40000 ALTER TABLE `product_videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `attribute_family_id` int(10) unsigned DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_sku_unique` (`sku`),
  KEY `products_attribute_family_id_foreign` (`attribute_family_id`),
  KEY `products_parent_id_foreign` (`parent_id`),
  CONSTRAINT `products_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`),
  CONSTRAINT `products_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'magic-blend-250g','simple',NULL,1,NULL,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(2,'red-chilli-250g','simple',NULL,1,NULL,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(3,'garam-masala-100g','simple',NULL,1,NULL,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(4,'cumin-seeds-250g','simple',NULL,1,NULL,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(5,'fennel-seeds-250g','simple',NULL,1,NULL,'2026-11-04 07:05:56','2026-11-04 07:05:56'),(6,'turmeric-powder-250g','simple',NULL,1,NULL,'2026-11-04 07:05:57','2026-11-04 07:05:57'),(7,'coriander-powder-250g','simple',NULL,1,NULL,'2026-11-04 07:05:57','2026-11-04 07:05:57'),(8,'heritage-gift-box-1kg','simple',NULL,1,NULL,'2026-11-04 07:05:57','2026-11-04 07:05:57'),(10,'malabar-black-pepper-100g','simple',NULL,1,NULL,'2026-11-04 08:09:45','2026-11-04 08:09:45'),(14,'royal-shahi-biryani-masala-856','simple',NULL,1,NULL,'2026-11-04 08:49:49','2026-11-04 08:49:49'),(16,'dhruv-parekh-100','simple',NULL,1,NULL,'2026-11-04 09:56:21','2026-11-04 09:56:21');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refund_items`
--

DROP TABLE IF EXISTS `refund_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refund_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `product_id` int(10) unsigned DEFAULT NULL,
  `product_type` varchar(255) DEFAULT NULL,
  `order_item_id` int(10) unsigned DEFAULT NULL,
  `refund_id` int(10) unsigned DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `refund_items_parent_id_foreign` (`parent_id`),
  KEY `refund_items_order_item_id_foreign` (`order_item_id`),
  KEY `refund_items_refund_id_foreign` (`refund_id`),
  CONSTRAINT `refund_items_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `refund_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `refund_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `refund_items_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund_items`
--

LOCK TABLES `refund_items` WRITE;
/*!40000 ALTER TABLE `refund_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `refund_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refunds`
--

DROP TABLE IF EXISTS `refunds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refunds` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `increment_id` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `total_qty` int(11) DEFAULT NULL,
  `base_currency_code` varchar(255) DEFAULT NULL,
  `channel_currency_code` varchar(255) DEFAULT NULL,
  `order_currency_code` varchar(255) DEFAULT NULL,
  `adjustment_refund` decimal(12,4) DEFAULT 0.0000,
  `base_adjustment_refund` decimal(12,4) DEFAULT 0.0000,
  `adjustment_fee` decimal(12,4) DEFAULT 0.0000,
  `base_adjustment_fee` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `order_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `refunds_order_id_foreign` (`order_id`),
  CONSTRAINT `refunds_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refunds`
--

LOCK TABLES `refunds` WRITE;
/*!40000 ALTER TABLE `refunds` DISABLE KEYS */;
/*!40000 ALTER TABLE `refunds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma`
--

DROP TABLE IF EXISTS `rma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `rma_status_id` int(10) unsigned DEFAULT NULL,
  `package_condition` varchar(255) DEFAULT NULL,
  `information` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_order_id_foreign` (`order_id`),
  KEY `rma_rma_status_id_foreign` (`rma_status_id`),
  CONSTRAINT `rma_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rma_rma_status_id_foreign` FOREIGN KEY (`rma_status_id`) REFERENCES `rma_statuses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma`
--

LOCK TABLES `rma` WRITE;
/*!40000 ALTER TABLE `rma` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_additional_fields`
--

DROP TABLE IF EXISTS `rma_additional_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_additional_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rma_id` int(10) unsigned DEFAULT NULL,
  `rma_custom_field_id` int(10) unsigned DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_additional_fields_rma_id_foreign` (`rma_id`),
  KEY `rma_additional_fields_rma_custom_field_id_foreign` (`rma_custom_field_id`),
  CONSTRAINT `rma_additional_fields_rma_custom_field_id_foreign` FOREIGN KEY (`rma_custom_field_id`) REFERENCES `rma_custom_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rma_additional_fields_rma_id_foreign` FOREIGN KEY (`rma_id`) REFERENCES `rma` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_additional_fields`
--

LOCK TABLES `rma_additional_fields` WRITE;
/*!40000 ALTER TABLE `rma_additional_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_additional_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_custom_field_options`
--

DROP TABLE IF EXISTS `rma_custom_field_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_custom_field_options` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rma_custom_field_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_custom_field_options_rma_custom_field_id_foreign` (`rma_custom_field_id`),
  CONSTRAINT `rma_custom_field_options_rma_custom_field_id_foreign` FOREIGN KEY (`rma_custom_field_id`) REFERENCES `rma_custom_fields` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_custom_field_options`
--

LOCK TABLES `rma_custom_field_options` WRITE;
/*!40000 ALTER TABLE `rma_custom_field_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_custom_field_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_custom_fields`
--

DROP TABLE IF EXISTS `rma_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_custom_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) DEFAULT 0,
  `code` varchar(255) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `is_required` tinyint(1) DEFAULT 0,
  `position` int(11) DEFAULT 0,
  `input_validation` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rma_custom_fields_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_custom_fields`
--

LOCK TABLES `rma_custom_fields` WRITE;
/*!40000 ALTER TABLE `rma_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_images`
--

DROP TABLE IF EXISTS `rma_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_images` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rma_id` int(10) unsigned NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_images_rma_id_foreign` (`rma_id`),
  CONSTRAINT `rma_images_rma_id_foreign` FOREIGN KEY (`rma_id`) REFERENCES `rma` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_images`
--

LOCK TABLES `rma_images` WRITE;
/*!40000 ALTER TABLE `rma_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_items`
--

DROP TABLE IF EXISTS `rma_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rma_id` int(10) unsigned DEFAULT NULL,
  `rma_reason_id` int(10) unsigned DEFAULT NULL,
  `order_item_id` int(10) unsigned DEFAULT NULL,
  `variant_id` int(10) unsigned DEFAULT NULL,
  `quantity` int(10) unsigned NOT NULL,
  `resolution` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_items_rma_id_foreign` (`rma_id`),
  KEY `rma_items_rma_reason_id_foreign` (`rma_reason_id`),
  KEY `rma_items_order_item_id_foreign` (`order_item_id`),
  KEY `rma_items_variant_id_foreign` (`variant_id`),
  CONSTRAINT `rma_items_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rma_items_rma_id_foreign` FOREIGN KEY (`rma_id`) REFERENCES `rma` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rma_items_rma_reason_id_foreign` FOREIGN KEY (`rma_reason_id`) REFERENCES `rma_reasons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `rma_items_variant_id_foreign` FOREIGN KEY (`variant_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_items`
--

LOCK TABLES `rma_items` WRITE;
/*!40000 ALTER TABLE `rma_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_messages`
--

DROP TABLE IF EXISTS `rma_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rma_id` int(10) unsigned NOT NULL,
  `message` longtext NOT NULL,
  `attachment_path` longtext DEFAULT NULL,
  `attachment` longtext DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_messages_rma_id_foreign` (`rma_id`),
  CONSTRAINT `rma_messages_rma_id_foreign` FOREIGN KEY (`rma_id`) REFERENCES `rma` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_messages`
--

LOCK TABLES `rma_messages` WRITE;
/*!40000 ALTER TABLE `rma_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_reason_resolutions`
--

DROP TABLE IF EXISTS `rma_reason_resolutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_reason_resolutions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rma_reason_id` int(10) unsigned NOT NULL,
  `resolution_type` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_reason_resolutions_rma_reason_id_foreign` (`rma_reason_id`),
  CONSTRAINT `rma_reason_resolutions_rma_reason_id_foreign` FOREIGN KEY (`rma_reason_id`) REFERENCES `rma_reasons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_reason_resolutions`
--

LOCK TABLES `rma_reason_resolutions` WRITE;
/*!40000 ALTER TABLE `rma_reason_resolutions` DISABLE KEYS */;
INSERT INTO `rma_reason_resolutions` VALUES (1,1,'return','2026-10-06 13:16:21','2026-10-06 13:16:21'),(2,1,'cancel_items','2026-10-06 13:16:21','2026-10-06 13:16:21'),(3,2,'return','2026-10-06 13:16:21','2026-10-06 13:16:21'),(4,2,'cancel_items','2026-10-06 13:16:21','2026-10-06 13:16:21'),(5,3,'return','2026-10-06 13:16:21','2026-10-06 13:16:21'),(6,3,'cancel_items','2026-10-06 13:16:21','2026-10-06 13:16:21'),(7,4,'return','2026-10-06 13:16:21','2026-10-06 13:16:21'),(8,4,'cancel_items','2026-10-06 13:16:21','2026-10-06 13:16:21'),(9,5,'return','2026-10-06 13:16:21','2026-10-06 13:16:21'),(10,5,'cancel_items','2026-10-06 13:16:21','2026-10-06 13:16:21');
/*!40000 ALTER TABLE `rma_reason_resolutions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_reasons`
--

DROP TABLE IF EXISTS `rma_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_reasons` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_reasons`
--

LOCK TABLES `rma_reasons` WRITE;
/*!40000 ALTER TABLE `rma_reasons` DISABLE KEYS */;
INSERT INTO `rma_reasons` VALUES (1,'Manufacturer Defect',1,1,0,'2026-10-06 13:16:21','2026-10-06 13:16:21'),(2,'Damaged During Shipping',1,2,0,'2026-10-06 13:16:21','2026-10-06 13:16:21'),(3,'Wrong Description Online',1,3,0,'2026-10-06 13:16:21','2026-10-06 13:16:21'),(4,'Dead On Arrival',1,4,0,'2026-10-06 13:16:21','2026-10-06 13:16:21'),(5,'Product Not Received Yet',1,5,0,'2026-10-06 13:16:21','2026-10-06 13:16:21');
/*!40000 ALTER TABLE `rma_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_rules`
--

DROP TABLE IF EXISTS `rma_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `return_period` int(11) DEFAULT NULL,
  `default` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_rules`
--

LOCK TABLES `rma_rules` WRITE;
/*!40000 ALTER TABLE `rma_rules` DISABLE KEYS */;
INSERT INTO `rma_rules` VALUES (1,'Basic','1',1,10,NULL,'2026-10-06 13:16:22','2026-10-06 13:16:22');
/*!40000 ALTER TABLE `rma_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_statuses`
--

DROP TABLE IF EXISTS `rma_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_statuses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `default` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_statuses`
--

LOCK TABLES `rma_statuses` WRITE;
/*!40000 ALTER TABLE `rma_statuses` DISABLE KEYS */;
INSERT INTO `rma_statuses` VALUES (1,'Pending Review',1,'#efb308',1,NULL,NULL),(2,'Approved',1,'#12af56',1,NULL,NULL),(3,'Awaiting Return',1,'#f59e0b',1,NULL,NULL),(4,'Return In Transit',1,'#3b82f6',1,NULL,NULL),(5,'Refunded',1,'#10b981',1,NULL,NULL),(6,'Solved',1,'#47b84f',1,NULL,NULL),(7,'Request Declined',1,'#e11d48',1,NULL,NULL),(8,'Item Canceled',1,'#dc2626',1,NULL,NULL),(9,'Request Canceled',1,'#991b1b',1,NULL,NULL);
/*!40000 ALTER TABLE `rma_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `permission_type` varchar(255) NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Administrator','This role users will have all the access','all',NULL,NULL,NULL),(2,'Workshop & Media Coordinator','Coordinates student admissions, batch dates, seats, video hub, and showcase bento gallery','custom','[\"dashboard\",\"vize_workshops\",\"vize_videos\",\"vize_showcase\",\"vize_offers\",\"customers\"]','2026-10-08 12:14:51','2026-10-08 12:14:51'),(3,'Factory Lab & Catalog Manager','Maintains formulation listings, pigment swatches, live-edge table catalog, and warehouse inventory','custom','[\"dashboard\",\"vize_resins\",\"vize_pigments\",\"vize_table_tops\",\"settings.inventory_sources\"]','2026-10-08 12:14:51','2026-10-08 12:14:51'),(4,'Finance & Analytics Manager','Access to business revenue analytics, product volume metrics, customer spend, and GST tax settings','custom','[\"dashboard\",\"reporting\",\"reporting.sales\",\"reporting.products\",\"reporting.customers\",\"settings.taxes\"]','2026-10-08 12:14:51','2026-10-08 12:14:51');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `search_synonyms`
--

DROP TABLE IF EXISTS `search_synonyms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_synonyms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `terms` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_synonyms`
--

LOCK TABLES `search_synonyms` WRITE;
/*!40000 ALTER TABLE `search_synonyms` DISABLE KEYS */;
/*!40000 ALTER TABLE `search_synonyms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `search_terms`
--

DROP TABLE IF EXISTS `search_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_terms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `term` varchar(255) NOT NULL,
  `results` int(11) NOT NULL DEFAULT 0,
  `uses` int(11) NOT NULL DEFAULT 0,
  `redirect_url` varchar(255) DEFAULT NULL,
  `display_in_suggested_terms` tinyint(1) NOT NULL DEFAULT 0,
  `locale` varchar(255) NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `search_terms_channel_id_foreign` (`channel_id`),
  CONSTRAINT `search_terms_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_terms`
--

LOCK TABLES `search_terms` WRITE;
/*!40000 ALTER TABLE `search_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `search_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('3rDOhuDfNi1OisH16NrLiKgdMKFOsuQU8ntGvYV4',NULL,'127.0.0.1','','YTozOntzOjY6Il90b2tlbiI7czo0MDoiUjdFN0VlVU1GS25tVmpQWURrN09QSkVOZTBkcWpBNFJwZENVeFdtaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9zZXR0aW5ncy9jaGFubmVscyI7czo1OiJyb3V0ZSI7czoyOToiYWRtaW4uc2V0dGluZ3MuY2hhbm5lbHMuaW5kZXgiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1794562648),('gzNcLqOSdAOGAtGZwAVa0r1OaRTnWD1RWHijN7MO',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.22000.2538','YTozOntzOjY6Il90b2tlbiI7czo0MDoienUwZWRjV3VxMnZMNzI5MkhzdkJCcjFpelhGb3g1RUdJVnN2a2cxaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9zZXR0aW5ncy9pbnZlbnRvcnktc291cmNlcyI7czo1OiJyb3V0ZSI7czozODoiYWRtaW4uc2V0dGluZ3MuaW52ZW50b3J5X3NvdXJjZXMuaW5kZXgiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1794562808),('oxzpjd15SegoTsIinA0eSsZAlzNj8JilUpEm5GyR',NULL,'127.0.0.1','','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiOTdjcTIzWG51TjdGYjNKVHNabnVyejhIbXJyYVI0NkhHendzVUpSayI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozNzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2FkbWluL2Rhc2hib2FyZCI7fXM6OToiX3ByZXZpb3VzIjthOjI6e3M6MzoidXJsIjtzOjMzOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYWRtaW4vbG9naW4iO3M6NToicm91dGUiO3M6MjA6ImFkbWluLnNlc3Npb24uY3JlYXRlIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1794562648),('Vogofff4T60qXkJ05tm5yx9aQEYFBUgmHtrJ6pTa',10,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36 Edg/157.0.0.0','YTo2OntzOjY6Il90b2tlbiI7czo0MDoiRGI5UlByTVhEMlJmc25XNHBzdG1udFFvQjExdWxxQXk0U3dNc1hVNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9jYXRhbG9nL3Byb2R1Y3RzIjtzOjU6InJvdXRlIjtzOjI4OiJhZG1pbi5jYXRhbG9nLnByb2R1Y3RzLmluZGV4Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MDp7fXM6NTI6ImxvZ2luX2FkbWluXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MjtzOjU1OiJsb2dpbl9jdXN0b21lcl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjEwO30=',1794564409);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment_items`
--

DROP TABLE IF EXISTS `shipment_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipment_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT NULL,
  `price` decimal(12,4) DEFAULT 0.0000,
  `base_price` decimal(12,4) DEFAULT 0.0000,
  `total` decimal(12,4) DEFAULT 0.0000,
  `base_total` decimal(12,4) DEFAULT 0.0000,
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `product_id` int(10) unsigned DEFAULT NULL,
  `product_type` varchar(255) DEFAULT NULL,
  `order_item_id` int(10) unsigned DEFAULT NULL,
  `shipment_id` int(10) unsigned NOT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shipment_items_shipment_id_foreign` (`shipment_id`),
  CONSTRAINT `shipment_items_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment_items`
--

LOCK TABLES `shipment_items` WRITE;
/*!40000 ALTER TABLE `shipment_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipment_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipments`
--

DROP TABLE IF EXISTS `shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` varchar(255) DEFAULT NULL,
  `total_qty` int(11) DEFAULT NULL,
  `total_weight` decimal(12,4) DEFAULT NULL,
  `carrier_code` varchar(255) DEFAULT NULL,
  `carrier_title` varchar(255) DEFAULT NULL,
  `track_number` text DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `customer_id` int(10) unsigned DEFAULT NULL,
  `customer_type` varchar(255) DEFAULT NULL,
  `order_id` int(10) unsigned NOT NULL,
  `order_address_id` int(10) unsigned DEFAULT NULL,
  `inventory_source_id` int(10) unsigned DEFAULT NULL,
  `inventory_source_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shipments_order_id_foreign` (`order_id`),
  KEY `shipments_inventory_source_id_foreign` (`inventory_source_id`),
  CONSTRAINT `shipments_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE SET NULL,
  CONSTRAINT `shipments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipments`
--

LOCK TABLES `shipments` WRITE;
/*!40000 ALTER TABLE `shipments` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitemap_channels`
--

DROP TABLE IF EXISTS `sitemap_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitemap_channels` (
  `sitemap_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `sitemap_channels_sitemap_id_channel_id_unique` (`sitemap_id`,`channel_id`),
  KEY `sitemap_channels_channel_id_foreign` (`channel_id`),
  CONSTRAINT `sitemap_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sitemap_channels_sitemap_id_foreign` FOREIGN KEY (`sitemap_id`) REFERENCES `sitemaps` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitemap_channels`
--

LOCK TABLES `sitemap_channels` WRITE;
/*!40000 ALTER TABLE `sitemap_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `sitemap_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitemaps`
--

DROP TABLE IF EXISTS `sitemaps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitemaps` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `generated_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitemaps`
--

LOCK TABLES `sitemaps` WRITE;
/*!40000 ALTER TABLE `sitemaps` DISABLE KEYS */;
/*!40000 ALTER TABLE `sitemaps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscribers_list`
--

DROP TABLE IF EXISTS `subscribers_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscribers_list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `is_subscribed` tinyint(1) NOT NULL DEFAULT 0,
  `token` varchar(255) DEFAULT NULL,
  `customer_id` int(10) unsigned DEFAULT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscribers_list_customer_id_foreign` (`customer_id`),
  KEY `subscribers_list_channel_id_foreign` (`channel_id`),
  CONSTRAINT `subscribers_list_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subscribers_list_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscribers_list`
--

LOCK TABLES `subscribers_list` WRITE;
/*!40000 ALTER TABLE `subscribers_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscribers_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_categories`
--

DROP TABLE IF EXISTS `tax_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tax_categories_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_categories`
--

LOCK TABLES `tax_categories` WRITE;
/*!40000 ALTER TABLE `tax_categories` DISABLE KEYS */;
INSERT INTO `tax_categories` VALUES (1,'gst-18','Standard GST 18% (Polymers, Resins & Kits)','Standard 18% GST applicable to casting epoxies, hardeners, coatings, and notch trowel kits.','2026-10-08 12:14:51','2026-10-08 12:14:51'),(2,'gst-12','GST 12% (Pigments & Color Tints)','12% GST applicable to liquid pastes, metallic powders, and alcohol ink colorants.','2026-10-08 12:14:51','2026-10-08 12:14:51'),(3,'gst-5','GST 5% (Workshop Educational Materials)','5% concessional GST on course literature and student materials.','2026-10-08 12:14:51','2026-10-08 12:14:51');
/*!40000 ALTER TABLE `tax_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_categories_tax_rates`
--

DROP TABLE IF EXISTS `tax_categories_tax_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_categories_tax_rates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tax_category_id` int(10) unsigned NOT NULL,
  `tax_rate_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tax_map_index_unique` (`tax_category_id`,`tax_rate_id`),
  KEY `tax_categories_tax_rates_tax_rate_id_foreign` (`tax_rate_id`),
  CONSTRAINT `tax_categories_tax_rates_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tax_categories_tax_rates_tax_rate_id_foreign` FOREIGN KEY (`tax_rate_id`) REFERENCES `tax_rates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_categories_tax_rates`
--

LOCK TABLES `tax_categories_tax_rates` WRITE;
/*!40000 ALTER TABLE `tax_categories_tax_rates` DISABLE KEYS */;
INSERT INTO `tax_categories_tax_rates` VALUES (1,1,1,'2026-10-08 12:14:51','2026-10-08 12:14:51'),(2,2,2,'2026-10-08 12:14:51','2026-10-08 12:14:51'),(3,3,3,'2026-10-08 12:14:51','2026-10-08 12:14:51');
/*!40000 ALTER TABLE `tax_categories_tax_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_rates`
--

DROP TABLE IF EXISTS `tax_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_rates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `is_zip` tinyint(1) NOT NULL DEFAULT 0,
  `zip_code` varchar(255) DEFAULT NULL,
  `zip_from` varchar(255) DEFAULT NULL,
  `zip_to` varchar(255) DEFAULT NULL,
  `state` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `tax_rate` decimal(12,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tax_rates_identifier_unique` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_rates`
--

LOCK TABLES `tax_rates` WRITE;
/*!40000 ALTER TABLE `tax_rates` DISABLE KEYS */;
INSERT INTO `tax_rates` VALUES (1,'GST-18',0,NULL,NULL,NULL,'*','IN',18.0000,'2026-10-08 12:14:51','2026-10-08 12:14:51'),(2,'GST-12',0,NULL,NULL,NULL,'*','IN',12.0000,'2026-10-08 12:14:51','2026-10-08 12:14:51'),(3,'GST-5',0,NULL,NULL,NULL,'*','IN',5.0000,'2026-10-08 12:14:51','2026-10-08 12:14:51');
/*!40000 ALTER TABLE `tax_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `theme_section_translations`
--

DROP TABLE IF EXISTS `theme_section_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theme_section_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `section_id` int(10) unsigned NOT NULL,
  `locale` varchar(255) NOT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  `draft_options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`draft_options`)),
  PRIMARY KEY (`id`),
  KEY `theme_customization_id_foreign` (`section_id`),
  CONSTRAINT `theme_customization_id_foreign` FOREIGN KEY (`section_id`) REFERENCES `theme_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theme_section_translations`
--

LOCK TABLES `theme_section_translations` WRITE;
/*!40000 ALTER TABLE `theme_section_translations` DISABLE KEYS */;
INSERT INTO `theme_section_translations` VALUES (1,1,'en','{\"images\":[{\"title\":\"Get Ready For New Collection\",\"link\":\"#formal-wear-female\",\"image\":\"storage\\/themes\\/default\\/sections\\/1\\/03R3feSYtMzr4rYkmFYQyVeann7dOEnZlD8sgynW.webp\"},{\"title\":\"Get Ready For New Collection\",\"link\":\"#formal-wear-men\",\"image\":\"storage\\/themes\\/default\\/sections\\/1\\/P13xuuYUMbo2hkhCOd9c4KmXAiqrGPQqjnSWSiJE.webp\"},{\"title\":\"Get Ready For New Collection\",\"link\":\"#active-wear-female\",\"image\":\"storage\\/themes\\/default\\/sections\\/1\\/40BC6hqhK9GkNKfUuNR5iLSoGI1o0DXrNKohpjfB.webp\"},{\"title\":\"Get Ready For New Collection\",\"link\":\"#smart-home-automation\",\"image\":\"storage\\/themes\\/default\\/sections\\/1\\/I2LI5Bgh4Z5sz54WMP4AXj9v9kYyGcBTqm95mDUU.webp\"},{\"title\":\"Get Ready For New Collection\",\"link\":\"#mobile-phones-accessories\",\"image\":\"storage\\/themes\\/default\\/sections\\/1\\/SzhTKJ5gX0CRr85L3gYVKevknsl9jpvKm4Q9sSMc.webp\"},{\"title\":\"Get Ready For New Collection\",\"link\":\"#laptops-tablets\",\"image\":\"storage\\/themes\\/default\\/sections\\/1\\/OBpTmIjaEr6AfCEI5DcGA59QGfSn2FPPgUCDvqib.webp\"}]}',NULL),(2,2,'en','{\"html\":\"<div class=\\\"home-offer\\\"><h1>Get UPTO 40% OFF on your 1st order SHOP NOW<\\/h1><\\/div>\",\"css\":\".home-offer h1 {display: block;font-weight: 500;text-align: center;font-size: 22px;font-family: DM Serif Display;background-color: #E8EDFE;padding-top: 20px;padding-bottom: 20px;}@media (max-width:768px){.home-offer h1 {font-size:18px;padding-top: 10px;padding-bottom: 10px;}@media (max-width:525px) {.home-offer h1 {font-size:14px;padding-top: 6px;padding-bottom: 6px;}}\"}',NULL),(3,5,'en','{\"html\":\"<div class=\\\"top-collection-container\\\">\\n                                <div class=\\\"top-collection-header\\\">\\n                                    <h2>The game with our new additions!<\\/h2>\\n                                <\\/div>\\n\\n                                <div class=\\\"top-collection-grid container\\\">\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"#electronics\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/5\\/BHO7wR2ugg37eXLi0KE1ezrFnAU8F6klamx1vf5a.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        <\\/a>\\n                                    <\\/div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"#mens\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/5\\/XfiiA263uBybbHllRenlf8uHaE2FJPfGMYaMY4UT.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        <\\/a>\\n                                    <\\/div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"#womens\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/5\\/Q2dpjXeHEKvXCdFt7GgVkd7B1YzKuy9XEx5rx0Dt.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        <\\/a>\\n                                    <\\/div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"#formal-wear-men\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/5\\/BfX31HECP4hlcAJ8gesruSqyhjTTMSJyKeY2Pe0s.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        <\\/a>\\n                                    <\\/div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"#formal-wear-female\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/5\\/SFzpSgZkr28BnbN5yfuZ7OccbIWbie1glv551dXV.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        <\\/a>\\n                                    <\\/div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"#wellness\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/5\\/zi6eVG2jWzmXu89NpuStCiNWcxdWrNYVlICcQyYk.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        <\\/a>\\n                                    <\\/div>\\n                                <\\/div>\\n                            <\\/div>\",\"css\":\".top-collection-container {overflow: hidden;}.top-collection-header {padding-left: 15px;padding-right: 15px;text-align: center;font-size: 70px;line-height: 90px;color: #060C3B;margin-top: 80px;}.top-collection-header h2 {max-width: 595px;margin-left: auto;margin-right: auto;font-family: DM Serif Display;}.top-collection-grid {display: flex;flex-wrap: wrap;gap: 32px;justify-content: center;margin-top: 60px;width: 100%;margin-right: auto;margin-left: auto;padding-right: 90px;padding-left: 90px;}.top-collection-card {position: relative;background: #f9fafb;overflow:hidden;border-radius:20px;}.top-collection-card img {border-radius: 16px;max-width: 100%;text-indent:-9999px;transition: transform 300ms ease;transform: scale(1);}.top-collection-card:hover img {transform: scale(1.05);transition: all 300ms ease;}.top-collection-card h3 {color: #060C3B;font-size: 30px;font-family: DM Serif Display;transform: translateX(-50%);width: max-content;left: 50%;bottom: 30px;position: absolute;margin: 0;font-weight: inherit;}@media not all and (min-width: 525px) {.top-collection-header {margin-top: 28px;font-size: 20px;line-height: 1.5;}.top-collection-grid {gap: 10px}}@media not all and (min-width: 768px) {.top-collection-header {margin-top: 30px;font-size: 28px;line-height: 3;}.top-collection-header h2 {line-height:2; margin-bottom:20px;} .top-collection-grid {gap: 14px}} @media not all and (min-width: 1024px) {.top-collection-grid {padding-left: 30px;padding-right: 30px;}}@media (max-width: 768px) {.top-collection-grid { row-gap:15px; column-gap:0px;justify-content: space-between;margin-top: 0px;} .top-collection-card{width:48%} .top-collection-card img {width:100%;} .top-collection-card h3 {font-size:24px; bottom: 16px;}}@media (max-width:520px) { .top-collection-grid{padding-left: 15px;padding-right: 15px;} .top-collection-card h3 {font-size:18px; bottom: 10px;}}\"}',NULL),(4,6,'en','{\"html\":\"<div class=\\\"section-gap bold-collections container\\\">\\n                                <div class=\\\"inline-col-wrapper\\\">\\n                                    <div class=\\\"inline-col-image-wrapper\\\">\\n                                        <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/6\\/BTohri9fGzkzE7WfZniQZbwr5n8QfKxVPyGb1BUI.webp\\\" class=\\\"lazy\\\" width=\\\"632\\\" height=\\\"510\\\" alt=\\\"Get Ready for our new Bold Collections!\\\">\\n                                    <\\/div>\\n\\n                                    <div class=\\\"inline-col-content-wrapper\\\">\\n                                        <h2 class=\\\"inline-col-title\\\"> Get Ready for our new Bold Collections! <\\/h2> \\n                                        \\n                                        <p class=\\\"inline-col-description\\\">Introducing Our New Bold Collections! Elevate your style with daring designs and vibrant statements. Explore striking patterns and bold colors that redefine your wardrobe. Get ready to embrace the extraordinary!<\\/p>\\n                                        \\n                                        <a href=\\\"#wellness\\\">\\n                                            <button class=\\\"primary-button max-md:rounded-lg max-md:px-4 max-md:py-2.5 max-md:text-sm\\\">View Collections<\\/button>\\n                                        <\\/a>\\n                                    <\\/div>\\n                                <\\/div>\\n                            <\\/div>\",\"css\":\".section-gap{margin-top:80px}.direction-ltr{direction:ltr}.direction-rtl{direction:rtl}.inline-col-wrapper{display:grid;grid-template-columns:auto 1fr;grid-gap:60px;align-items:center}.inline-col-wrapper .inline-col-image-wrapper{overflow:hidden}.inline-col-wrapper .inline-col-image-wrapper img{max-width:100%;height:auto;border-radius:16px;text-indent:-9999px}.inline-col-wrapper .inline-col-content-wrapper{display:flex;flex-wrap:wrap;gap:20px;max-width:464px}.inline-col-wrapper .inline-col-content-wrapper .inline-col-title{max-width:442px;font-size:60px;font-weight:400;color:#060c3b;line-height:70px;font-family:DM Serif Display;margin:0}.inline-col-wrapper .inline-col-content-wrapper .inline-col-description{margin:0;font-size:18px;color:#6e6e6e;font-family:Poppins}@media (max-width:991px){.inline-col-wrapper{grid-template-columns:1fr;grid-gap:16px}.inline-col-wrapper .inline-col-content-wrapper{gap:10px}} @media (max-width:768px){.inline-col-wrapper .inline-col-image-wrapper img {width:100%;} .inline-col-wrapper .inline-col-content-wrapper .inline-col-title{font-size:28px !important;line-height:normal !important}} @media (max-width:525px){.inline-col-wrapper .inline-col-content-wrapper .inline-col-title{font-size:20px !important;} .inline-col-description{font-size:16px} .inline-col-wrapper{grid-gap:10px}}\"}',NULL),(5,8,'en','{\"html\":\"<div class=\\\"section-game\\\">\\n                                <div class=\\\"section-title\\\">\\n                                    <h2>The game with our new additions!<\\/h2> \\n                                <\\/div>\\n\\n                                <div class=\\\"section-gap container\\\">\\n                                    <div class=\\\"collection-card-wrapper\\\">\\n                                        <div class=\\\"single-collection-card\\\">\\n                                            <a href=\\\"#active-wear\\\">\\n                                                <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/8\\/GKe3hD6Sj5D6OmayMjCHo1689e0oaiQh0AwD9QEi.webp\\\" class=\\\"lazy\\\" width=\\\"615\\\" height=\\\"600\\\" alt=\\\"The game with our new additions!\\\">\\n                                                \\n                                                <h3 class=\\\"overlay-text\\\">Our Collections<\\/h3> \\n                                            <\\/a>\\n                                        <\\/div>\\n\\n                                        <div class=\\\"single-collection-card\\\">\\n                                            <a href=\\\"#active-wear-female\\\">\\n                                                <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/8\\/qfpPx9eRIEbS9MCdUyqo269DrWMuOFYz0jMhVjDu.webp\\\" class=\\\"lazy\\\" width=\\\"615\\\" height=\\\"600\\\" alt=\\\"The game with our new additions!\\\">\\n                                                \\n                                                <h3 class=\\\"overlay-text\\\"> Our Collections <\\/h3> \\n                                            <\\/a>\\n                                        <\\/div>\\n                                    <\\/div>\\n                                <\\/div>\\n                            <\\/div>\",\"css\":\".section-game {overflow: hidden;}.section-title,.section-title h2{font-weight:400;font-family:DM Serif Display}.section-title{margin-top:80px;padding-left:15px;padding-right:15px;text-align:center;line-height:90px}.section-title h2{font-size:70px;color:#060c3b;max-width:595px;margin:auto}.collection-card-wrapper{display:flex;flex-wrap:wrap;justify-content:center;gap:30px}.collection-card-wrapper .single-collection-card{position:relative}.collection-card-wrapper .single-collection-card img{border-radius:16px;background-color:#f5f5f5;max-width:100%;height:auto;text-indent:-9999px}.collection-card-wrapper .single-collection-card .overlay-text{font-size:50px;font-weight:400;max-width:234px;font-style:italic;color:#060c3b;font-family:DM Serif Display;position:absolute;bottom:30px;left:30px;margin:0}@media (max-width:1024px){.section-title{padding:0 30px}}@media (max-width:991px){.collection-card-wrapper{flex-wrap:wrap}}@media (max-width:768px) {.collection-card-wrapper .single-collection-card .overlay-text{font-size:32px; bottom:20px}.section-title{margin-top:32px}.section-title h2{font-size:28px;line-height:normal}} @media (max-width:525px){.collection-card-wrapper .single-collection-card .overlay-text{font-size:18px; bottom:10px} .section-title{margin-top:28px}.section-title h2{font-size:20px;} .collection-card-wrapper{gap:10px; 15px; row-gap:15px; column-gap:0px;justify-content: space-between;margin-top: 15px;} .collection-card-wrapper .single-collection-card {width:48%;}}\"}',NULL),(6,10,'en','{\"html\":\"<div class=\\\"section-gap bold-collections container\\\">\\n                                <div class=\\\"inline-col-wrapper direction-rtl\\\">\\n                                    <div class=\\\"inline-col-image-wrapper\\\">\\n                                        <img src=\\\"\\\" data-src=\\\"storage\\/themes\\/default\\/sections\\/10\\/lGnT0BSzRngg2L6uEAqKjBGhBElRSh6u1vGkHgTR.webp\\\" class=\\\"lazy\\\" width=\\\"632\\\" height=\\\"510\\\" alt=\\\"Unleash Your Boldness with Our New Collection!\\\">\\n                                    <\\/div>\\n\\n                                    <div class=\\\"inline-col-content-wrapper direction-ltr\\\">\\n                                        <h2 class=\\\"inline-col-title\\\">Unleash Your Boldness with Our New Collection!<\\/h2> \\n                                        \\n                                        <p class=\\\"inline-col-description\\\">Our Bold Collections are here to redefine your wardrobe with fearless designs and striking, vibrant colors. From daring patterns to powerful hues, this is your chance to break away from the ordinary and step into the extraordinary.<\\/p>\\n                                        \\n                                        <a href=\\\"#electronics\\\">\\n                                            <button class=\\\"primary-button max-md:rounded-lg max-md:px-4 max-md:py-2.5 max-md:text-sm\\\">View Collections<\\/button>\\n                                        <\\/a>\\n                                    <\\/div>\\n                                <\\/div>\\n                            <\\/div>\",\"css\":\".section-gap{margin-top:80px}.direction-ltr{direction:ltr}.direction-rtl{direction:rtl}.inline-col-wrapper{display:grid;grid-template-columns:auto 1fr;grid-gap:60px;align-items:center}.inline-col-wrapper .inline-col-image-wrapper{overflow:hidden}.inline-col-wrapper .inline-col-image-wrapper img{max-width:100%;height:auto;border-radius:16px;text-indent:-9999px}.inline-col-wrapper .inline-col-content-wrapper{display:flex;flex-wrap:wrap;gap:20px;max-width:464px}.inline-col-wrapper .inline-col-content-wrapper .inline-col-title{max-width:442px;font-size:60px;font-weight:400;color:#060c3b;line-height:70px;font-family:DM Serif Display;margin:0}.inline-col-wrapper .inline-col-content-wrapper .inline-col-description{margin:0;font-size:18px;color:#6e6e6e;font-family:Poppins}@media (max-width:991px){.inline-col-wrapper{grid-template-columns:1fr;grid-gap:16px}.inline-col-wrapper .inline-col-content-wrapper{gap:10px}}@media (max-width:768px) {.inline-col-wrapper .inline-col-image-wrapper img {max-width:100%;}.inline-col-wrapper .inline-col-content-wrapper{max-width:100%;justify-content:center; text-align:center} .section-gap{padding:0 30px; gap:20px;margin-top:24px} .bold-collections{margin-top:32px;}} @media (max-width:525px){.inline-col-wrapper .inline-col-content-wrapper{gap:10px} .inline-col-wrapper .inline-col-content-wrapper .inline-col-title{font-size:20px;line-height:normal} .section-gap{padding:0 15px; gap:15px;margin-top:10px} .bold-collections{margin-top:28px;}  .inline-col-description{font-size:16px !important} .inline-col-wrapper{grid-gap:15px}\"}',NULL),(7,12,'en','{\"services\":[{\"title\":\"Free Shipping\",\"description\":\"Enjoy free shipping on all orders\",\"service_icon\":\"icon-truck\"},{\"title\":\"Product Replace\",\"description\":\"Easy Product Replacement Available!\",\"service_icon\":\"icon-product\"},{\"title\":\"Emi Available\",\"description\":\"No cost EMI available on all major credit cards\",\"service_icon\":\"icon-dollar-sign\"},{\"title\":\"24\\/7 Support\",\"description\":\"Dedicated 24\\/7 support via chat and email\",\"service_icon\":\"icon-support\"}]}',NULL),(8,13,'en','{\"column_1\":[{\"url\":\"http:\\/\\/localhost:8000\\/page\\/about-us\",\"title\":\"About Us\"},{\"url\":\"http:\\/\\/localhost:8000\\/contact-us\",\"title\":\"Contact Us\"},{\"url\":\"http:\\/\\/localhost:8000\\/page\\/customer-service\",\"title\":\"Customer Service\"},{\"url\":\"http:\\/\\/localhost:8000\\/page\\/whats-new\",\"title\":\"What\'s New\"},{\"url\":\"http:\\/\\/localhost:8000\\/page\\/terms-of-use\",\"title\":\"Terms of Use\"},{\"url\":\"http:\\/\\/localhost:8000\\/page\\/terms-conditions\",\"title\":\"Terms & Conditions\"}],\"column_2\":[{\"url\":\"http:\\/\\/localhost:8000\\/page\\/privacy-policy\",\"title\":\"Privacy Policy\"},{\"url\":\"http:\\/\\/localhost:8000\\/page\\/payment-policy\",\"title\":\"Payment Policy\"},{\"url\":\"http:\\/\\/localhost:8000\\/page\\/shipping-policy\",\"title\":\"Shipping Policy\"},{\"url\":\"http:\\/\\/localhost:8000\\/page\\/refund-policy\",\"title\":\"Refund Policy\"},{\"url\":\"http:\\/\\/localhost:8000\\/page\\/return-policy\",\"title\":\"Return Policy\"}]}',NULL);
/*!40000 ALTER TABLE `theme_section_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `theme_sections`
--

DROP TABLE IF EXISTS `theme_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theme_sections` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `theme_code` varchar(255) DEFAULT 'default',
  `type` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL,
  `draft_sort_order` int(11) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `draft_status` tinyint(1) DEFAULT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `theme_customizations_channel_id_foreign` (`channel_id`),
  CONSTRAINT `theme_customizations_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theme_sections`
--

LOCK TABLES `theme_sections` WRITE;
/*!40000 ALTER TABLE `theme_sections` DISABLE KEYS */;
INSERT INTO `theme_sections` VALUES (1,'default','image_carousel','Image Carousel',1,NULL,1,NULL,1,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(2,'default','static_content','Offer Information',2,NULL,1,NULL,1,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(5,'default','static_content','Top Collections',5,NULL,1,NULL,1,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(6,'default','static_content','Bold Collections',6,NULL,1,NULL,1,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(8,'default','static_content','Game Container',8,NULL,1,NULL,1,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(10,'default','static_content','Bold Collections',10,NULL,1,NULL,1,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(12,'default','services_content','Services Content',12,NULL,1,NULL,1,'2026-10-06 13:16:19','2026-10-06 13:16:19'),(13,'default','footer_links','Footer Links',13,NULL,1,NULL,1,'2026-10-06 13:16:19','2026-10-06 13:16:19');
/*!40000 ALTER TABLE `theme_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `url_rewrites`
--

DROP TABLE IF EXISTS `url_rewrites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `url_rewrites` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(255) NOT NULL,
  `request_path` varchar(255) NOT NULL,
  `target_path` varchar(255) NOT NULL,
  `redirect_type` varchar(255) DEFAULT NULL,
  `locale` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `url_rewrites_et_rp_lc_idx` (`entity_type`,`request_path`,`locale`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `url_rewrites`
--

LOCK TABLES `url_rewrites` WRITE;
/*!40000 ALTER TABLE `url_rewrites` DISABLE KEYS */;
/*!40000 ALTER TABLE `url_rewrites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wishlist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `item_options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`item_options`)),
  `moved_to_cart` date DEFAULT NULL,
  `shared` tinyint(1) DEFAULT NULL,
  `time_of_moving` date DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wishlist_channel_id_foreign` (`channel_id`),
  KEY `wishlist_product_id_foreign` (`product_id`),
  KEY `wishlist_customer_id_foreign` (`customer_id`),
  CONSTRAINT `wishlist_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist_items`
--

DROP TABLE IF EXISTS `wishlist_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wishlist_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `moved_to_cart` date DEFAULT NULL,
  `shared` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wishlist_items_channel_id_foreign` (`channel_id`),
  KEY `wishlist_items_product_id_foreign` (`product_id`),
  KEY `wishlist_items_customer_id_foreign` (`customer_id`),
  CONSTRAINT `wishlist_items_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_items_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist_items`
--

LOCK TABLES `wishlist_items` WRITE;
/*!40000 ALTER TABLE `wishlist_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-13 17:47:03
