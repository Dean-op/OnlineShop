<template>
  <div class="search-page">
    <front-header></front-header>
    <div class="main-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <h2>搜索结果</h2>
        <div class="total-count">共 {{ total }} 件商品</div>
      </div>

      <!-- 排序和筛选区域 -->
      <div class="toolbar">
        <div class="sort-options">
          <el-radio-group v-model="sortBy" size="small" @change="handleSort">
            <el-radio-button label="default">默认排序</el-radio-button>
            <el-radio-button label="sales,desc">销量优先</el-radio-button>
            <el-radio-button label="price,asc">价格从低到高</el-radio-button>
            <el-radio-button label="price,desc">价格从高到低</el-radio-button>
          </el-radio-group>
        </div>
        <div class="filter-box">
          <el-select v-model="categoryId" placeholder="商品分类" clearable @change="handleFilter">
            <el-option
              v-for="item in categories"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            ></el-option>
          </el-select>
          <el-select v-model="priceRange" placeholder="价格区间" clearable @change="handleFilter">
            <el-option label="0-50元" value="0-50"></el-option>
            <el-option label="50-100元" value="50-100"></el-option>
            <el-option label="100-200元" value="100-200"></el-option>
            <el-option label="200元以上" value="200-"></el-option>
          </el-select>
        </div>
      </div>

      <!-- 商品列表 -->
      <div class="products-grid" v-loading="loading">
        <el-empty 
          v-if="!loading && products.length === 0"
          :image-size="200"
          description="暂无相关商品"
        >
          <template #description>
            <p class="empty-text">抱歉，没有找到相关商品</p>
            <p class="empty-tips">您可以：</p>
            <ul class="empty-suggestions">
              <li>检查是否有错别字</li>
              <li>使用其他搜索词</li>
              <li>减少筛选条件</li>
            </ul>
          </template>
          <div class="empty-actions">
            <el-button type="primary" @click="$router.push('/products')">浏览全部商品</el-button>
            <el-button @click="resetFilters">清除筛选条件</el-button>
          </div>
        </el-empty>
        
        <el-row :gutter="20" v-else>
          <el-col :span="6" v-for="product in products" :key="product.id">
            <product-card 
              :product="product"
              @add-to-cart="handleAddToCart"
              @toggle-favorite="handleToggleFavorite"
            />
          </el-col>
        </el-row>
      </div>

      <!-- 分页 -->
      <div class="pagination-wrapper" v-if="total > 0">
        <el-pagination
          background
          :current-page.sync="currentPage"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next, jumper"
          @current-change="getProducts"
        >
        </el-pagination>
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
import { debounce } from 'lodash'

export default {
  name: 'Search',
  components: {
    FrontHeader,
    FrontFooter,
    ProductCard
  },
  data() {
    return {
      userInfo: null,
      loading: false,
      products: [],
      categories: [],
      total: 0,
      currentPage: 1,
      pageSize: 12,

      sortBy: 'default',
      categoryId: '',
      priceRange: '',
      searchKey: '',
      debouncedSearch: null
    }
  },
  created() {
    this.userInfo = JSON.parse(localStorage.getItem('frontUser') || '{}')
    this.searchKey = this.$route.query.keyword || ''
    this.getCategories()
    this.getProducts()
  },
  mounted() {
  },

  watch: {
    '$route.query.keyword'(newVal) {
      this.searchKey = newVal
      this.currentPage = 1
      this.getProducts()
    }
  },
  methods: {
    isLogin() {
      if (!this.userInfo || !this.userInfo.id) {
        this.$message.warning('请先登录')
        this.$router.push('/login')
        return false
      }
      return true
    },
    async getCategories() {
      try {
        const res = await Request.get('/category/all')
        if (res.code === '0') {
          this.categories = res.data
        }
      } catch (error) {
        console.error('获取分类列表失败:', error)
      }
    },
    
    async getProducts() {
      this.loading = true
      try {
        // 构建基础参数
        const params = {
          currentPage: this.currentPage,
          size: this.pageSize,
          name: this.searchKey || undefined,  // 如果为空字符串则设为 undefined
          categoryId: this.categoryId || undefined
        }

        // 添加排序参数
        if (this.sortBy && this.sortBy !== 'default') {
          const [field, order] = this.sortBy.split(',')
          params.sortField = field
          params.sortOrder = order
        }

        // 添加价格区间参数
        if (this.priceRange) {
          const [min, max] = this.priceRange.split('-')
          if (min) params.minPrice = Number(min)
          if (max) params.maxPrice = Number(max)
        }

        const res = await Request.get('/product/page', { params })
        
        if (res.code === '0') {
          // 确保返回的数据是数组
          this.products = Array.isArray(res.data.records) ? res.data.records : []
          this.total = res.data.total || 0
        } else {
          this.products = []
          this.total = 0
          this.$message.error(res.msg || '获取商品列表失败')
        }
      } catch (error) {
        console.error('获取商品列表失败:', error)
        this.$message.error('获取商品列表失败')
        this.products = []
        this.total = 0
      } finally {
        this.loading = false
      }
    },
    
    handleSort() {
      this.currentPage = 1
      this.getProducts()
    },
    
    handleFilter() {
      this.currentPage = 1
      this.getProducts()
    },
    async handleAddToCart(product) {
      try {
        if (!this.isLogin()) {
          return
        }

        const data = {
          userId: this.userInfo.id,
          productId: product.id,
          quantity: 1
        }

        const res = await Request.post('/cart', data)
        if (res.code === '0') {
          this.$message({
            type: 'success',
            message: '已添加到购物车'
          })
        }
      } catch (error) {
        console.error('添加到购物车失败:', error)
        this.$message.error('添加到购物车失败')
      }
    },

    handleToggleFavorite({ product, status }) {
      const targetProduct = this.products.find(p => p.id === product.id)
      if (targetProduct) {
        targetProduct.isFavorite = status === 1
      }
    },
    
    resetFilters() {
      this.categoryId = ''
      this.priceRange = ''
      this.sortBy = 'default'
      this.currentPage = 1
      this.getProducts()
    }
  }
}
</script>

<style scoped>
.search-page {
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

.total-count {
  color: #606266;
  font-size: 15px;
  font-weight: 500;
  background: #f0f2f5;
  padding: 8px 16px;
  border-radius: 20px;
}

/* 工具栏样式 */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  background: white;
  padding: 16px 24px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.filter-box {
  display: flex;
  gap: 16px;
}

/* 排序选项样式 */
.sort-options :deep(.el-radio-group) {
  display: flex;
  gap: 8px;
}

.sort-options :deep(.el-radio-button__inner) {
  border-radius: 20px;
  padding: 0 20px;
  height: 32px;
  line-height: 32px;
  transition: all 0.3s ease;
}

.sort-options :deep(.el-radio-button:not(:last-child) .el-radio-button__inner) {
  border-right: 1px solid #DCDFE6;
}

.sort-options :deep(.el-radio-button__orig-radio:checked + .el-radio-button__inner) {
  background: #0f2ea8;
  border-color: #0f2ea8;
  box-shadow: -1px 0 0 0 #0f2ea8;
}

/* 筛选框样式 */
.filter-box :deep(.el-select) {
  width: 160px;
}

/* 分页样式 */
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin: 40px 0;
  padding: 20px 0;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled).active) {
  background-color: #0f2ea8;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled):hover) {
  color: #0f2ea8;
}

/* 加载状态样式 */
:deep(.el-loading-mask) {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(4px);
}

/* 响应式布局 */
@media (max-width: 1440px) {
  .main-content {
    max-width: 1200px;
  }
}

@media (max-width: 1200px) {
  .main-content {
    max-width: 960px;
  }
}

/* 商品网格样式 */
.products-grid {
  min-height: 400px;
  margin: 0 -10px;
}

.el-col {
  padding: 10px;
  margin-bottom: 20px;
  transition: all 0.3s ease;
}

/* 空状态样式 */
.empty-text {
  font-size: 16px;
  color: #606266;
  margin-bottom: 12px;
}

.empty-tips {
  font-size: 14px;
  color: #909399;
  margin: 8px 0;
}

.empty-suggestions {
  list-style: none;
  padding: 0;
  margin: 0 0 20px;
  text-align: center;
}

.empty-suggestions li {
  color: #909399;
  font-size: 14px;
  line-height: 1.8;
}

.empty-actions {
  display: flex;
  gap: 12px;
  justify-content: center;
}
</style> 