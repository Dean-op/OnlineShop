package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.sql.Timestamp;

@Data
@Schema(description = "订单投诉实体")
@TableName("complaint")
public class Complaint {
    @TableId(type = IdType.AUTO)
    @Schema(description = "投诉ID")
    private Long id;

    @Schema(description = "订单ID")
    private Long orderId;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "商家ID")
    private Long merchantId;

    @Schema(description = "投诉类型：1-商品质量 2-服务态度 3-物流问题 4-虚假宣传 5-其他")
    private Integer type;

    @Schema(description = "投诉标题")
    private String title;

    @Schema(description = "投诉内容")
    private String content;

    @Schema(description = "图片证据，多个用逗号分隔")
    private String images;

    @Schema(description = "投诉状态：0-待处理 1-处理中 2-已解决 3-已关闭")
    private Integer status;

    @Schema(description = "商家回复")
    private String merchantReply;

    @Schema(description = "管理员处理意见")
    private String adminReply;

    @Schema(description = "创建时间")
    private Timestamp createdAt;

    @Schema(description = "更新时间")
    private Timestamp updatedAt;

    @TableField(exist = false)
    @Schema(description = "用户信息")
    private User user;

    @TableField(exist = false)
    @Schema(description = "订单信息")
    private Order order;

    @TableField(exist = false)
    @Schema(description = "商家信息")
    private User merchant;
}
