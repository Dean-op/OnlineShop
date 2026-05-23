<template>
  <div class="person-info" style="padding: 24px; background-color: #f0f2f5; min-height: calc(100vh - 60px);">
    <!-- 页面标题区域 -->
    <div class="page-header">
      <h2>个人信息</h2>
      <el-tag type="info">{{ getRoleName(userInfo.role) }}</el-tag>
    </div>

    <!-- 信息卡片 -->
    <div class="card-container">
      <el-card class="info-card" shadow="hover">
        <el-form 
          :model="userInfo" 
          :rules="rules" 
          ref="userInfoForm" 
          label-width="80px"
          class="info-form"
        >
          <el-form-item label="用户名" prop="username">
            <el-input v-model="userInfo.username" disabled>
              <template slot="prepend">
                <i class="el-icon-user"></i>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="姓名" prop="name">
            <el-input v-model="userInfo.name">
              <template slot="prepend">
                <i class="el-icon-edit"></i>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="邮箱" prop="email">
            <el-input v-model="userInfo.email">
              <template slot="prepend">
                <i class="el-icon-message"></i>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="update" icon="el-icon-check">
              保存修改
            </el-button>
          </el-form-item>
        </el-form>
      </el-card>
    </div>
  </div>
</template>

<script>
import request from '@/utils/request';

export default {
  name: 'PersonInfo',
  inject: ['userInfo'],
  
  data() {
    return {
      rules: {
        name: [
          { required: true, message: '姓名不能为空', trigger: 'blur' },
          { min: 2, max: 10, message: '姓名长度必须在2到10个字符之间', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '邮箱不能为空', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱地址', trigger: ['blur', 'change'] }
        ]
      }
    };
  },

  methods: {
    getRoleName(role) {
      const roleMap = {
        'SUPER_ADMIN': '超级管理员',
        'ADMIN': '管理员',
        'FARMER': '商家',
        'USER': '普通用户'
      }
      return roleMap[role]
    },

    update() {
      this.$refs.userInfoForm.validate((valid) => {
        if (valid) {
          request.put("/user/" + this.userInfo.id, this.userInfo).then(response => {
            if (response.code == '0') {
              this.$message({
                type: 'success',
                message: '信息保存成功!'
              })
              localStorage.setItem("backUser", JSON.stringify(this.userInfo))
              this.$emit("update:user", this.userInfo)


            } else {
              this.$message({
                type: 'error',
                message: response.msg
              })
            }
          })
        } else {
          return false;
        }
      });
    }
  }
};
</script>

<style scoped>
.page-header {
  display: flex;
  align-items: center;
  margin-bottom: 24px;
}

.page-header h2 {
  font-size: 24px;
  font-weight: 500;
  color: #1f2f3d;
  margin: 0;
  margin-right: 15px;
}

.card-container {
  max-width: 800px;
  margin: 0 auto;
}

.info-card {
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.info-form {
  max-width: 600px;
  margin: 0 auto;
  padding: 30px 20px;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #1f2f3d;
}

:deep(.el-input__inner) {
  border-radius: 4px;
}

:deep(.el-input-group__prepend) {
  background-color: #f5f7fa;
  border-color: #dcdfe6;
  color: #909399;
  padding: 0 15px;
}

:deep(.el-button) {
  padding: 12px 20px;
  font-size: 14px;
  border-radius: 4px;
  width: 100%;
}

:deep(.el-button--primary) {
  background-color: #409eff;
  border-color: #409eff;
  &:hover {
    background-color: #66b1ff;
    border-color: #66b1ff;
  }
}

:deep(.el-tag) {
  height: 28px;
  line-height: 26px;
  padding: 0 10px;
  font-size: 13px;
}
</style>