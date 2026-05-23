/*
 Navicat Premium Data Transfer

 Source Server         : jx
 Source Server Type    : MySQL
 Source Server Version : 80031 (8.0.31)
 Source Host           : localhost:3306
 Source Schema         : product_system

 Target Server Type    : MySQL
 Target Server Version : 80031 (8.0.31)
 File Encoding         : 65001

 Date: 23/02/2025 19:35:32
*/

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS `product_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 使用数据库
USE `product_system`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '联系电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '详细地址',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, 4, '13800138001', '北京市朝阳区某街道1号', '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `address` VALUES (2, 4, '13800138002', '北京市海淀区某街道2号', '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `address` VALUES (3, 5, '13800138003', '上海市浦东新区某街道3号', '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `address` VALUES (4, 2, '13800138004', '广州市天河区某街道4号', '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `address` VALUES (5, 3, '13800138005', '深圳市南山区某街道5号', '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `address` VALUES (8, 8, '15252393509', '15816165', '2025-02-17 09:10:44', '2025-02-17 09:10:44');

-- ----------------------------
-- Table structure for carousel_item
-- ----------------------------
DROP TABLE IF EXISTS `carousel_item`;
CREATE TABLE `carousel_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '轮播图片URL',
  `tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签文本',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述文本',
  `product_id` bigint NOT NULL DEFAULT 0 COMMENT '商品id',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序顺序',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_carousel_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_carousel_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页轮播图表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carousel_item
-- ----------------------------
INSERT INTO `carousel_item` VALUES (1, '/img/1738657068595.png', '钜惠上新', '云南高原红富士苹果', '精选云南高原红富士苹果，果肉细腻，口感甘甜，营养丰富', 1, 1, 1);
INSERT INTO `carousel_item` VALUES (2, '/img/1738656949200.jpg', '新品上市', '有机蔬菜礼盒', '精选时令有机蔬菜，无农药，绿色健康', 5, 2, 1);
INSERT INTO `carousel_item` VALUES (3, '/img/1738657109060.jpg', '产地直供', '新鲜水果礼盒', '全场水果低至7折，新鲜美味，产地直供', 8, 3, 1);
INSERT INTO `carousel_item` VALUES (5, '/img/1738898140804.png', '11', '111', '111', 12, 2, 1);

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '商品数量',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '购物车表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (2, 4, 3, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `cart` VALUES (3, 5, 2, 3, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `cart` VALUES (4, 5, 4, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `cart` VALUES (5, 4, 5, 2, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `cart` VALUES (11, 2, 9, 2, '2025-02-04 13:52:59', '2025-02-04 13:52:59');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '分类描述',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '新鲜水果', '各类新鲜应季水果', '2025-02-03 10:46:11', '2025-02-07 21:03:01', 'el-icon-apple');
INSERT INTO `category` VALUES (2, '时令蔬菜', '当季新鲜蔬菜', '2025-02-03 10:46:11', '2025-02-03 12:05:12', 'el-icon-food');
INSERT INTO `category` VALUES (3, '粮油作物', '稻谷、小麦等粮食作物', '2025-02-03 10:46:11', '2025-02-03 12:05:26', 'el-icon-dessert');
INSERT INTO `category` VALUES (4, '特色农产', '地方特色农产品', '2025-02-03 10:46:11', '2025-02-03 12:05:39', 'el-icon-sugar');
INSERT INTO `category` VALUES (5, '有机农产', '有机认证农产品', '2025-02-03 10:46:11', '2025-02-03 12:05:54', 'el-icon-dish');

-- ----------------------------
-- Table structure for dict_item
-- ----------------------------
DROP TABLE IF EXISTS `dict_item`;
CREATE TABLE `dict_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dict_type_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '关联的字典类型code',
  `item_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典项的键',
  `item_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典项的值',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '字典项的描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `item_key`(`item_key` ASC) USING BTREE,
  INDEX `dict_type_code`(`dict_type_code` ASC) USING BTREE,
  CONSTRAINT `dict_item_ibfk_1` FOREIGN KEY (`dict_type_code`) REFERENCES `sys_dict` (`dict_type_code`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 283 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统字典项表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dict_item (Icon dictionary - truncated for brevity, keeping first 20 entries)
-- ----------------------------
INSERT INTO `dict_item` VALUES (1, 'icon', 'user', 'el-icon-user1', NULL, '2024-07-30 23:06:45', '2025-02-18 14:40:17');
INSERT INTO `dict_item` VALUES (2, 'icon', 'house', 'el-icon-house', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (3, 'icon', 'menu', 'el-icon-menu', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (4, 'icon', 's-custom', 'el-icon-s-custom', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (5, 'icon', 's-grid', 'el-icon-s-grid', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (6, 'icon', 'document', 'el-icon-document', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (7, 'icon', 'coffee', 'el-icon-coffee', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (8, 'icon', 's-marketing', 'el-icon-s-marketing', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (9, 'icon', 'phone-outline', 'el-icon-phone-outline', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (10, 'icon', 'platform-eleme', 'el-icon-platform-eleme', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (11, 'icon', 'eleme', 'el-icon-eleme', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (12, 'icon', 'delete-solid', 'el-icon-delete-solid', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (13, 'icon', 'delete', 'el-icon-delete', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (14, 'icon', 's-tools', 'el-icon-s-tools', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (15, 'icon', 'setting', 'el-icon-setting', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (16, 'icon', 'user-solid', 'el-icon-user-solid', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (17, 'icon', 'phone', 'el-icon-phone', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (18, 'icon', 'more', 'el-icon-more', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (19, 'icon', 'more-outline', 'el-icon-more-outline', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');
INSERT INTO `dict_item` VALUES (20, 'icon', 'star-on', 'el-icon-star-on', NULL, '2024-07-30 23:06:45', '2024-07-30 23:06:45');

-- Note: The dict_item table contains 279 icon entries. For brevity, only showing first 20.
-- Full list available in original script if needed.

-- ----------------------------
-- Table structure for favorite
-- ----------------------------
DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '收藏状态:0取消,1收藏',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `favorite_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `favorite_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of favorite
-- ----------------------------
INSERT INTO `favorite` VALUES (4, 5, 4, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `favorite` VALUES (5, 4, 5, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `favorite` VALUES (7, 4, 22, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (8, 3, 24, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (9, 2, 2, 0, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (11, 5, 19, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (12, 3, 1, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (13, 2, 8, 0, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (15, 4, 7, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (17, 2, 16, 0, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (18, 1, 23, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (20, 5, 24, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (21, 3, 8, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (22, 2, 18, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (23, 1, 18, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (25, 5, 13, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (26, 4, 15, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (27, 3, 9, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (28, 2, 24, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (29, 1, 16, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (31, 5, 4, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (32, 4, 11, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (33, 3, 20, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (34, 2, 14, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (35, 1, 12, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (37, 2, 1, 0, '2025-02-03 20:34:17', '2025-02-03 20:34:17');
INSERT INTO `favorite` VALUES (49, 2, 6, 1, '2025-02-03 21:22:21', '2025-02-03 21:22:21');
INSERT INTO `favorite` VALUES (50, 2, 19, 0, '2025-02-03 21:23:43', '2025-02-03 21:23:43');
INSERT INTO `favorite` VALUES (51, 2, 7, 0, '2025-02-03 21:27:14', '2025-02-03 21:27:14');
INSERT INTO `favorite` VALUES (52, 2, 15, 0, '2025-02-03 21:49:51', '2025-02-03 21:49:51');
INSERT INTO `favorite` VALUES (60, 8, 7, 1, '2025-02-07 11:23:48', '2025-02-07 11:23:48');
INSERT INTO `favorite` VALUES (61, 8, 6, 1, '2025-02-21 10:35:11', '2025-02-21 10:35:11');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `total_price` decimal(10, 2) NOT NULL COMMENT '订单总价',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '订单状态:0待支付,1已支付,2已发货,3已完成,4已取消,5退款中,6已退款,7退款失败',
  `last_status` tinyint NOT NULL DEFAULT 0 COMMENT '上一个订单状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单备注',
  `refund_time` timestamp NULL DEFAULT NULL COMMENT '退款时间',
  `refund_status` tinyint NULL DEFAULT 0 COMMENT '退款状态:0无退款,1申请退款,2退款中,3已退款,4退款失败',
  `refund_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款原因',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL COMMENT '购买数量',
  `price` decimal(10, 2) NOT NULL COMMENT '商品单价',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `recv_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '地址信息',
  `recv_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `product_id`(`product_id` ASC) USING BTREE,
  INDEX `idx_order_user`(`user_id` ASC) USING BTREE COMMENT '订单用户索引',
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `order_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES (2, 4, 59.90, 2, 0, NULL, NULL, 0, NULL, 3, 1, 59.90, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL, NULL);
INSERT INTO `order` VALUES (3, 5, 299.00, 1, 0, NULL, NULL, 0, NULL, 4, 1, 299.00, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL, NULL);
INSERT INTO `order` VALUES (5, 4, 14.40, 4, 0, NULL, NULL, 0, NULL, 5, 3, 4.80, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL, NULL);
INSERT INTO `order` VALUES (6, 1, 47.40, 5, 0, NULL, NULL, 0, NULL, 5, 3, 15.80, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (7, 1, 159.00, 4, 0, NULL, NULL, 0, NULL, 12, 1, 53.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (8, 1, 86.70, 1, 0, NULL, NULL, 0, NULL, 18, 2, 28.90, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (9, 1, 196.50, 0, 0, NULL, NULL, 0, NULL, 22, 1, 65.50, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (10, 1, 75.60, 4, 0, NULL, NULL, 0, NULL, 8, 5, 12.60, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (11, 1, 138.00, 6, 0, NULL, NULL, 0, NULL, 15, 4, 34.50, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (12, 2, 128.40, 2, 0, NULL, NULL, 0, NULL, 3, 2, 42.80, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (13, 2, 89.70, 1, 0, NULL, NULL, 0, NULL, 20, 1, 17.94, '2025-02-03 16:02:13', '2025-02-03 16:02:13', '广州市天河区某街道2号', '13800138004');
INSERT INTO `order` VALUES (14, 2, 156.00, 7, 0, NULL, NULL, 0, NULL, 7, 1, 39.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (15, 2, 234.50, 3, 2, NULL, NULL, 0, NULL, 16, 1, 78.17, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (16, 2, 95.40, 4, 0, NULL, NULL, 0, NULL, 24, 3, 15.90, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (17, 2, 177.00, 7, 0, '', NULL, 0, NULL, 11, 3, 44.25, '2025-02-03 16:02:13', '2025-02-04 13:26:37', NULL, NULL);
INSERT INTO `order` VALUES (18, 3, 147.00, 4, 0, NULL, NULL, 0, NULL, 2, 3, 49.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (19, 3, 88.50, 7, 0, NULL, NULL, 0, NULL, 19, 2, 22.13, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (20, 3, 165.00, 5, 0, NULL, NULL, 0, NULL, 6, 5, 33.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (21, 3, 256.50, 7, 0, NULL, NULL, 0, NULL, 14, 3, 85.50, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (22, 3, 104.40, 1, 0, NULL, NULL, 0, NULL, 23, 1, 17.40, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (23, 3, 198.00, 5, 0, NULL, NULL, 0, NULL, 10, 1, 49.50, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (24, 4, 168.00, 4, 0, NULL, NULL, 0, NULL, 1, 2, 56.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (25, 4, 97.50, 4, 0, NULL, NULL, 0, NULL, 17, 2, 24.38, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (26, 4, 144.00, 3, 0, NULL, NULL, 0, NULL, 4, 1, 28.80, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (27, 4, 289.50, 0, 0, NULL, NULL, 0, NULL, 13, 1, 96.50, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (28, 4, 113.40, 6, 0, NULL, NULL, 0, NULL, 21, 1, 18.90, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (29, 4, 219.00, 2, 0, NULL, NULL, 0, NULL, 9, 4, 54.75, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (31, 5, 106.50, 4, 0, NULL, NULL, 0, NULL, 15, 2, 26.63, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (32, 5, 123.00, 6, 0, NULL, NULL, 0, NULL, 5, 2, 24.60, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (33, 5, 312.50, 4, 0, NULL, NULL, 0, NULL, 11, 1, 104.17, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (34, 5, 122.40, 4, 0, NULL, NULL, 0, NULL, 20, 6, 20.40, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (35, 5, 240.00, 5, 0, NULL, NULL, 0, NULL, 8, 1, 60.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (42, 2, 59.80, 1, 0, NULL, NULL, 0, NULL, 16, 2, 29.90, '2025-02-04 09:45:12', '2025-02-04 10:45:36', '广州市天河区某街道4号', '13800138004');
INSERT INTO `order` VALUES (43, 2, 55.00, 0, 0, NULL, NULL, 0, NULL, 9, 1, 55.00, '2025-02-04 13:54:35', '2025-02-04 13:54:35', '广州市天河区某街道4号', '13800138004');
INSERT INTO `order` VALUES (108, 8, 32.90, 1, 0, NULL, NULL, 0, NULL, 7, 1, 32.90, '2025-02-17 09:10:48', '2025-02-17 09:10:48', '15816165', '15252393509');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `is_discount` tinyint NULL DEFAULT NULL COMMENT '是否开启折扣',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商品描述',
  `price` decimal(10, 2) NOT NULL COMMENT '商品价格',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存数量',
  `category_id` bigint NOT NULL COMMENT '分类ID',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片URL',
  `sales_count` int NOT NULL DEFAULT 0 COMMENT '销量',
  `farmer_id` bigint NOT NULL COMMENT '商家ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '商品状态:0下架,1上架',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `discount_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '折扣价格',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `farmer_id`(`farmer_id` ASC) USING BTREE,
  INDEX `idx_product_name`(`name` ASC) USING BTREE COMMENT '商品名称索引',
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`farmer_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (NULL, 1, '红富士苹果', '山东栖霞红富士苹果，甜度高', 15.80, 1000, 1, '/img/1738583441855.png', 500, 2, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL);
INSERT INTO `product` VALUES (NULL, 2, '有机胡萝卜', '绿色种植无农药胡萝卜', 3.50, 490, 2, '/img/1738583800211.jpg', 210, 2, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL);
INSERT INTO `product` VALUES (NULL, 3, '东北大米', '黑龙江五常大米，珍珠米', 59.90, 997, 3, '/img/1738583812449.jpg', 300, 3, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL);
INSERT INTO `product` VALUES (NULL, 4, '云南松茸', '云南野生松茸，鲜嫩可口', 299.00, 100, 4, '/img/1738583821169.jpg', 50, 3, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL);
INSERT INTO `product` VALUES (NULL, 5, '有机生菜', '温室种植有机生菜', 4.80, 196, 5, '/img/1738583838818.jpg', 150, 2, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL);
INSERT INTO `product` VALUES (NULL, 7, '陕西猕猴桃', '眉县徐香猕猴桃，营养丰富', 32.90, 98, 1, '/img/1738583862059.jpeg', 1281, 3, 1, '2025-02-03 10:46:53', '2025-02-10 15:02:58', NULL);
INSERT INTO `product` VALUES (NULL, 8, '广西百香果', '新鲜采摘百香果，酸甜可口', 23.50, 400, 1, '/img/1738584263429.jpeg', 150, 2, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 10, '山东大葱', '章丘大葱，鲜嫩爽口', 5.80, 800, 2, '/img/1738583935639.jpeg', 420, 2, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 11, '四川青花椒', '汉源青花椒，麻味十足', 28.90, 198, 2, '/img/1738583949066.jpeg', 91, 2, 1, '2025-02-03 10:46:53', '2025-02-04 13:26:22', NULL);
INSERT INTO `product` VALUES (NULL, 12, '云南小黄姜', '文山小黄姜，新鲜辛香', 12.50, 600, 2, '/img/1738583968036.jpeg', 230, 2, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 13, '潍坊萝卜', '潍坊青萝卜，清脆可口', 3.90, 1000, 2, '/img/1738584031795.jpeg', 580, 3, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 14, '黑龙江黄豆', '东北非转基因黄豆', 15.80, 2000, 3, '/img/1738584049511.jpeg', 680, 2, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 15, '湖南茶油', '野生山茶油，物理压榨', 168.00, 200, 3, '/img/1738584057203.jpg', 120, 3, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 16, '河南小麦粉', '优质面粉，筋度适中', 29.90, 1498, 3, '/img/1738584111103.jpg', 452, 2, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 17, '内蒙古小米', '赤峰小米，黄金粒', 25.80, 1000, 3, '/img/1738584167430.jpeg', 380, 3, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 18, '新疆红枣', '和田大枣，肉厚核小', 46.80, 500, 4, '/img/1738584187227.jpeg', 280, 2, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 19, '西湖龙井', '明前龙井茶，清香持久', 288.00, 98, 4, '/img/1738584197286.jpeg', 61, 3, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (1, 20, '云南花椒', '<p>大理花椒，麻味浓郁</p>', 58.90, 300, 4, '/img/1738584246224.jpeg', 150, 2, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', 48.90);
INSERT INTO `product` VALUES (NULL, 21, '安徽毛豆', '江淮鲜毛豆，饱满翠绿', 8.80, 600, 4, '/img/1738584342382.jpeg', 320, 3, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 22, '有机西红柿', '温室种植有机番茄', 9.90, 400, 5, '/img/1738584354484.jpeg', 280, 2, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 23, '有机菠菜', '无农药绿色菠菜', 6.80, 300, 5, '/img/1738584422080.jpg', 220, 3, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);
INSERT INTO `product` VALUES (NULL, 24, '有机土豆', '马铃薯，无农药种植', 8.50, 797, 5, '/img/1738584387775.jpg', 463, 2, 1, '2025-02-03 10:46:53', '2025-02-03 10:46:53', NULL);

-- ----------------------------
-- Table structure for review
-- ----------------------------
DROP TABLE IF EXISTS `review`;
CREATE TABLE `review`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `rating` tinyint NOT NULL COMMENT '评分(1-5星)',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评价内容',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '评价状态:0待审核,1已通过,2已拒绝',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_review_product`(`product_id` ASC) USING BTREE COMMENT '评价商品索引',
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `review_chk_1` CHECK (`rating` between 1 and 5)
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of review
-- ----------------------------
INSERT INTO `review` VALUES (1, 4, 1, 5, '苹果非常甜，很好吃！', 1, '2025-02-03 10:46:11');
INSERT INTO `review` VALUES (2, 4, 3, 4, '大米品质不错', 1, '2025-02-03 10:46:11');
INSERT INTO `review` VALUES (3, 5, 2, 5, '胡萝卜新鲜爽脆', 1, '2025-02-03 10:46:11');
INSERT INTO `review` VALUES (4, 5, 4, 5, '松茸很新鲜，味道好极了', 1, '2025-02-03 10:46:11');
INSERT INTO `review` VALUES (5, 4, 5, 4, '生菜很新鲜', 0, '2025-02-03 10:46:11');

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dict_type_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典编码',
  `dict_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dict_type_code`(`dict_type_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统字典表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES (1, 'icon', '图标', '系统图标字典表', 0, '2024-07-30 21:53:19', '2024-07-30 21:53:19');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `role` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单角色',
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '菜单名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '菜单路径',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `pid` int NULL DEFAULT NULL COMMENT '菜单父id',
  `page_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '页面路径',
  `sort_num` int NULL DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 1, '数据概览', '/showView', 'el-icon-s-data', '系统数据统计', NULL, 'ShowView', 1);
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 2, '个人中心', NULL, 'el-icon-user', '用户个人信息管理', NULL, NULL, 2);
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 3, '基本信息', '/personInfo', 'el-icon-info', NULL, 2, 'PersonInfo', 1);
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 4, '修改密码', '/password', 'el-icon-lock', NULL, 2, 'Password', 2);
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 10, '商品管理', NULL, 'el-icon-shopping-bag-1', '农产品相关管理', NULL, NULL, 3);
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 11, '农产品列表', '/productManager', 'el-icon-shopping-cart-full', NULL, 10, 'ProductManager', 1);
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN', 12, '商品分类', '/categoryManager', 'el-icon-folder', NULL, 10, 'CategoryManager', 2);
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 20, '交易管理', NULL, 'el-icon-shopping-cart-2', '订单相关管理', NULL, NULL, 4);
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 21, '订单列表', '/orderManager', 'el-icon-document', NULL, 20, 'OrderManager', 1);
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN', 22, '购物车', '/cartManager', 'el-icon-shopping-cart-1', NULL, 20, 'CartManager', 2);
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN', 23, '商品评价', '/reviewManager', 'el-icon-chat-dot-square', NULL, 20, 'ReviewManager', 3);
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN', 30, '系统管理', NULL, 'el-icon-setting', '系统相关配置', NULL, NULL, 5);
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN', 31, '用户管理', '/userManager', 'el-icon-user', NULL, 30, 'UserManager', 1);
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 32, '通知公告', '/notices', 'el-icon-bell', NULL, 30, 'NoticeList', 2);
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 33, '轮播图', '/carouselManager', 'el-icon-picture', NULL, 30, 'CarouselManager', 3);
INSERT INTO `sys_menu` VALUES ('SUPER_ADMIN', 40, '开发配置', NULL, 'el-icon-s-tools', '系统开发配置', NULL, NULL, 6);
INSERT INTO `sys_menu` VALUES ('SUPER_ADMIN', 41, '菜单管理', '/menu', 'el-icon-menu', NULL, 40, 'Menu', 1);
INSERT INTO `sys_menu` VALUES ('SUPER_ADMIN', 42, '图标库', '/iconItem', 'el-icon-picture-outline-round', NULL, 40, 'IconItem', 2);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '真实姓名',
  `role` enum('SUPER_ADMIN','ADMIN','FARMER','USER') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'USER' COMMENT '用户角色',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '电子邮箱',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '账号状态(0禁用,1启用)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_user_username`(`username` ASC) USING BTREE COMMENT '用户名索引'
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'Sadmin', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '系统管理员', 'SUPER_ADMIN', 'admin@example.com', 1, '2025-02-03 10:46:11', '2025-02-03 11:26:45');
INSERT INTO `user` VALUES (2, 'farmer1', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '张农夫', 'FARMER', 'farmer1@example.com', 1, '2025-02-03 10:46:11', '2025-02-03 17:14:38');
INSERT INTO `user` VALUES (3, 'farmer2', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '李农夫', 'FARMER', 'farmer2@example.com', 1, '2025-02-03 10:46:11', '2025-02-04 21:25:10');
INSERT INTO `user` VALUES (4, 'user1', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '王小明', 'USER', 'user1@example.com', 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `user` VALUES (5, 'user2', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '李小红', 'USER', 'user2@example.com', 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `user` VALUES (7, 'admin', '$2a$10$b9no1M1aC2IfqbO7Jt1LjuRd2P1hy4kPiMhp42PJBS8zb2jOuS/Vm', '管理员1', 'ADMIN', 'admin@qq.com', 1, '2025-02-04 20:22:32', '2025-02-04 20:22:46');
INSERT INTO `user` VALUES (8, 'ftfx666', '$2a$10$UO9HRLTzevXecsjrBoWvi.5SV0zRBS9WFkAIAD7c2lpbOBUHB..9G', 'jx', 'USER', '1796145608@qq.com', 1, '2025-02-07 10:49:19', '2025-02-07 10:49:19');

SET FOREIGN_KEY_CHECKS = 1;

