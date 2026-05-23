<template>
  <footer class="front-footer">
    <div class="footer-content">
      <!-- 主要内容区域 -->
      <div class="footer-main">
        <div class="footer-section about-section">
          <div class="footer-logo">
            <i class="el-icon-shopping-bag-2"></i>
            <span class="footer-logo-text">文旅电商平台</span>
          </div>
          <p class="footer-slogan">
            探索文旅特色，品味地道好物
          </p>
          <div class="footer-contact">
            <div class="contact-item">
              <i class="el-icon-phone"></i>
              <span>400-123-4567</span>
            </div>
            <div class="contact-item">
              <i class="el-icon-message"></i>
              <span>service@example.com</span>
            </div>
          </div>
          
          <div class="social-links">
          </div>
        </div>
        

        
      <!-- 认证信息区域 -->
      <div class="footer-certifications">
        <div class="cert-item">
          <i class="el-icon-circle-check"></i>
          <span>品质保证</span>
        </div>
        <div class="cert-item">
          <i class="el-icon-truck"></i>
          <span>全国配送</span>
        </div>
        <div class="cert-item">
          <i class="el-icon-service"></i>
          <span>7×24小时服务</span>
        </div>
        <div class="cert-item">
          <i class="el-icon-lock"></i>
          <span>安全支付</span>
        </div>
        <div class="cert-item">
          <i class="el-icon-refresh"></i>
          <span>无忧退换</span>
        </div>
      </div>
      </div>



      <!-- 版权信息 -->
      <div class="footer-bottom">
        <div class="copyright">
          <p>Copyright © 2025 文旅电商平台 </p>
        </div>
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  name: 'FrontFooter'
}
</script>

<style scoped>
/* Material You Footer Styles */
.front-footer {
  background: linear-gradient(135deg, #1C1B1F 0%, #2D2C31 100%);
  padding: 60px 0 24px;
  margin-top: 80px;
  color: var(--md-surface, #FFFBFE);
  position: relative;
  overflow: hidden;
}

.front-footer::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--md-theme, #C77800), var(--md-theme-light, #FFDEAC), var(--md-theme, #C77800));
  background-size: 200% auto;
  animation: gradientMove 5s ease infinite;
}

@keyframes gradientMove {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
  position: relative;
}

.footer-main {
  display: flex;
  justify-content: space-between;
  margin-bottom: 48px;
  flex-wrap: wrap;
  gap: 40px;
}

.footer-section {
  flex: 1;
  min-width: 200px;
}

.about-section {
  max-width: 320px;
}

.footer-logo {
  display: flex;
  align-items: center;
  margin-bottom: 24px;
}

.footer-logo i {
  font-size: 36px;
  color: var(--md-theme, #C77800);
  margin-right: 12px;
  transition: transform 400ms var(--md-transition-standard);
}

.footer-logo:hover i {
  transform: scale(1.1) rotate(5deg);
}

.footer-logo-text {
  font-size: 24px;
  font-weight: 600;
  color: var(--md-surface, #FFFBFE);
  letter-spacing: 0.5px;
}

.footer-slogan {
  color: var(--md-surface-variant, #E7E0EC);
  line-height: 1.8;
  margin-bottom: 28px;
  font-size: 15px;
  padding-right: 20px;
}

.footer-contact {
  color: var(--md-surface-variant, #E7E0EC);
  display: flex;
  flex-direction: column;
  gap: 16px;
  font-size: 14px;
  margin-bottom: 28px;
}

.contact-item {
  display: flex;
  align-items: center;
  transition: transform 300ms var(--md-transition-standard);
  padding: 8px 12px;
  border-radius: var(--md-corner-medium, 12px);
  margin: -8px -12px;
}

.contact-item:hover {
  transform: translateX(8px);
  background: rgba(255, 255, 255, 0.05);
}

.contact-item i {
  color: var(--md-theme, #C77800);
  margin-right: 12px;
  font-size: 18px;
  width: 24px;
}

.social-links {
  display: flex;
  gap: 16px;
  margin-top: 24px;
}

.footer-certifications {
  display: flex;
  justify-content: space-between;
  padding: 32px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  margin-bottom: 32px;
  flex-wrap: wrap;
  gap: 16px;
}

.cert-item {
  display: flex;
  align-items: center;
  color: var(--md-surface-variant, #E7E0EC);
  transition: all 300ms var(--md-transition-standard);
  padding: 12px 20px;
  border-radius: var(--md-corner-large, 16px);
}

.cert-item:hover {
  color: var(--md-theme, #C77800);
  background: rgba(199, 120, 0, 0.1);
  transform: translateY(-4px);
}

.cert-item i {
  font-size: 28px;
  margin-right: 12px;
  color: var(--md-theme, #C77800);
}

.cert-item span {
  font-size: 14px;
  font-weight: 500;
}

.footer-bottom {
  text-align: center;
  color: var(--md-outline, #79747E);
  font-size: 13px;
  padding-top: 24px;
}

.copyright p {
  margin: 0;
  line-height: 1.8;
}

/* 响应式布局 */
@media (max-width: 992px) {
  .footer-main {
    gap: 32px;
  }

  .footer-section {
    flex: 1 1 40%;
  }

  .footer-certifications {
    justify-content: center;
    gap: 20px;
  }
}

@media (max-width: 768px) {
  .front-footer {
    padding: 48px 0 20px;
    margin-top: 60px;
  }

  .footer-main {
    flex-direction: column;
    gap: 32px;
  }

  .footer-section {
    min-width: 100%;
  }

  .about-section {
    max-width: 100%;
    text-align: center;
  }

  .footer-logo {
    justify-content: center;
  }

  .footer-contact {
    align-items: center;
  }

  .footer-certifications {
    flex-wrap: wrap;
    gap: 12px;
    padding: 24px 0;
  }

  .cert-item {
    width: calc(50% - 8px);
    justify-content: center;
    padding: 10px 16px;
  }
}

@media (max-width: 480px) {
  .cert-item {
    width: 100%;
  }

  .footer-logo-text {
    font-size: 20px;
  }

  .footer-slogan {
    font-size: 14px;
  }
}
</style>
