package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.springboot.common.Result;
import org.example.springboot.entity.Scenic;
import org.example.springboot.mapper.ScenicMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;

@Service
public class ScenicService {

    @Autowired
    private ScenicMapper scenicMapper;

    public Result<?> createScenic(Scenic scenic) {
        scenic.setViewCount(0);
        scenic.setStatus(1);
        scenic.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        scenic.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        scenicMapper.insert(scenic);
        return Result.success("添加成功");
    }

    public Result<?> updateScenic(Long id, Scenic scenic) {
        scenic.setId(id);
        scenic.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        scenicMapper.updateById(scenic);
        return Result.success("更新成功");
    }

    public Result<?> deleteScenic(Long id) {
        scenicMapper.deleteById(id);
        return Result.success("删除成功");
    }

    public Result<?> getScenicById(Long id) {
        Scenic scenic = scenicMapper.selectById(id);
        if (scenic != null) {
            // 增加浏览量
            scenic.setViewCount(scenic.getViewCount() + 1);
            scenicMapper.updateById(scenic);
        }
        return Result.success(scenic);
    }

    public Result<?> getScenicsByPage(String keyword, String province, String city, String level, Integer status, Integer currentPage, Integer size) {
        QueryWrapper<Scenic> queryWrapper = new QueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            queryWrapper.and(w -> w.like("name", keyword).or().like("description", keyword).or().like("tags", keyword));
        }
        if (province != null && !province.isEmpty()) {
            queryWrapper.eq("province", province);
        }
        if (city != null && !city.isEmpty()) {
            queryWrapper.eq("city", city);
        }
        if (level != null && !level.isEmpty()) {
            queryWrapper.eq("level", level);
        }
        if (status != null) {
            queryWrapper.eq("status", status);
        }
        queryWrapper.orderByDesc("view_count");

        Page<Scenic> page = new Page<>(currentPage, size);
        Page<Scenic> result = scenicMapper.selectPage(page, queryWrapper);

        return Result.success(result);
    }

    public Result<?> getHotScenics(Integer limit) {
        QueryWrapper<Scenic> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", 1).orderByDesc("view_count").last("LIMIT " + limit);
        return Result.success(scenicMapper.selectList(queryWrapper));
    }

    public Result<?> updateStatus(Long id, Integer status) {
        Scenic scenic = scenicMapper.selectById(id);
        if (scenic != null) {
            scenic.setStatus(status);
            scenic.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
            scenicMapper.updateById(scenic);
        }
        return Result.success("操作成功");
    }
}
