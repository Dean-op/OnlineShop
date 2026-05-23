package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.springboot.common.Result;
import org.example.springboot.entity.Forum;
import org.example.springboot.entity.ForumReply;
import org.example.springboot.service.ForumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Tag(name = "文化论坛管理接口")
@RestController
@RequestMapping("/forum")
public class ForumController {

    @Autowired
    private ForumService forumService;

    @Operation(summary = "发布帖子")
    @PostMapping
    public Result<?> createForum(@RequestBody Forum forum) {
        return forumService.createForum(forum);
    }

    @Operation(summary = "更新帖子")
    @PutMapping("/{id}")
    public Result<?> updateForum(@PathVariable Long id, @RequestBody Forum forum) {
        return forumService.updateForum(id, forum);
    }

    @Operation(summary = "删除帖子")
    @DeleteMapping("/{id}")
    public Result<?> deleteForum(@PathVariable Long id) {
        return forumService.deleteForum(id);
    }

    @Operation(summary = "获取帖子详情")
    @GetMapping("/{id}")
    public Result<?> getForumById(@PathVariable Long id) {
        return forumService.getForumById(id);
    }

    @Operation(summary = "分页查询帖子列表")
    @GetMapping("/page")
    public Result<?> getForumsByPage(
            @RequestParam(required = false) Integer type,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long scenicId,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        return forumService.getForumsByPage(type, userId, scenicId, keyword, currentPage, size);
    }

    @Operation(summary = "发布回复")
    @PostMapping("/reply")
    public Result<?> createReply(@RequestBody ForumReply reply) {
        return forumService.createReply(reply);
    }

    @Operation(summary = "删除回复")
    @DeleteMapping("/reply/{id}")
    public Result<?> deleteReply(@PathVariable Long id) {
        return forumService.deleteReply(id);
    }

    @Operation(summary = "点赞帖子")
    @PostMapping("/{id}/like")
    public Result<?> likeForum(@PathVariable Long id) {
        return forumService.likeForum(id);
    }

    @Operation(summary = "设置置顶")
    @PostMapping("/{id}/top")
    public Result<?> setTop(@PathVariable Long id, @RequestParam Integer isTop) {
        return forumService.setTop(id, isTop);
    }

    @Operation(summary = "关联景点")
    @PostMapping("/{id}/link-scenic")
    public Result<?> linkScenic(@PathVariable Long id, @RequestParam(required = false) Long scenicId) {
        return forumService.linkScenic(id, scenicId);
    }
}
