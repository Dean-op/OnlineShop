/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80407
 Source Host           : localhost:3306
 Source Schema         : product_system

 Target Server Type    : MySQL
 Target Server Version : 80407
 File Encoding         : 65001

 Date: 22/05/2026 22:12:48
*/

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '收货地址表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (3, 5, '13800138003', '上海市浦东新区某街道3号', '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `address` VALUES (5, 3, '13800138005', '深圳市南山区某街道5号', '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `address` VALUES (9, 16, '13700137001', '北京市海淀区中关村大街1号', '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `address` VALUES (10, 16, '13700137002', '北京市朝阳区建国门外大街2号', '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `address` VALUES (11, 17, '13700137003', '上海市黄浦区南京东路3号', '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `address` VALUES (12, 18, '13700137004', '广州市天河区天河路4号', '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `address` VALUES (13, 19, '13700137005', '深圳市南山区科技园5号', '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `address` VALUES (14, 20, '13700137006', '杭州市西湖区文一西路6号', '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `address` VALUES (15, 23, '19712000931', 'sxd', '2026-02-05 18:47:44', '2026-02-05 18:47:44');
INSERT INTO `address` VALUES (16, 25, '19712000931', '山东省龙口是', '2026-04-29 15:59:36', '2026-04-29 15:59:36');

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页轮播图表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carousel_item
-- ----------------------------
INSERT INTO `carousel_item` VALUES (1, '/img/1738657068595.png', '钜惠上新', '云南高原红富士苹果', '精选云南高原红富士苹果，果肉细腻，口感甘甜，营养丰富', 1, 1, 1);
INSERT INTO `carousel_item` VALUES (2, '/img/1738656949200.jpg', '新品上市', '有机蔬菜礼盒', '精选时令有机蔬菜，无农药，绿色健康', 5, 2, 1);
INSERT INTO `carousel_item` VALUES (3, '/img/1738657109060.jpg', '产地直供', '新鲜水果礼盒', '全场水果低至7折，新鲜美味，产地直供', 8, 3, 1);
INSERT INTO `carousel_item` VALUES (6, '/img/1738656784943.jpeg', '数码狂欢', 'iPhone 15 Pro限时特惠', '旗舰手机大促销，立减700元，数量有限先到先得', 27, 6, 1);
INSERT INTO `carousel_item` VALUES (7, '/img/1738896109540.png', '春季新品', '春装上新 焕新出发', '运动服饰全场8折，舒适时尚，让运动更自由', 33, 7, 1);
INSERT INTO `carousel_item` VALUES (8, '/img/1738898118895.png', '美妆盛典', 'SK-II神仙水特价', '大牌护肤品限时优惠，宠爱自己从肌肤开始', 55, 8, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '购物车表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (3, 5, 2, 3, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `cart` VALUES (4, 5, 4, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `cart` VALUES (11, 2, 9, 2, '2025-02-04 13:52:59', '2025-02-04 13:52:59');
INSERT INTO `cart` VALUES (19, 16, 32, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `cart` VALUES (20, 16, 40, 2, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `cart` VALUES (21, 17, 47, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `cart` VALUES (22, 18, 53, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `cart` VALUES (23, 18, 66, 2, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `cart` VALUES (24, 19, 48, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `cart` VALUES (25, 20, 65, 3, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `cart` VALUES (27, 5, 59, 2, '2025-11-04 14:39:15', '2025-11-04 14:39:15');

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
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '新鲜水果', '各类新鲜应季水果', '2025-02-03 10:46:11', '2025-02-07 21:03:01', 'el-icon-apple');
INSERT INTO `category` VALUES (2, '时令蔬菜', '当季新鲜蔬菜', '2025-02-03 10:46:11', '2025-02-03 12:05:12', 'el-icon-food');
INSERT INTO `category` VALUES (3, '粮油作物', '稻谷、小麦等粮食作物', '2025-02-03 10:46:11', '2025-02-03 12:05:26', 'el-icon-dessert');
INSERT INTO `category` VALUES (4, '特色农产', '地方特色农产品', '2025-02-03 10:46:11', '2025-02-03 12:05:39', 'el-icon-sugar');
INSERT INTO `category` VALUES (5, '有机农产', '有机认证农产品', '2025-02-03 10:46:11', '2025-02-03 12:05:54', 'el-icon-dish');
INSERT INTO `category` VALUES (8, '数码电器', '手机、电脑、平板、智能设备等', '2025-11-04 14:39:15', '2025-11-04 14:39:15', 'el-icon-mobile-phone');
INSERT INTO `category` VALUES (9, '服装鞋包', '男装、女装、鞋子、箱包配饰', '2025-11-04 14:39:15', '2025-11-04 14:39:15', 'el-icon-shopping-bag-2');
INSERT INTO `category` VALUES (10, '图书文娱', '图书、文具、乐器、影音娱乐', '2025-11-04 14:39:15', '2025-11-04 14:39:15', 'el-icon-reading');
INSERT INTO `category` VALUES (11, '家居生活', '家具、厨具、家纺、收纳用品', '2025-11-04 14:39:15', '2025-11-04 14:39:15', 'el-icon-house');
INSERT INTO `category` VALUES (12, '运动户外', '运动器材、户外装备、健身用品', '2025-11-04 14:39:15', '2025-11-04 14:39:15', 'el-icon-trophy');
INSERT INTO `category` VALUES (13, '美妆个护', '护肤、彩妆、个人护理用品', '2025-11-04 14:39:15', '2025-11-04 14:39:15', 'el-icon-present');
INSERT INTO `category` VALUES (14, '母婴玩具', '婴儿用品、儿童玩具、童装', '2025-11-04 14:39:15', '2025-11-04 14:39:15', 'el-icon-shopping-cart-full');
INSERT INTO `category` VALUES (15, '食品饮料', '零食、饮料、酒水、进口食品', '2025-11-04 14:39:15', '2025-11-04 14:39:15', 'el-icon-coffee-cup');

-- ----------------------------
-- Table structure for complaint
-- ----------------------------
DROP TABLE IF EXISTS `complaint`;
CREATE TABLE `complaint`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '投诉ID',
  `order_id` bigint NULL DEFAULT NULL COMMENT '订单ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `merchant_id` bigint NULL DEFAULT NULL COMMENT '商家ID',
  `type` int NULL DEFAULT 5 COMMENT '投诉类型：1-商品质量 2-服务态度 3-物流问题 4-虚假宣传 5-其他',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '投诉标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '投诉内容',
  `images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片证据，多个用逗号分隔',
  `status` int NULL DEFAULT 0 COMMENT '投诉状态：0-待处理 1-处理中 2-已解决 3-已关闭',
  `merchant_reply` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '商家回复',
  `admin_reply` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '管理员处理意见',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单投诉表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of complaint
-- ----------------------------
INSERT INTO `complaint` VALUES (1, 133, 23, NULL, 1, '001', '001', '', 0, '001', '001', '2026-05-22 21:35:26', '2026-05-22 21:48:42');
INSERT INTO `complaint` VALUES (2, 134, 23, NULL, 1, 'test', 'test', NULL, 2, NULL, 'test', '2026-05-22 21:53:54', '2026-05-22 21:56:22');

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
-- Records of dict_item
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
) ENGINE = InnoDB AUTO_INCREMENT = 83 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of favorite
-- ----------------------------
INSERT INTO `favorite` VALUES (4, 5, 4, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `favorite` VALUES (8, 3, 24, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (9, 2, 2, 0, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (11, 5, 19, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (13, 2, 8, 0, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (17, 2, 16, 0, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (18, 1, 23, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (20, 5, 24, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (21, 3, 8, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (22, 2, 18, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (23, 1, 18, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (25, 5, 13, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (27, 3, 9, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (28, 2, 24, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (29, 1, 16, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (31, 5, 4, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (33, 3, 20, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (34, 2, 14, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (35, 1, 12, 1, '2025-02-03 16:02:13', '2025-02-03 16:02:13');
INSERT INTO `favorite` VALUES (49, 2, 6, 1, '2025-02-03 21:22:21', '2025-02-03 21:22:21');
INSERT INTO `favorite` VALUES (50, 2, 19, 0, '2025-02-03 21:23:43', '2025-02-03 21:23:43');
INSERT INTO `favorite` VALUES (51, 2, 7, 0, '2025-02-03 21:27:14', '2025-02-03 21:27:14');
INSERT INTO `favorite` VALUES (52, 2, 15, 0, '2025-02-03 21:49:51', '2025-02-03 21:49:51');
INSERT INTO `favorite` VALUES (62, 16, 27, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (63, 16, 31, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (64, 16, 30, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (65, 17, 38, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (66, 17, 56, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (67, 18, 52, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (68, 18, 54, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (69, 19, 45, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (70, 19, 49, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (71, 20, 62, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (72, 20, 61, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (74, 5, 58, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `favorite` VALUES (75, 23, 7, 0, '2026-02-05 19:07:06', '2026-02-05 19:07:06');
INSERT INTO `favorite` VALUES (76, 23, 28, 0, '2026-02-05 19:07:08', '2026-02-05 19:07:08');
INSERT INTO `favorite` VALUES (77, 25, 27, 1, '2026-04-29 16:00:22', '2026-04-29 16:00:22');
INSERT INTO `favorite` VALUES (78, 23, 40, 0, '2026-05-20 16:16:52', '2026-05-20 16:16:52');
INSERT INTO `favorite` VALUES (79, 23, 33, 0, '2026-05-20 16:16:56', '2026-05-20 16:16:56');
INSERT INTO `favorite` VALUES (80, 23, 64, 0, '2026-05-21 22:34:40', '2026-05-21 22:34:40');
INSERT INTO `favorite` VALUES (81, 23, 35, 0, '2026-05-22 22:02:51', '2026-05-22 22:02:51');
INSERT INTO `favorite` VALUES (82, 23, 69, 0, '2026-05-22 22:02:56', '2026-05-22 22:02:56');

-- ----------------------------
-- Table structure for forum
-- ----------------------------
DROP TABLE IF EXISTS `forum`;
CREATE TABLE `forum`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `type` int NULL DEFAULT 1 COMMENT '帖子类型：1-普通话题 2-商品文化分享',
  `product_id` bigint NULL DEFAULT NULL COMMENT '关联商品ID（商家分享时使用）',
  `scenic_id` bigint NULL DEFAULT NULL COMMENT '关联景点ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '帖子标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '帖子内容',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '封面图片',
  `images` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片列表，多个用逗号分隔',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览量',
  `like_count` int NULL DEFAULT 0 COMMENT '点赞数',
  `reply_count` int NULL DEFAULT 0 COMMENT '回复数',
  `status` int NULL DEFAULT 1 COMMENT '状态：0-待审核 1-已发布 2-已下架',
  `is_top` int NULL DEFAULT 0 COMMENT '是否置顶：0-否 1-是',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  INDEX `idx_type`(`type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_scenic_id`(`scenic_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文化论坛帖子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum
-- ----------------------------
INSERT INTO `forum` VALUES (1, 22, 1, NULL, NULL, '1', '1', '', NULL, 4, 1, 1, 1, 0, '2025-12-24 02:31:26', '2025-12-24 02:31:26');
INSERT INTO `forum` VALUES (2, 22, 2, NULL, NULL, '1', '1', '/img/1766514852416.jpg', NULL, 3, 18, 0, 1, 0, '2025-12-24 02:34:15', '2025-12-24 02:34:15');
INSERT INTO `forum` VALUES (3, 25, 1, NULL, 3, '1', '和，的故事发生', '', NULL, 2, 0, 1, 1, 0, '2026-04-29 16:05:09', '2026-05-22 00:47:27');

-- ----------------------------
-- Table structure for forum_reply
-- ----------------------------
DROP TABLE IF EXISTS `forum_reply`;
CREATE TABLE `forum_reply`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '回复ID',
  `forum_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父回复ID（回复的回复）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '回复内容',
  `like_count` int NULL DEFAULT 0 COMMENT '点赞数',
  `status` int NULL DEFAULT 0 COMMENT '状态：0-正常 1-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_forum_id`(`forum_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '论坛回复表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_reply
-- ----------------------------
INSERT INTO `forum_reply` VALUES (1, 1, 22, NULL, '1', 0, 0, '2025-12-24 02:34:05');
INSERT INTO `forum_reply` VALUES (2, 3, 25, NULL, 'ask', 0, 0, '2026-04-29 16:05:20');

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
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (33, '618年中大促预热', '618购物狂欢节即将来袭！全场满300减50，满600减120，部分爆款商品更有5折起优惠，敬请期待！', '2025-11-04 14:39:15');
INSERT INTO `notice` VALUES (34, '新用户专享福利', '新用户注册即送100元无门槛优惠券，首单立减！同时赠送会员积分，积分可兑换更多好礼。', '2025-11-04 14:39:15');
INSERT INTO `notice` VALUES (35, '物流配送时效升级', '为提升购物体验，我们已全面升级物流配送系统。主要城市支持当日达/次日达服务，让您更快收到心仪商品！', '2025-11-04 14:39:15');
INSERT INTO `notice` VALUES (36, '正品保障承诺', '商城所有商品均为正品保证，支持7天无理由退换货，假一赔十，让您购物更放心！', '2025-11-04 14:39:15');

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
  `platform_intervention` tinyint NULL DEFAULT 0 COMMENT '骞冲彴浠嬪叆鐘舵?:0鏈?粙鍏?1鐢ㄦ埛鐢宠?浠嬪叆,2骞冲彴澶勭悊涓?3骞冲彴宸蹭粙鍏',
  `platform_intervention_time` timestamp NULL DEFAULT NULL COMMENT '骞冲彴浠嬪叆鏃堕棿',
  `platform_intervention_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鐢ㄦ埛鐢宠?骞冲彴浠嬪叆鐨勫師鍥',
  `platform_handler_id` bigint NULL DEFAULT NULL COMMENT '骞冲彴澶勭悊浜哄憳ID',
  `platform_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '骞冲彴澶勭悊澶囨敞',
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
) ENGINE = InnoDB AUTO_INCREMENT = 140 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES (3, 5, 299.00, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 4, 1, 299.00, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL, NULL);
INSERT INTO `order` VALUES (6, 1, 47.40, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 5, 3, 15.80, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (7, 1, 159.00, 4, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 12, 1, 53.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (8, 1, 86.70, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 18, 2, 28.90, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (9, 1, 196.50, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 22, 1, 65.50, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (10, 1, 75.60, 4, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 8, 5, 12.60, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (11, 1, 138.00, 6, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 15, 4, 34.50, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (18, 3, 147.00, 4, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 2, 3, 49.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (19, 3, 88.50, 7, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 19, 2, 22.13, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (20, 3, 165.00, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 6, 5, 33.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (21, 3, 256.50, 7, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 14, 3, 85.50, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (22, 3, 104.40, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 23, 1, 17.40, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (23, 3, 198.00, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 10, 1, 49.50, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (31, 5, 106.50, 4, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 15, 2, 26.63, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (32, 5, 123.00, 6, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 5, 2, 24.60, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (33, 5, 312.50, 4, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 11, 1, 104.17, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (34, 5, 122.40, 4, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 20, 6, 20.40, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (35, 5, 240.00, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 8, 1, 60.00, '2025-02-03 16:02:13', '2025-02-03 16:02:13', NULL, NULL);
INSERT INTO `order` VALUES (109, 16, 7299.00, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 27, 1, 7299.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '北京市海淀区中关村大街1号', '13700137001');
INSERT INTO `order` VALUES (110, 16, 1398.00, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 33, 2, 699.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '北京市海淀区中关村大街1号', '13700137001');
INSERT INTO `order` VALUES (111, 16, 128.00, 2, 1, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 39, 1, 128.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '北京市朝阳区建国门外大街2号', '13700137002');
INSERT INTO `order` VALUES (112, 17, 1490.00, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 55, 1, 1490.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '上海市黄浦区南京东路3号', '13700137003');
INSERT INTO `order` VALUES (113, 17, 549.00, 3, 2, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 37, 1, 549.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '上海市黄浦区南京东路3号', '13700137003');
INSERT INTO `order` VALUES (114, 18, 8999.00, 2, 1, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 31, 1, 8999.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '广州市天河区天河路4号', '13700137004');
INSERT INTO `order` VALUES (115, 18, 399.00, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 51, 1, 399.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '广州市天河区天河路4号', '13700137004');
INSERT INTO `order` VALUES (116, 19, 469.00, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 46, 1, 469.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '深圳市南山区科技园5号', '13700137005');
INSERT INTO `order` VALUES (117, 19, 258.00, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 50, 2, 129.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '深圳市南山区科技园5号', '13700137005');
INSERT INTO `order` VALUES (118, 20, 479.00, 2, 1, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 60, 1, 479.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '杭州市西湖区文一西路6号', '13700137006');
INSERT INTO `order` VALUES (119, 20, 278.00, 3, 2, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 63, 2, 139.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '杭州市西湖区文一西路6号', '13700137006');
INSERT INTO `order` VALUES (121, 5, 936.00, 2, 1, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 57, 2, 468.00, '2025-11-04 14:39:15', '2025-11-04 14:39:15', '上海市浦东新区某街道3号', '13800138003');
INSERT INTO `order` VALUES (123, 23, 5999.00, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 28, 1, 5999.00, '2026-02-05 18:47:54', '2026-02-05 18:48:14', 'sxd', '19712000931');
INSERT INTO `order` VALUES (124, 23, 5999.00, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 28, 1, 5999.00, '2026-02-05 19:07:21', '2026-05-01 13:37:00', 'sxd', '19712000931');
INSERT INTO `order` VALUES (125, 23, 299.00, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 4, 1, 299.00, '2026-02-24 21:59:37', '2026-02-24 21:59:52', 'sxd', '19712000931');
INSERT INTO `order` VALUES (126, 23, 6556.00, 6, 0, '', '2026-02-24 22:12:21', 3, NULL, 3, '2026-02-24 22:11:52', '3563565655656', 1, '4155', 67, 1, 6556.00, '2026-02-24 22:06:56', '2026-02-24 22:07:16', 'sxd', '19712000931');
INSERT INTO `order` VALUES (127, 25, 7299.00, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 27, 1, 7299.00, '2026-04-29 16:02:42', '2026-04-29 16:02:42', '山东省龙口是', '19712000931');
INSERT INTO `order` VALUES (128, 23, 6556.00, 7, 0, '', NULL, 0, NULL, 1, '2026-05-01 14:54:40', '方式是三份 士大夫士大夫s', NULL, NULL, 67, 1, 6556.00, '2026-04-29 16:13:35', '2026-05-01 14:53:34', 'sxd', '19712000931');
INSERT INTO `order` VALUES (129, 23, 89.00, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 40, 1, 89.00, '2026-05-01 14:50:52', '2026-05-01 14:52:36', 'sxd', '19712000931');
INSERT INTO `order` VALUES (130, 23, 79.00, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 64, 1, 79.00, '2026-05-01 14:50:52', '2026-05-22 12:50:13', 'sxd', '19712000931');
INSERT INTO `order` VALUES (131, 23, 55.00, 6, 3, '', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 68, 1, 55.00, '2026-05-01 14:52:51', '2026-05-22 15:26:00', 'sxd', '19712000931');
INSERT INTO `order` VALUES (132, 23, 89.00, 5, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 40, 1, 89.00, '2026-05-20 16:18:29', '2026-05-20 16:18:44', 'sxd', '19712000931');
INSERT INTO `order` VALUES (133, 23, 7299.00, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 27, 1, 7299.00, '2026-05-20 16:59:26', '2026-05-20 16:59:26', 'sxd', '19712000931');
INSERT INTO `order` VALUES (134, 23, 55.00, 2, 1, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 68, 1, 55.00, '2026-05-20 17:01:14', '2026-05-20 17:01:14', 'sxd', '19712000931');
INSERT INTO `order` VALUES (135, 23, 52330.00, 3, 2, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 69, 52330, 1.00, '2026-05-21 22:37:56', '2026-05-21 22:37:56', 'sxd', '19712000931');
INSERT INTO `order` VALUES (136, 23, 1.00, 3, 2, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 69, 1, 1.00, '2026-05-22 12:41:49', '2026-05-22 12:41:49', 'sxd', '19712000931');
INSERT INTO `order` VALUES (137, 23, 1.00, 6, 1, '', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 69, 1, 1.00, '2026-05-22 13:54:38', '2026-05-22 15:27:04', 'sxd', '19712000931');
INSERT INTO `order` VALUES (138, 23, 1.00, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 69, 1, 1.00, '2026-05-22 15:26:26', '2026-05-22 15:26:26', 'sxd', '19712000931');
INSERT INTO `order` VALUES (139, 23, 599.00, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, 36, 1, 599.00, '2026-05-22 21:57:19', '2026-05-22 21:57:19', 'sxd', '19712000931');

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
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (NULL, 1, '红富士苹果', '山东栖霞红富士苹果，甜度高', 15.80, 1000, 1, '/img/1738583441855.png', 500, 2, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL);
INSERT INTO `product` VALUES (NULL, 2, '有机胡萝卜', '绿色种植无农药胡萝卜', 3.50, 490, 2, '/img/1738583800211.jpg', 210, 2, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL);
INSERT INTO `product` VALUES (NULL, 3, '东北大米', '黑龙江五常大米，珍珠米', 59.90, 997, 3, '/img/1738583812449.jpg', 300, 3, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL);
INSERT INTO `product` VALUES (NULL, 4, '云南松茸', '云南野生松茸，鲜嫩可口', 299.00, 98, 4, '/img/1738583821169.jpg', 51, 3, 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11', NULL);
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
INSERT INTO `product` VALUES (1, 27, 'Apple iPhone 15 Pro', '<p>A17 Pro芯片，钛金属边框，48MP主摄，支持USB-C接口</p>', 7999.00, 496, 8, '/img/1779375780451.png', 1258, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 7299.00);
INSERT INTO `product` VALUES (NULL, 28, '小米14 Ultra', '<p>骁龙8 Gen3旗舰芯片，徕卡光学镜头，120W快充</p>', 5999.00, 296, 8, '/img/1779375833476.png', 894, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 29, '华为MatePad Pro', '<p>13.2英寸OLED屏幕，麒麟9000S芯片，支持手写笔</p>', 4299.00, 200, 8, '/img/1779375859500.png', 0, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 3899.00);
INSERT INTO `product` VALUES (NULL, 30, 'Sony WH-1000XM5', '<p>业界顶级降噪，30小时续航，支持LDAC高清音质</p>', 2499.00, 150, 8, '/img/1779375902159.png', 0, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 31, '戴尔XPS 13', '<p>13代酷睿i7，16GB内存，512GB固态，3.5K OLED屏</p>', 9999.00, 100, 8, '/img/1779375939230.png', 0, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 8999.00);
INSERT INTO `product` VALUES (NULL, 32, 'Apple Watch Series 9', 'S9芯片，双击手势，18小时续航，GPS+蜂窝', 3199.00, 250, 8, '/img/1738583849407.jpg', 0, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 33, 'Nike Air Max 270', '<p>气垫缓震运动鞋，透气网面，时尚百搭</p>', 899.00, 500, 9, '/img/1779375635566.png', 2340, 11, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 699.00);
INSERT INTO `product` VALUES (NULL, 34, 'Adidas三叶草卫衣', '<p>经典款连帽卫衣，纯棉面料，多色可选</p>', 399.00, 800, 9, '/img/1779375714305.png', 1876, 11, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 35, '优衣库摇粒绒外套', '<p>轻便保暖，防风防泼水，多个口袋设计</p>', 199.00, 1000, 9, '/img/1779375551606.png', 3245, 11, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 149.00);
INSERT INTO `product` VALUES (NULL, 36, 'Levi\'s 501牛仔裤', '<p>经典直筒版型，100%纯棉牛仔布，耐穿百搭</p>', 599.00, 599, 9, '/img/1779375970917.png', 0, 11, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 37, '新秀丽拉杆箱', '20寸登机箱，TSA海关锁，静音万向轮', 699.00, 300, 9, '/img/1738583949066.jpeg', 0, 11, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 549.00);
INSERT INTO `product` VALUES (NULL, 38, 'Coach经典款手提包', '真皮材质，简约时尚，多隔层设计', 1899.00, 150, 9, '/img/1738583968036.jpeg', 0, 11, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 39, '《三体》全集', '<p>刘慈欣科幻巨著，雨果奖获奖作品，精装典藏版</p>', 168.00, 1000, 10, '/img/1779375521866.png', 4567, 12, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 128.00);
INSERT INTO `product` VALUES (NULL, 40, '晨光文具套装', '<p>包含笔记本、签字笔、荧光笔等，学生必备</p>', 89.00, 1996, 10, '/img/1779375490448.png', 5680, 12, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (NULL, 41, '得力计算器', '科学计算器，双行显示，太阳能供电', 45.00, 1500, 10, '/img/1738584057203.jpg', 0, 12, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 42, '《人类简史》', '尤瓦尔赫拉利畅销书，探索人类进化历程', 68.00, 800, 10, '/img/1738584111103.jpg', 0, 12, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 52.00);
INSERT INTO `product` VALUES (NULL, 43, '雅马哈尤克里里', '23寸入门款，音色清亮，适合初学者', 399.00, 200, 10, '/img/1738584167430.jpeg', 0, 12, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 44, '无印良品收纳箱', '<p>环保PP材质，透明可视，可叠放设计</p>', 79.00, 1000, 11, '/img/1779375683245.png', 2134, 13, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 59.00);
INSERT INTO `product` VALUES (NULL, 45, '九阳破壁机', '1200W大功率，8叶精钢刀头，静音设计', 499.00, 300, 11, '/img/1738584197286.jpeg', 987, 13, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 46, '美的电饭煲', '4L容量IH电磁加热，24小时预约，多功能', 599.00, 400, 11, '/img/1738584233484.jpeg', 0, 13, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 469.00);
INSERT INTO `product` VALUES (NULL, 47, '全棉时代毛巾套装', '纯棉面料，柔软吸水，5条装礼盒', 129.00, 800, 11, '/img/1738584246224.jpeg', 0, 13, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (NULL, 48, '宜家置物架', '三层金属置物架，承重强，简约北欧风', 199.00, 500, 11, '/img/1738584263429.jpeg', 0, 13, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 49, '飞利浦台灯', '护眼LED台灯，无频闪，三档调光', 299.00, 350, 11, '/img/1738584342382.jpeg', 0, 13, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 249.00);
INSERT INTO `product` VALUES (1, 50, 'Keep瑜伽垫', '<p>TPE环保材质，10mm加厚，防滑耐磨</p>', 169.00, 600, 12, '/img/1779375748472.png', 1543, 14, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 129.00);
INSERT INTO `product` VALUES (NULL, 51, '迪卡侬登山包', '50L大容量，防水防撕裂，透气背负系统', 399.00, 300, 12, '/img/1738584375766.jpeg', 0, 14, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 52, '李宁篮球鞋', '云减震科技，包裹性好，耐磨橡胶外底', 599.00, 400, 12, '/img/1738584387775.jpg', 0, 14, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 459.00);
INSERT INTO `product` VALUES (NULL, 53, '安踏运动套装', '速干面料，透气舒适，春秋季节适用', 299.00, 700, 12, '/img/1738584422080.jpg', 0, 14, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 54, '骆驼冲锋衣', '三合一两件套，防风防水，可拆卸内胆', 699.00, 250, 12, '/img/1738584448644.jpg', 0, 14, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 549.00);
INSERT INTO `product` VALUES (1, 55, 'SK-II神仙水', '230ml大瓶装，改善肤质，提亮肤色', 1690.00, 200, 13, '/img/1738656784943.jpeg', 678, 15, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 1490.00);
INSERT INTO `product` VALUES (NULL, 56, '雅诗兰黛小棕瓶', '50ml眼部精华，抗衰老修护，改善细纹', 880.00, 300, 13, '/img/1738656949200.jpg', 0, 15, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 57, '兰蔻粉水', '<p>400ml大瓶装，温和保湿，二次清洁</p>', 560.00, 400, 13, '/img/1779376022084.png', 1234, 15, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 468.00);
INSERT INTO `product` VALUES (NULL, 58, '资生堂红腰子', '75ml精华液，提升紧致，改善暗沉', 760.00, 250, 13, '/img/1738657109060.jpg', 0, 15, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (NULL, 59, '欧莱雅护发精油', '100ml免洗护发精油，修复干枯毛躁', 139.00, 600, 13, '/img/1738896109540.png', 0, 15, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 60, '乐高积木城堡', '1000片颗粒，培养动手能力，适合6岁以上', 599.00, 300, 14, '/img/1738896328552.png', 0, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 479.00);
INSERT INTO `product` VALUES (NULL, 61, '飞鹤星飞帆奶粉', '3段奶粉，700g罐装，添加乳铁蛋白', 328.00, 500, 14, '/img/1738898118895.png', 0, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (1, 62, '好孩子婴儿推车', '<p>可坐可躺，双向推行，减震避震系统</p>', 1299.00, 150, 14, '/img/1779376053234.png', 0, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 1099.00);
INSERT INTO `product` VALUES (1, 63, '三只松鼠坚果礼盒', '<p>每日坚果大礼包，30袋装，营养健康</p>', 169.00, 800, 15, '/img/1779375582126.png', 2456, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', 139.00);
INSERT INTO `product` VALUES (0, 64, '蒙牛特仑苏牛奶', '<p>250ml*16盒，3.6g蛋白，醇厚香浓</p>', 79.00, 998, 15, '/img/1779375440061.png', 6790, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (NULL, 65, '百草味肉松饼', '720g大包装，传统手工制作，酥脆可口', 49.90, 1500, 15, '/img/1758719022313.jpg', 0, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (NULL, 66, '农夫山泉天然水', '<p>550ml*24瓶，天然弱碱性水</p>', 39.90, 2000, 15, '/img/1779376087955.png', 0, 10, 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15', NULL);
INSERT INTO `product` VALUES (0, 67, 'a\'da', '<p><br></p>', 6556.00, 19, 1, '', 2, 24, 1, '2026-02-05 19:17:19', '2026-02-05 19:17:19', 0.00);
INSERT INTO `product` VALUES (0, 68, 'aa', '<p><br></p>', 55.00, 0, 1, '', 2, 24, 1, '2026-04-29 16:18:52', '2026-04-29 16:18:52', 0.00);
INSERT INTO `product` VALUES (0, 69, '苹果', '<p><br></p>', 1.00, 428334, 1, '/img/1779375294555.png', 52333, 24, 1, '2026-05-21 22:37:39', '2026-05-21 22:37:39', 0.00);

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
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品评价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of review
-- ----------------------------
INSERT INTO `review` VALUES (3, 5, 2, 5, '胡萝卜新鲜爽脆', 1, '2025-02-03 10:46:11');
INSERT INTO `review` VALUES (4, 5, 4, 5, '松茸很新鲜，味道好极了', 1, '2025-02-03 10:46:11');
INSERT INTO `review` VALUES (9, 16, 33, 5, '鞋子非常舒适，气垫避震效果很好，颜色也很正！', 1, '2025-11-04 14:39:15');
INSERT INTO `review` VALUES (10, 16, 39, 5, '科幻迷必读！情节引人入胜，脑洞大开，强烈推荐！', 1, '2025-11-04 14:39:15');
INSERT INTO `review` VALUES (11, 17, 55, 5, '用了一个月，皮肤确实有改善，值得购买！', 1, '2025-11-04 14:39:15');
INSERT INTO `review` VALUES (12, 17, 37, 4, '箱子质量不错，就是价格稍贵，整体满意', 1, '2025-11-04 14:39:15');
INSERT INTO `review` VALUES (13, 18, 31, 5, '笔记本性能强悍，屏幕显示效果超级棒，办公娱乐都很流畅', 1, '2025-11-04 14:39:15');
INSERT INTO `review` VALUES (14, 18, 51, 5, '背包容量大，背负系统舒适，爬山必备', 1, '2025-11-04 14:39:15');
INSERT INTO `review` VALUES (15, 19, 50, 4, '瑜伽垫厚度合适，防滑效果好，就是有点味道', 1, '2025-11-04 14:39:15');
INSERT INTO `review` VALUES (16, 20, 60, 5, '孩子非常喜欢，拼搭过程很有趣，质量也很好', 1, '2025-11-04 14:39:15');
INSERT INTO `review` VALUES (18, 5, 57, 4, '粉水很温和，补水效果不错，会回购', 0, '2025-11-04 14:39:15');
INSERT INTO `review` VALUES (19, 23, 68, 5, '第三方士大夫发生', 0, '2026-05-01 14:54:09');
INSERT INTO `review` VALUES (20, 23, 68, 5, '154515', 0, '2026-05-01 14:58:02');

-- ----------------------------
-- Table structure for scenic
-- ----------------------------
DROP TABLE IF EXISTS `scenic`;
CREATE TABLE `scenic`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '景点ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '景点名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '景点简介',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '详细介绍',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '景点封面图',
  `images` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '景点图片，多个用逗号分隔',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所在省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所在城市',
  `address` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详细地址',
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '景点等级：5A/4A/3A等',
  `ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '门票价格',
  `open_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '开放时间',
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '景点标签，多个用逗号分隔',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览量',
  `status` int NULL DEFAULT 1 COMMENT '状态：0-下架 1-上架',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_province_city`(`province` ASC, `city` ASC) USING BTREE,
  INDEX `idx_level`(`level` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文旅景点表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of scenic
-- ----------------------------
INSERT INTO `scenic` VALUES (1, '西湖90', '杭州西湖是中国著名的风景名胜区，以其秀丽的湖光山色闻名于世', '西湖位于浙江省杭州市西面，是中国大陆首批国家重点风景名胜区和中国十大风景名胜之一、中国主要的观赏性淡水湖泊之一。西湖三面环山，面积约6.39平方千米，东西宽约2.8千米，南北长约3.2千米，绕湖一周近15千米。', '/img/1778571907820.jpg', NULL, '浙江省', '杭州市', '杭州市西湖区', '5A', 0.00, '全天开放', '0571-87179617', '自然风光,历史文化,世界遗产', 6, 1, '2025-12-23 22:45:58', '2026-05-12 15:45:09');
INSERT INTO `scenic` VALUES (3, '黄山', '黄山以奇松、怪石、云海、温泉、冬雪五绝著称于世', '黄山位于安徽省南部黄山市境内，是安徽旅游的标志，素有\"五岳归来不看山，黄山归来不看岳\"的美誉。黄山原名\"黟山\"，因峰岩青黑，遥望苍黛而名。', '/img/1778571919668.jpg', NULL, '安徽省', '黄山市', '黄山市黄山区', '5A', 0.00, '06:30-16:30', '0559-5580327', '自然风光,奇松怪石,云海', 6, 1, '2025-12-23 22:45:58', '2026-05-20 16:28:12');
INSERT INTO `scenic` VALUES (4, '西湖', '杭州西湖是中国著名的风景名胜区，以其秀丽的湖光山色闻名于世', '西湖位于浙江省杭州市西面，是中国大陆首批国家重点风景名胜区和中国十大风景名胜之一、中国主要的观赏性淡水湖泊之一。西湖三面环山，面积约6.39平方千米，东西宽约2.8千米，南北长约3.2千米，绕湖一周近15千米。', NULL, NULL, '浙江省', '杭州市', '杭州市西湖区', '5A', 0.00, '全天开放', '0571-87179617', '自然风光,历史文化,世界遗产', 1, 1, '2025-12-24 02:05:27', '2025-12-24 02:05:27');
INSERT INTO `scenic` VALUES (5, '故宫博物院', '北京故宫是中国明清两代的皇家宫殿，是世界上现存规模最大、保存最完整的木质结构古建筑群', '故宫又称紫禁城，位于北京中轴线的中心，是明清两代的皇家宫殿。故宫始建于明成祖永乐四年（1406年），永乐十八年（1420年）建成，是中国古代宫廷建筑之精华。', '/img/1778571992510.webp', NULL, '北京市', '北京市', '北京市东城区景山前街4号', '5A', 0.00, '08:30-17:00', '010-85007421', '历史文化,皇家建筑,博物馆', 3, 1, '2025-12-24 02:05:27', '2026-05-20 16:28:18');
INSERT INTO `scenic` VALUES (7, '西湖', '杭州西湖是中国著名的风景名胜区，以其秀丽的湖光山色闻名于世', '西湖位于浙江省杭州市西面，是中国大陆首批国家重点风景名胜区和中国十大风景名胜之一、中国主要的观赏性淡水湖泊之一。西湖三面环山，面积约6.39平方千米，东西宽约2.8千米，南北长约3.2千米，绕湖一周近15千米。', NULL, NULL, '浙江省', '杭州市', '杭州市西湖区', '5A', 0.00, '全天开放', '0571-87179617', '自然风光,历史文化,世界遗产', 1, 1, '2025-12-24 02:05:30', '2025-12-24 02:05:30');
INSERT INTO `scenic` VALUES (8, '故宫博物院', '北京故宫是中国明清两代的皇家宫殿，是世界上现存规模最大、保存最完整的木质结构古建筑群', '故宫又称紫禁城，位于北京中轴线的中心，是明清两代的皇家宫殿。故宫始建于明成祖永乐四年（1406年），永乐十八年（1420年）建成，是中国古代宫廷建筑之精华。', NULL, NULL, '北京市', '北京市', '北京市东城区景山前街4号', '5A', 60.00, '08:30-17:00', '010-85007421', '历史文化,皇家建筑,博物馆', 1, 1, '2025-12-24 02:05:30', '2025-12-24 02:05:30');
INSERT INTO `scenic` VALUES (9, '黄山', '黄山以奇松、怪石、云海、温泉、冬雪五绝著称于世', '黄山位于安徽省南部黄山市境内，是安徽旅游的标志，素有\"五岳归来不看山，黄山归来不看岳\"的美誉。黄山原名\"黟山\"，因峰岩青黑，遥望苍黛而名。', NULL, NULL, '安徽省', '黄山市', '黄山市黄山区', '5A', 0.00, '06:30-16:30', '0559-5580327', '自然风光,奇松怪石,云海', 2, 1, '2025-12-24 02:05:30', '2026-05-20 16:28:05');
INSERT INTO `scenic` VALUES (10, '西湖', '杭州西湖是中国著名的风景名胜区，以其秀丽的湖光山色闻名于世', '西湖位于浙江省杭州市西面，是中国大陆首批国家重点风景名胜区和中国十大风景名胜之一、中国主要的观赏性淡水湖泊之一。西湖三面环山，面积约6.39平方千米，东西宽约2.8千米，南北长约3.2千米，绕湖一周近15千米。', NULL, NULL, '浙江省', '杭州市', '杭州市西湖区', '5A', 0.00, '全天开放', '0571-87179617', '自然风光,历史文化,世界遗产', 0, 1, '2025-12-24 02:08:41', '2025-12-24 02:08:41');
INSERT INTO `scenic` VALUES (11, '故宫博物院', '北京故宫是中国明清两代的皇家宫殿，是世界上现存规模最大、保存最完整的木质结构古建筑群', '故宫又称紫禁城，位于北京中轴线的中心，是明清两代的皇家宫殿。故宫始建于明成祖永乐四年（1406年），永乐十八年（1420年）建成，是中国古代宫廷建筑之精华。', NULL, NULL, '北京市', '北京市', '北京市东城区景山前街4号', '5A', 60.00, '08:30-17:00', '010-85007421', '历史文化,皇家建筑,博物馆', 0, 1, '2025-12-24 02:08:41', '2025-12-24 02:08:41');
INSERT INTO `scenic` VALUES (12, '黄山', '黄山以奇松、怪石、云海、温泉、冬雪五绝著称于世', '黄山位于安徽省南部黄山市境内，是安徽旅游的标志，素有\"五岳归来不看山，黄山归来不看岳\"的美誉。黄山原名\"黟山\"，因峰岩青黑，遥望苍黛而名。', NULL, NULL, '安徽省', '黄山市', '黄山市黄山区', '5A', 0.00, '06:30-16:30', '0559-5580327', '自然风光,奇松怪石,云海', 1, 1, '2025-12-24 02:08:41', '2026-05-20 16:27:58');

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
INSERT INTO `sys_menu` VALUES ('FARMER,ADMIN,SUPER_ADMIN', 11, '商品列表', '/productManager', 'el-icon-shopping-cart-full', NULL, 10, 'ProductManager', 1);
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
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN', 50, '文旅管理', NULL, 'el-icon-place', '文旅景点与论坛管理', NULL, NULL, 6);
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN', 51, '景点管理', '/scenicManager', 'el-icon-location-outline', '管理文旅景点信息', 50, 'ScenicManager', 1);
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN', 52, '论坛管理', '/forumManager', 'el-icon-chat-dot-round', '管理文化论坛帖子', 50, 'ForumManager', 2);
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN', 53, '投诉管理', '/complaintManager', 'el-icon-warning-outline', '处理用户订单投诉', 50, 'ComplaintManager', 3);

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
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'Sadmin', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '系统管理员', 'SUPER_ADMIN', 'admin@example.com', 1, '2025-02-03 10:46:11', '2025-02-03 11:26:45');
INSERT INTO `user` VALUES (2, 'farmer1', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '张农', 'FARMER', 'farmer1@example.com', 1, '2025-02-03 10:46:11', '2026-04-29 16:17:20');
INSERT INTO `user` VALUES (3, 'farmer2', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '李农夫', 'FARMER', 'farmer2@example.com', 1, '2025-02-03 10:46:11', '2025-02-04 21:25:10');
INSERT INTO `user` VALUES (5, 'user2', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '李小红', 'USER', 'user2@example.com', 1, '2025-02-03 10:46:11', '2025-02-03 10:46:11');
INSERT INTO `user` VALUES (7, 'admin', '$2a$10$b9no1M1aC2IfqbO7Jt1LjuRd2P1hy4kPiMhp42PJBS8zb2jOuS/Vm', '管理员1', 'ADMIN', 'admin@qq.com', 1, '2025-02-04 20:22:32', '2026-02-05 18:41:49');
INSERT INTO `user` VALUES (10, 'shop_digital', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '数码专营店', 'FARMER', 'digital@shop.com', 1, '2025-11-04 14:39:15', '2026-02-05 18:41:33');
INSERT INTO `user` VALUES (11, 'shop_fashion', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '时尚服饰馆', 'FARMER', 'fashion@shop.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (12, 'shop_book', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '书香文具店', 'FARMER', 'book@shop.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (13, 'shop_home', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '居家生活馆', 'FARMER', 'home@shop.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (14, 'shop_sport', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '运动户外店', 'FARMER', 'sport@shop.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (15, 'shop_beauty', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '美妆护肤馆', 'FARMER', 'beauty@shop.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (16, 'buyer01', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '张小购', 'USER', 'buyer01@example.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (17, 'buyer02', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '李买家', 'USER', 'buyer02@example.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (18, 'buyer03', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '王剁手', 'USER', 'buyer03@example.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (19, 'buyer04', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '赵购物', 'USER', 'buyer04@example.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (20, 'buyer05', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '钱网购', 'USER', 'buyer05@example.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (21, 'operator', '$2a$10$b9no1M1aC2IfqbO7Jt1LjuRd2P1hy4kPiMhp42PJBS8zb2jOuS/Vm', '系统运营', 'ADMIN', 'operator@shop.com', 1, '2025-11-04 14:39:15', '2025-11-04 14:39:15');
INSERT INTO `user` VALUES (22, '123', '$2a$10$geekDmMY5OvxWTNUEIYnFOYnIoHDgBt0rIN28bBlHk92HgvorGyza', '1', 'USER', '1346845013@qq.com', 1, '2025-12-24 02:30:59', '2025-12-24 02:30:59');
INSERT INTO `user` VALUES (23, '1213', '$2a$10$rKwvoj15O5gA39WWJe.UfOzCqOREnvSixFaduN44i0.a5TvOIqa2a', 'aaaaa', 'USER', '1300551643@qq.com', 1, '2026-02-05 18:43:34', '2026-02-05 18:43:34');
INSERT INTO `user` VALUES (24, 'zzl', '$2a$10$/nacRN.YUDPm12hLutol3uUpIYvnkmJ3rOCF8hhjN7ccRv3lwtV82', 'zzz', 'FARMER', '1816786054@qq.com', 1, '2026-02-05 19:13:46', '2026-02-05 19:13:46');
INSERT INTO `user` VALUES (25, 'qwe', '$2a$10$0V6g6FRiZzUnJCyx1mGFfu1LHWbWZh3OUoQYFceQzU6E/wpD9XhM6', '李四', 'USER', '158578219@qq.com', 1, '2026-04-29 15:58:08', '2026-04-29 15:58:08');

SET FOREIGN_KEY_CHECKS = 1;
