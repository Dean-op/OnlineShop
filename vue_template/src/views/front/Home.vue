<template>
  <div class="home" v-if="refresh" :key="refresh">
    <front-header></front-header>
    <div class="main-content">
      <front-carousel></front-carousel>
      <front-category></front-category>

      <!-- 统计数据展示 -->
      <div class="stats-section">
        <div class="stat-card">
          <div class="stat-icon">
            <i class="el-icon-goods"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.productCount }}+</div>
            <div class="stat-label">优质商品</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">
            <i class="el-icon-user"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.userCount }}+</div>
            <div class="stat-label">注册用户</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">
            <i class="el-icon-s-order"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.orderCount }}+</div>
            <div class="stat-label">成功订单</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">
            <i class="el-icon-star-on"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.rating }}</div>
            <div class="stat-label">用户好评</div>
          </div>
        </div>
      </div>

      <!-- 推荐商品区域 -->
      <div class="section">
        <div class="section-header">
          <div class="title-wrapper">
            <h2 class="section-title">推荐商品</h2>
            <div class="title-line"></div>
          </div>
          <div class="more-btn" @click="$router.push('/products')">
            <span>查看更多</span>
            <i class="el-icon-arrow-right"></i>
          </div>
        </div>
        <el-row :gutter="20">
          <el-col :span="6" v-for="product in recommendProducts" :key="product.id">
            <product-card :product="product" @add-to-cart="handleAddToCart" @toggle-favorite="handleToggleFavorite"></product-card>
          </el-col>
        </el-row>
      </div>

      <!-- 新品上市区域 -->
      <div class="section">
        <div class="section-header">
          <div class="title-wrapper">
            <h2 class="section-title">新品上市</h2>
            <div class="title-line"></div>
          </div>
          <div class="more-btn" @click="$router.push('/products?type=new')">
            <span>查看更多</span>
            <i class="el-icon-arrow-right"></i>
          </div>
        </div>
        <el-row :gutter="20">
          <el-col :span="6" v-for="product in newProducts" :key="product.id">
            <product-card :product="product" @add-to-cart="handleAddToCart" @toggle-favorite="handleToggleFavorite"></product-card>
          </el-col>
        </el-row>
      </div>
    </div>
    <front-footer></front-footer>
  </div>
</template>

<script>
import FrontHeader from '@/components/front/FrontHeader.vue'
import FrontFooter from '@/components/front/FrontFooter.vue'
import FrontCarousel from '@/components/front/FrontCarousel.vue'
import FrontCategory from '@/components/front/FrontCategory.vue'
import ProductCard from '@/components/front/ProductCard.vue'
import Request from '@/utils/request'

export default {
  name: 'Home',
  components: {
    FrontHeader,
    FrontFooter,
    FrontCarousel,
    FrontCategory,
    ProductCard
  },
  data() {
    return {
      recommendProducts: [],
      newProducts: [],
      isLoggedIn: false,
      refresh: true,
      stats: {
        productCount: 1000,
        userCount: 5000,
        orderCount: 8000,
        rating: '4.9'
      }
    }
  },
  computed: {
   
  },
  methods: {
    // 修改 checkLoginStatus 方法
    checkLoginStatus() {
      const token = localStorage.getItem('token');
      const userStr = localStorage.getItem('frontUser');
      
      if (token && userStr) {
        try {
          const user = JSON.parse(userStr);
       
          // 检查用户角色，如果不是 USER 则注销
          if (user.role !== 'USER') {
            this.logout();
            this.$message.warning('请使用普通用户账号访问');
            return;
          }
          this.isLoggedIn = true;
        } catch (error) {
          this.logout();
        }
      } else {
        this.isLoggedIn = false;
      }
    },

    // 修改 logout 方法
    logout() {
      localStorage.removeItem('token');
      localStorage.removeItem('frontUser');
      this.isLoggedIn = false;
      // 强制刷新整个页面
      window.location.reload()
   
    },

    // 获取推荐商品
    async getRecommendProducts() {
      try {
        // 重新检查登录状态
        this.checkLoginStatus();
        
        let products = [];
        
        if (!this.isLoggedIn) {
          // 未登录状态 - 获取随机排序的前8条商品
          const res = await Request.get('/product/page?status=1&size=8');
          if (res.code === '0') {
            products = res.data.records || res.data;
            // 随机排序
            products = products.sort(() => Math.random() - 0.5);
          }
        } else {
          // 登录状态 - 获取个性化推荐
          const userStr = localStorage.getItem('frontUser');
          if (!userStr) {
            throw new Error('User info not found');
          }
          const userId = JSON.parse(userStr).id;
          const res = await Request.get(`/recommend/user/${userId}`);
          if (res.code === '0') {
            products = res.data.records || res.data;
          }
          
          // 获取收藏状态
          try {
            const favRes = await Request.get(`/favorite/user/${userId}`);
            if (favRes.code === '0') {
              const favorites = favRes.data;
              products = products.map(product => ({
                ...product,
                isFavorite: favorites.some(f => f.productId === product.id && f.status === 1)
              }));
            }
          } catch (error) {
            console.error('获取收藏状态失败:', error);
            products = products.map(product => ({
              ...product,
              isFavorite: false
            }));
          }
        }

        // 设置推荐商品
        this.recommendProducts = products.map(product => ({
          ...product,
          isFavorite: product.isFavorite || false
        }));

      } catch (error) {
        console.error('获取推荐商品失败:', error);
        // 如果获取失败，回退到未登录状态的推荐
        this.isLoggedIn = false;
        this.getRecommendProducts();
      }
    },
    // 获取新品
    async getNewProducts() {
      try {
        const res = await Request.get('/product/page?status=1&sort=updatedAt,desc&size=4')
        if (res.code === '0') {
          this.newProducts = res.data.records.map(product => ({
            ...product,
            isFavorite: false
          }))
        }
      } catch (error) {
        console.error('获取新品失败:', error)
      }
    },
    // 添加到购物车
    handleAddToCart(product) {
      this.$message({
        type: 'success',
        message: '已添加到购物车'
      })
    },
    // 切换收藏状态
    async handleToggleFavorite({ product, status }) {
      // 更新本地数据
      const targetProduct = this.recommendProducts.find(p => p.id === product.id)
      if (targetProduct) {
        targetProduct.isFavorite = status === 1
      }
      
      // 重新获取推荐商品列表
      await this.getRecommendProducts()
    }
  },
  created() {
    // 添加登录状态检查
    this.checkLoginStatus();
    this.getRecommendProducts();
    this.getNewProducts();
  },
  mounted() {
    const userStr = localStorage.getItem('frontUser');
    if (userStr) {
      this.isLoggedIn = true;
    }
  }
}
</script>

<style scoped>
.home {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  position: relative;
  overflow-x: hidden;
}

.home::before {
  content: '';
  position: fixed;
  top: 0;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle at 20% 30%, rgba(255, 152, 0, 0.03) 0%, transparent 50%),
              radial-gradient(circle at 80% 70%, rgba(255, 183, 77, 0.05) 0%, transparent 50%);
  pointer-events: none;
  z-index: 0;
}

.main-content {
  flex: 1;
  padding: 0 20px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  position: relative;
  z-index: 1;
}

/* 统计数据展示 */
.stats-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 24px;
  margin: 48px 0;
  padding: 0;
}

.stat-card {
  background: #fff;
  border-radius: 20px;
  padding: 32px 28px;
  display: flex;
  align-items: center;
  gap: 20px;
  box-shadow: 0 4px 16px rgba(255, 152, 0, 0.08),
              0 8px 32px rgba(255, 152, 0, 0.04);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.stat-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, #FF9800, #FFB74D);
  transition: width 0.4s ease;
}

.stat-card:hover::before {
  width: 100%;
  opacity: 0.05;
}

.stat-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 24px rgba(255, 152, 0, 0.15),
              0 16px 48px rgba(255, 152, 0, 0.1);
}

.stat-icon {
  width: 72px;
  height: 72px;
  border-radius: 18px;
  background: linear-gradient(135deg, #FF9800, #FFB74D);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 16px rgba(255, 152, 0, 0.3);
  transition: all 0.4s ease;
  flex-shrink: 0;
}

.stat-card:hover .stat-icon {
  transform: scale(1.1) rotate(5deg);
  box-shadow: 0 6px 20px rgba(255, 152, 0, 0.4);
}

.stat-icon i {
  font-size: 36px;
  color: #fff;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 36px;
  font-weight: 700;
  background: linear-gradient(135deg, #FF9800, #F57C00);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 4px;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}
.section {
  margin: 40px 0;
}
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.title-wrapper {
  position: relative;
}

.section-title {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #333;
  position: relative;
  z-index: 1;
}

.title-line {
  position: absolute;
  bottom: 4px;
  left: 0;
  width: 100%;
  height: 10px;
  background: linear-gradient(90deg, 
    rgba(255, 152, 0, 0.2),
    rgba(255, 183, 77, 0.3),
    rgba(255, 152, 0, 0.2));
  border-radius: 6px;
  z-index: 0;
}

.more-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  border-radius: 24px;
  background: linear-gradient(135deg, #FF9800, #FFB74D);
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 8px rgba(255, 152, 0, 0.2);
  position: relative;
  overflow: hidden;
}

.more-btn::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: width 0.6s ease, height 0.6s ease;
}

.more-btn:active::after {
  width: 200px;
  height: 200px;
}

.more-btn:hover {
  background: linear-gradient(135deg, #FFB74D, #FF9800);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 152, 0, 0.3);
}

.more-btn span {
  position: relative;
  z-index: 1;
}

.more-btn i {
  font-size: 14px;
  transition: transform 0.3s ease;
  position: relative;
  z-index: 1;
}

.more-btn:hover i {
  transform: translateX(4px);
}


.el-col {
  margin-bottom: 30px;
}

/* 确保最后一行的卡片底部没有多余的margin */
.section:last-child .el-col {
  margin-bottom: 0;
}
</style> 