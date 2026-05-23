<template>
  <div class="header-bar">
    <div class="header-left">
      <BreadCrumbs />
    </div>
    <div class="header-right">
      <div class="header-actions">
        <el-tooltip content="返回前台" placement="bottom">
          <div class="back-to-front" @click="goToFront">
            <i class="el-icon-s-home"></i>
            <span>返回前台</span>
          </div>
        </el-tooltip>
        <el-tooltip content="刷新页面" placement="bottom">
          <i class="el-icon-refresh-right action-icon" @click="refreshPage"></i>
        </el-tooltip>
        <el-tooltip :content="isFullscreen ? '退出全屏' : '全屏显示'" placement="bottom">
          <i :class="isFullscreen ? 'el-icon-close' : 'el-icon-full-screen'" 
             class="action-icon"
             @click="toggleFullScreen"></i>
        </el-tooltip>
        <el-divider direction="vertical"></el-divider>
        <UserAvatar />
      </div>
    </div>
  </div>
</template>

<script>
import BreadCrumbs from '../components/BreadCrumbs/index.vue'
import UserAvatar from '../components/UserAvatar/index.vue'

export default {
  name: 'HeaderBar',
  components: {
    BreadCrumbs,
    UserAvatar
  },
  data() {
    return {
      isFullscreen: false
    }
  },
  methods: {
    refreshPage() {
      window.location.reload()
    },
    toggleFullScreen() {
      if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen()
        this.isFullscreen = true
      } else {
        if (document.exitFullscreen) {
          document.exitFullscreen()
          this.isFullscreen = false
        }
      }
    },
    goToFront() {
      this.$router.push('/');
    }
  },
  mounted() {
    document.addEventListener('fullscreenchange', () => {
      this.isFullscreen = !!document.fullscreenElement
    })
  }
}
</script>

<style lang="less" scoped>
.header-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  
  .header-left {
    display: flex;
    align-items: center;
  }
  
  .header-right {
    display: flex;
    align-items: center;
    
    .header-actions {
      display: flex;
      align-items: center;
      gap: 20px;
      
      .back-to-front {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 6px 12px;
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.3s ease;
        color: #606266;
        
        &:hover {
          color: #FF9800;
          background: #FFF3E0;
        }
        
        i {
          font-size: 18px;
        }
        
        span {
          font-size: 14px;
        }
      }
      
      .action-icon {
        font-size: 20px;
        color: #606266;
        cursor: pointer;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        
        &:hover {
          color: #FF9800;
          transform: scale(1.15);
        }
        
        &.el-icon-refresh-right:hover {
          transform: scale(1.15) rotate(180deg);
        }
      }
      
      .el-divider--vertical {
        height: 20px;
        margin: 0;
      }
    }
  }
}

:deep(.el-badge__content.is-fixed) {
  top: 10px;
  right: 20px;
}

:deep(.el-badge__content) {
  background: linear-gradient(135deg, #FF9800, #FFB74D);
  border: none;
  box-shadow: 0 2px 4px rgba(255, 152, 0, 0.3);
}

:deep(.el-divider--vertical) {
  background-color: #E4E7ED;
}
</style>