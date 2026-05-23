<template>
  <div class="carousel-container">
    <el-carousel 
      :interval="5000" 
      arrow="hover" 
      :height="carouselHeight + 'px'"
      :autoplay="true"
    >
      <el-carousel-item v-for="item in carouselItems" :key="item.id">
        <div class="carousel-item">
          <div class="carousel-image-wrapper">
            <el-image 
              :src="'api'+item.imageUrl" 
              fit="cover"
              class="carousel-image"
            >
              <div slot="error" class="image-slot">
                <i class="el-icon-picture-outline"></i>
              </div>
            </el-image>
          </div>
          <div class="carousel-content">
            <div class="content-wrapper">
              <span class="tag">{{ item.tag }}</span>
              <h2 class="title">{{ item.title }}</h2>
              <p class="description">{{ item.description }}</p>
              <div class="price-section" v-if="item.product && item.product.isDiscount">
                <span class="currency">¥</span>
                <span class="price">{{ item.product.discountPrice }}</span>
                <span class="original-price">
                  ¥{{ item.product.price }}
                </span>
              </div>

              <div class="price-section" v-else-if="item.product">
                <span class="currency">¥</span>
                <span class="price">{{ item.product.price }}</span>
              </div>
              <el-button 
                type="success" 
                round 
                class="action-button"
                @click="handleView(item)"
              >
                {{ item.product ? '立即购买' : '查看详情' }}
              </el-button>
            </div>
          </div>
        </div>
      </el-carousel-item>
    </el-carousel>
  </div>
</template>

<script>
import Request from '@/utils/request'

export default {
  name: 'FrontCarousel',
  data() {
    return {
      carouselItems: [],
      carouselHeight: 0
    }
  },
  mounted() {
    this.calculateHeight()
    window.addEventListener('resize', this.calculateHeight)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.calculateHeight)
  },
  created() {
    this.getCarouselItems()
  },
  methods: {
    calculateHeight() {
      const containerWidth = this.$el.clientWidth
      this.carouselHeight = Math.floor(containerWidth / 3)
    },
    async getCarouselItems() {
      try {
        const res = await Request.get('/carousel/active')
        if (res.code === '0') {
          this.carouselItems = res.data
        }
      } catch (error) {
        console.error('获取轮播图数据失败:', error)
      }
    },
    handleView(item) {
      if (item.product) {
        this.$router.push(`/product/${item.product.id}`)
      }
    }
  }
}
</script>

<style scoped>
.carousel-container {
  margin: 20px auto;
  max-width: 1400px;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(255, 152, 0, 0.15),
              0 12px 48px rgba(255, 152, 0, 0.1);
  width: 100%;
  position: relative;
}

.carousel-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 5px;
  background: linear-gradient(90deg, #FF9800, #FFB74D, #FFA726, #FF9800);
  background-size: 200% auto;
  animation: gradientMove 3s ease infinite;
  z-index: 2;
}

@keyframes gradientMove {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.carousel-item {
  height: 100%;
  display: flex;
  position: relative;
}

.carousel-image-wrapper {
  width: 100%;
  height: 100%;
  position: relative;
}

.carousel-image {
  width: 100%;
  height: 100%;
  transition: transform 0.6s ease;
}

.carousel-content {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, 
    rgba(255, 152, 0, 0.9) 0%, 
    rgba(255, 152, 0, 0.6) 35%,
    rgba(255, 152, 0, 0.3) 60%,
    rgba(255, 152, 0, 0) 100%);
}

.content-wrapper {
  padding: 0 80px;
  max-width: 600px;
  color: white;
}

.tag {
  display: inline-block;
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.25);
  backdrop-filter: blur(10px);
  color: white;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 20px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.title {
  font-size: 48px;
  font-weight: 700;
  margin: 0 0 20px;
  line-height: 1.2;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  animation: slideInLeft 0.8s ease-out;
}

@keyframes slideInLeft {
  from {
    opacity: 0;
    transform: translateX(-50px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.description {
  font-size: 18px;
  line-height: 1.6;
  margin: 0 0 30px;
  opacity: 0.95;
  text-shadow: 0 1px 4px rgba(0, 0, 0, 0.15);
  animation: slideInLeft 0.8s ease-out 0.2s both;
}

.price-section {
  margin-bottom: 30px;
}

.currency {
  font-size: 20px;
  font-weight: 500;
  vertical-align: baseline;
}

.price {
  font-size: 42px;
  font-weight: 700;
  color: #fff;
  margin-right: 12px;
  margin-left: 4px;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

.original-price {
  font-size: 16px;
  color: #909399;
  text-decoration: line-through;
  margin-left: 8px;
}

.action-button {
  padding: 14px 36px;
  font-size: 16px;
  font-weight: 600;
  background: rgba(255, 255, 255, 0.95);
  border: 2px solid rgba(255, 255, 255, 0.3);
  color: #FF9800;
  border-radius: 30px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  position: relative;
  overflow: hidden;
  animation: slideInLeft 0.8s ease-out 0.4s both;
}

.action-button::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: rgba(255, 152, 0, 0.2);
  transform: translate(-50%, -50%);
  transition: width 0.6s ease, height 0.6s ease;
}

.action-button:active::before {
  width: 300px;
  height: 300px;
}

.action-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
  background: #fff;
  color: #FF6D00;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
  font-size: 30px;
}

/* 修改轮播图指示器样式 */
:deep(.el-carousel__indicators) {
  bottom: 30px; /* 调整指示器位置 */
}

:deep(.el-carousel__indicator) {
  padding: 12px 4px;
}

:deep(.el-carousel__button) {
  width: 36px;
  height: 4px;
  background-color: rgba(255, 255, 255, 0.5);
  border-radius: 4px;
  transition: all 0.3s ease;
}

:deep(.el-carousel__indicator.is-active .el-carousel__button) {
  background: linear-gradient(90deg, #FF9800, #FFB74D);
  width: 48px;
  box-shadow: 0 2px 8px rgba(255, 152, 0, 0.5);
}

/* 修改箭头样式 */
:deep(.el-carousel__arrow) {
  background: rgba(255, 152, 0, 0.8);
  backdrop-filter: blur(10px);
  border-radius: 50%;
  width: 48px;
  height: 48px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 2px solid rgba(255, 255, 255, 0.3);
}

:deep(.el-carousel__arrow:hover) {
  background: linear-gradient(135deg, #FF9800, #FFB74D);
  transform: scale(1.1);
  box-shadow: 0 4px 16px rgba(255, 152, 0, 0.4);
}

/* 移除 indicator-position="outside" 相关样式 */
.el-carousel {
  margin-bottom: 0; /* 移除底部空白 */
}

:deep(.el-carousel__container) {
  margin-bottom: 0; /* 确保容器底部没有空白 */
}
</style> 