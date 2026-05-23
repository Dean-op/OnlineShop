package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.springboot.common.Result;
import org.example.springboot.entity.Forum;
import org.example.springboot.entity.ForumReply;
import org.example.springboot.entity.Product;
import org.example.springboot.entity.Scenic;
import org.example.springboot.entity.User;
import org.example.springboot.mapper.ForumMapper;
import org.example.springboot.mapper.ForumReplyMapper;
import org.example.springboot.mapper.ProductMapper;
import org.example.springboot.mapper.ScenicMapper;
import org.example.springboot.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;

@Service
public class ForumService {

    @Autowired
    private ForumMapper forumMapper;

    @Autowired
    private ForumReplyMapper forumReplyMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private ScenicMapper scenicMapper;

    public Result<?> createForum(Forum forum) {
        forum.setViewCount(0);
        forum.setLikeCount(0);
        forum.setReplyCount(0);
        forum.setStatus(1);
        forum.setIsTop(0);
        forum.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        forum.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        forumMapper.insert(forum);
        return Result.success("发布成功");
    }

    public Result<?> updateForum(Long id, Forum forum) {
        forum.setId(id);
        forum.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        forumMapper.updateById(forum);
        return Result.success("更新成功");
    }

    public Result<?> deleteForum(Long id) {
        forumMapper.deleteById(id);
        // 删除相关回复
        QueryWrapper<ForumReply> replyWrapper = new QueryWrapper<>();
        replyWrapper.eq("forum_id", id);
        forumReplyMapper.delete(replyWrapper);
        return Result.success("删除成功");
    }

    public Result<?> getForumById(Long id) {
        Forum forum = forumMapper.selectById(id);
        if (forum != null) {
            // 增加浏览量
            forum.setViewCount(forum.getViewCount() + 1);
            forumMapper.updateById(forum);
            fillForumInfo(forum);
            // 获取回复列表
            QueryWrapper<ForumReply> replyWrapper = new QueryWrapper<>();
            replyWrapper.eq("forum_id", id).eq("status", 0).orderByAsc("created_at");
            List<ForumReply> replies = forumReplyMapper.selectList(replyWrapper);
            for (ForumReply reply : replies) {
                if (reply.getUserId() != null) {
                    reply.setUser(userMapper.selectById(reply.getUserId()));
                }
            }
            forum.setReplies(replies);
        }
        return Result.success(forum);
    }

    public Result<?> getForumsByPage(Integer type, Long userId, Long scenicId, String keyword, Integer currentPage, Integer size) {
        QueryWrapper<Forum> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", 1);
        if (type != null) {
            queryWrapper.eq("type", type);
        }
        if (userId != null) {
            queryWrapper.eq("user_id", userId);
        }
        if (scenicId != null) {
            queryWrapper.eq("scenic_id", scenicId);
        }
        if (keyword != null && !keyword.isEmpty()) {
            queryWrapper.and(w -> w.like("title", keyword).or().like("content", keyword));
        }
        queryWrapper.orderByDesc("is_top").orderByDesc("created_at");

        Page<Forum> page = new Page<>(currentPage, size);
        Page<Forum> result = forumMapper.selectPage(page, queryWrapper);

        for (Forum forum : result.getRecords()) {
            fillForumInfo(forum);
        }

        return Result.success(result);
    }

    public Result<?> createReply(ForumReply reply) {
        reply.setLikeCount(0);
        reply.setStatus(0);
        reply.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        forumReplyMapper.insert(reply);

        // 更新帖子回复数
        Forum forum = forumMapper.selectById(reply.getForumId());
        if (forum != null) {
            forum.setReplyCount(forum.getReplyCount() + 1);
            forumMapper.updateById(forum);
        }

        return Result.success("回复成功");
    }

    public Result<?> deleteReply(Long id) {
        ForumReply reply = forumReplyMapper.selectById(id);
        if (reply != null) {
            reply.setStatus(1);
            forumReplyMapper.updateById(reply);

            // 更新帖子回复数
            Forum forum = forumMapper.selectById(reply.getForumId());
            if (forum != null && forum.getReplyCount() > 0) {
                forum.setReplyCount(forum.getReplyCount() - 1);
                forumMapper.updateById(forum);
            }
        }
        return Result.success("删除成功");
    }

    public Result<?> likeForum(Long id) {
        Forum forum = forumMapper.selectById(id);
        if (forum != null) {
            forum.setLikeCount(forum.getLikeCount() + 1);
            forumMapper.updateById(forum);
        }
        return Result.success("点赞成功");
    }

    public Result<?> setTop(Long id, Integer isTop) {
        Forum forum = forumMapper.selectById(id);
        if (forum != null) {
            forum.setIsTop(isTop);
            forumMapper.updateById(forum);
        }
        return Result.success("操作成功");
    }

    private void fillForumInfo(Forum forum) {
        if (forum.getUserId() != null) {
            User user = userMapper.selectById(forum.getUserId());
            forum.setUser(user);
        }
        if (forum.getProductId() != null) {
            Product product = productMapper.selectById(forum.getProductId());
            forum.setProduct(product);
        }
        if (forum.getScenicId() != null) {
            Scenic scenic = scenicMapper.selectById(forum.getScenicId());
            forum.setScenic(scenic);
        }
    }

    public Result<?> linkScenic(Long forumId, Long scenicId) {
        Forum forum = forumMapper.selectById(forumId);
        if (forum == null) {
            return Result.error("-1", "帖子不存在");
        }
        forum.setScenicId(scenicId);
        forum.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        forumMapper.updateById(forum);
        return Result.success("关联成功");
    }
}
