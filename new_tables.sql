-- 订单投诉表
CREATE TABLE
IF NOT EXISTS `complaint` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '投诉ID',
    `order_id` BIGINT DEFAULT NULL COMMENT '订单ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `merchant_id` BIGINT DEFAULT NULL COMMENT '商家ID',
    `type` INT DEFAULT 5 COMMENT '投诉类型：1-商品质量 2-服务态度 3-物流问题 4-虚假宣传 5-其他',
    `title` VARCHAR (200) NOT NULL COMMENT '投诉标题',
    `content` TEXT COMMENT '投诉内容',
    `images` VARCHAR (1000) DEFAULT NULL COMMENT '图片证据，多个用逗号分隔',
    `status` INT DEFAULT 0 COMMENT '投诉状态：0-待处理 1-处理中 2-已解决 3-已关闭',
    `merchant_reply` TEXT COMMENT '商家回复',
    `admin_reply` TEXT COMMENT '管理员处理意见',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_order_id` (`order_id`),
    KEY `idx_merchant_id` (`merchant_id`),
    KEY `idx_status` (`status`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '订单投诉表';
  -- 文化论坛帖子表
  CREATE TABLE
  IF NOT EXISTS `forum` (
      `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
      `user_id` BIGINT NOT NULL COMMENT '用户ID',
      `type` INT DEFAULT 1 COMMENT '帖子类型：1-普通话题 2-商品文化分享',
      `product_id` BIGINT DEFAULT NULL COMMENT '关联商品ID（商家分享时使用）',
      `scenic_id` BIGINT DEFAULT NULL COMMENT '关联景点ID',
      `title` VARCHAR (200) NOT NULL COMMENT '帖子标题',
      `content` TEXT COMMENT '帖子内容',
      `cover_image` VARCHAR (500) DEFAULT NULL COMMENT '封面图片',
      `images` VARCHAR (2000) DEFAULT NULL COMMENT '图片列表，多个用逗号分隔',
      `view_count` INT DEFAULT 0 COMMENT '浏览量',
      `like_count` INT DEFAULT 0 COMMENT '点赞数',
      `reply_count` INT DEFAULT 0 COMMENT '回复数',
      `status` INT DEFAULT 1 COMMENT '状态：0-待审核 1-已发布 2-已下架',
      `is_top` INT DEFAULT 0 COMMENT '是否置顶：0-否 1-是',
      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
      PRIMARY KEY (`id`),
      KEY `idx_user_id` (`user_id`),
      KEY `idx_product_id` (`product_id`),
      KEY `idx_scenic_id` (`scenic_id`),
      KEY `idx_type` (`type`),
      KEY `idx_status` (`status`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '文化论坛帖子表';
    -- 如果表已存在，添加scenic_id字段（执行前请检查字段是否已存在）
    -- ALTER TABLE `forum` ADD COLUMN `scenic_id` bigint DEFAULT NULL COMMENT '关联景点ID' AFTER `product_id`;
    -- ALTER TABLE `forum` ADD INDEX `idx_scenic_id` (`scenic_id`);
    -- 论坛回复表
    CREATE TABLE
    IF NOT EXISTS `forum_reply` (
        `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '回复ID',
        `forum_id` BIGINT NOT NULL COMMENT '帖子ID',
        `user_id` BIGINT NOT NULL COMMENT '用户ID',
        `parent_id` BIGINT DEFAULT NULL COMMENT '父回复ID（回复的回复）',
        `content` TEXT NOT NULL COMMENT '回复内容',
        `like_count` INT DEFAULT 0 COMMENT '点赞数',
        `status` INT DEFAULT 0 COMMENT '状态：0-正常 1-已删除',
        `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        PRIMARY KEY (`id`),
        KEY `idx_forum_id` (`forum_id`),
        KEY `idx_user_id` (`user_id`),
        KEY `idx_parent_id` (`parent_id`)
      ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '论坛回复表';
      
      -- 文旅景点表
      CREATE TABLE
      IF NOT EXISTS `scenic` (
          `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '景点ID',
          `name` VARCHAR (200) NOT NULL COMMENT '景点名称',
          `description` VARCHAR (500) DEFAULT NULL COMMENT '景点简介',
          `detail` TEXT COMMENT '详细介绍',
          `cover_image` VARCHAR (500) DEFAULT NULL COMMENT '景点封面图',
          `images` VARCHAR (2000) DEFAULT NULL COMMENT '景点图片，多个用逗号分隔',
          `province` VARCHAR (50) DEFAULT NULL COMMENT '所在省份',
          `city` VARCHAR (50) DEFAULT NULL COMMENT '所在城市',
          `address` VARCHAR (300) DEFAULT NULL COMMENT '详细地址',
          `level` VARCHAR (20) DEFAULT NULL COMMENT '景点等级：5A/4A/3A等',
          `ticket_price` DECIMAL (10, 2) DEFAULT NULL COMMENT '门票价格',
          `open_time` VARCHAR (100) DEFAULT NULL COMMENT '开放时间',
          `phone` VARCHAR (50) DEFAULT NULL COMMENT '联系电话',
          `tags` VARCHAR (200) DEFAULT NULL COMMENT '景点标签，多个用逗号分隔',
          `view_count` INT DEFAULT 0 COMMENT '浏览量',
          `status` INT DEFAULT 1 COMMENT '状态：0-下架 1-上架',
          `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
          `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
          PRIMARY KEY (`id`),
          KEY `idx_province_city` (`province`, `city`),
          KEY `idx_level` (`level`),
          KEY `idx_status` (`status`)
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '文旅景点表';
        -- 插入示例景点数据
        INSERT INTO `scenic` (`name`, `description`, `detail`, `province`, `city`, `address`, `level`, `ticket_price`, `open_time`, `phone`, `tags`, `status`)
        VALUES
        ('西湖', '杭州西湖是中国著名的风景名胜区，以其秀丽的湖光山色闻名于世', '西湖位于浙江省杭州市西面，是中国大陆首批国家重点风景名胜区和中国十大风景名胜之一、中国主要的观赏性淡水湖泊之一。西湖三面环山，面积约6.39平方千米，东西宽约2.8千米，南北长约3.2千米，绕湖一周近15千米。', '浙江省', '杭州市', '杭州市西湖区', '5A', 0.00, '全天开放', '0571-87179617', '自然风光,历史文化,世界遗产', 1),
        ('故宫博物院', '北京故宫是中国明清两代的皇家宫殿，是世界上现存规模最大、保存最完整的木质结构古建筑群', '故宫又称紫禁城，位于北京中轴线的中心，是明清两代的皇家宫殿。故宫始建于明成祖永乐四年（1406年），永乐十八年（1420年）建成，是中国古代宫廷建筑之精华。', '北京市', '北京市', '北京市东城区景山前街4号', '5A', 60.00, '08:30-17:00', '010-85007421', '历史文化,皇家建筑,博物馆', 1),
        ('黄山', '黄山以奇松、怪石、云海、温泉、冬雪五绝著称于世', '黄山位于安徽省南部黄山市境内，是安徽旅游的标志，素有"五岳归来不看山，黄山归来不看岳"的美誉。黄山原名"黟山"，因峰岩青黑，遥望苍黛而名。', '安徽省', '黄山市', '黄山市黄山区', '5A', 190.00, '06:30-16:30', '0559-5580327', '自然风光,奇松怪石,云海', 1);
        -- =====================================================
        -- 新增管理端菜单（文旅功能模块）
        -- =====================================================
        -- 添加"文旅管理"父级菜单
        INSERT INTO `sys_menu` (`role`, `id`, `name`, `path`, `icon`, `description`, `pid`, `page_path`, `sort_num`)
        VALUES
        ('ADMIN,SUPER_ADMIN', 50, '文旅管理', NULL, 'el-icon-place', '文旅景点与论坛管理', NULL, NULL, 6);
        
        -- 添加"景点管理"子菜单
        INSERT INTO `sys_menu` (`role`, `id`, `name`, `path`, `icon`, `description`, `pid`, `page_path`, `sort_num`)
        VALUES
        ('ADMIN,SUPER_ADMIN', 51, '景点管理', '/scenicManager', 'el-icon-location-outline', '管理文旅景点信息', 50, 'ScenicManager', 1);
        -- 添加"论坛管理"子菜单
        INSERT INTO `sys_menu` (`role`, `id`, `name`, `path`, `icon`, `description`, `pid`, `page_path`, `sort_num`)
        VALUES
        ('ADMIN,SUPER_ADMIN', 52, '论坛管理', '/forumManager', 'el-icon-chat-dot-round', '管理文化论坛帖子', 50, 'ForumManager', 2);
        -- 添加"投诉管理"子菜单
        INSERT INTO `sys_menu` (`role`, `id`, `name`, `path`, `icon`, `description`, `pid`, `page_path`, `sort_num`)
        VALUES
        ('ADMIN,SUPER_ADMIN', 53, '投诉管理', '/complaintManager', 'el-icon-warning-outline', '处理用户订单投诉', 50, 'ComplaintManager', 3);