<script setup>
import '../assets/iconfont.css';

</script>
<template>
    <div>

        <!-- <span
            style="height: 60px;display: flex;flex-direction: row;justify-content: center;align-items: center;text-align: center;font-weight: bolder;color: green;font-size:20px;">商品销售管理系统</span> -->
        <el-menu
            :default-active="$route.path"
            class="el-menu-vertical"
            router
            :collapse-transition="false"
            background-color="#fff"
            text-color="#606266">

            <div v-for="item in userMenuList" :key="item.id">
                <div v-if="item.path">
                    <div v-if="!item.pid">
                        <el-menu-item :index="item.path">
                            <i :class="item.icon"></i>
                            <span>{{ item.name }}</span>
                        </el-menu-item>
                    </div>
                </div>
                <div v-else>
                    <el-submenu :index="item.id + ''">
                        <template slot="title">
                            <i :class="item.icon"></i>
                            <span>{{ item.name }}</span>
                        </template>
                        <div v-for="subItem in item.children" :key="subItem.id">
                            <el-menu-item :index="subItem.path">
                                <i :class="subItem.icon"></i>
                                <span>{{ subItem.name }}</span>
                            </el-menu-item>
                        </div>
                    </el-submenu>
                </div>

            </div>

        </el-menu>

    </div>
</template>

<script>


import {setRoutes} from "@/router";
import Request from '../utils/request.js'
export default {
    name: 'Aside',
    components: {},
    // 用户信息
    userInfo: {},
    created() {
        let userMenuListStr = localStorage.getItem("userMenuList")
        this.userMenuList = userMenuListStr ? JSON.parse(userMenuListStr) : [];
        this.userInfo = localStorage.getItem("backUser") ? JSON.parse(localStorage.getItem("backUser")) : {};
        console.log("userMenuList:" + userMenuListStr);
    },
    data() {
        return {
          
            userMenuList: [
                {
                    name: 'Dashboard',
                    path: 'dashboard',
                    icon: 'el-icon-menu'
                },
                {
                    name: 'Reports',
                    path: 'reports',
                    icon: 'el-icon-document',
                    children: [
                        {
                            name: 'Report 1',
                            path: 'report1',
                            icon: 'el-icon-document'
                        },
                        {
                            name: 'Report 2',
                            path: 'report2',
                            icon: 'el-icon-document'
                        }
                    ]
                },
                // 更多静态菜单项...
            ],
            user: {},
            path: this.$route.path
        }
    },
    methods: {
        printMenu(menu) {
            console.log("Submenu:" + menu)
        },
        refreshMenu(){
            Request.get("/menu/getMenuTree/"+this.userInfo.id).then(response => {
                if (response.code === '0') {
                    localStorage.setItem("userMenuList", JSON.stringify(response.data))
                    setRoutes();
         
                } else {
                    this.$message({
                        type: 'error',
                        message: response.msg
                    })
                }
            })
        }

    }
}
</script>

<style scoped lang="scss">
.el-menu {
    border-right: none;
    padding: 12px;
}

.el-menu-item {
    height: 50px;
    line-height: 50px;
    border-radius: 10px;
    margin-bottom: 6px;
    color: #606266;
    font-size: 14px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
    
    &::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 152, 0, 0.2);
        transform: translate(-50%, -50%);
        transition: width 0.6s ease, height 0.6s ease;
    }
    
    &:active::after {
        width: 200px;
        height: 200px;
    }
    
    &:hover {
        color: #FF9800;
        background-color: #FFF3E0 !important;
        transform: translateX(4px);
        box-shadow: 0 2px 8px rgba(255, 152, 0, 0.15);
    }
    
    &.is-active {
        color: #fff;
        background: linear-gradient(135deg, #FF9800, #FFB74D) !important;
        font-weight: 600;
        box-shadow: 0 4px 12px rgba(255, 152, 0, 0.3);
    }
}

.el-submenu ::v-deep .el-submenu__title {
    height: 50px;
    line-height: 50px;
    border-radius: 10px;
    color: #606266;
    font-size: 14px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    
    &:hover {
        color: #FF9800;
        background-color: #FFF3E0 !important;
        transform: translateX(4px);
    }
}

.el-submenu ::v-deep .el-menu--inline {
    padding-left: 0;
    background: #FFFBF5;
    border-radius: 8px;
    margin: 4px 0;
    
    .el-menu-item {
        height: 45px;
        line-height: 45px;
        padding-left: 48px !important;
        background-color: transparent;
        
        &:hover {
            color: #FF9800;
            background-color: #FFF3E0 !important;
        }
        
        &.is-active {
            color: #fff;
            background: linear-gradient(135deg, #FF9800, #FFB74D) !important;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(255, 152, 0, 0.2);
        }
    }
}

/* 图标样式 */
.el-menu-item [class^="el-icon-"],
.el-submenu [class^="el-icon-"] {
    font-size: 18px;
    margin-right: 12px;
    color: #909399;
    transition: all 0.3s ease;
}

.el-menu-item:hover [class^="el-icon-"],
.el-submenu:hover [class^="el-icon-"] {
    color: #FF9800;
    transform: scale(1.1);
}

.el-menu-item.is-active [class^="el-icon-"],
.el-submenu.is-active [class^="el-icon-"] {
    color: #fff;
}
</style>