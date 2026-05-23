<template>
  <div class="login-container">
    <h2 class="login-title">欢迎回来</h2>
    <p class="login-subtitle">请登录您的账号</p>

    <el-form ref="loginForm" :model="loginForm" :rules="rules" class="login-form">
      <div class="form-content">
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" placeholder="用户名" prefix-icon="el-icon-user">
          </el-input>
        </el-form-item>

        <el-form-item prop="password">
          <el-input type="password" v-model="loginForm.password" placeholder="密码" prefix-icon="el-icon-lock">
          </el-input>
        </el-form-item>

        <el-form-item>
          <div class="validate-container">
            <el-input v-model="loginForm.validCode" placeholder="验证码" prefix-icon="el-icon-key">
            </el-input>
            <ValidCode @input="createValidCode" class="validate-code" />
          </div>
        </el-form-item>

        <el-form-item>
          <el-button type="success" class="login-button" @click="onLogin">
            登录
          </el-button>
        </el-form-item>

        <div class="login-actions">
          <el-link type="success" @click="$router.push('/forget')" class="forget-link">
            <i class="el-icon-question"></i> 忘记密码？
          </el-link>
          <div class="register-link">
            还没有账号？
            <el-link type="success" @click="toRegister">立即注册</el-link>
          </div>
        </div>
      </div>
    </el-form>
  </div>
</template>

<script>
import ValidCode from "../components/Validate";
import request from "@/utils/request";
import { setRoutes } from "@/router";



export default {
  name: 'Login',
  components: {
    ValidCode
  },
  data() {
    return {
      validCode: '', //通过valicode获取的验证码
      loginForm: {
        username: '',
        password: '',
        validCode: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
        ]
      }
    };
  },
  methods: {
    toRegister() {
      this.$router.push("/register");
    },
    createValidCode(data) {
      this.validCode = data
    },
    onLogin() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          // 验证码比较时转换为小写，实现不区分大小写
          if (this.loginForm.validCode.toLowerCase() !== this.validCode.toLowerCase()) {
            this.$message.error("验证码错误");
            return;
          }
          request.post("/user/login", this.loginForm)
            .then(res => {
              if (res.code === "0") {
                this.$message.success("登录成功");
                if (res.data.token) {
                  localStorage.setItem("token", res.data.token);
                }
                if (res.data) {
                  if (res.data.role === 'USER') {
                    localStorage.setItem("frontUser", JSON.stringify(res.data));
                  } else {
                    localStorage.setItem("backUser", JSON.stringify(res.data));
                  }
                }

                // 根据用户角色决定跳转路径
                if (res.data.role !== 'USER') {
                  if (res.data.menuList) {
                    localStorage.setItem("userMenuList", JSON.stringify(res.data.menuList));
                  }
                  setRoutes();
                  this.$router.push('/showView');
                } else {
          
                  this.$router.push('/');
                }
              } else {
                this.$message.error(res.msg);
              }
            })
            .catch(error => {
              console.error("登录失败:", error);
            });
        } else {
          return false;
        }
      });
    }
  }
};
</script>

<style scoped>
.login-container {
  width: 100%;
  max-width: 380px;
  animation: fadeIn 0.6s ease-out;
}

.login-title {
  font-size: 60px;
  color: #2c3e50;
  margin-bottom: 12px;
  text-align: center;
  font-weight: 600;
}

.login-subtitle {
  font-size: 29px;
  color: #7f8c8d;
  margin-bottom: 40px;
  text-align: center;
}

.login-form {
  margin-top: 20px;
  background: #fff;
  padding: 40px 30px 30px 30px;
  border-radius: 16px;
  box-shadow: 0 4px 16px rgba(255, 152, 0, 0.12),
              0 8px 32px rgba(255, 152, 0, 0.08);
  animation: fadeIn 0.6s ease-out;
  border: 1px solid #FFE0B2;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.validate-container {
  display: flex;
  gap: 16px;
  align-items: center;
  justify-content: space-between;
  margin-top: -10px;
  margin-bottom: 10px;
  width: 100%;
  box-sizing: border-box;
  animation: fadeIn 0.6s ease-out;
  border: 1px solid #FFE0B2;
  border-radius: 12px;
  padding: 0 10px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.validate-container:hover {
  border-color: #FFB74D;
  box-shadow: 0 2px 8px rgba(255, 152, 0, 0.1);
}

.validate-code {
  flex-shrink: 0;
  width: 120px;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(0,0,0
,0.1);
  transition: all 0.3s ease;

}

.login-button {
  width: 100%;
  height: 46px;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 1px;
  margin-top: 20px;
  border-radius: 24px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  box-shadow: 0 4px 12px rgba(255, 152, 0, 0.25);
  background: linear-gradient(135deg, #FF9800, #FFB74D);
  color: #fff;
  border: none;
  cursor: pointer;
  text-align: center;
  user-select: none;
  outline: none;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  box-sizing: border-box;
  animation: fadeIn 0.6s ease-out;
  position: relative;
  overflow: hidden;
}

.login-button::after {
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

.login-button:active::after {
  width: 400px;
  height: 400px;
}

.login-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(255, 152, 0, 0.35);
  background: linear-gradient(135deg, #FFB74D, #FF9800);
}

.login-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 24px;
  font-size: 14px;
}

.forget-link {
  display: flex;
  align-items: center;
  gap: 4px;
  color: #5f7c7e;
  font-size: 14px;
  cursor: pointer;
}

.register-link {
  color: #7f8c8d;
  background-color: transparent!important;
  font-size: 14px;
  cursor: pointer;

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
  box-shadow: 0 0 0 2px rgba(15, 46, 168, 0.2);
}

:deep(.el-form-item) {
  margin-bottom: 24px;
}

/* 修复图标垂直居中 */
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

.form-content {
  width: 85%;
  margin: 0 auto;
}

/* 修复按钮文字居中 */
.validate-btn {
  height: 42px;
  padding: 0 15px;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 登录按钮样式调整 */
.login-button {
  height: 42px;
  line-height: 42px;
  font-size: 16px;
  font-weight: 500;
  border-radius: 8px;
  transition: all 0.3s ease;
}

/* 响应式调整 */
@media (max-width: 480px) {
  .form-content {
    width: 100%;
  }
}
</style>