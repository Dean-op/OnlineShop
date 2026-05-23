<template>
  <div class="scenic-page">
    <front-header></front-header>
    <div class="main-content">
      <div class="page-header">
        <h2>文旅景点</h2>
        <div class="search-bar">
          <el-input v-model="keyword" placeholder="搜索景点..." prefix-icon="el-icon-search" clearable
            @keyup.enter.native="getScenics" style="width: 300px">
          </el-input>
          <el-select v-model="filterLevel" placeholder="景区等级" clearable @change="getScenics">
            <el-option label="5A级" value="5A"></el-option>
            <el-option label="4A级" value="4A"></el-option>
            <el-option label="3A级" value="3A"></el-option>
          </el-select>
        </div>
      </div>

      <div class="scenic-list" v-loading="loading">
        <el-empty v-if="!loading && scenics.length === 0" description="暂无景点信息"></el-empty>

        <div class="scenic-grid">
          <div v-for="item in scenics" :key="item.id" class="scenic-card" @click="goToDetail(item.id)">
            <div class="scenic-cover">
              <el-image :src="item.coverImage?.startsWith('http') ? item.coverImage : `/api${item.coverImage}`" fit="cover">
                <div slot="error" class="image-error"><i class="el-icon-picture-outline"></i></div>
              </el-image>
              <el-tag v-if="item.level" class="level-tag" type="warning">{{ item.level }}</el-tag>
            </div>
            <div class="scenic-info">
              <h3 class="scenic-name">{{ item.name }}</h3>
              <p class="scenic-desc">{{ item.description }}</p>
              <div class="scenic-location">
                <i class="el-icon-location"></i>
                {{ item.province }} {{ item.city }}
              </div>
              <div class="scenic-footer">
                <div class="ticket-price" v-if="item.ticketPrice">
                  <span class="price">¥{{ item.ticketPrice }}</span>
                  <span class="label">起</span>
                </div>
                <div class="ticket-price" v-else>
                  <span class="free">免费</span>
                </div>
                <div class="view-count">
                  <i class="el-icon-view"></i> {{ item.viewCount }}
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="pagination-wrapper" v-if="total > 0">
          <el-pagination background :current-page.sync="currentPage" :page-size="pageSize" :total="total"
            layout="prev, pager, next" @current-change="getScenics">
          </el-pagination>
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
  name: 'Scenic',
  components: { FrontHeader, FrontFooter },
  data() {
    return {
      loading: false,
      scenics: [],
      keyword: '',
      filterLevel: '',
      currentPage: 1,
      pageSize: 12,
      total: 0
    }
  },
  created() {
    this.getScenics()
  },
  methods: {
    async getScenics() {
      this.loading = true
      try {
        const res = await Request.get('/scenic/page', {
          params: {
            keyword: this.keyword,
            level: this.filterLevel,
            status: 1,
            currentPage: this.currentPage,
            size: this.pageSize
          }
        })
        if (res.code === '0') {
          this.scenics = res.data.records
          this.total = res.data.total
        }
      } finally {
        this.loading = false
      }
    },
    goToDetail(id) {
      this.$router.push(`/scenic/${id}`)
    }
  }
}
</script>

<style scoped>
.scenic-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f8f9fa;
}
.main-content {
  flex: 1;
  padding: 40px;
  max-width: 1400px;
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
.search-bar {
  display: flex;
  gap: 12px;
}
.scenic-list {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}
.scenic-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 24px;
}
.scenic-card {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  transition: all 0.3s;
}
.scenic-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(255, 152, 0, 0.2);
}
.scenic-cover {
  position: relative;
  height: 200px;
}
.scenic-cover .el-image {
  width: 100%;
  height: 100%;
}
.level-tag {
  position: absolute;
  top: 12px;
  right: 12px;
}
.image-error {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #909399;
  font-size: 40px;
}
.scenic-info {
  padding: 16px;
}
.scenic-name {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 8px 0;
}
.scenic-desc {
  color: #606266;
  font-size: 14px;
  line-height: 1.5;
  margin: 0 0 12px 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.scenic-location {
  color: #909399;
  font-size: 13px;
  margin-bottom: 12px;
}
.scenic-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.ticket-price .price {
  color: #ff4757;
  font-size: 20px;
  font-weight: 600;
}
.ticket-price .label {
  color: #909399;
  font-size: 12px;
}
.ticket-price .free {
  color: #67c23a;
  font-weight: 500;
}
.view-count {
  color: #909399;
  font-size: 13px;
}
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 30px;
}
</style>
