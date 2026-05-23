<template>
  <div class="app-wrapper">
    <div class="side-container">
      <div class="logo-container">
        <i class="el-icon-shopping-bag-2 logo-icon"></i>
        <h1 class="logo-text">文旅电商平台</h1>
      </div>
      <SideMenu ref="sideMenu" />
    </div>
    <div class="main-container">
      <div class="main-header">
        <HeaderBar />
      </div>
      <div class="main-content">
        <el-scrollbar wrap-class="scrollbar">
          <router-view @update:user="updateUser" />
        </el-scrollbar>
      </div>
    </div>
  </div>
</template>

<script>
import HeaderBar from '../components/Header.vue'
import SideMenu from '../components/Aside.vue'

export default {
  name: 'Layout',
  data() {
    return {
      userInfo: JSON.parse(localStorage.getItem("backUser") || {}),
    };
  },
  created() {
// 判断是否登录
    if(!this.userInfo){
      this.$message.warning('请先登录')
      this.$router.push('/login')
    }

  },
  provide() {
    return {
      userInfo: this.userInfo,
    
    };
  },
  components: { HeaderBar, SideMenu },
  computed: {

  },
  methods: {
    updateUser(user) {
      this.userInfo = user;
      this.$refs.sideMenu.refreshMenu();
    }

  }
}
</script>

<style lang="less">
@import "../assets/less/scroller-bar";

.app-wrapper {
  width: 100%;
  height: 100%;
  overflow: hidden;
  background-color: #FFF8E1;

  .side-container {
    box-shadow: 2px 0 12px rgba(255, 152, 0, 0.12),
                4px 0 24px rgba(255, 152, 0, 0.08);
    background-color: #fff;
    float: left;
    width: 220px;
    height: 100vh;
    overflow-y: auto;
    overflow-x: hidden;
    // 滚动条宽度
    scrollbar-width: thin;
    // 滚动条颜色
    scrollbar-color: #FFB74D transparent;
    // Webkit 浏览器滚动条样式
    &::-webkit-scrollbar {
      width: 6px;
    }
    &::-webkit-scrollbar-track {
      background: transparent;
    }
    &::-webkit-scrollbar-thumb {
      background-color: #FFB74D;
      border-radius: 3px;
    }
    &::-webkit-scrollbar-thumb:hover {
      background: #FF9800;
    }
    border-right: 1px solid #FFE0B2;
    position: relative;
    z-index: 2;

    .logo-container {
      height: 64px;
      background: linear-gradient(135deg, #FF9800, #FFB74D);
      display: flex;
      align-items: center;
      padding: 0 20px;
      gap: 10px;
      position: relative;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(255, 152, 0, 0.2);
      
      &:before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(to right, 
          rgba(255,255,255,0.1),
          rgba(255,255,255,0.4),
          rgba(255,255,255,0.1)
        );
      }
      
      .logo-icon {
        font-size: 28px;
        color: #fff;
        position: relative;
        z-index: 1;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }
      
      .logo-text {
        margin: 0;
        font-size: 17px;
        color: #fff;
        font-weight: 600;
        letter-spacing: 0.5px;
        white-space: nowrap;
        position: relative;
        z-index: 1;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }
    }
  }

  .main-container {
    margin-left: 220px;
    min-height: 100vh;
    background-color: #FFF8E1;
    padding: 16px;
    position: relative;
    overflow: hidden;

    .main-header {
      background: #fff;
      border-radius: 12px;
      margin-bottom: 16px;
      box-shadow: 0 2px 8px rgba(255, 152, 0, 0.08),
                  0 4px 16px rgba(255, 152, 0, 0.04);
      padding: 16px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      
      &:hover {
        box-shadow: 0 4px 12px rgba(255, 152, 0, 0.12),
                    0 6px 20px rgba(255, 152, 0, 0.08);
      }
      
      .el-header {
        padding: 0;
        height: auto;
      }
    }

    .main-content {
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(255, 152, 0, 0.08),
                  0 4px 16px rgba(255, 152, 0, 0.04);
      min-height: calc(100vh - 140px);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      
      &:hover {
        box-shadow: 0 4px 12px rgba(255, 152, 0, 0.12),
                    0 6px 20px rgba(255, 152, 0, 0.08);
      }
      
      .el-scrollbar {
        height: calc(100vh - 140px);
        
        .scrollbar {
          height: 100%;
          overflow-x: hidden;
          padding: 20px;
        }
      }
    }
  }
}
</style>