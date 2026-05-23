package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.sql.Timestamp;

@Data
@Schema(description = "论坛回复实体")
@TableName("forum_reply")
public class ForumReply {
    @TableId(type = IdType.AUTO)
    @Schema(description = "回复ID")
    private Long id;

    @Schema(description = "帖子ID")
    private Long forumId;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "父回复ID（回复的回复）")
    private Long parentId;

    @Schema(description = "回复内容")
    private String content;

    @Schema(description = "点赞数")
    private Integer likeCount;

    @Schema(description = "状态：0-正常 1-已删除")
    private Integer status;

    @Schema(description = "创建时间")
    private Timestamp createdAt;

    @TableField(exist = false)
    @Schema(description = "用户信息")
    private User user;

    @TableField(exist = false)
    @Schema(description = "被回复用户信息")
    private User replyToUser;
}
