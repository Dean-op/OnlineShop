package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
@Schema(description = "文旅景点实体")
@TableName("scenic")
public class Scenic {
    @TableId(type = IdType.AUTO)
    @Schema(description = "景点ID")
    private Long id;

    @Schema(description = "景点名称")
    private String name;

    @Schema(description = "景点简介")
    private String description;

    @Schema(description = "详细介绍")
    private String detail;

    @Schema(description = "景点封面图")
    private String coverImage;

    @Schema(description = "景点图片，多个用逗号分隔")
    private String images;

    @Schema(description = "所在省份")
    private String province;

    @Schema(description = "所在城市")
    private String city;

    @Schema(description = "详细地址")
    private String address;

    @Schema(description = "景点等级：5A/4A/3A等")
    private String level;

    @Schema(description = "门票价格")
    private BigDecimal ticketPrice;

    @Schema(description = "开放时间")
    private String openTime;

    @Schema(description = "联系电话")
    private String phone;

    @Schema(description = "景点标签，多个用逗号分隔")
    private String tags;

    @Schema(description = "浏览量")
    private Integer viewCount;

    @Schema(description = "状态：0-下架 1-上架")
    private Integer status;

    @Schema(description = "创建时间")
    private Timestamp createdAt;

    @Schema(description = "更新时间")
    private Timestamp updatedAt;
}
