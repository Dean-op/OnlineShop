<template>
  <div class="forum-detail-page">
    <front-header></front-header>
    <div class="main-content" v-loading="loading">
      <div v-if="forum" class="forum-container">
        <div class="forum-header">
          <el-tag :type="forum.type === 1 ? 'primary' : 'success'" size="small">
            {{ forum.type === 1 ? '话题讨论' : '文化分享' }}
          </el-tag>
          <h1 class="forum-title">{{ forum.title }}</h1>
          <div class="forum-meta">
            <div class="author" v-if="forum.user">
              <span class="username">{{ forum.user.username }}</span>
            </div>
            <span class="time">{{ formatTime(forum.createdAt) }}</span>
            <span class="stats"><i class="el-icon-view"></i> {{ forum.viewCount }}</span>
            <span class="stats"><i class="el-icon-star-off"></i> {{ forum.likeCount }}</span>
          </div>
        </div>

        <div class="forum-body">
          <!-- 封面图片 -->
          <div v-if="forum.coverImage" class="forum-cover">
            <el-image
              :src="forum.coverImage.startsWith('http') ? forum.coverImage : `/api${forum.coverImage}`"
              fit="cover"
              class="cover-image"
              :preview-src-list="[forum.coverImage.startsWith('http') ? forum.coverImage : `/api${forum.coverImage}`]">
            </el-image>
          </div>

          <div class="forum-content">{{ forum.content }}</div>

          <!-- 内容图片 -->
          <div v-if="forum.images" class="forum-images">
            <el-image v-for="(img, index) in forum.images.split(',')" :key="index"
              :src="img.startsWith('http') ? img : `/api${img}`" fit="cover" class="content-image"
              :preview-src-list="forum.images.split(',').map(i => i.startsWith('http') ? i : `/api${i}`)">
            </el-image>
          </div>
        </div>

        <div v-if="forum.product" class="related-product-card">
          <div class="product-title">关联商品</div>
          <div class="product-info" @click="goToProduct(forum.product.id)">
            <el-image :src="forum.product.imageUrl?.startsWith('http') ? forum.product.imageUrl : `/api${forum.product.imageUrl}`" fit="cover" class="product-image"></el-image>
            <div class="product-detail">
              <div class="product-name">{{ forum.product.name }}</div>
              <div class="product-price">¥{{ forum.product.price }}</div>
            </div>
          </div>
        </div>

        <div class="forum-actions">
          <el-button type="primary" plain @click="likeForum"><i class="el-icon-star-off"></i> 点赞</el-button>
        </div>

        <div class="reply-section">
          <h3>评论 ({{ forum.replyCount }})</h3>
          <div class="reply-input">
            <el-input type="textarea" v-model="replyContent" :rows="3" placeholder="发表您的评论..."></el-input>
            <el-button type="primary" @click="submitReply" style="margin-top: 10px">发表评论</el-button>
          </div>

          <div class="reply-list">
            <div v-for="reply in forum.replies" :key="reply.id" class="reply-item">
              <div class="reply-header">
                <span class="reply-user">{{ reply.user?.username }}</span>
                <span class="reply-time">{{ formatTime(reply.createdAt) }}</span>
              </div>
              <div class="reply-content">{{ reply.content }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <front-footer></front-footer>
  </div>
</template>

<script>
import FrontHeader from '@/components/front/FrontHeader.vue'
import FrontFooter from '@/components/front/FrontFooter.vue'
import Request from '@/utils/request'
import { formatTime } from '@/utils/time'

export default {
  name: 'ForumDetail',
  components: { FrontHeader, FrontFooter },
  data() {
    return {
      loading: false,
      forum: null,
      replyContent: '',
      userInfo: JSON.parse(localStorage.getItem('frontUser') || '{}')
    }
  },
  created() {
    this.getForum()
  },
  methods: {
    formatTime,
    async getForum() {
      this.loading = true
      try {
        const res = await Request.get(`/forum/${this.$route.params.id}`)
        if (res.code === '0') {
          this.forum = res.data
        }
      } finally {
        this.loading = false
      }
    },
    async likeForum() {
      const res = await Request.post(`/forum/${this.forum.id}/like`)
      if (res.code === '0') {
        this.forum.likeCount++
        this.$message.success('点赞成功')
      }
    },
    async submitReply() {
      if (!this.userInfo.id) {
        this.$message.warning('请先登录')
        this.$router.push('/login')
        return
      }
      if (!this.replyContent.trim()) {
        this.$message.warning('请输入评论内容')
        return
      }
      const res = await Request.post('/forum/reply', {
        forumId: this.forum.id,
        userId: this.userInfo.id,
        content: this.replyContent
      })
      if (res.code === '0') {
        this.$message.success('评论成功')
        this.replyContent = ''
        this.getForum()
      }
    },
    goToProduct(id) {
      this.$router.push(`/product/${id}`)
    }
  }
}
</script>

<style scoped>
.forum-detail-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f8f9fa;
}
.main-content {
  flex: 1;
  padding: 40px;
  max-width: 900px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}
.forum-container {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}
.forum-header {
  border-bottom: 1px solid #ebeef5;
  padding-bottom: 20px;
  margin-bottom: 20px;
}
.forum-title {
  font-size: 28px;
  font-weight: 600;
  color: #303133;
  margin: 16px 0;
}
.forum-meta {
  display: flex;
  align-items: center;
  gap: 20px;
  color: #909399;
  font-size: 14px;
}
.stats {
  display: flex;
  align-items: center;
  gap: 4px;
}
.forum-body {
  padding: 20px 0;
}
.forum-cover {
  margin-bottom: 20px;
}
.cover-image {
  width: 100%;
  max-height: 400px;
  border-radius: 8px;
  object-fit: cover;
}
.forum-content {
  font-size: 16px;
  line-height: 1.8;
  color: #303133;
  white-space: pre-wrap;
}
.forum-images {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 20px;
}
.content-image {
  width: 200px;
  height: 150px;
  border-radius: 8px;
}
.related-product-card {
  background: #FFF8E1;
  border-radius: 8px;
  padding: 16px;
  margin: 20px 0;
}
.product-title {
  font-weight: 600;
  color: #FF9800;
  margin-bottom: 12px;
}
.product-info {
  display: flex;
  gap: 12px;
  cursor: pointer;
}
.product-image {
  width: 80px;
  height: 80px;
  border-radius: 6px;
}
.product-name {
  font-weight: 500;
  color: #303133;
  margin-bottom: 8px;
}
.product-price {
  color: #ff4757;
  font-weight: 600;
}
.forum-actions {
  padding: 20px 0;
  border-top: 1px solid #ebeef5;
  border-bottom: 1px solid #ebeef5;
}
.reply-section {
  margin-top: 30px;
}
.reply-section h3 {
  font-size: 18px;
  color: #303133;
  margin-bottom: 20px;
}
.reply-input {
  margin-bottom: 30px;
}
.reply-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.reply-item {
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
}
.reply-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}
.reply-user {
  font-weight: 500;
  color: #303133;
}
.reply-time {
  color: #909399;
  font-size: 13px;
}
.reply-content {
  color: #606266;
  line-height: 1.6;
}
</style>
