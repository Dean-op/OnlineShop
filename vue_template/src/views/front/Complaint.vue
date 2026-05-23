<template>
  <div class="complaint-page">
    <front-header></front-header>
    <div class="main-content">
      <div class="page-header">
        <h2>我的投诉</h2>
        <el-button type="primary" @click="showCreateDialog">发起投诉</el-button>
      </div>

      <div class="complaint-list" v-loading="loading">
        <el-empty v-if="!loading && complaints.length === 0" description="暂无投诉记录"></el-empty>

        <div v-for="item in complaints" :key="item.id" class="complaint-item">
          <div class="complaint-header">
            <span class="complaint-id">投诉编号：{{ item.id }}</span>
            <span class="complaint-time">{{ formatTime(item.createdAt) }}</span>
            <el-tag :type="getStatusType(item.status)" size="small">{{ getStatusText(item.status) }}</el-tag>
          </div>
          <div class="complaint-body">
            <div class="complaint-title">{{ item.title }}</div>
            <div class="complaint-content">{{ item.content }}</div>
            <div class="complaint-type">投诉类型：{{ getTypeText(item.type) }}</div>
            <div v-if="item.order" class="complaint-order">
              关联订单：#{{ item.order.id }}
            </div>
          </div>
          <div v-if="item.merchantReply" class="reply-section">
            <div class="reply-title">商家回复：</div>
            <div class="reply-content">{{ item.merchantReply }}</div>
          </div>
          <div v-if="item.adminReply" class="reply-section admin">
            <div class="reply-title">平台处理意见：</div>
            <div class="reply-content">{{ item.adminReply }}</div>
          </div>
        </div>

        <div class="pagination-wrapper" v-if="total > 0">
          <el-pagination background :current-page.sync="currentPage" :page-size="pageSize" :total="total"
            layout="prev, pager, next" @current-change="getComplaints">
          </el-pagination>
        </div>
      </div>
    </div>
    <front-footer></front-footer>

    <!-- 创建投诉对话框 -->
    <el-dialog title="发起投诉" :visible.sync="dialogVisible" width="600px">
      <el-form :model="form" :rules="rules" ref="form" label-width="100px">
        <el-form-item label="关联订单" prop="orderId">
          <el-select v-model="form.orderId" placeholder="请选择要投诉的订单" style="width: 100%" @change="onOrderChange">
            <el-option v-for="order in orders" :key="order.id" :label="'订单#' + order.id + ' - ' + order.product.name" :value="order.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="投诉类型" prop="type">
          <el-select v-model="form.type" placeholder="请选择投诉类型" style="width: 100%">
            <el-option label="商品质量问题" :value="1"></el-option>
            <el-option label="服务态度问题" :value="2"></el-option>
            <el-option label="物流问题" :value="3"></el-option>
            <el-option label="虚假宣传" :value="4"></el-option>
            <el-option label="其他" :value="5"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="投诉标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入投诉标题"></el-input>
        </el-form-item>
        <el-form-item label="投诉内容" prop="content">
          <el-input type="textarea" v-model="form.content" :rows="4" placeholder="请详细描述您的问题"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitComplaint">提交</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import FrontHeader from '@/components/front/FrontHeader.vue'
import FrontFooter from '@/components/front/FrontFooter.vue'
import Request from '@/utils/request'
import { formatTime } from '@/utils/time'

export default {
  name: 'Complaint',
  components: { FrontHeader, FrontFooter },
  data() {
    return {
      loading: false,
      complaints: [],
      orders: [],
      currentPage: 1,
      pageSize: 10,
      total: 0,
      dialogVisible: false,
      form: {
        orderId: null,
        merchantId: null,
        type: null,
        title: '',
        content: ''
      },
      rules: {
        orderId: [{ required: true, message: '请选择订单', trigger: 'change' }],
        type: [{ required: true, message: '请选择投诉类型', trigger: 'change' }],
        title: [{ required: true, message: '请输入投诉标题', trigger: 'blur' }],
        content: [{ required: true, message: '请输入投诉内容', trigger: 'blur' }]
      },
      userInfo: JSON.parse(localStorage.getItem('frontUser') || '{}')
    }
  },
  created() {
    this.getComplaints()
    this.getOrders()
  },
  methods: {
    formatTime,
    async getComplaints() {
      this.loading = true
      try {
        const res = await Request.get('/complaint/page', {
          params: {
            userId: this.userInfo.id,
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
    async getOrders() {
      const res = await Request.get('/order/page', {
        params: { userId: this.userInfo.id, currentPage: 1, size: 100 }
      })
      if (res.code === '0') {
        this.orders = res.data.records.filter(o => [1, 2, 3].includes(o.status))
      }
    },
    showCreateDialog() {
      this.form = { orderId: null, merchantId: null, type: null, title: '', content: '' }
      this.dialogVisible = true
    },
    onOrderChange(orderId) {
      const order = this.orders.find(o => o.id === orderId)
      if (order && order.product) {
        this.form.merchantId = order.product.userId
      }
    },
    async submitComplaint() {
      await this.$refs.form.validate()
      const res = await Request.post('/complaint', {
        ...this.form,
        userId: this.userInfo.id
      })
      if (res.code === '0') {
        this.$message.success('投诉提交成功')
        this.dialogVisible = false
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
.complaint-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f8f9fa;
}
.main-content {
  flex: 1;
  padding: 40px;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}
.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 30px;
  background: white;
  padding: 24px 30px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}
.page-header h2 {
  font-size: 24px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
}
.complaint-list {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}
.complaint-item {
  border: 1px solid #ebeef5;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 16px;
}
.complaint-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 12px;
}
.complaint-id {
  color: #909399;
  font-size: 14px;
}
.complaint-time {
  color: #909399;
  font-size: 14px;
}
.complaint-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
}
.complaint-content {
  color: #606266;
  line-height: 1.6;
  margin-bottom: 8px;
}
.complaint-type, .complaint-order {
  color: #909399;
  font-size: 13px;
}
.reply-section {
  margin-top: 16px;
  padding: 12px;
  background: #f5f7fa;
  border-radius: 6px;
}
.reply-section.admin {
  background: #fdf6ec;
}
.reply-title {
  font-weight: 600;
  color: #606266;
  margin-bottom: 6px;
}
.reply-content {
  color: #606266;
  line-height: 1.6;
}
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}
</style>
