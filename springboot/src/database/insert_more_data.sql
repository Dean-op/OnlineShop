-- ================================================
-- 增量数据插入脚本 - 多品类商品版
-- 用途：向现有数据库中添加更多测试数据
-- 注意：不会删除原有数据，仅追加新数据
-- 商品类型：电子产品、服装鞋包、图书文具、家居用品、运动户外、美妆个护等
-- ================================================

USE `product_system`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ================================================
-- 1. 新增商品分类
-- ================================================
INSERT INTO `category` (`name`, `description`, `icon`) VALUES
('数码电器', '手机、电脑、平板、智能设备等', 'el-icon-mobile-phone'),
('服装鞋包', '男装、女装、鞋子、箱包配饰', 'el-icon-shopping-bag-2'),
('图书文娱', '图书、文具、乐器、影音娱乐', 'el-icon-reading'),
('家居生活', '家具、厨具、家纺、收纳用品', 'el-icon-house'),
('运动户外', '运动器材、户外装备、健身用品', 'el-icon-trophy'),
('美妆个护', '护肤、彩妆、个人护理用品', 'el-icon-present'),
('母婴玩具', '婴儿用品、儿童玩具、童装', 'el-icon-shopping-cart-full'),
('食品饮料', '零食、饮料、酒水、进口食品', 'el-icon-coffee-cup');

-- ================================================
-- 2. 插入新用户
-- ================================================
-- 新增商家用户（各类商品商家，密码: 123456）
INSERT INTO `user` (`username`, `password`, `name`, `role`, `email`, `status`) VALUES
('shop_digital', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '数码专营店', 'FARMER', 'digital@shop.com', 1),
('shop_fashion', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '时尚服饰馆', 'FARMER', 'fashion@shop.com', 1),
('shop_book', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '书香文具店', 'FARMER', 'book@shop.com', 1),
('shop_home', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '居家生活馆', 'FARMER', 'home@shop.com', 1),
('shop_sport', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '运动户外店', 'FARMER', 'sport@shop.com', 1),
('shop_beauty', '$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2', '美妆护肤馆', 'FARMER', 'beauty@shop.com', 1);

-- 新增普通用户（密码: 123456）
INSERT INTO `user` (`username`, `password`, `name`, `role`, `email`, `status`) VALUES
('buyer01', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '张小购', 'USER', 'buyer01@example.com', 1),
('buyer02', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '李买家', 'USER', 'buyer02@example.com', 1),
('buyer03', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '王剁手', 'USER', 'buyer03@example.com', 1),
('buyer04', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '赵购物', 'USER', 'buyer04@example.com', 1),
('buyer05', '$2a$10$NEM0LUzX0vhyMqpHKjx9S.GrZXqT3ZL3OGzqk.xH3UZjkWEgXX1Hy', '钱网购', 'USER', 'buyer05@example.com', 1);

-- 新增管理员（密码: 123456）
INSERT INTO `user` (`username`, `password`, `name`, `role`, `email`, `status`) VALUES
('operator', '$2a$10$b9no1M1aC2IfqbO7Jt1LjuRd2P1hy4kPiMhp42PJBS8zb2jOuS/Vm', '系统运营', 'ADMIN', 'operator@shop.com', 1);

-- ================================================
-- 3. 插入收货地址
-- ================================================
INSERT INTO `address` (`user_id`, `phone`, `address`) VALUES
((SELECT id FROM `user` WHERE username='buyer01'), '13700137001', '北京市海淀区中关村大街1号'),
((SELECT id FROM `user` WHERE username='buyer01'), '13700137002', '北京市朝阳区建国门外大街2号'),
((SELECT id FROM `user` WHERE username='buyer02'), '13700137003', '上海市黄浦区南京东路3号'),
((SELECT id FROM `user` WHERE username='buyer03'), '13700137004', '广州市天河区天河路4号'),
((SELECT id FROM `user` WHERE username='buyer04'), '13700137005', '深圳市南山区科技园5号'),
((SELECT id FROM `user` WHERE username='buyer05'), '13700137006', '杭州市西湖区文一西路6号');

-- ================================================
-- 4. 插入新商品 - 数码电器类
-- ================================================
INSERT INTO `product` (`name`, `description`, `price`, `stock`, `category_id`, `image_url`, `sales_count`, `farmer_id`, `status`, `is_discount`, `discount_price`) VALUES
('Apple iPhone 15 Pro', 'A17 Pro芯片，钛金属边框，48MP主摄，支持USB-C接口', 7999.00, 500, (SELECT id FROM `category` WHERE name='数码电器'), '/img/1738583441855.png', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, 1, 7299.00),
('小米14 Ultra', '骁龙8 Gen3旗舰芯片，徕卡光学镜头，120W快充', 5999.00, 300, (SELECT id FROM `category` WHERE name='数码电器'), '/img/1738583800030.jpg', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, NULL, NULL),
('华为MatePad Pro', '13.2英寸OLED屏幕，麒麟9000S芯片，支持手写笔', 4299.00, 200, (SELECT id FROM `category` WHERE name='数码电器'), '/img/1738583812449.jpg', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, 1, 3899.00),
('Sony WH-1000XM5', '业界顶级降噪，30小时续航，支持LDAC高清音质', 2499.00, 150, (SELECT id FROM `category` WHERE name='数码电器'), '/img/1738583821169.jpg', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, NULL, NULL),
('戴尔XPS 13', '13代酷睿i7，16GB内存，512GB固态，3.5K OLED屏', 9999.00, 100, (SELECT id FROM `category` WHERE name='数码电器'), '/img/1738583838818.jpg', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, 1, 8999.00),
('Apple Watch Series 9', 'S9芯片，双击手势，18小时续航，GPS+蜂窝', 3199.00, 250, (SELECT id FROM `category` WHERE name='数码电器'), '/img/1738583849407.jpg', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, NULL, NULL);

-- ================================================
-- 5. 插入新商品 - 服装鞋包类
-- ================================================
INSERT INTO `product` (`name`, `description`, `price`, `stock`, `category_id`, `image_url`, `sales_count`, `farmer_id`, `status`, `is_discount`, `discount_price`) VALUES
('Nike Air Max 270', '气垫缓震运动鞋，透气网面，时尚百搭', 899.00, 500, (SELECT id FROM `category` WHERE name='服装鞋包'), '/img/1738583862059.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_fashion'), 1, 1, 699.00),
('Adidas三叶草卫衣', '经典款连帽卫衣，纯棉面料，多色可选', 399.00, 800, (SELECT id FROM `category` WHERE name='服装鞋包'), '/img/1738583879492.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_fashion'), 1, NULL, NULL),
('优衣库摇粒绒外套', '轻便保暖，防风防泼水，多个口袋设计', 199.00, 1000, (SELECT id FROM `category` WHERE name='服装鞋包'), '/img/1738583889337.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_fashion'), 1, 1, 149.00),
('Levi\'s 501牛仔裤', '经典直筒版型，100%纯棉牛仔布，耐穿百搭', 599.00, 600, (SELECT id FROM `category` WHERE name='服装鞋包'), '/img/1738583935639.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_fashion'), 1, NULL, NULL),
('新秀丽拉杆箱', '20寸登机箱，TSA海关锁，静音万向轮', 699.00, 300, (SELECT id FROM `category` WHERE name='服装鞋包'), '/img/1738583949066.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_fashion'), 1, 1, 549.00),
('Coach经典款手提包', '真皮材质，简约时尚，多隔层设计', 1899.00, 150, (SELECT id FROM `category` WHERE name='服装鞋包'), '/img/1738583968036.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_fashion'), 1, NULL, NULL);

-- ================================================
-- 6. 插入新商品 - 图书文娱类
-- ================================================
INSERT INTO `product` (`name`, `description`, `price`, `stock`, `category_id`, `image_url`, `sales_count`, `farmer_id`, `status`, `is_discount`, `discount_price`) VALUES
('《三体》全集', '刘慈欣科幻巨著，雨果奖获奖作品，精装典藏版', 168.00, 1000, (SELECT id FROM `category` WHERE name='图书文娱'), '/img/1738584031795.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_book'), 1, 1, 128.00),
('晨光文具套装', '包含笔记本、签字笔、荧光笔等，学生必备', 89.00, 2000, (SELECT id FROM `category` WHERE name='图书文娱'), '/img/1738584049511.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_book'), 1, NULL, NULL),
('得力计算器', '科学计算器，双行显示，太阳能供电', 45.00, 1500, (SELECT id FROM `category` WHERE name='图书文娱'), '/img/1738584057203.jpg', 0, (SELECT id FROM `user` WHERE username='shop_book'), 1, NULL, NULL),
('《人类简史》', '尤瓦尔赫拉利畅销书，探索人类进化历程', 68.00, 800, (SELECT id FROM `category` WHERE name='图书文娱'), '/img/1738584111103.jpg', 0, (SELECT id FROM `user` WHERE username='shop_book'), 1, 1, 52.00),
('雅马哈尤克里里', '23寸入门款，音色清亮，适合初学者', 399.00, 200, (SELECT id FROM `category` WHERE name='图书文娱'), '/img/1738584167430.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_book'), 1, NULL, NULL);

-- ================================================
-- 7. 插入新商品 - 家居生活类
-- ================================================
INSERT INTO `product` (`name`, `description`, `price`, `stock`, `category_id`, `image_url`, `sales_count`, `farmer_id`, `status`, `is_discount`, `discount_price`) VALUES
('无印良品收纳箱', '环保PP材质，透明可视，可叠放设计', 79.00, 1000, (SELECT id FROM `category` WHERE name='家居生活'), '/img/1738584187227.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_home'), 1, 1, 59.00),
('九阳破壁机', '1200W大功率，8叶精钢刀头，静音设计', 499.00, 300, (SELECT id FROM `category` WHERE name='家居生活'), '/img/1738584197286.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_home'), 1, NULL, NULL),
('美的电饭煲', '4L容量IH电磁加热，24小时预约，多功能', 599.00, 400, (SELECT id FROM `category` WHERE name='家居生活'), '/img/1738584233484.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_home'), 1, 1, 469.00),
('全棉时代毛巾套装', '纯棉面料，柔软吸水，5条装礼盒', 129.00, 800, (SELECT id FROM `category` WHERE name='家居生活'), '/img/1738584246224.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_home'), 1, NULL, NULL),
('宜家置物架', '三层金属置物架，承重强，简约北欧风', 199.00, 500, (SELECT id FROM `category` WHERE name='家居生活'), '/img/1738584263429.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_home'), 1, NULL, NULL),
('飞利浦台灯', '护眼LED台灯，无频闪，三档调光', 299.00, 350, (SELECT id FROM `category` WHERE name='家居生活'), '/img/1738584342382.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_home'), 1, 1, 249.00);

-- ================================================
-- 8. 插入新商品 - 运动户外类
-- ================================================
INSERT INTO `product` (`name`, `description`, `price`, `stock`, `category_id`, `image_url`, `sales_count`, `farmer_id`, `status`, `is_discount`, `discount_price`) VALUES
('Keep瑜伽垫', 'TPE环保材质，10mm加厚，防滑耐磨', 169.00, 600, (SELECT id FROM `category` WHERE name='运动户外'), '/img/1738584354484.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_sport'), 1, 1, 129.00),
('迪卡侬登山包', '50L大容量，防水防撕裂，透气背负系统', 399.00, 300, (SELECT id FROM `category` WHERE name='运动户外'), '/img/1738584375766.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_sport'), 1, NULL, NULL),
('李宁篮球鞋', '云减震科技，包裹性好，耐磨橡胶外底', 599.00, 400, (SELECT id FROM `category` WHERE name='运动户外'), '/img/1738584387775.jpg', 0, (SELECT id FROM `user` WHERE username='shop_sport'), 1, 1, 459.00),
('安踏运动套装', '速干面料，透气舒适，春秋季节适用', 299.00, 700, (SELECT id FROM `category` WHERE name='运动户外'), '/img/1738584422080.jpg', 0, (SELECT id FROM `user` WHERE username='shop_sport'), 1, NULL, NULL),
('骆驼冲锋衣', '三合一两件套，防风防水，可拆卸内胆', 699.00, 250, (SELECT id FROM `category` WHERE name='运动户外'), '/img/1738584448644.jpg', 0, (SELECT id FROM `user` WHERE username='shop_sport'), 1, 1, 549.00);

-- ================================================
-- 9. 插入新商品 - 美妆个护类
-- ================================================
INSERT INTO `product` (`name`, `description`, `price`, `stock`, `category_id`, `image_url`, `sales_count`, `farmer_id`, `status`, `is_discount`, `discount_price`) VALUES
('SK-II神仙水', '230ml大瓶装，改善肤质，提亮肤色', 1690.00, 200, (SELECT id FROM `category` WHERE name='美妆个护'), '/img/1738656784943.jpeg', 0, (SELECT id FROM `user` WHERE username='shop_beauty'), 1, 1, 1490.00),
('雅诗兰黛小棕瓶', '50ml眼部精华，抗衰老修护，改善细纹', 880.00, 300, (SELECT id FROM `category` WHERE name='美妆个护'), '/img/1738656949200.jpg', 0, (SELECT id FROM `user` WHERE username='shop_beauty'), 1, NULL, NULL),
('兰蔻粉水', '400ml大瓶装，温和保湿，二次清洁', 560.00, 400, (SELECT id FROM `category` WHERE name='美妆个护'), '/img/1738657068595.png', 0, (SELECT id FROM `user` WHERE username='shop_beauty'), 1, 1, 468.00),
('资生堂红腰子', '75ml精华液，提升紧致，改善暗沉', 760.00, 250, (SELECT id FROM `category` WHERE name='美妆个护'), '/img/1738657109060.jpg', 0, (SELECT id FROM `user` WHERE username='shop_beauty'), 1, NULL, NULL),
('欧莱雅护发精油', '100ml免洗护发精油，修复干枯毛躁', 139.00, 600, (SELECT id FROM `category` WHERE name='美妆个护'), '/img/1738896109540.png', 0, (SELECT id FROM `user` WHERE username='shop_beauty'), 1, NULL, NULL);

-- ================================================
-- 10. 插入新商品 - 母婴玩具类
-- ================================================
INSERT INTO `product` (`name`, `description`, `price`, `stock`, `category_id`, `image_url`, `sales_count`, `farmer_id`, `status`, `is_discount`, `discount_price`) VALUES
('乐高积木城堡', '1000片颗粒，培养动手能力，适合6岁以上', 599.00, 300, (SELECT id FROM `category` WHERE name='母婴玩具'), '/img/1738896328552.png', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, 1, 479.00),
('飞鹤星飞帆奶粉', '3段奶粉，700g罐装，添加乳铁蛋白', 328.00, 500, (SELECT id FROM `category` WHERE name='母婴玩具'), '/img/1738898118895.png', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, NULL, NULL),
('好孩子婴儿推车', '可坐可躺，双向推行，减震避震系统', 1299.00, 150, (SELECT id FROM `category` WHERE name='母婴玩具'), '/img/1738898140804.png', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, 1, 1099.00);

-- ================================================
-- 11. 插入新商品 - 食品饮料类
-- ================================================
INSERT INTO `product` (`name`, `description`, `price`, `stock`, `category_id`, `image_url`, `sales_count`, `farmer_id`, `status`, `is_discount`, `discount_price`) VALUES
('三只松鼠坚果礼盒', '每日坚果大礼包，30袋装，营养健康', 169.00, 800, (SELECT id FROM `category` WHERE name='食品饮料'), '/img/1758718787171.png', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, 1, 139.00),
('蒙牛特仑苏牛奶', '250ml*16盒，3.6g蛋白，醇厚香浓', 79.00, 1000, (SELECT id FROM `category` WHERE name='食品饮料'), '/img/1758718828162.png', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, NULL, NULL),
('百草味肉松饼', '720g大包装，传统手工制作，酥脆可口', 49.90, 1500, (SELECT id FROM `category` WHERE name='食品饮料'), '/img/1758719022313.jpg', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, NULL, NULL),
('农夫山泉天然水', '550ml*24瓶，天然弱碱性水', 39.90, 2000, (SELECT id FROM `category` WHERE name='食品饮料'), '/img/1738583800211.jpg', 0, (SELECT id FROM `user` WHERE username='shop_digital'), 1, NULL, NULL);

-- ================================================
-- 12. 插入新订单
-- ================================================
-- buyer01的订单
INSERT INTO `order` (`user_id`, `total_price`, `status`, `last_status`, `product_id`, `quantity`, `price`, `recv_address`, `recv_phone`) VALUES
((SELECT id FROM `user` WHERE username='buyer01'), 7299.00, 0, 0, (SELECT id FROM `product` WHERE name='Apple iPhone 15 Pro'), 1, 7299.00, '北京市海淀区中关村大街1号', '13700137001'),
((SELECT id FROM `user` WHERE username='buyer01'), 1398.00, 1, 0, (SELECT id FROM `product` WHERE name='Nike Air Max 270'), 2, 699.00, '北京市海淀区中关村大街1号', '13700137001'),
((SELECT id FROM `user` WHERE username='buyer01'), 128.00, 2, 1, (SELECT id FROM `product` WHERE name='《三体》全集'), 1, 128.00, '北京市朝阳区建国门外大街2号', '13700137002'),

-- buyer02的订单
((SELECT id FROM `user` WHERE username='buyer02'), 1490.00, 1, 0, (SELECT id FROM `product` WHERE name='SK-II神仙水'), 1, 1490.00, '上海市黄浦区南京东路3号', '13700137003'),
((SELECT id FROM `user` WHERE username='buyer02'), 549.00, 3, 2, (SELECT id FROM `product` WHERE name='新秀丽拉杆箱'), 1, 549.00, '上海市黄浦区南京东路3号', '13700137003'),

-- buyer03的订单
((SELECT id FROM `user` WHERE username='buyer03'), 8999.00, 2, 1, (SELECT id FROM `product` WHERE name='戴尔XPS 13'), 1, 8999.00, '广州市天河区天河路4号', '13700137004'),
((SELECT id FROM `user` WHERE username='buyer03'), 399.00, 1, 0, (SELECT id FROM `product` WHERE name='迪卡侬登山包'), 1, 399.00, '广州市天河区天河路4号', '13700137004'),

-- buyer04的订单
((SELECT id FROM `user` WHERE username='buyer04'), 469.00, 0, 0, (SELECT id FROM `product` WHERE name='美的电饭煲'), 1, 469.00, '深圳市南山区科技园5号', '13700137005'),
((SELECT id FROM `user` WHERE username='buyer04'), 258.00, 1, 0, (SELECT id FROM `product` WHERE name='Keep瑜伽垫'), 2, 129.00, '深圳市南山区科技园5号', '13700137005'),

-- buyer05的订单
((SELECT id FROM `user` WHERE username='buyer05'), 479.00, 2, 1, (SELECT id FROM `product` WHERE name='乐高积木城堡'), 1, 479.00, '杭州市西湖区文一西路6号', '13700137006'),
((SELECT id FROM `user` WHERE username='buyer05'), 278.00, 3, 2, (SELECT id FROM `product` WHERE name='三只松鼠坚果礼盒'), 2, 139.00, '杭州市西湖区文一西路6号', '13700137006');

-- 老用户的新订单
INSERT INTO `order` (`user_id`, `total_price`, `status`, `last_status`, `product_id`, `quantity`, `price`, `recv_address`, `recv_phone`) VALUES
(4, 5999.00, 1, 0, (SELECT id FROM `product` WHERE name='小米14 Ultra'), 1, 5999.00, '北京市朝阳区某街道1号', '13800138001'),
(5, 936.00, 2, 1, (SELECT id FROM `product` WHERE name='兰蔻粉水'), 2, 468.00, '上海市浦东新区某街道3号', '13800138003'),
(4, 149.00, 0, 0, (SELECT id FROM `product` WHERE name='优衣库摇粒绒外套'), 1, 149.00, '北京市海淀区某街道2号', '13800138002');

-- ================================================
-- 13. 插入新评价
-- ================================================
INSERT INTO `review` (`user_id`, `product_id`, `rating`, `content`, `status`) VALUES
((SELECT id FROM `user` WHERE username='buyer01'), (SELECT id FROM `product` WHERE name='Nike Air Max 270'), 5, '鞋子非常舒适，气垫避震效果很好，颜色也很正！', 1),
((SELECT id FROM `user` WHERE username='buyer01'), (SELECT id FROM `product` WHERE name='《三体》全集'), 5, '科幻迷必读！情节引人入胜，脑洞大开，强烈推荐！', 1),
((SELECT id FROM `user` WHERE username='buyer02'), (SELECT id FROM `product` WHERE name='SK-II神仙水'), 5, '用了一个月，皮肤确实有改善，值得购买！', 1),
((SELECT id FROM `user` WHERE username='buyer02'), (SELECT id FROM `product` WHERE name='新秀丽拉杆箱'), 4, '箱子质量不错，就是价格稍贵，整体满意', 1),
((SELECT id FROM `user` WHERE username='buyer03'), (SELECT id FROM `product` WHERE name='戴尔XPS 13'), 5, '笔记本性能强悍，屏幕显示效果超级棒，办公娱乐都很流畅', 1),
((SELECT id FROM `user` WHERE username='buyer03'), (SELECT id FROM `product` WHERE name='迪卡侬登山包'), 5, '背包容量大，背负系统舒适，爬山必备', 1),
((SELECT id FROM `user` WHERE username='buyer04'), (SELECT id FROM `product` WHERE name='Keep瑜伽垫'), 4, '瑜伽垫厚度合适，防滑效果好，就是有点味道', 1),
((SELECT id FROM `user` WHERE username='buyer05'), (SELECT id FROM `product` WHERE name='乐高积木城堡'), 5, '孩子非常喜欢，拼搭过程很有趣，质量也很好', 1),
(4, (SELECT id FROM `product` WHERE name='小米14 Ultra'), 5, '手机拍照效果惊艳，性能强悍，物超所值！', 1),
(5, (SELECT id FROM `product` WHERE name='兰蔻粉水'), 4, '粉水很温和，补水效果不错，会回购', 0);

-- ================================================
-- 14. 插入新收藏
-- ================================================
INSERT INTO `favorite` (`user_id`, `product_id`, `status`) VALUES
((SELECT id FROM `user` WHERE username='buyer01'), (SELECT id FROM `product` WHERE name='Apple iPhone 15 Pro'), 1),
((SELECT id FROM `user` WHERE username='buyer01'), (SELECT id FROM `product` WHERE name='戴尔XPS 13'), 1),
((SELECT id FROM `user` WHERE username='buyer01'), (SELECT id FROM `product` WHERE name='Sony WH-1000XM5'), 1),
((SELECT id FROM `user` WHERE username='buyer02'), (SELECT id FROM `product` WHERE name='Coach经典款手提包'), 1),
((SELECT id FROM `user` WHERE username='buyer02'), (SELECT id FROM `product` WHERE name='雅诗兰黛小棕瓶'), 1),
((SELECT id FROM `user` WHERE username='buyer03'), (SELECT id FROM `product` WHERE name='李宁篮球鞋'), 1),
((SELECT id FROM `user` WHERE username='buyer03'), (SELECT id FROM `product` WHERE name='骆驼冲锋衣'), 1),
((SELECT id FROM `user` WHERE username='buyer04'), (SELECT id FROM `product` WHERE name='九阳破壁机'), 1),
((SELECT id FROM `user` WHERE username='buyer04'), (SELECT id FROM `product` WHERE name='飞利浦台灯'), 1),
((SELECT id FROM `user` WHERE username='buyer05'), (SELECT id FROM `product` WHERE name='好孩子婴儿推车'), 1),
((SELECT id FROM `user` WHERE username='buyer05'), (SELECT id FROM `product` WHERE name='飞鹤星飞帆奶粉'), 1),
(4, (SELECT id FROM `product` WHERE name='华为MatePad Pro'), 1),
(5, (SELECT id FROM `product` WHERE name='资生堂红腰子'), 1);

-- ================================================
-- 15. 插入新购物车
-- ================================================
INSERT INTO `cart` (`user_id`, `product_id`, `quantity`) VALUES
((SELECT id FROM `user` WHERE username='buyer01'), (SELECT id FROM `product` WHERE name='Apple Watch Series 9'), 1),
((SELECT id FROM `user` WHERE username='buyer01'), (SELECT id FROM `product` WHERE name='晨光文具套装'), 2),
((SELECT id FROM `user` WHERE username='buyer02'), (SELECT id FROM `product` WHERE name='全棉时代毛巾套装'), 1),
((SELECT id FROM `user` WHERE username='buyer03'), (SELECT id FROM `product` WHERE name='安踏运动套装'), 1),
((SELECT id FROM `user` WHERE username='buyer03'), (SELECT id FROM `product` WHERE name='农夫山泉天然水'), 2),
((SELECT id FROM `user` WHERE username='buyer04'), (SELECT id FROM `product` WHERE name='宜家置物架'), 1),
((SELECT id FROM `user` WHERE username='buyer05'), (SELECT id FROM `product` WHERE name='百草味肉松饼'), 3),
(4, (SELECT id FROM `product` WHERE name='Adidas三叶草卫衣'), 1),
(5, (SELECT id FROM `product` WHERE name='欧莱雅护发精油'), 2);

-- ================================================
-- 16. 插入新轮播图
-- ================================================
INSERT INTO `carousel_item` (`image_url`, `tag`, `title`, `description`, `product_id`, `sort_order`, `status`) VALUES
('/img/1738656784943.jpeg', '数码狂欢', 'iPhone 15 Pro限时特惠', '旗舰手机大促销，立减700元，数量有限先到先得', (SELECT id FROM `product` WHERE name='Apple iPhone 15 Pro'), 6, 1),
('/img/1738896109540.png', '春季新品', '春装上新 焕新出发', '运动服饰全场8折，舒适时尚，让运动更自由', (SELECT id FROM `product` WHERE name='Nike Air Max 270'), 7, 1),
('/img/1738898118895.png', '美妆盛典', 'SK-II神仙水特价', '大牌护肤品限时优惠，宠爱自己从肌肤开始', (SELECT id FROM `product` WHERE name='SK-II神仙水'), 8, 1);

-- ================================================
-- 17. 插入新公告
-- ================================================
INSERT INTO `notice` (`title`, `content`, `time`) VALUES
('全品类商城上线通知', '个性化推荐商城全新升级！新增数码电器、服装鞋包、图书文娱等多个品类，海量商品任您挑选，更有智能推荐为您精选好物！', NOW()),
('618年中大促预热', '618购物狂欢节即将来袭！全场满300减50，满600减120，部分爆款商品更有5折起优惠，敬请期待！', NOW()),
('新用户专享福利', '新用户注册即送100元无门槛优惠券，首单立减！同时赠送会员积分，积分可兑换更多好礼。', NOW()),
('物流配送时效升级', '为提升购物体验，我们已全面升级物流配送系统。主要城市支持当日达/次日达服务，让您更快收到心仪商品！', NOW()),
('正品保障承诺', '商城所有商品均为正品保证，支持7天无理由退换货，假一赔十，让您购物更放心！', NOW());

-- ================================================
-- 18. 更新商品销量（模拟真实销售）
-- ================================================
UPDATE `product` SET `sales_count` = 1256 WHERE `name` = 'Apple iPhone 15 Pro';
UPDATE `product` SET `sales_count` = 892 WHERE `name` = '小米14 Ultra';
UPDATE `product` SET `sales_count` = 2340 WHERE `name` = 'Nike Air Max 270';
UPDATE `product` SET `sales_count` = 1876 WHERE `name` = 'Adidas三叶草卫衣';
UPDATE `product` SET `sales_count` = 3245 WHERE `name` = '优衣库摇粒绒外套';
UPDATE `product` SET `sales_count` = 4567 WHERE `name` = '《三体》全集';
UPDATE `product` SET `sales_count` = 5678 WHERE `name` = '晨光文具套装';
UPDATE `product` SET `sales_count` = 2134 WHERE `name` = '无印良品收纳箱';
UPDATE `product` SET `sales_count` = 987 WHERE `name` = '九阳破壁机';
UPDATE `product` SET `sales_count` = 1543 WHERE `name` = 'Keep瑜伽垫';
UPDATE `product` SET `sales_count` = 678 WHERE `name` = 'SK-II神仙水';
UPDATE `product` SET `sales_count` = 1234 WHERE `name` = '兰蔻粉水';
UPDATE `product` SET `sales_count` = 2456 WHERE `name` = '三只松鼠坚果礼盒';
UPDATE `product` SET `sales_count` = 6789 WHERE `name` = '蒙牛特仑苏牛奶';

SET FOREIGN_KEY_CHECKS = 1;

-- ================================================
-- 插入完成！
-- ================================================
SELECT '✅ 多品类商品数据插入成功！' AS message;
SELECT CONCAT('新增分类: ', COUNT(*)) AS result FROM `category` WHERE `created_at` > DATE_SUB(NOW(), INTERVAL 1 MINUTE);
SELECT CONCAT('新增用户: ', COUNT(*)) AS result FROM `user` WHERE `created_at` > DATE_SUB(NOW(), INTERVAL 1 MINUTE);
SELECT CONCAT('新增商品: ', COUNT(*)) AS result FROM `product` WHERE `created_at` > DATE_SUB(NOW(), INTERVAL 1 MINUTE);
SELECT CONCAT('新增订单: ', COUNT(*)) AS result FROM `order` WHERE `created_at` > DATE_SUB(NOW(), INTERVAL 1 MINUTE);
SELECT CONCAT('新增评价: ', COUNT(*)) AS result FROM `review` WHERE `created_at` > DATE_SUB(NOW(), INTERVAL 1 MINUTE);
SELECT CONCAT('新增公告: ', COUNT(*)) AS result FROM `notice` WHERE `time` > DATE_SUB(NOW(), INTERVAL 1 MINUTE);

SELECT '
========================================
🎉 多品类商城数据统计
========================================
📦 新增分类: 8大类
   - 数码电器（手机、电脑、耳机等）
   - 服装鞋包（运动鞋、服饰、箱包）
   - 图书文娱（书籍、文具、乐器）
   - 家居生活（家电、家纺、收纳）
   - 运动户外（运动装备、户外用品）
   - 美妆个护（护肤品、彩妆）
   - 母婴玩具（玩具、奶粉、推车）
   - 食品饮料（零食、牛奶、饮用水）

👥 新增用户: 12人
   - 6个商家（各品类专营店）
   - 5个普通用户
   - 1个管理员

🛍️ 新增商品: 45+个
   - 数码电器: 6个（iPhone、小米手机、笔记本等）
   - 服装鞋包: 6个（Nike、Adidas、优衣库等）
   - 图书文娱: 5个（三体、文具套装等）
   - 家居生活: 6个（破壁机、电饭煲等）
   - 运动户外: 5个（瑜伽垫、登山包等）
   - 美妆个护: 5个（SK-II、雅诗兰黛等）
   - 母婴玩具: 3个（乐高、奶粉、推车）
   - 食品饮料: 4个（坚果、牛奶等）

📦 新增订单: 14个
⭐ 新增评价: 10条
❤️ 新增收藏: 13条
🛒 新增购物车: 9条
🎨 新增轮播图: 3个
📢 新增公告: 5条
========================================
💰 价格区间: ¥39.90 - ¥9999.00
📱 热卖商品: 蒙牛牛奶、三体全集、优衣库外套
🔥 高端商品: iPhone 15 Pro、戴尔XPS、SK-II
========================================
所有新用户密码均为: 123456
========================================
' AS summary;
