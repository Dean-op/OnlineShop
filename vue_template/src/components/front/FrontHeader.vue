<template>
  <div class="front-header">
    <!-- 顶部区域：Logo + 搜索 + 用户 -->
    <div class="header-top">
      <div class="header-container">
        <div class="logo-area" @click="$router.push('/')">
          <div class="logo-icon">
            <i class="el-icon-sunny"></i>
          </div>
          <div class="logo-text-group">
            <span class="logo-text">文旅电商平台</span>
            <span class="logo-slogan">探索文旅 · 品味好物</span>
          </div>
        </div>

        <div class="search-area">
          <div class="search-wrapper">
            <i class="el-icon-search search-icon"></i>
            <el-input
              v-model="searchKey"
              placeholder="搜索商品、景点、文化..."
              clearable
              class="search-input"
              @keyup.enter.native="handleSearch"
            />
            <div class="search-btn" @click="handleSearch">
              <i class="el-icon-right"></i>
            </div>
          </div>
        </div>

        <div class="user-area">
          <div class="weather-widget">
            <i class="el-icon-partly-cloudy"></i>
            <span>适宜出游</span>
          </div>

          <div v-if="!isLoggedIn" class="login-btn" @click="goToLogin">
            <div class="btn-bg"></div>
            <i class="el-icon-user"></i>
            <span>登录</span>
          </div>

          <div v-else class="user-info">
            <el-dropdown>
              <div class="user-dropdown">
                <div class="avatar-ring">
                  <div class="user-avatar">
                    <i class="el-icon-user-solid"></i>
                  </div>
                </div>
                <span class="username">{{ userInfo.username }}</span>
                <i class="el-icon-arrow-down arrow-icon"></i>
              </div>
              <el-dropdown-menu slot="dropdown" class="user-dropdown-menu">
                <el-dropdown-item @click.native="goToUserCenter">
                  <i class="el-icon-user"></i> 个人中心
                </el-dropdown-item>
                <el-dropdown-item @click.native="$router.push('/favorite')">
                  <i class="el-icon-star-on"></i> 我的收藏
                </el-dropdown-item>
                <el-dropdown-item @click.native="logout">
                  <i class="el-icon-switch-button"></i> 退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>

          <div class="admin-btn" @click="goToAdmin">
            <i class="el-icon-setting"></i>
            <span>管理后台</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部导航区域 -->
    <div class="header-nav">
      <div class="nav-container">
        <div class="nav-list">
          <div
            v-for="(item, index) in navItems"
            :key="item.path"
            :class="['nav-item', { 'is-active': activePath === item.path }]"
            @click="navigateTo(item.path)"
            :style="{ animationDelay: index * 0.05 + 's' }"
          >
            <div class="nav-icon-wrapper">
              <i :class="item.icon"></i>
              <div class="icon-bg"></div>
            </div>
            <span class="nav-text">{{ item.name }}</span>
            <div class="nav-indicator"></div>
            <div class="hover-bubble"></div>
          </div>
        </div>

        <!-- 装饰元素 -->
        <div class="nav-decoration">
          <div class="deco-dot" v-for="n in 5" :key="n"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FrontHeader',
  data() {
    return {
      searchKey: '',
      isLoggedIn: false,
      userInfo: {},
      navItems: [
        { name: '首页', path: '/', icon: 'el-icon-s-home' },
        { name: '全部商品', path: '/products', icon: 'el-icon-goods' },
        { name: '文旅景点', path: '/scenic', icon: 'el-icon-place' },
        { name: '文化论坛', path: '/forum', icon: 'el-icon-chat-dot-round' },
        { name: '智能客服', path: '/ai-chat', icon: 'el-icon-service' },
        { name: '购物车', path: '/cart', icon: 'el-icon-shopping-cart-full' },
        { name: '我的订单', path: '/order', icon: 'el-icon-tickets' },
        { name: '我的收藏', path: '/favorite', icon: 'el-icon-star-on' },
        { name: '个人中心', path: '/user-center', icon: 'el-icon-user' }
      ]
    }
  },
  created() {
    this.checkLoginStatus();
  },
  methods: {
    checkLoginStatus() {
      const userInfo = localStorage.getItem('frontUser');
      if (userInfo) {
        this.isLoggedIn = true;
        this.userInfo = JSON.parse(userInfo);
      }
    },
    navigateTo(path) {
      this.$router.push(path);
    },
    goToLogin() {
      this.$router.push('/login')
    },
    goToUserCenter() {
      this.$router.push('/user-center')
    },
    logout() {
      localStorage.removeItem('token');
      localStorage.removeItem('frontUser');
      this.isLoggedIn = false;
      this.userInfo = {};
      this.$message.success('已退出登录');
      this.$router.push('/');
      window.location.reload()
    },
    handleSearch() {
      if (!this.searchKey.trim()) {
        this.$message({
          type: 'warning',
          message: '请输入搜索关键词'
        })
        return
      }
      this.$router.push({
        path: '/search',
        query: { keyword: this.searchKey.trim() }
      })
      this.searchKey = ''
    },
    goToAdmin() {
      const userMenuList = localStorage.getItem('userMenuList');
      const backUser = localStorage.getItem('backUser');
      if (!userMenuList || !backUser) {
        this.$message.warning('请先登录后台账号');
        this.$router.push('/login');
        return;
      }
      this.$router.push('/showView');
    }
  },
  computed: {
    activePath() {
      return this.$route.path;
    }
  }
}
</script>

<style scoped>
/* ====== 头部整体样式 ====== */
.front-header {
  position: sticky;
  top: 0;
  z-index: 1000;
  font-family: 'Google Sans', 'Roboto', -apple-system, BlinkMacSystemFont, sans-serif;
}

/* ====== 顶部区域 ====== */
.header-top {
  background: linear-gradient(135deg, #FFFBFE 0%, #FFF8F0 100%);
  border-bottom: 1px solid rgba(199, 120, 0, 0.1);
  backdrop-filter: blur(20px);
}

.header-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 16px 32px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 32px;
}

/* ====== Logo区域 ====== */
.logo-area {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 8px 16px 8px 8px;
  border-radius: 20px;
  transition: all 400ms cubic-bezier(0.2, 0, 0, 1);
  position: relative;
}

.logo-area:hover {
  background: linear-gradient(135deg, #FFDEAC 0%, #FFE8C4 100%);
  transform: scale(1.02);
}

.logo-icon {
  width: 52px;
  height: 52px;
  border-radius: 16px;
  background: linear-gradient(135deg, #FF9500 0%, #FFAA33 50%, #FFB84D 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 14px;
  box-shadow: 0 4px 16px rgba(255, 149, 0, 0.35);
  transition: all 400ms cubic-bezier(0.2, 0, 0, 1);
  position: relative;
  overflow: hidden;
}

.logo-icon::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
  transform: rotate(45deg);
  animation: logoShine 3s infinite;
}

@keyframes logoShine {
  0%, 100% { transform: rotate(45deg) translateX(-100%); }
  50% { transform: rotate(45deg) translateX(100%); }
}

.logo-area:hover .logo-icon {
  transform: rotate(-8deg) scale(1.1);
  box-shadow: 0 6px 24px rgba(255, 149, 0, 0.5);
}

.logo-icon i {
  font-size: 28px;
  color: #FFFFFF;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
  animation: sunRotate 10s linear infinite;
}

@keyframes sunRotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.logo-text-group {
  display: flex;
  flex-direction: column;
}

.logo-text {
  font-size: 22px;
  font-weight: 700;
  background: linear-gradient(135deg, #C77800, #E59500);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 1px;
}

.logo-slogan {
  font-size: 12px;
  color: #79747E;
  letter-spacing: 2px;
  margin-top: 2px;
}

/* ====== 搜索区域 ====== */
.search-area {
  flex: 1;
  max-width: 480px;
}

.search-wrapper {
  display: flex;
  align-items: center;
  background: #F3EDF7;
  border-radius: 28px;
  padding: 4px;
  transition: all 300ms cubic-bezier(0.2, 0, 0, 1);
  border: 2px solid transparent;
}

.search-wrapper:focus-within {
  background: #FFFFFF;
  border-color: #C77800;
  box-shadow: 0 4px 20px rgba(199, 120, 0, 0.15);
}

.search-icon {
  padding: 0 16px;
  font-size: 20px;
  color: #79747E;
  transition: all 300ms;
}

.search-wrapper:focus-within .search-icon {
  color: #C77800;
  transform: scale(1.1);
}

.search-input {
  flex: 1;
}

.search-input :deep(.el-input__inner) {
  border: none !important;
  background: transparent !important;
  height: 44px;
  font-size: 15px;
  padding: 0;
}

.search-input :deep(.el-input__inner::placeholder) {
  color: #79747E;
}

.search-btn {
  width: 44px;
  height: 44px;
  border-radius: 22px;
  background: linear-gradient(135deg, #C77800, #E59500);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 300ms cubic-bezier(0.2, 0, 0, 1);
  box-shadow: 0 2px 8px rgba(199, 120, 0, 0.3);
}

.search-btn:hover {
  transform: scale(1.1) rotate(10deg);
  box-shadow: 0 4px 16px rgba(199, 120, 0, 0.4);
}

.search-btn i {
  font-size: 18px;
  color: #FFFFFF;
}

/* ====== 用户区域 ====== */
.user-area {
  display: flex;
  align-items: center;
  gap: 16px;
}

.weather-widget {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 18px;
  background: linear-gradient(135deg, #E3F2FD, #BBDEFB);
  border-radius: 20px;
  font-size: 13px;
  color: #1565C0;
  font-weight: 500;
}

.weather-widget i {
  font-size: 18px;
  animation: cloudFloat 3s ease-in-out infinite;
}

@keyframes cloudFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-3px); }
}

.login-btn {
  position: relative;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  border-radius: 24px;
  background: linear-gradient(135deg, #C77800, #E59500);
  color: #FFFFFF;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(199, 120, 0, 0.3);
  transition: all 300ms cubic-bezier(0.2, 0, 0, 1);
}

.login-btn:hover {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 8px 24px rgba(199, 120, 0, 0.4);
}

.login-btn .btn-bg {
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
  transition: left 500ms;
}

.login-btn:hover .btn-bg {
  left: 100%;
}

.login-btn i {
  font-size: 18px;
}

/* 用户下拉 */
.user-dropdown {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  padding: 6px 16px 6px 6px;
  border-radius: 28px;
  background: #F3EDF7;
  transition: all 300ms cubic-bezier(0.2, 0, 0, 1);
}

.user-dropdown:hover {
  background: #FFDEAC;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(199, 120, 0, 0.2);
}

.avatar-ring {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #C77800, #FFB84D);
  padding: 2px;
  animation: ringPulse 2s ease-in-out infinite;
}

@keyframes ringPulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(199, 120, 0, 0.4); }
  50% { box-shadow: 0 0 0 4px rgba(199, 120, 0, 0); }
}

.user-avatar {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: #FFFFFF;
  display: flex;
  align-items: center;
  justify-content: center;
}

.user-avatar i {
  font-size: 20px;
  color: #C77800;
}

.username {
  font-size: 14px;
  font-weight: 600;
  color: #1C1B1F;
}

.arrow-icon {
  font-size: 12px;
  color: #79747E;
  transition: transform 300ms;
}

.user-dropdown:hover .arrow-icon {
  transform: rotate(180deg);
}

.admin-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  border-radius: 24px;
  background: linear-gradient(135deg, #E8DEF8, #D0BCFF);
  color: #21005D;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 300ms cubic-bezier(0.2, 0, 0, 1);
}

.admin-btn:hover {
  background: linear-gradient(135deg, #D0BCFF, #B69DF8);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(103, 80, 164, 0.3);
}

.admin-btn i {
  font-size: 18px;
  animation: gearSpin 4s linear infinite;
  animation-play-state: paused;
}

.admin-btn:hover i {
  animation-play-state: running;
}

@keyframes gearSpin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* ====== 导航区域 ====== */
.header-nav {
  background: linear-gradient(135deg, #FFFFFF 0%, #FFFBFE 100%);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
  position: relative;
  overflow: hidden;
}

.nav-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 32px;
  position: relative;
}

.nav-list {
  display: flex;
  justify-content: center;
  gap: 8px;
  padding: 12px 0;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 24px;
  border-radius: 16px;
  cursor: pointer;
  transition: all 400ms cubic-bezier(0.2, 0, 0, 1);
  position: relative;
  overflow: hidden;
  animation: navFadeIn 600ms backwards;
}

@keyframes navFadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.nav-icon-wrapper {
  position: relative;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-icon-wrapper i {
  font-size: 20px;
  color: #49454F;
  transition: all 300ms cubic-bezier(0.2, 0, 0, 1);
  z-index: 1;
  position: relative;
}

.icon-bg {
  position: absolute;
  width: 100%;
  height: 100%;
  border-radius: 12px;
  background: transparent;
  transition: all 300ms cubic-bezier(0.2, 0, 0, 1);
}

.nav-text {
  font-size: 15px;
  font-weight: 500;
  color: #49454F;
  transition: all 300ms;
  white-space: nowrap;
}

.nav-indicator {
  position: absolute;
  bottom: 8px;
  left: 50%;
  transform: translateX(-50%) scaleX(0);
  width: 24px;
  height: 4px;
  border-radius: 2px;
  background: linear-gradient(135deg, #C77800, #FFB84D);
  transition: transform 300ms cubic-bezier(0.2, 0, 0, 1);
}

.hover-bubble {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(199, 120, 0, 0.1) 0%, transparent 70%);
  transform: translate(-50%, -50%);
  transition: all 400ms cubic-bezier(0.2, 0, 0, 1);
  pointer-events: none;
}

/* 悬停状态 */
.nav-item:hover {
  background: linear-gradient(135deg, #FFF8F0, #FFDEAC);
}

.nav-item:hover .nav-icon-wrapper i {
  color: #C77800;
  transform: scale(1.15) translateY(-2px);
}

.nav-item:hover .icon-bg {
  background: rgba(199, 120, 0, 0.12);
  transform: scale(1.2);
}

.nav-item:hover .nav-text {
  color: #C77800;
  font-weight: 600;
}

.nav-item:hover .hover-bubble {
  width: 150%;
  height: 150%;
}

/* 激活状态 */
.nav-item.is-active {
  background: linear-gradient(135deg, #FFDEAC, #FFE8C4);
  box-shadow: 0 4px 16px rgba(199, 120, 0, 0.2);
}

.nav-item.is-active .nav-icon-wrapper i {
  color: #C77800;
  transform: scale(1.1);
}

.nav-item.is-active .icon-bg {
  background: rgba(199, 120, 0, 0.15);
}

.nav-item.is-active .nav-text {
  color: #271900;
  font-weight: 700;
}

.nav-item.is-active .nav-indicator {
  transform: translateX(-50%) scaleX(1);
}

/* 点击效果 */
.nav-item:active {
  transform: scale(0.96);
}

/* 装饰元素 */
.nav-decoration {
  position: absolute;
  right: 32px;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  gap: 6px;
}

.deco-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: linear-gradient(135deg, #C77800, #FFB84D);
  opacity: 0.3;
  animation: dotPulse 2s ease-in-out infinite;
}

.deco-dot:nth-child(2) { animation-delay: 0.2s; }
.deco-dot:nth-child(3) { animation-delay: 0.4s; }
.deco-dot:nth-child(4) { animation-delay: 0.6s; }
.deco-dot:nth-child(5) { animation-delay: 0.8s; }

@keyframes dotPulse {
  0%, 100% { transform: scale(1); opacity: 0.3; }
  50% { transform: scale(1.5); opacity: 0.6; }
}

/* ====== 响应式布局 ====== */
@media (max-width: 1400px) {
  .header-container, .nav-container {
    padding: 16px 24px;
  }

  .nav-item {
    padding: 12px 18px;
  }

  .nav-text {
    font-size: 14px;
  }
}

@media (max-width: 1200px) {
  .weather-widget {
    display: none;
  }

  .nav-item {
    padding: 10px 14px;
    gap: 8px;
  }

  .nav-icon-wrapper {
    width: 32px;
    height: 32px;
  }

  .nav-icon-wrapper i {
    font-size: 18px;
  }

  .search-area {
    max-width: 360px;
  }

  .nav-decoration {
    display: none;
  }
}

@media (max-width: 992px) {
  .logo-slogan {
    display: none;
  }

  .nav-text {
    display: none;
  }

  .nav-item {
    padding: 12px;
  }

  .nav-icon-wrapper {
    width: 40px;
    height: 40px;
  }

  .nav-icon-wrapper i {
    font-size: 22px;
  }
}
</style>
