<template>
    <div class="lr-container">
        <el-button class="back-home-btn" type="success" plain @click="goToHome">
            <i class="el-icon-back"></i>
            返回首页
        </el-button>
        <div class="lr-content">

            <div class="lr-right">
                <router-view />
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'LRLayout',
    methods: {
        goToHome() {
            this.$router.push('/')
        }
    }
}
</script>

<style scoped>
.lr-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #f5f7fa 0%, #e4e7eb 100%);
    padding: 20px;
    position: relative;
}

.lr-content {
    display: flex;
    width: 1100px;
    height: 720px;
    background: white;
    border-radius: 30px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    animation: slideUp 0.6s ease-out;
}

.lr-left {
    flex: 1.2;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 60px;
    position: relative;
    overflow: hidden;
}

.lr-left::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(15, 46, 168, 0.7), rgba(59, 130, 246, 0.7));
    opacity: 0.85;
}

.brand-info {
    position: relative;
    color: white;
    text-align: center;
    z-index: 1;
}

.logo-container {
    width: 80px;
    height: 80px;
    margin: 0 auto 24px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.logo-container i {
    font-size: 40px;
}

.brand-info h1 {
    font-size: 36px;
    font-weight: 600;
    margin-bottom: 16px;
    letter-spacing: 1px;
}

.brand-info p {
    font-size: 18px;
    opacity: 0.9;
    margin-bottom: 40px;
}

.features {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-top: 60px;
}

.feature-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
}

.feature-item i {
    font-size: 32px;
    opacity: 0.9;
}

.feature-item span {
    font-size: 14px;
}

.lr-right {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 60px;
    background: white;
}

@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@media (max-width: 1200px) {
    .lr-content {
        width: 900px;
        height: 680px;
    }
}

@media (max-width: 992px) {
    .lr-left {
        display: none;
    }
}

.back-home-btn {
    position: fixed;
    top: 20px;
    left: 20px;
    font-size: 14px;
    padding: 8px 12px;
    border-radius: 8px;
    transition: all 0.3s ease;
    z-index: 100;
    box-shadow: 0 2px 8px rgba(15, 46, 168, 0.2);
    background: white;
}

.back-home-btn:hover {
    transform: translateX(-4px);
    box-shadow: 0 2px 8px rgba(15, 46, 168, 0.3);
}

.back-home-btn i {
    margin-right: 4px;
    transition: transform 0.3s ease;
}

.back-home-btn:hover i {
    transform: translateX(-2px);
}
</style>