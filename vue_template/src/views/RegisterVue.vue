<template>
    <div class="register-container">
        <h2 class="register-title">创建新账号</h2>
        <p class="register-subtitle">加入文旅电商平台</p>

        <el-form ref="registerForm" :model="registerForm" :rules="rules" class="register-form">
            <div class="form-content">
                <el-form-item prop="username">
                    <el-input 
                        v-model="registerForm.username" 
                        placeholder="请输入用户名"
                        prefix-icon="el-icon-user">
                    </el-input>
                </el-form-item>

                <el-form-item prop="password">
                    <el-input 
                        type="password" 
                        v-model="registerForm.password" 
                        placeholder="请设置密码"
                        prefix-icon="el-icon-lock">
                    </el-input>
                </el-form-item>

                <el-form-item prop="name">
                    <el-input 
                        v-model="registerForm.name" 
                        placeholder="请输入真实姓名"
                        prefix-icon="el-icon-user">
                    </el-input>
                </el-form-item>

                <el-form-item prop="email">
                    <el-input 
                        v-model="registerForm.email" 
                        placeholder="请输入邮箱"
                        prefix-icon="el-icon-message">
                    </el-input>
                </el-form-item>

                <el-form-item prop="code">
                    <div class="validate-container">
                        <el-input 
                            v-model="registerForm.code" 
                            placeholder="请输入验证码"
                            prefix-icon="el-icon-chat-line-round">
                        </el-input>
                        <el-button 
                            type="success" 
                            :disabled="disabled"
                            class="validate-btn"
                            @click="sendVerificationCode">
                            {{ buttonContent }}
                        </el-button>
                    </div>
                </el-form-item>

                <el-form-item prop="role">
                    <el-select 
                        v-model="registerForm.role" 
                        placeholder="请选择用户角色"
                        class="role-select">
                        <el-option label="普通用户" value="USER"></el-option>
                        <el-option label="商家" value="FARMER"></el-option>
                        <el-option label="管理员" value="ADMIN"></el-option>
                    </el-select>
                </el-form-item>

                <el-form-item prop="invitationCode" v-if="registerForm.role === 'ADMIN'">
                    <el-input 
                        v-model="registerForm.invitationCode" 
                        placeholder="请输入管理员邀请码"
                        prefix-icon="el-icon-key">
                        <template slot="append">
                            <el-tooltip content="请联系超级管理员获取邀请码" placement="top">
                                <i class="el-icon-question"></i>
                            </el-tooltip>
                        </template>
                    </el-input>
                </el-form-item>

                <el-form-item>
                    <el-button 
                        type="success" 
                        class="register-button"
                        @click="onRegister">
                        立即注册
                    </el-button>
                </el-form-item>

                <div class="register-actions">
                    <el-link type="success" @click="$router.push('/login')">
                        <i class="el-icon-arrow-left"></i> 返回登录
                    </el-link>
                </div>
            </div>
        </el-form>
    </div>
</template>

<script>
import request from "@/utils/request";

export default {
    name: 'Register',
    data() {
        // 验证邀请码
        const validateInvitationCode = (rule, value, callback) => {
            if (this.registerForm.role === 'ADMIN') {
                if (!value) {
                    callback(new Error('请输入管理员邀请码'));
                } else if (value !== 'ADMIN666') { // 邀请码写死为ADMIN666
                    callback(new Error('邀请码不正确'));
                } else {
                    callback();
                }
            } else {
                callback();
            }
        };

        return {
            countdown: 0,
            disabled: false,
            timer: null,
            emailCode: '',
            buttonContent: '发送验证码',
            registerForm: {
                username: '',
                password: '',
                name: '',
                email: '',
                code: '',
                role: 'USER',
                status: 1,
                invitationCode: '' // 添加邀请码字段
            },
            rules: {
                username: [
                    { required: true, message: '请输入用户名', trigger: 'blur' },
                    { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
                ],
                password: [
                    { required: true, message: '请输入密码', trigger: 'blur' },
                    { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
                ],
                name: [
                    { required: true, message: '请输入真实姓名', trigger: 'blur' }
                ],
                email: [
                    { required: true, message: '请输入邮箱', trigger: 'blur' },
                    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
                ],
                code: [
                    { required: true, message: '请输入验证码', trigger: 'blur' }
                ],
                role: [
                    { required: true, message: '请选择用户角色', trigger: 'change' }
                ],
                invitationCode: [
                    { validator: validateInvitationCode, trigger: 'blur' }
                ]
            }
        };
    },
    methods: {
        sendVerificationCode() {
            if (this.disabled) return;
            
            if (!this.registerForm.email) {
                this.$message.error('请先输入邮箱地址');
                return;
            }

            request.get(`/email/sendEmail/${this.registerForm.email}`).then(res => {
                if (res.code === '0') {
                    this.$message({
                        type: 'success',
                        message: "验证码已发送到您的邮箱,请查收"
                    });
                    console.log(res.data);
                    this.emailCode = res.data;
                    this.startCountdown();
                } else {
                    this.$message({
                        type: 'error',
                        message: res.msg
                    });
                }
            });
        },
        
        startCountdown() {
            this.countdown = 60;
            this.disabled = true;
            this.buttonContent = `${this.countdown}秒后重试`;

            this.timer = setInterval(() => {
                if (this.countdown > 0) {
                    this.countdown--;
                    this.buttonContent = `${this.countdown}秒后重试`;
                } else {
                    clearInterval(this.timer);
                    this.disabled = false;
                    this.buttonContent = '发送验证码';
                }
            }, 1000);
        },

        onRegister() {
            this.$refs.registerForm.validate((valid) => {
                if (valid) {
                    // 将验证码转换为字符串后再比较
                    if (String(this.registerForm.code) !== String(this.emailCode)) {
                        console.log('Input code:', this.registerForm.code, 'Expected code:', this.emailCode);
                        this.$message({
                            type: 'error',
                            message: '验证码不正确'
                        });
                        return;
                    }

                    // 如果是管理员注册，验证邀请码
                    if (this.registerForm.role === 'ADMIN' && 
                        this.registerForm.invitationCode !== 'ADMIN666') {
                        this.$message({
                            type: 'error',
                            message: '管理员邀请码不正确'
                        });
                        return;
                    }

                    request.post("/user/add", this.registerForm).then(res => {
                        if (res.code === '0') {
                            this.$message({
                                type: 'success',
                                message: "注册成功，请登录"
                            });
                            this.$router.push('/login');
                        } else {
                            this.$message({
                                type: 'error',
                                message: res.msg
                            });
                        }
                    });
                }
            });
        }
    },
    beforeDestroy() {
        clearInterval(this.timer);
    }
};
</script>

<style scoped>
.register-container {
    width: 100%;
    max-width: 380px;
    animation: fadeIn 0.6s ease-out;
    margin: 40px auto 0;
    padding: 0 40px 40px;

}

.register-title {
    font-size: 32px;
    color: #2c3e50;
    margin-bottom: 12px;
    text-align: center;
    font-weight: 600;
    letter-spacing: 1px;

}

.register-subtitle {
    font-size: 16px;
    color: #7f8c8d;
    margin-bottom: 40px;
    text-align: center;
    font-weight: 400;
    letter-spacing: 1px;

}

.register-form {
    margin-top: 20px;

}

.form-content {
    width: 85%;
    margin: 0 auto;
}

.validate-container {
    display: flex;
    gap: 16px;
}

.validate-btn {
    flex-shrink: 0;
    width: 120px;
    height: 42px;
    font-size: 14px;
    border-radius: 8px;
    line-height: 42px;
    padding: 0 15px;
    transition: all 0.3s ease;
    
    display: flex;
    align-items: center;
    justify-content: center;

    background: #153088;
    color: white;

}

.role-select {
    width: 100%;
}

.register-button {
    width: 100%;
    height: 42px;
    font-size: 16px;
    font-weight: 500;
    letter-spacing: 1px;
    margin-top: 20px;
    border-radius: 8px;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0;
    background: #3a4ec2;
}

.register-button:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(58, 78, 194, 0.3);
}

.register-actions {
    display: flex;
    justify-content: center;
    margin-top: 24px;
    font-size: 14px;
}

.register-actions .el-link {
    display: flex;
    align-items: center;
    gap: 4px;
}

.el-input-group__append {
    padding: 0 10px;
    cursor: help;
}

.el-input-group__append i {
    font-size: 16px;
    color: #909399;
}

.el-tooltip {
    cursor: help;
}

/* Element UI 组件样式覆盖 */
:deep(.el-input__inner) {
    height: 42px;
    line-height: 42px;
    border-radius: 8px;
    border: 1px solid #dcdfe6;
    transition: all 0.3s ease;
}

:deep(.el-input__inner:focus) {
    border-color: #0f2ea8;
    box-shadow: 0 0 0 2px rgba(103, 194, 58, 0.2);
}

:deep(.el-form-item) {
    margin-bottom: 24px;
}

:deep(.el-input__prefix) {
    left: 12px;
    top: 0;
    height: 100%;
    display: flex;
    align-items: center;
}

:deep(.el-input__prefix i) {
    font-size: 16px;
    line-height: 1;
    display: flex;
    align-items: center;
}

:deep(.el-input__inner) {
    padding-left: 38px;
}

:deep(.el-select .el-input__inner) {
    padding-left: 15px;
}

:deep(.el-select .el-input__suffix) {
    display: flex;
    align-items: center;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* 响应式调整 */
@media (max-width: 480px) {
    .register-container {
        padding: 0 20px;
    }
    
    .form-content {
        width: 100%;
    }
    
    .validate-container {
        gap: 8px;
    }
    
    .validate-btn {
        width: 110px;
        font-size: 13px;
    }
}

.validate-code {
    flex-shrink: 0;
    width: 120px;
    border-radius: 8px;
    overflow: hidden;
    /* 移除阴影效果 */
    /* box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); */
}
</style>