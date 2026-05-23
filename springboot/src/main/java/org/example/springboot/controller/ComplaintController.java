package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.springboot.common.Result;
import org.example.springboot.entity.Complaint;
import org.example.springboot.service.ComplaintService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Tag(name = "订单投诉管理接口")
@RestController
@RequestMapping("/complaint")
public class ComplaintController {

    @Autowired
    private ComplaintService complaintService;

    @Operation(summary = "创建投诉")
    @PostMapping
    public Result<?> createComplaint(@RequestBody Complaint complaint) {
        return complaintService.createComplaint(complaint);
    }

    @Operation(summary = "更新投诉")
    @PutMapping("/{id}")
    public Result<?> updateComplaint(@PathVariable Long id, @RequestBody Complaint complaint) {
        return complaintService.updateComplaint(id, complaint);
    }

    @Operation(summary = "删除投诉")
    @DeleteMapping("/{id}")
    public Result<?> deleteComplaint(@PathVariable Long id) {
        return complaintService.deleteComplaint(id);
    }

    @Operation(summary = "获取投诉详情")
    @GetMapping("/{id}")
    public Result<?> getComplaintById(@PathVariable Long id) {
        return complaintService.getComplaintById(id);
    }

    @Operation(summary = "分页查询投诉列表")
    @GetMapping("/page")
    public Result<?> getComplaintsByPage(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long merchantId,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        return complaintService.getComplaintsByPage(userId, merchantId, status, currentPage, size);
    }

    @Operation(summary = "商家回复投诉")
    @PostMapping("/{id}/merchant-reply")
    public Result<?> merchantReply(@PathVariable Long id, @RequestParam String reply) {
        return complaintService.merchantReply(id, reply);
    }

    @Operation(summary = "管理员处理投诉")
    @PostMapping("/{id}/admin-handle")
    public Result<?> adminHandle(
            @PathVariable Long id,
            @RequestParam String reply,
            @RequestParam Integer status) {
        return complaintService.adminHandle(id, reply, status);
    }
}
