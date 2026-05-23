-- 平台管理员介入退款功能的数据库修改
-- 为订单表添加平台介入相关字段

ALTER TABLE `order`
ADD COLUMN `platform_intervention` tinyint NULL DEFAULT 0 COMMENT '平台介入状态:0未介入,1用户申请介入,2平台处理中,3平台已介入' AFTER `refund_reason`,
ADD COLUMN `platform_intervention_time` timestamp NULL DEFAULT NULL COMMENT '平台介入时间' AFTER `platform_intervention`,
ADD COLUMN `platform_intervention_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户申请平台介入的原因' AFTER `platform_intervention_time`,
ADD COLUMN `platform_handler_id` bigint NULL DEFAULT NULL COMMENT '平台处理人员ID' AFTER `platform_intervention_reason`,
ADD COLUMN `platform_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台处理备注' AFTER `platform_handler_id`;

-- 更新退款状态说明
-- 退款状态:0无退款,1申请退款,2退款中,3已退款,4退款失败,5平台介入已退款
