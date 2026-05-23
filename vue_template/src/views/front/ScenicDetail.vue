<template>
  <div class="scenic-detail-page">
    <front-header></front-header>
    <div class="main-content" v-loading="loading">
      <div v-if="scenic" class="scenic-container">
        <div class="scenic-gallery">
          <el-image :src="scenic.coverImage?.startsWith('http') ? scenic.coverImage : `/api${scenic.coverImage}`" fit="cover" class="main-image">
          </el-image>
          <div v-if="scenic.images" class="image-list">
            <el-image v-for="(img, index) in scenic.images.split(',').slice(0, 4)" :key="index"
              :src="img.startsWith('http') ? img : `/api${img}`" fit="cover" class="thumb-image"
              :preview-src-list="scenic.images.split(',').map(i => i.startsWith('http') ? i : `/api${i}`)">
            </el-image>
          </div>
        </div>

        <div class="scenic-info">
          <div class="info-header">
            <h1 class="scenic-name">{{ scenic.name }}</h1>
            <el-tag v-if="scenic.level" type="warning" size="medium">{{ scenic.level }}级景区</el-tag>
          </div>

          <div class="scenic-tags" v-if="scenic.tags">
            <el-tag v-for="tag in scenic.tags.split(',')" :key="tag" size="small" effect="plain">{{ tag }}</el-tag>
          </div>

          <div class="info-section">
            <div class="info-item">
              <i class="el-icon-location"></i>
              <span>{{ scenic.province }} {{ scenic.city }} {{ scenic.address }}</span>
            </div>
            <div class="info-item" v-if="scenic.openTime">
              <i class="el-icon-time"></i>
              <span>开放时间：{{ scenic.openTime }}</span>
            </div>
            <div class="info-item" v-if="scenic.phone">
              <i class="el-icon-phone"></i>
              <span>联系电话：{{ scenic.phone }}</span>
            </div>
            <div class="info-item">
              <i class="el-icon-view"></i>
              <span>浏览量：{{ scenic.viewCount }}</span>
            </div>
          </div>

          <div class="ticket-section">
            <div class="ticket-price" v-if="scenic.ticketPrice">
              <span class="label">门票价格</span>
              <span class="price">¥{{ scenic.ticketPrice }}</span>
              <span class="unit">/人</span>
            </div>
            <div class="ticket-price" v-else>
              <span class="free">免费开放</span>
            </div>
          </div>
        </div>

        <div class="scenic-detail">
          <h2>景点介绍</h2>
          <div class="detail-content">{{ scenic.description }}</div>
          <div v-if="scenic.detail" class="detail-full">{{ scenic.detail }}</div>
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

export default {
  name: 'ScenicDetail',
  components: { FrontHeader, FrontFooter },
  data() {
    return {
      loading: false,
      scenic: null
    }
  },
  created() {
    this.getScenic()
  },
  methods: {
    async getScenic() {
      this.loading = true
      try {
        const res = await Request.get(`/scenic/${this.$route.params.id}`)
        if (res.code === '0') {
          this.scenic = res.data
        }
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.scenic-detail-page {
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
.scenic-container {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}
.scenic-gallery {
  margin-bottom: 30px;
}
.main-image {
  width: 100%;
  height: 400px;
  border-radius: 12px;
  margin-bottom: 12px;
}
.image-list {
  display: flex;
  gap: 12px;
}
.thumb-image {
  width: calc(25% - 9px);
  height: 100px;
  border-radius: 8px;
  cursor: pointer;
}
.scenic-info {
  padding-bottom: 30px;
  border-bottom: 1px solid #ebeef5;
}
.info-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
}
.scenic-name {
  font-size: 28px;
  font-weight: 600;
  color: #303133;
  margin: 0;
}
.scenic-tags {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
}
.info-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #606266;
  font-size: 14px;
}
.info-item i {
  color: #FF9800;
  font-size: 18px;
}
.ticket-section {
  margin-top: 24px;
  padding: 20px;
  background: linear-gradient(135deg, #FFF8E1, #FFE0B2);
  border-radius: 12px;
}
.ticket-price {
  display: flex;
  align-items: baseline;
  gap: 8px;
}
.ticket-price .label {
  color: #666;
  font-size: 14px;
}
.ticket-price .price {
  color: #ff4757;
  font-size: 32px;
  font-weight: 600;
}
.ticket-price .unit {
  color: #909399;
  font-size: 14px;
}
.ticket-price .free {
  color: #67c23a;
  font-size: 20px;
  font-weight: 600;
}
.scenic-detail {
  margin-top: 30px;
}
.scenic-detail h2 {
  font-size: 20px;
  color: #303133;
  margin-bottom: 16px;
}
.detail-content {
  font-size: 15px;
  line-height: 1.8;
  color: #606266;
  margin-bottom: 16px;
}
.detail-full {
  font-size: 15px;
  line-height: 1.8;
  color: #606266;
  white-space: pre-wrap;
}
</style>
