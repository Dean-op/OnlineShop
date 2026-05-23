<template>
  <div class="products-page">
    <front-header></front-header>
    <div class="main-content">
      <!-- 筛选区域 -->
      <div class="filter-section">
        <el-card shadow="never">
          <!-- 分类筛选 -->
          <div class="filter-group">
            <div class="filter-label">分类：</div>
            <div class="filter-options">
              <el-tag :effect="selectedCategory === '' ? 'dark' : 'plain'" @click="handleCategoryChange('')" class="filter-tag">全部</el-tag>
              <el-tag v-for="category in categories" :key="category.id" :effect="selectedCategory === category.id ? 'dark' : 'plain'"
                @click="handleCategoryChange(category.id)" class="filter-tag">{{ category.name }}</el-tag>
            </div>
          </div>

          <!-- 价格区间 -->
          <div class="filter-group">
            <div class="filter-label">价格：</div>
            <div class="filter-options">
              <el-tag :effect="priceRange === '' ? 'dark' : 'plain'" @click="handlePriceRangeChange('')" class="filter-tag">全部</el-tag>
              <el-tag v-for="(range, index) in priceRanges" :key="index" :effect="priceRange === range.value ? 'dark' : 'plain'"
                @click="handlePriceRangeChange(range.value)" class="filter-tag">{{ range.label }}</el-tag>
            </div>
          </div>
        </el-card>
      </div>

      <!-- 排序和搜索区域 -->
      <div class="toolbar">
        <div class="sort-options">
          <el-radio-group v-model="sortBy" size="small">
            <el-radio-button 
              v-for="option in sortOptions" 
              :key="option.value" 
              :label="option.value"
            >{{ option.label }}</el-radio-button>
          </el-radio-group>
        </div>
        <div class="search-box">
          <el-input 
            v-model="searchKeyword" 
            placeholder="搜索商品" 
            prefix-icon="el-icon-search" 
            clearable 
          ></el-input>
        </div>
      </div>

      <!-- 商品列表 -->
      <div class="products-grid" v-loading="loading">
        <el-row :gutter="20" v-if="products.length > 0">
          <el-col :span="6" v-for="product in products" :key="product.id">
            <product-card :product="product"  />
          </el-col>
        </el-row>
        <div v-else class="empty-state">
          <i class="el-icon-goods"></i>
          <p>暂无商品</p>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination background :current-page.sync="currentPage" :page-size="pageSize" :total="total" layout="prev, pager, next, jumper"
          @current-change="handlePageChange">
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
  name: 'Products',
  components: {
    FrontHeader,
    FrontFooter,
    ProductCard
  },
  data() {
    return {
      loading: false,
      products: [],
      categories: [],
      selectedCategory: '',
      priceRange: '',
      priceRanges: [
        { label: '0-50元', value: '0-50' },
        { label: '50-100元', value: '50-100' },
        { label: '100-200元', value: '100-200' },
        { label: '200元以上', value: '200-' }
      ],
      sortOptions: [
        { label: '默认排序', value: 'default' },
        { label: '销量优先', value: 'sales,desc' },
        { label: '价格从低到高', value: 'price,asc' },
        { label: '价格从高到低', value: 'price,desc' }
      ],
      sortBy: 'default',
      searchKeyword: '',
      currentPage: 1,
      pageSize: 12,
      total: 0,
      debouncedSearch: null
    }
  },
  methods: {
    // 获取商品分类
    async getCategories() {
      try {
        const res = await Request.get('/category/all')
        if (res.code === '0') {
          this.categories = res.data
        }
      } catch (error) {
        console.error('获取分类失败:', error)
      }
    },
    // 获取商品列表
    async getProducts() {
      this.loading = true
      try {
        const params = {
          status: 1,
          currentPage: this.currentPage,
          size: this.pageSize
        }

        // 添加分类筛选
        if (this.selectedCategory) {
          params.categoryId = this.selectedCategory
        }

        // 添加价格区间筛选
        if (this.priceRange) {
          const [min, max] = this.priceRange.split('-')
          if (min) params.minPrice = min
          if (max) params.maxPrice = max
        }

        // 添加排序
        if (this.sortBy !== 'default') {
          const [field, order] = this.sortBy.split(',')
          params.sortField = field
          params.sortOrder = order
        }

        // 添加搜索关键词
        if (this.searchKeyword) {
          params.name = this.searchKeyword
        }

        const res = await Request.get('/product/page', { params })
        if (res.code === '0') {
          if (res.data && res.data.records) {
            this.products = res.data.records.map(product => ({
              ...product,
              isFavorite: false,
              imageUrl: product.imageUrl?.startsWith('http') ? product.imageUrl : `${product.imageUrl}`
            }))
            this.total = res.data.total
          } else {
            this.products = []
            this.total = 0
          }
        } else {
          this.products = []
          this.total = 0
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
    handleCategoryChange(categoryId) {
      this.selectedCategory = categoryId
      this.currentPage = 1
      this.getProducts()
    },
    handlePriceRangeChange(range) {
      this.priceRange = range
      this.currentPage = 1
      this.getProducts()
    },
    handleSearch() {
      this.debouncedSearch()
    },
    handlePageChange(page) {
      this.getProducts()
    },
    // 监听路由变化
    handleRouteChange() {
      const query = {}
      if (this.selectedCategory) {
        query.category = this.selectedCategory
      }
      if (this.searchKeyword) {
        query.keyword = this.searchKeyword
      }
      // 更新URL，但不触发路由变化
      this.$router.replace({ query }).catch(() => {})
    }
  },
  watch: {
    // 监听搜索关键词变化
    searchKeyword() {
      this.handleSearch()
      this.handleRouteChange()
    },
    
    // 监听分类变化
    selectedCategory() {
      this.handleRouteChange()
    },
    sortBy() {
      this.currentPage = 1
      this.getProducts()
    }
  },
  created() {
    // 创建防抖的搜索函数
    this.debouncedSearch = debounce(() => {
      this.currentPage = 1
      this.getProducts()
    }, 300)

    this.getCategories()
    this.getProducts()
    
    // 从URL获取查询参数
    const { category, keyword } = this.$route.query
    if (category) this.selectedCategory = category
    if (keyword) {
      this.searchKeyword = keyword
      this.handleSearch()
    }
  },
  beforeDestroy() {
    // 清除防抖函数
    if (this.debouncedSearch) {
      this.debouncedSearch.cancel()
    }
  }
}
</script>

<style scoped>
.products-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f8f9fa;
}

.main-content {
  flex: 1;
  padding: 30px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}

/* 筛选区域样式 */
.filter-section {
  margin-bottom: 30px;
}

.filter-section :deep(.el-card) {
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05) !important;
  transition: all 0.3s ease;
}

.filter-section :deep(.el-card:hover) {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08) !important;
}

.filter-group {
  display: flex;
  align-items: center;
  padding: 16px 0;
}

.filter-group:not(:last-child) {
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.filter-label {
  width: 80px;
  color: #1a1a1a;
  font-size: 15px;
  font-weight: 500;
  line-height: 32px;
}

.filter-options {
  flex: 1;
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
}

.filter-tag {
  cursor: pointer;
  user-select: none;
  margin: 0;
  padding: 0 16px;
  border-radius: 20px;
  font-size: 14px;
  transition: all 0.3s ease;
  height: 32px;
  line-height: 32px;
  display: flex;
  align-items: center;
}

.filter-tag:hover {
  transform: translateY(-1px);
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
  gap: 20px;
}

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

/* 搜索框样式优化 */
.search-box {
  width: 320px;
  position: relative;
}

.search-box :deep(.el-input__inner) {
  border-radius: 24px;
  padding-left: 45px;  /* 为搜索图标留出空间 */
  height: 40px;
  line-height: 40px;
  font-size: 14px;
  border: 2px solid transparent;
  background: #f5f7fa;
  transition: all 0.3s ease;
}

.search-box :deep(.el-input__inner:hover) {
  background: #ebeef5;
}

.search-box :deep(.el-input__inner:focus) {
  background: #fff;
  border-color: #0f2ea8;
  box-shadow: 0 0 0 2px rgba(103, 194, 58, 0.1);
}

.search-box :deep(.el-input__prefix) {
  left: 16px;
  line-height: 40px;
}

.search-box :deep(.el-input__icon) {
  font-size: 18px;
  color: #909399;
  transition: all 0.3s ease;
}

.search-box :deep(.el-input__inner:focus + .el-input__prefix .el-input__icon) {
  color: #0f2ea8;
}

.search-box :deep(.el-input-group__append) {
  display: none;  /* 移除搜索按钮，使用图标代替 */
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

/* 空状态样式 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
  color: #909399;
}

.empty-state i {
  font-size: 48px;
  margin-bottom: 16px;
}

.empty-state p {
  font-size: 16px;
  margin: 0;
}
</style> 