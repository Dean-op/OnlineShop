package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
@Schema(description = "订单实体")
@TableName("`order`")
public class Order {
    @TableId(type = IdType.AUTO)
    @Schema(description = "订单ID")
    private Long id;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "订单总价")
    private BigDecimal totalPrice;

    @Schema(description = "订单状态")
    private Integer status;

    @Schema(description = "上一个订单状态")
    private Integer lastStatus;

    @Schema(description = "订单备注")
    private String remark;

    @Schema(description = "退款时间")
    private Timestamp refundTime;

    @Schema(description = "退款状态")
    private Integer refundStatus;

    @Schema(description = "退款原因")
    private String refundReason;

    @Schema(description = "平台介入状态:0未介入,1用户申请介入,2平台处理中,3平台已介入")
    private Integer platformIntervention;

    @Schema(description = "平台介入时间")
    private Timestamp platformInterventionTime;

    @Schema(description = "用户申请平台介入的原因")
    private String platformInterventionReason;

    @Schema(description = "平台处理人员ID")
    private Long platformHandlerId;

    @Schema(description = "平台处理备注")
    private String platformRemark;

    @Schema(description = "地址信息")
    private String recvAddress;
    @Schema(description = "电话信息")
    private String recvPhone;
    @Schema(description = "商品ID")
    private Long productId;

    @Schema(description = "购买数量")
    private Integer quantity;

    @Schema(description = "商品单价")
    private BigDecimal price;

    @Schema(description = "创建时间")
    private Timestamp createdAt;

    @Schema(description = "更新时间")
    private Timestamp updatedAt;

    @TableField(exist = false)
    @Schema(description = "用户信息")
    private User user;

    @TableField(exist = false)
    @Schema(description = "商品信息")
    private Product product;

    @TableField(exist = false)
    @Schema(description = "农民信息")
    private User farmer;

} 