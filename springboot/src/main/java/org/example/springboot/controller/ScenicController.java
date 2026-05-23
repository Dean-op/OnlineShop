package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.springboot.common.Result;
import org.example.springboot.entity.Scenic;
import org.example.springboot.service.ScenicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Tag(name = "文旅景点管理接口")
@RestController
@RequestMapping("/scenic")
public class ScenicController {

    @Autowired
    private ScenicService scenicService;

    @Operation(summary = "添加景点")
    @PostMapping
    public Result<?> createScenic(@RequestBody Scenic scenic) {
        return scenicService.createScenic(scenic);
    }

    @Operation(summary = "更新景点")
    @PutMapping("/{id}")
    public Result<?> updateScenic(@PathVariable Long id, @RequestBody Scenic scenic) {
        return scenicService.updateScenic(id, scenic);
    }

    @Operation(summary = "删除景点")
    @DeleteMapping("/{id}")
    public Result<?> deleteScenic(@PathVariable Long id) {
        return scenicService.deleteScenic(id);
    }

    @Operation(summary = "获取景点详情")
    @GetMapping("/{id}")
    public Result<?> getScenicById(@PathVariable Long id) {
        return scenicService.getScenicById(id);
    }

    @Operation(summary = "分页查询景点列表")
    @GetMapping("/page")
    public Result<?> getScenicsByPage(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String province,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String level,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        return scenicService.getScenicsByPage(keyword, province, city, level, status, currentPage, size);
    }

    @Operation(summary = "获取热门景点")
    @GetMapping("/hot")
    public Result<?> getHotScenics(@RequestParam(defaultValue = "6") Integer limit) {
        return scenicService.getHotScenics(limit);
    }

    @Operation(summary = "更新景点状态")
    @PutMapping("/{id}/status")
    public Result<?> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        return scenicService.updateStatus(id, status);
    }
}
