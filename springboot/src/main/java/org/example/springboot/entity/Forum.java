package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.sql.Timestamp;
import java.util.List;

@Data
@Schema(description = "文化论坛帖子实体")
@TableName("forum")
public class Forum {
    @TableId(type = IdType.AUTO)
    @Schema(description = "帖子ID")
    private Long id;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "帖子类型：1-普通话题 2-商品文化分享")
    private Integer type;

    @Schema(description = "关联商品ID（商家分享时使用）")
    private Long productId;

    @Schema(description = "关联景点ID")
    private Long scenicId;

    @Schema(description = "帖子标题")
    private String title;

    @Schema(description = "帖子内容")
    private String content;

    @Schema(description = "封面图片")
    private String coverImage;

    @Schema(description = "图片列表，多个用逗号分隔")
    private String images;

    @Schema(description = "浏览量")
    private Integer viewCount;

    @Schema(description = "点赞数")
    private Integer likeCount;

    @Schema(description = "回复数")
    private Integer replyCount;

    @Schema(description = "状态：0-待审核 1-已发布 2-已下架")
    private Integer status;

    @Schema(description = "是否置顶：0-否 1-是")
    private Integer isTop;

    @Schema(description = "创建时间")
    private Timestamp createdAt;

    @Schema(description = "更新时间")
    private Timestamp updatedAt;

    @TableField(exist = false)
    @Schema(description = "用户信息")
    private User user;

    @TableField(exist = false)
    @Schema(description = "关联商品信息")
    private Product product;

    @TableField(exist = false)
    @Schema(description = "关联景点信息")
    private Scenic scenic;

    @TableField(exist = false)
    @Schema(description = "回复列表")
    private List<ForumReply> replies;
}
