<template>
  <div class="favorite-page">
    <front-header></front-header>
    <div class="main-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <h2>我的收藏</h2>
        <div class="favorite-count">共 {{ totalItems }} 件商品</div>
      </div>

      <!-- 收藏列表 -->
      <div class="favorite-content" v-loading="loading">
        <!-- 空收藏提示 -->
        <el-empty 
          v-if="!loading && favorites.length === 0"
          description="暂无收藏商品"
        >
          <el-button type="primary" @click="$router.push('/products')">去逛逛</el-button>
        </el-empty>

        <!-- 收藏商品列表 -->
        <el-row :gutter="20" v-else>
          <el-col :span="6" v-for="item in favorites" :key="item.id">
            <product-card
              :product="item.product"
              :is-favorite-page="true"
      
              @toggle-favorite="handleCancelFavorite"
            />
          </el-col>
        </el-row>

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="favorites.length > 0">
          <el-pagination
            background
            :current-page.sync="currentPage"
            :page-size="pageSize"
            :total="total"
            layout="prev, pager, next, jumper"
            @current-change="handlePageChange"
          >
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
import ProductCard from '@/components/front/ProductCard.vue'
import Request from '@/utils/request'

export default {
  name: 'Favorite',
  components: {
    FrontHeader,
    FrontFooter,
    ProductCard
  },
  data() {
    return {
      userInfo: JSON.parse(localStorage.getItem('frontUser') || '{}'),
      loading: false,
      favorites: [],
      currentPage: 1,
      pageSize: 12,
      total: 0
    }
  },
  computed: {
    totalItems() {
      return this.total
    }
  },
  methods: {
    // 获取收藏列表
    async getFavorites() {
      this.loading = true
      try {
        const userId = this.userInfo.id
        const res = await Request.get(`/favorite/page?userId=${userId}&currentPage=${this.currentPage}&size=${this.pageSize}`)
        if (res.code === '0') {
          if(res.data.total===0){
            this.favorites = []
            this.total = 0
          }
          else{
            this.favorites = res.data.records.map(item => ({
              ...item,
              product: {
              ...item.product,
              isFavorite: item.status === 1  // 设置收藏状态
            }
          }))
          this.total = res.data.total
        }
      }} catch (error) {
        console.error('获取收藏列表失败:', error)
        this.$message({
          type: 'error',
          message: '获取收藏列表失败'
        })
      } finally {
        this.loading = false
      }
    },
    // 取消收藏
    async handleCancelFavorite(item) {
      try {
        await this.$confirm('确定要取消收藏该商品吗？', '提示', {
          type: 'warning'
        })
        const userId = this.userInfo.id
        const data = {
          userId: userId,
          productId: item.id,
          status: item.status  // 直接使用原有状态
        }
        const res = await Request.post('/favorite', data)
        if (res.code === '0') {
          this.$message({
            type: 'success',
            message: '已取消收藏'
          })
          this.getFavorites()
        } else {
          this.$message({
            type: 'error',
            message: res.msg || '取消收藏失败'
          })
        }
      } catch (error) {
        if (error !== 'cancel') {
          console.error('取消收藏失败:', error)
          this.$message({
            type: 'error',
            message: '取消收藏失败'
          })
        }
      }
    },
    isLogin() {
      const userStr = localStorage.getItem('frontUser')
      if (!userStr) {
        this.$message({
          type: 'warning',
          message: '请先登录'
        })
        this.$router.push('/login')
        return
      }
    },
    

    // 跳转到商品详情
    goToDetail(product) {
      this.$router.push(`/product/${product.id}`)
    },
    // 页码改变
    handlePageChange() {
      this.getFavorites()
    }
  },
  created() {
   
  },
  mounted() {
    const userInfo = localStorage.getItem('frontUser')
    if(!userInfo){
      this.$message.warning('请先登录')
      this.$router.push('/login')
    }
    else{
      this.userInfo = JSON.parse(userInfo)
      this.getFavorites()
    }
  }
}
</script>

<style scoped>
.favorite-page {
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

/* 页面标题样式 */
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
  font-size: 28px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
  position: relative;
  display: inline-block;
}

.page-header h2::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 100%;
  height: 4px;
  background: #0f2ea8;
  border-radius: 2px;
  opacity: 0.8;
}

.favorite-count {
  color: #606266;
  font-size: 15px;
  font-weight: 500;
  background: #f0f2f5;
  padding: 8px 16px;
  border-radius: 20px;
}

/* 收藏内容样式 */
.favorite-content {
  min-height: 400px;
}

/* 分页样式 */
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 40px;
  padding: 20px 0;
}

/* 空状态样式 */
:deep(.el-empty) {
  padding: 60px 0;
}

:deep(.el-empty .el-button) {
  margin-top: 20px;
  padding: 12px 30px;
  font-size: 15px;
  border-radius: 24px;
  background: linear-gradient(135deg, #0f2ea8, #3465af);
  border: none;
  transition: all 0.3s ease;
}

:deep(.el-empty .el-button:hover) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(64, 136, 192, 0.3);
}

/* 加载状态样式 */
:deep(.el-loading-mask) {
  background-color: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(4px);
}
</style> 