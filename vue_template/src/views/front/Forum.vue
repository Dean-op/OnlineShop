<template>
  <div class="forum-page">
    <front-header></front-header>
    <div class="main-content">
      <div class="page-header">
        <h2>文化论坛</h2>
        <div class="header-actions">
          <el-radio-group v-model="filterType" @change="getForums">
            <el-radio-button :label="null">全部</el-radio-button>
            <el-radio-button :label="1">话题讨论</el-radio-button>
            <el-radio-button :label="2">文化分享</el-radio-button>
          </el-radio-group>
          <el-button type="primary" @click="showCreateDialog">发布帖子</el-button>
        </div>
      </div>

      <div class="forum-container">
        <div class="forum-list" v-loading="loading">
          <el-empty v-if="!loading && forums.length === 0" description="暂无帖子"></el-empty>

          <div v-for="item in forums" :key="item.id" class="forum-item" @click="goToDetail(item.id)">
            <div class="forum-cover" v-if="item.coverImage">
              <el-image :src="item.coverImage.startsWith('http') ? item.coverImage : `/api${item.coverImage}`" fit="cover"></el-image>
            </div>
            <div class="forum-info">
              <div class="forum-header">
                <el-tag v-if="item.isTop" type="danger" size="mini">置顶</el-tag>
                <el-tag :type="item.type === 1 ? 'primary' : 'success'" size="mini">
                  {{ item.type === 1 ? '话题讨论' : '文化分享' }}
                </el-tag>
                <span class="forum-title">{{ item.title }}</span>
              </div>
              <div class="forum-content">{{ (item.content || '').substring(0, 100) }}...</div>
              <div class="forum-meta">
                <div class="user-info" v-if="item.user">
                  <span class="username">{{ item.user.username }}</span>
                </div>
                <div class="stats">
                  <span><i class="el-icon-view"></i> {{ item.viewCount }}</span>
                  <span><i class="el-icon-chat-dot-round"></i> {{ item.replyCount }}</span>
                  <span><i class="el-icon-star-off"></i> {{ item.likeCount }}</span>
                </div>
                <span class="time">{{ formatTime(item.createdAt) }}</span>
              </div>
              <div v-if="item.product" class="related-product">
                <i class="el-icon-goods"></i> 关联商品：{{ item.product.name }}
              </div>
            </div>
          </div>

          <div class="pagination-wrapper" v-if="total > 0">
            <el-pagination background :current-page.sync="currentPage" :page-size="pageSize" :total="total"
              layout="prev, pager, next" @current-change="getForums">
            </el-pagination>
          </div>
        </div>
      </div>
    </div>
    <front-footer></front-footer>

    <!-- 发布帖子对话框 -->
    <el-dialog title="发布帖子" :visible.sync="dialogVisible" width="700px">
      <el-form :model="form" :rules="rules" ref="form" label-width="100px">
        <el-form-item label="帖子类型" prop="type">
          <el-radio-group v-model="form.type">
            <el-radio :label="1">话题讨论</el-radio>
            <el-radio :label="2">文化分享</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="关联商品" v-if="form.type === 2 && isMerchant">
          <el-select v-model="form.productId" placeholder="选择要分享的商品" style="width: 100%" clearable>
            <el-option v-for="product in myProducts" :key="product.id" :label="product.name" :value="product.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="帖子标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入帖子标题"></el-input>
        </el-form-item>
        <el-form-item label="帖子内容" prop="content">
          <el-input type="textarea" v-model="form.content" :rows="6" placeholder="分享您的想法..."></el-input>
        </el-form-item>
        <el-form-item label="封面图片">
          <el-upload
            class="cover-uploader"
            action="/api/file/upload/img"
            name="file"
            :show-file-list="false"
            :on-success="handleCoverSuccess"
            :on-error="handleUploadError">
            <img v-if="form.coverImage" :src="form.coverImage.startsWith('http') ? form.coverImage : `/api${form.coverImage}`" class="cover-preview">
            <i v-else class="el-icon-plus cover-uploader-icon"></i>
          </el-upload>
          <div class="upload-tip">点击上传封面图片</div>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForum">发布</el-button>
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
  name: 'Forum',
  components: { FrontHeader, FrontFooter },
  data() {
    return {
      loading: false,
      forums: [],
      myProducts: [],
      filterType: null,
      currentPage: 1,
      pageSize: 10,
      total: 0,
      dialogVisible: false,
      form: {
        type: 1,
        productId: null,
        title: '',
        content: '',
        coverImage: ''
      },
      rules: {
        type: [{ required: true, message: '请选择帖子类型', trigger: 'change' }],
        title: [{ required: true, message: '请输入帖子标题', trigger: 'blur' }],
        content: [{ required: true, message: '请输入帖子内容', trigger: 'blur' }]
      },
      userInfo: JSON.parse(localStorage.getItem('frontUser') || '{}')
    }
  },
  computed: {
    isMerchant() {
      return this.userInfo.role === 'merchant' || this.userInfo.role === 'MERCHANT'
    }
  },
  created() {
    this.getForums()
    if (this.isMerchant) {
      this.getMyProducts()
    }
  },
  methods: {
    formatTime,
    async getForums() {
      this.loading = true
      try {
        const res = await Request.get('/forum/page', {
          params: {
            type: this.filterType,
            currentPage: this.currentPage,
            size: this.pageSize
          }
        })
        if (res.code === '0') {
          this.forums = res.data?.records || []
          this.total = res.data?.total || 0
        }
      } catch (e) {
        console.error('获取论坛列表失败:', e)
        this.forums = []
        this.total = 0
      } finally {
        this.loading = false
      }
    },
    async getMyProducts() {
      const res = await Request.get('/product/page', {
        params: { userId: this.userInfo.id, currentPage: 1, size: 100 }
      })
      if (res.code === '0') {
        this.myProducts = res.data.records
      }
    },
    showCreateDialog() {
      if (!this.userInfo.id) {
        this.$message.warning('请先登录')
        this.$router.push('/login')
        return
      }
      this.form = { type: 1, productId: null, title: '', content: '', coverImage: '' }
      this.dialogVisible = true
    },
    handleCoverSuccess(res) {
      if (res.code === '0') {
        this.form.coverImage = res.data
        this.$message.success('图片上传成功')
      } else {
        this.$message.error(res.msg || '上传失败')
      }
    },
    handleUploadError(err) {
      console.error('上传错误:', err)
      this.$message.error('图片上传失败，请重试')
    },
    async submitForum() {
      await this.$refs.form.validate()
      const res = await Request.post('/forum', {
        ...this.form,
        userId: this.userInfo.id
      })
      if (res.code === '0') {
        this.$message.success('发布成功')
        this.dialogVisible = false
        this.getForums()
      }
    },
    goToDetail(id) {
      this.$router.push(`/forum/${id}`)
    }
  }
}
</script>

<style scoped>
.forum-page {
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
.header-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}
.forum-list {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}
.forum-item {
  display: flex;
  gap: 20px;
  padding: 20px;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  margin-bottom: 16px;
  cursor: pointer;
  transition: all 0.3s;
}
.forum-item:hover {
  border-color: #FF9800;
  box-shadow: 0 4px 12px rgba(255, 152, 0, 0.15);
}
.forum-cover {
  width: 160px;
  height: 120px;
  border-radius: 6px;
  overflow: hidden;
  flex-shrink: 0;
}
.forum-cover .el-image {
  width: 100%;
  height: 100%;
}
.forum-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.forum-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}
.forum-title {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
}
.forum-content {
  color: #606266;
  line-height: 1.6;
  margin-bottom: 12px;
  flex: 1;
}
.forum-meta {
  display: flex;
  align-items: center;
  gap: 20px;
  color: #909399;
  font-size: 13px;
}
.stats {
  display: flex;
  gap: 12px;
}
.stats span {
  display: flex;
  align-items: center;
  gap: 4px;
}
.related-product {
  margin-top: 8px;
  padding: 8px 12px;
  background: #FFF3E0;
  border-radius: 4px;
  color: #FF9800;
  font-size: 13px;
}
.cover-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  width: 178px;
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.cover-uploader :deep(.el-upload) {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.cover-uploader:hover {
  border-color: #FF9800;
}
.cover-uploader-icon {
  font-size: 28px;
  color: #8c939d;
}
.cover-preview {
  width: 178px;
  height: 120px;
  object-fit: cover;
}
.upload-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
}
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}
</style>
