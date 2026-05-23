<template>
  <div class="category-container">
    <div class="category-wrapper">
      <div 
        v-for="(category, index) in visibleCategories" 
        :key="index" 
        class="category-item"
        @click="handleCategoryClick(category)"
      >
        <div class="icon-wrapper">
          <i :class="['icon', category.icon]"></i>
        </div>
        <span class="category-name">{{ category.name }}</span>
      </div>
      <div 
        v-if="showMore" 
        class="category-item"
        @click="handleMoreClick"
      >
        <div class="icon-wrapper">
          <i class="el-icon-more"></i>
        </div>
        <span class="category-name">更多</span>
      </div>
    </div>
  </div>
</template>

<script>
import Request from '@/utils/request.js'

export default {
  name: 'FrontCategory',
  data() {
    return {
      categories: [],
      maxVisible: 6
    }
  },
  computed: {
    visibleCategories() {
      return this.categories.slice(0, this.maxVisible)
    },
    showMore() {
      return this.categories.length > this.maxVisible
    }
  },
  created() {
    this.fetchCategories()
  },
  methods: {
    async fetchCategories() {
      try {
        const res = await Request.get('/category/all')
        if (res.code === '0') {
          this.categories = res.data.map(item => ({
            ...item,
            icon: item.icon
          }))
        }
      } catch (error) {
        console.error('获取分类数据失败:', error)
      }
    },
    getCategoryIcon(name) {
      const iconMap = {
        '蔬菜': 'el-icon-food',
        '水果': 'el-icon-apple',
        '谷物': 'el-icon-dish',
        '干货': 'el-icon-dessert',
        '肉类': 'el-icon-food',
        '水产': 'el-icon-dish-1',
        '农副产品': 'el-icon-sugar',
        '其他': 'el-icon-more'
      }
      return iconMap[name] || 'el-icon-more'
    },
    handleCategoryClick(category) {
      this.$router.push({
        name: 'category',
        params: { id: category.id },
        query: { name: category.name }
      })
    },
    handleMoreClick() {
      this.$router.push('/products')
    }
  }
}
</script>

<style scoped>
.category-container {
  background: #fff;
  padding: 16px 0;
  margin: 20px 0;
  border-radius: 16px;
  box-shadow: 0 2px 8px rgba(255, 152, 0, 0.08),
              0 4px 16px rgba(255, 152, 0, 0.04);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.category-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 12px;
}

.category-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.category-item::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 152, 0, 0.1);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: width 0.6s ease, height 0.6s ease;
}

.category-item:active::after {
  width: 300px;
  height: 300px;
}

.category-item:hover {
  background: linear-gradient(135deg, #FFF3E0, #FFE0B2);
  transform: translateY(-6px);
  box-shadow: 0 4px 16px rgba(255, 152, 0, 0.2);
}

.icon-wrapper {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: linear-gradient(135deg, #FF9800, #FFB74D);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 8px rgba(255, 152, 0, 0.3);
  position: relative;
  z-index: 1;
}

.category-item:hover .icon-wrapper {
  transform: scale(1.1) rotate(5deg);
  box-shadow: 0 4px 12px rgba(255, 152, 0, 0.4);
}

.icon {
  font-size: 24px;
  color: #fff;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.category-name {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  text-align: center;
  position: relative;
  z-index: 1;
  transition: color 0.3s ease;
}

.category-item:hover .category-name {
  color: #FF9800;
}
</style> 