package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.springboot.common.Result;
import org.example.springboot.entity.Complaint;
import org.example.springboot.entity.Order;
import org.example.springboot.entity.User;
import org.example.springboot.mapper.ComplaintMapper;
import org.example.springboot.mapper.OrderMapper;
import org.example.springboot.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;

@Service
public class ComplaintService {

    @Autowired
    private ComplaintMapper complaintMapper;

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private UserMapper userMapper;

    public Result<?> createComplaint(Complaint complaint) {
        complaint.setStatus(0);
        complaint.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        complaint.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        complaintMapper.insert(complaint);
        return Result.success("投诉提交成功");
    }

    public Result<?> updateComplaint(Long id, Complaint complaint) {
        complaint.setId(id);
        complaint.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        complaintMapper.updateById(complaint);
        return Result.success("更新成功");
    }

    public Result<?> deleteComplaint(Long id) {
        complaintMapper.deleteById(id);
        return Result.success("删除成功");
    }

    public Result<?> getComplaintById(Long id) {
        Complaint complaint = complaintMapper.selectById(id);
        if (complaint != null) {
            fillComplaintInfo(complaint);
        }
        return Result.success(complaint);
    }

    public Result<?> getComplaintsByPage(Long userId, Long merchantId, Integer status, Integer currentPage, Integer size) {
        QueryWrapper<Complaint> queryWrapper = new QueryWrapper<>();
        if (userId != null) {
            queryWrapper.eq("user_id", userId);
        }
        if (merchantId != null) {
            queryWrapper.eq("merchant_id", merchantId);
        }
        if (status != null) {
            queryWrapper.eq("status", status);
        }
        queryWrapper.orderByDesc("created_at");

        Page<Complaint> page = new Page<>(currentPage, size);
        Page<Complaint> result = complaintMapper.selectPage(page, queryWrapper);

        for (Complaint complaint : result.getRecords()) {
            fillComplaintInfo(complaint);
        }

        return Result.success(result);
    }

    public Result<?> merchantReply(Long id, String reply) {
        Complaint complaint = complaintMapper.selectById(id);
        if (complaint == null) {
            return Result.error("-1", "投诉不存在");
        }
        complaint.setMerchantReply(reply);
        complaint.setStatus(1);
        complaint.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        complaintMapper.updateById(complaint);
        return Result.success("回复成功");
    }

    public Result<?> adminHandle(Long id, String reply, Integer status) {
        Complaint complaint = complaintMapper.selectById(id);
        if (complaint == null) {
            return Result.error("-1", "投诉不存在");
        }
        complaint.setAdminReply(reply);
        complaint.setStatus(status);
        complaint.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        complaintMapper.updateById(complaint);
        return Result.success("处理成功");
    }

    private void fillComplaintInfo(Complaint complaint) {
        if (complaint.getUserId() != null) {
            User user = userMapper.selectById(complaint.getUserId());
            complaint.setUser(user);
        }
        if (complaint.getOrderId() != null) {
            Order order = orderMapper.selectById(complaint.getOrderId());
            complaint.setOrder(order);
        }
        if (complaint.getMerchantId() != null) {
            User merchant = userMapper.selectById(complaint.getMerchantId());
            complaint.setMerchant(merchant);
        }
    }
}
