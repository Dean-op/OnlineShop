<template>
  <div class="complaint-manager">
    <div class="page-header">
      <h2>投诉管理</h2>
    </div>

    <div class="filter-bar">
      <el-select v-model="filterStatus" placeholder="投诉状态" clearable @change="getComplaints">
        <el-option label="待处理" :value="0"></el-option>
        <el-option label="处理中" :value="1"></el-option>
        <el-option label="已解决" :value="2"></el-option>
        <el-option label="已关闭" :value="3"></el-option>
      </el-select>
    </div>

    <el-table :data="complaints" v-loading="loading" stripe>
      <el-table-column prop="id" label="ID" width="80"></el-table-column>
      <el-table-column label="投诉用户" width="120">
        <template slot-scope="scope">{{ scope.row.user?.username }}</template>
      </el-table-column>
      <el-table-column prop="title" label="投诉标题" min-width="150"></el-table-column>
      <el-table-column label="投诉类型" width="100">
        <template slot-scope="scope">{{ getTypeText(scope.row.type) }}</template>
      </el-table-column>
      <el-table-column label="关联订单" width="100">
        <template slot-scope="scope">#{{ scope.row.orderId }}</template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template slot-scope="scope">
          <el-tag :type="getStatusType(scope.row.status)" size="small">{{ getStatusText(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createdAt" label="创建时间" width="160">
        <template slot-scope="scope">{{ formatTime(scope.row.createdAt) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="150" fixed="right">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="showDetail(scope.row)">查看</el-button>
          <el-button type="text" size="small" @click="showHandleDialog(scope.row)" v-if="scope.row.status < 2">处理</el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination-wrapper">
      <el-pagination background :current-page.sync="currentPage" :page-size="pageSize" :total="total"
        layout="total, prev, pager, next" @current-change="getComplaints">
      </el-pagination>
    </div>

    <!-- 详情对话框 -->
    <el-dialog title="投诉详情" :visible.sync="detailDialogVisible" width="600px">
      <div v-if="currentComplaint" class="complaint-detail">
        <div class="detail-item">
          <label>投诉用户：</label>
          <span>{{ currentComplaint.user?.username }}</span>
        </div>
        <div class="detail-item">
          <label>投诉类型：</label>
          <span>{{ getTypeText(currentComplaint.type) }}</span>
        </div>
        <div class="detail-item">
          <label>投诉标题：</label>
          <span>{{ currentComplaint.title }}</span>
        </div>
        <div class="detail-item">
          <label>投诉内容：</label>
          <span>{{ currentComplaint.content }}</span>
        </div>
        <div class="detail-item" v-if="currentComplaint.merchantReply">
          <label>商家回复：</label>
          <span>{{ currentComplaint.merchantReply }}</span>
        </div>
        <div class="detail-item" v-if="currentComplaint.adminReply">
          <label>处理意见：</label>
          <span>{{ currentComplaint.adminReply }}</span>
        </div>
      </div>
    </el-dialog>

    <!-- 处理对话框 -->
    <el-dialog title="处理投诉" :visible.sync="handleDialogVisible" width="500px">
      <el-form :model="handleForm" :rules="handleRules" ref="handleForm" label-width="100px">
        <el-form-item label="处理结果" prop="status">
          <el-select v-model="handleForm.status" style="width: 100%">
            <el-option label="已解决" :value="2"></el-option>
            <el-option label="已关闭" :value="3"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="处理意见" prop="reply">
          <el-input type="textarea" v-model="handleForm.reply" :rows="4" placeholder="请输入处理意见"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="handleDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitHandle">提交</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import Request from '@/utils/request'
import { formatTime } from '@/utils/time'

export default {
  name: 'ComplaintManager',
  data() {
    return {
      loading: false,
      complaints: [],
      filterStatus: null,
      currentPage: 1,
      pageSize: 10,
      total: 0,
      detailDialogVisible: false,
      handleDialogVisible: false,
      currentComplaint: null,
      handleForm: {
        status: 2,
        reply: ''
      },
      handleRules: {
        status: [{ required: true, message: '请选择处理结果', trigger: 'change' }],
        reply: [{ required: true, message: '请输入处理意见', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.getComplaints()
  },
  methods: {
    formatTime,
    async getComplaints() {
      this.loading = true
      try {
        const res = await Request.get('/complaint/page', {
          params: {
            status: this.filterStatus,
            currentPage: this.currentPage,
            size: this.pageSize
          }
        })
        if (res.code === '0') {
          this.complaints = res.data.records
          this.total = res.data.total
        }
      } finally {
        this.loading = false
      }
    },
    showDetail(complaint) {
      this.currentComplaint = complaint
      this.detailDialogVisible = true
    },
    showHandleDialog(complaint) {
      this.currentComplaint = complaint
      this.handleForm = { status: 2, reply: '' }
      this.handleDialogVisible = true
    },
    async submitHandle() {
      await this.$refs.handleForm.validate()
      const res = await Request.post(`/complaint/${this.currentComplaint.id}/admin-handle`, null, {
        params: {
          reply: this.handleForm.reply,
          status: this.handleForm.status
        }
      })
      if (res.code === '0') {
        this.$message.success('处理成功')
        this.handleDialogVisible = false
        this.getComplaints()
      }
    },
    getStatusText(status) {
      return ['待处理', '处理中', '已解决', '已关闭'][status] || '未知'
    },
    getStatusType(status) {
      return ['warning', 'primary', 'success', 'info'][status] || 'info'
    },
    getTypeText(type) {
      return ['', '商品质量', '服务态度', '物流问题', '虚假宣传', '其他'][type] || ''
    }
  }
}
</script>

<style scoped>
.complaint-manager {
  padding: 20px;
}
.page-header {
  margin-bottom: 20px;
}
.page-header h2 {
  margin: 0;
  font-size: 20px;
  color: #303133;
}
.filter-bar {
  margin-bottom: 20px;
}
.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
.complaint-detail .detail-item {
  margin-bottom: 16px;
}
.complaint-detail .detail-item label {
  font-weight: 600;
  color: #606266;
  margin-right: 8px;
}
</style>
