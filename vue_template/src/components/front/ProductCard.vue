<template>
  <div class="product-card" @click="handleClick">
    <div class="image-container">
      <el-image 
        :src="product.imageUrl?.startsWith('http') ? product.imageUrl : `/api${product.imageUrl}`" 
        class="product-image"
        fit="cover"
      >
        <div slot="error" class="image-slot">
          <i class="el-icon-picture-outline"></i>
        </div>
      </el-image>
      <div class="product-badge" v-if="product.isNew">新品</div>
    </div>
    
    <div class="product-content">
      <h3 class="product-name">{{ product.name }}</h3>
      
      <div class="product-info">
        <div v-if="product.isDiscount==1" class="price-section">
          <span   class="price">¥{{ product.discountPrice }}</span>
          <span  class="original-price">¥{{ product.price }}</span>

        </div>
        <div v-else class="price-section">
          <span   class="price">¥{{ product.price }}</span>
   

        </div>
        <div class="sales">已售{{ product.salesCount }}件</div>
      </div>
      
      <div class="product-actions">
        <div 
          class="cart-btn"
          @click.stop="handleAddToCart"
        >
          <i class="el-icon-shopping-cart-2"></i>
          <span>加入购物车</span>
        </div>
        <div 
          class="favorite-btn"
          :class="{ 'is-favorite': isFavoritePage || product.isFavorite }"
          @click.stop="handleFavorite"
        >
          <i :class="[isFavoritePage ? 'el-icon-delete' : 'el-icon-star-off']"></i>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Request from '@/utils/request'

export default {
  name: 'ProductCard',
  props: {
    product: {
      type: Object,
      required: true
    },
    isFavoritePage: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      userInfo: JSON.parse(localStorage.getItem('frontUser') || '{}')
    }
  },
  methods: {
    isLogin() {
      // 检查是否登录
      const userStr = localStorage.getItem('frontUser')
        if (!userStr) {
          this.$message({
            type: 'warning',
            message: '请先登录'
          })
          this.$router.push('/login')
          return false
        }
        return true
    },
    async handleAddToCart() {
      try {
   
         if(!this.isLogin()){
          return
         }

        const data = {
          userId: this.userInfo.id,
          productId: this.product.id,
          quantity: 1
        }

        const res = await Request.post('/cart', data)
        if (res.code === '0') {
          this.$message({
            type: 'success',
            message: '已添加到购物车'
          })
          this.$emit('add-to-cart', this.product)
        } else {
          this.$message({
            type: 'error',
            message: res.msg || '添加失败'
          })
        }
      } catch (error) {
        console.error('添加到购物车失败:', error)
        this.$message({
          type: 'error',
          message: '添加到购物车失败'
        })
      }
    },

    async handleFavorite() {
      try {
        // 如果是在收藏页面，只触发事件
        if (this.isFavoritePage) {
          this.$emit('toggle-favorite', this.product)
          return
        }

        if(!this.isLogin()){
          return
        }

        const data = {
          userId: this.userInfo.id,
          productId: this.product.id,
          status: this.product.isFavorite ? 1 : 0
        }
        const res = await Request.post('/favorite', data)
        if (res.code === '0') {
          // 使用服务器返回的状态
          this.product.isFavorite = res.data.status === 1
          this.$message({
            type: 'success',
            message: this.product.isFavorite ? '收藏成功' : '已取消收藏'
          })
          // 触发事件并传递最新状态
          this.$emit('toggle-favorite', {
            product: this.product,
            status: res.data.status
          })
          
          // 重新获取收藏状态
          this.getFavoriteStatus()
        } else {
          this.$message({
            type: 'error',
            message: res.msg || '操作失败'
          })
        }
      } catch (error) {
        console.error('收藏操作失败:', error)
        this.$message({
          type: 'error',
          message: '操作失败'
        })
      }
    },

    // 获取收藏状态的方法
    async getFavoriteStatus() {
      if (this.userInfo?.id) {
        try {
          const res = await Request.get(`/favorite/user/${this.userInfo.id}`)
          if (res.code === '0') {
            const favorites = res.data
            this.product.isFavorite = favorites.some(f => f.productId === this.product.id && f.status === 1)
          }
        } catch (error) {
          console.error('获取收藏状态失败:', error)
        }
      }
    },

    handleClick() {
      this.$router.push(`/product/${this.product.id}`)
    }
  },
  created() {

  },
  mounted() {
    // this.product = {
    //   ...this.product,
    //   isFavorite: false
    // }
    
    this.$nextTick(() => {
      this.getFavoriteStatus()
    })
  }
}
</script>

<style scoped>
/* Material You Product Card Styles */
.product-card {
  background: var(--md-surface-container-low, #F7F2FA);
  border-radius: var(--md-corner-extra-large, 28px);
  overflow: hidden;
  box-shadow: var(--md-elevation-1, 0px 1px 3px 1px rgba(0, 0, 0, 0.15));
  transition: all 400ms var(--md-transition-standard, cubic-bezier(0.2, 0, 0, 1));
  cursor: pointer;
  position: relative;
}

.product-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: var(--md-elevation-4, 0px 6px 10px 4px rgba(0, 0, 0, 0.15));
}

.product-card:active {
  transform: translateY(-4px) scale(1.01);
}

.image-container {
  position: relative;
  width: 100%;
  padding-bottom: 100%;
  overflow: hidden;
  border-radius: var(--md-corner-extra-large, 28px) var(--md-corner-extra-large, 28px) 0 0;
}

.product-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  transition: transform 500ms var(--md-transition-emphasized);
  object-fit: cover;
}

.product-card:hover .product-image {
  transform: scale(1.08);
}

.product-badge {
  position: absolute;
  top: 16px;
  right: 16px;
  background: var(--md-tertiary, #006B5B);
  color: var(--md-on-tertiary, #FFFFFF);
  padding: 8px 16px;
  border-radius: var(--md-corner-medium, 12px);
  font-size: 12px;
  font-weight: 600;
  box-shadow: var(--md-elevation-2);
  z-index: 2;
}

.product-content {
  padding: 20px;
}

.product-name {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: var(--md-on-surface, #1C1B1F);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  line-height: 1.4;
  margin-bottom: 12px;
}

.product-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 16px 0;
}

.price-section {
  display: flex;
  align-items: baseline;
  gap: 8px;
}

.price {
  color: var(--md-error, #B3261E);
  font-size: 24px;
  font-weight: 700;
}

.original-price {
  color: var(--md-outline, #79747E);
  font-size: 14px;
  text-decoration: line-through;
}

.sales {
  color: var(--md-on-surface-variant, #49454F);
  font-size: 13px;
  background: var(--md-surface-container-high, #ECE6F0);
  padding: 4px 12px;
  border-radius: var(--md-corner-small, 8px);
}

.product-actions {
  display: flex;
  gap: 12px;
  margin-top: 16px;
}

.cart-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 14px 20px;
  border-radius: var(--md-corner-extra-large, 28px);
  background: var(--md-theme, #C77800);
  color: var(--md-on-theme, #FFFFFF);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 300ms var(--md-transition-standard);
  box-shadow: var(--md-elevation-1);
  position: relative;
  overflow: hidden;
}

.cart-btn:hover {
  background: #A66400;
  box-shadow: var(--md-elevation-2);
  transform: translateY(-2px);
}

.cart-btn:active {
  transform: translateY(0);
  box-shadow: var(--md-elevation-1);
}

.cart-btn i {
  font-size: 18px;
}

.favorite-btn {
  width: 52px;
  height: 52px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--md-corner-full, 50%);
  color: var(--md-on-surface-variant, #49454F);
  cursor: pointer;
  transition: all 300ms var(--md-transition-standard);
  background: var(--md-surface-container-high, #ECE6F0);
  position: relative;
  overflow: hidden;
}

.favorite-btn:hover {
  background: var(--md-secondary-light, #FFD8E4);
  color: var(--md-secondary, #7D5260);
  transform: scale(1.1);
}

.favorite-btn:active {
  transform: scale(0.95);
}

.favorite-btn.is-favorite {
  background: var(--md-secondary, #7D5260);
  color: var(--md-on-secondary, #FFFFFF);
  box-shadow: var(--md-elevation-2);
}

.favorite-btn.is-favorite:hover {
  background: #6B4654;
  box-shadow: var(--md-elevation-3);
}

.favorite-btn i {
  font-size: 22px;
  transition: transform 300ms var(--md-transition-emphasized);
}

.favorite-btn:hover i {
  transform: scale(1.2);
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background: var(--md-surface-container, #F3EDF7);
  color: var(--md-outline, #79747E);
}

.image-slot i {
  font-size: 48px;
}
</style> 