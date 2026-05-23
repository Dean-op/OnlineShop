<template>
  <div class="scenic-manager">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2><i class="el-icon-place"></i> 景点信息管理</h2>
        <span class="header-desc">维护文旅景点基础信息，管理相关论坛与投诉</span>
      </div>
      <el-button type="primary" icon="el-icon-plus" @click="showCreateDialog">添加景点</el-button>
    </div>

    <!-- 数据统计卡片 -->
    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #667eea, #764ba2);">
          <i class="el-icon-place"></i>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalScenics }}</div>
          <div class="stat-label">景点总数</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb, #f5576c);">
          <i class="el-icon-chat-dot-round"></i>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalForums }}</div>
          <div class="stat-label">论坛帖子</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe);">
          <i class="el-icon-warning-outline"></i>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.pendingComplaints }}</div>
          <div class="stat-label">待处理投诉</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b, #38f9d7);">
          <i class="el-icon-view"></i>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalViews }}</div>
          <div class="stat-label">总浏览量</div>
        </div>
      </div>
    </div>

    <!-- 主内容区Tab切换 -->
    <el-tabs v-model="activeTab" type="card" class="main-tabs">
      <!-- 景点列表Tab -->
      <el-tab-pane label="景点列表" name="scenic">
        <div class="filter-bar">
          <el-input v-model="keyword" placeholder="搜索景点名称..." prefix-icon="el-icon-search" clearable
            style="width: 250px" @keyup.enter.native="getScenics">
          </el-input>
          <el-select v-model="filterLevel" placeholder="景区等级" clearable @change="getScenics">
            <el-option label="5A级" value="5A"></el-option>
            <el-option label="4A级" value="4A"></el-option>
            <el-option label="3A级" value="3A"></el-option>
          </el-select>
          <el-select v-model="filterStatus" placeholder="状态" clearable @change="getScenics">
            <el-option label="已上架" :value="1"></el-option>
            <el-option label="已下架" :value="0"></el-option>
          </el-select>
          <el-button icon="el-icon-refresh" @click="getScenics">刷新</el-button>
        </div>

        <el-table :data="scenics" v-loading="loading" stripe class="data-table">
          <el-table-column prop="id" label="ID" width="70"></el-table-column>
          <el-table-column label="景点封面" width="100">
            <template slot-scope="scope">
              <el-image v-if="scope.row.coverImage"
                :src="scope.row.coverImage.startsWith('http') ? scope.row.coverImage : `/api${scope.row.coverImage}`"
                fit="cover" class="cover-img">
              </el-image>
              <div v-else class="no-cover"><i class="el-icon-picture"></i></div>
            </template>
          </el-table-column>
          <el-table-column prop="name" label="景点名称" min-width="150">
            <template slot-scope="scope">
              <div class="scenic-name">{{ scope.row.name }}</div>
              <div class="scenic-tags" v-if="scope.row.tags">
                <el-tag v-for="tag in scope.row.tags.split(',').slice(0,2)" :key="tag" size="mini" type="info">
                  {{ tag }}
                </el-tag>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="level" label="等级" width="80">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.level" :type="getLevelType(scope.row.level)" size="small">
                {{ scope.row.level }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="位置" min-width="130">
            <template slot-scope="scope">
              <i class="el-icon-location-outline"></i>
              {{ scope.row.province }} {{ scope.row.city }}
            </template>
          </el-table-column>
          <el-table-column label="门票" width="90">
            <template slot-scope="scope">
              <span :class="scope.row.ticketPrice ? 'price' : 'free'">
                {{ scope.row.ticketPrice ? '¥' + scope.row.ticketPrice : '免费' }}
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="viewCount" label="浏览" width="80">
            <template slot-scope="scope">
              <i class="el-icon-view"></i> {{ scope.row.viewCount }}
            </template>
          </el-table-column>
          <el-table-column label="状态" width="80">
            <template slot-scope="scope">
              <el-tag :type="scope.row.status === 1 ? 'success' : 'info'" size="small" effect="dark">
                {{ scope.row.status === 1 ? '上架' : '下架' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="220" fixed="right">
            <template slot-scope="scope">
              <el-button type="text" size="small" icon="el-icon-edit" @click="showEditDialog(scope.row)">编辑</el-button>
              <el-button type="text" size="small" icon="el-icon-chat-dot-round"
                @click="viewRelatedForums(scope.row)">论坛</el-button>
              <el-button type="text" size="small" @click="toggleStatus(scope.row)">
                {{ scope.row.status === 1 ? '下架' : '上架' }}
              </el-button>
              <el-button type="text" size="small" style="color: #f56c6c" icon="el-icon-delete"
                @click="deleteScenic(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>

        <div class="pagination-wrapper">
          <el-pagination background :current-page.sync="currentPage" :page-size="pageSize" :total="total"
            layout="total, prev, pager, next, jumper" @current-change="getScenics">
          </el-pagination>
        </div>
      </el-tab-pane>

      <!-- 论坛关联Tab -->
      <el-tab-pane label="文化论坛" name="forum">
        <div class="tab-header">
          <p class="tab-desc"><i class="el-icon-info"></i> 管理与景点相关的文化论坛帖子，可置顶精华内容或删除违规帖子</p>
        </div>
        <div class="filter-bar">
          <el-input v-model="forumKeyword" placeholder="搜索帖子标题..." prefix-icon="el-icon-search" clearable
            style="width: 250px" @keyup.enter.native="getForums">
          </el-input>
          <el-select v-model="forumFilterType" placeholder="帖子类型" clearable @change="getForums">
            <el-option label="话题讨论" :value="1"></el-option>
            <el-option label="文化分享" :value="2"></el-option>
          </el-select>
          <el-select v-model="forumFilterScenic" placeholder="关联景点" clearable @change="getForums">
            <el-option v-for="s in scenicOptions" :key="s.id" :label="s.name" :value="s.id"></el-option>
          </el-select>
          <el-button icon="el-icon-refresh" @click="getForums">刷新</el-button>
        </div>

        <el-table :data="forums" v-loading="forumLoading" stripe class="data-table">
          <el-table-column prop="id" label="ID" width="70"></el-table-column>
          <el-table-column label="封面" width="90">
            <template slot-scope="scope">
              <el-image v-if="scope.row.coverImage"
                :src="scope.row.coverImage.startsWith('http') ? scope.row.coverImage : `/api${scope.row.coverImage}`"
                fit="cover" class="cover-img-sm">
              </el-image>
            </template>
          </el-table-column>
          <el-table-column prop="title" label="标题" min-width="200">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.isTop" type="danger" size="mini" effect="dark"
                style="margin-right: 6px;">置顶</el-tag>
              {{ scope.row.title }}
            </template>
          </el-table-column>
          <el-table-column label="类型" width="100">
            <template slot-scope="scope">
              <el-tag :type="scope.row.type === 1 ? 'primary' : 'success'" size="small">
                {{ scope.row.type === 1 ? '话题讨论' : '文化分享' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="发布者" width="100">
            <template slot-scope="scope">{{ scope.row.user?.username || '-' }}</template>
          </el-table-column>
          <el-table-column label="关联景点" width="120">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.scenic" type="warning" size="small">
                {{ scope.row.scenic?.name }}
              </el-tag>
              <span v-else class="text-muted">未关联</span>
            </template>
          </el-table-column>
          <el-table-column label="互动数据" width="140">
            <template slot-scope="scope">
              <span class="data-item"><i class="el-icon-view"></i>{{ scope.row.viewCount }}</span>
              <span class="data-item"><i class="el-icon-chat-dot-round"></i>{{ scope.row.replyCount }}</span>
              <span class="data-item"><i class="el-icon-star-off"></i>{{ scope.row.likeCount }}</span>
            </template>
          </el-table-column>
          <el-table-column label="置顶" width="80">
            <template slot-scope="scope">
              <el-switch v-model="scope.row.isTop" :active-value="1" :inactive-value="0"
                @change="toggleForumTop(scope.row)">
              </el-switch>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="160" fixed="right">
            <template slot-scope="scope">
              <el-button type="text" size="small" icon="el-icon-view" @click="viewForumDetail(scope.row)">查看</el-button>
              <el-button type="text" size="small" icon="el-icon-link"
                @click="showLinkScenicDialog(scope.row)">关联景点</el-button>
              <el-button type="text" size="small" style="color: #f56c6c" icon="el-icon-delete"
                @click="deleteForum(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>

        <div class="pagination-wrapper">
          <el-pagination background :current-page.sync="forumCurrentPage" :page-size="forumPageSize"
            :total="forumTotal" layout="total, prev, pager, next" @current-change="getForums">
          </el-pagination>
        </div>
      </el-tab-pane>

      <!-- 投诉管理Tab -->
      <el-tab-pane label="用户投诉" name="complaint">
        <div class="tab-header">
          <p class="tab-desc"><i class="el-icon-info"></i> 查看和处理用户订单投诉，及时响应用户反馈</p>
        </div>
        <div class="filter-bar">
          <el-select v-model="complaintFilterStatus" placeholder="投诉状态" clearable @change="getComplaints">
            <el-option label="待处理" :value="0"></el-option>
            <el-option label="处理中" :value="1"></el-option>
            <el-option label="已解决" :value="2"></el-option>
            <el-option label="已关闭" :value="3"></el-option>
          </el-select>
          <el-select v-model="complaintFilterType" placeholder="投诉类型" clearable @change="getComplaints">
            <el-option label="商品质量" :value="1"></el-option>
            <el-option label="服务态度" :value="2"></el-option>
            <el-option label="物流问题" :value="3"></el-option>
            <el-option label="虚假宣传" :value="4"></el-option>
            <el-option label="其他" :value="5"></el-option>
          </el-select>
          <el-button icon="el-icon-refresh" @click="getComplaints">刷新</el-button>
        </div>

        <el-table :data="complaints" v-loading="complaintLoading" stripe class="data-table">
          <el-table-column prop="id" label="ID" width="70"></el-table-column>
          <el-table-column label="投诉用户" width="110">
            <template slot-scope="scope">
              <div class="user-cell">
                <i class="el-icon-user"></i>
                {{ scope.row.user?.username || '-' }}
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="title" label="投诉标题" min-width="180"></el-table-column>
          <el-table-column label="投诉类型" width="100">
            <template slot-scope="scope">
              <el-tag size="small" type="info">{{ getComplaintTypeText(scope.row.type) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="关联订单" width="100">
            <template slot-scope="scope">
              <el-link type="primary" v-if="scope.row.orderId">#{{ scope.row.orderId }}</el-link>
              <span v-else class="text-muted">-</span>
            </template>
          </el-table-column>
          <el-table-column label="状态" width="100">
            <template slot-scope="scope">
              <el-tag :type="getComplaintStatusType(scope.row.status)" size="small" effect="dark">
                {{ getComplaintStatusText(scope.row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="创建时间" width="160">
            <template slot-scope="scope">{{ formatTime(scope.row.createdAt) }}</template>
          </el-table-column>
          <el-table-column label="操作" width="150" fixed="right">
            <template slot-scope="scope">
              <el-button type="text" size="small" icon="el-icon-view"
                @click="showComplaintDetail(scope.row)">查看</el-button>
              <el-button type="text" size="small" icon="el-icon-s-check" v-if="scope.row.status < 2"
                @click="showHandleComplaintDialog(scope.row)">处理</el-button>
            </template>
          </el-table-column>
        </el-table>

        <div class="pagination-wrapper">
          <el-pagination background :current-page.sync="complaintCurrentPage" :page-size="complaintPageSize"
            :total="complaintTotal" layout="total, prev, pager, next" @current-change="getComplaints">
          </el-pagination>
        </div>
      </el-tab-pane>

      <!-- 资讯公告Tab -->
      <el-tab-pane label="资讯公告" name="news">
        <div class="tab-header">
          <div class="tab-header-left">
            <p class="tab-desc"><i class="el-icon-info"></i> 发布景点相关资讯、活动公告和优惠信息</p>
          </div>
          <el-button type="primary" size="small" icon="el-icon-plus" @click="showNewsDialog">发布公告</el-button>
        </div>

        <el-table :data="newsList" v-loading="newsLoading" stripe class="data-table">
          <el-table-column prop="id" label="ID" width="70"></el-table-column>
          <el-table-column prop="title" label="公告标题" min-width="200"></el-table-column>
          <el-table-column label="关联景点" width="150">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.scenic" type="warning" size="small">{{ scope.row.scenic?.name }}</el-tag>
              <el-tag v-else size="small">全局公告</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="类型" width="100">
            <template slot-scope="scope">
              <el-tag :type="getNewsTypeTag(scope.row.type)" size="small">{{ getNewsTypeText(scope.row.type) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="发布时间" width="160">
            <template slot-scope="scope">{{ formatTime(scope.row.createdAt) }}</template>
          </el-table-column>
          <el-table-column label="状态" width="80">
            <template slot-scope="scope">
              <el-tag :type="scope.row.status === 1 ? 'success' : 'info'" size="small">
                {{ scope.row.status === 1 ? '发布' : '草稿' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="150" fixed="right">
            <template slot-scope="scope">
              <el-button type="text" size="small" icon="el-icon-edit" @click="editNews(scope.row)">编辑</el-button>
              <el-button type="text" size="small" style="color: #f56c6c" icon="el-icon-delete"
                @click="deleteNews(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>

        <div class="pagination-wrapper">
          <el-pagination background :current-page.sync="newsCurrentPage" :page-size="newsPageSize" :total="newsTotal"
            layout="total, prev, pager, next" @current-change="getNews">
          </el-pagination>
        </div>
      </el-tab-pane>
    </el-tabs>

    <!-- 添加/编辑景点对话框 -->
    <el-dialog :title="isEdit ? '编辑景点' : '添加景点'" :visible.sync="dialogVisible" width="750px" top="5vh">
      <el-form :model="form" :rules="rules" ref="form" label-width="100px" class="scenic-form">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="景点名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入景点名称"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="景区等级" prop="level">
              <el-select v-model="form.level" placeholder="请选择等级" style="width: 100%">
                <el-option label="5A级" value="5A"></el-option>
                <el-option label="4A级" value="4A"></el-option>
                <el-option label="3A级" value="3A"></el-option>
                <el-option label="其他" value="其他"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="所在省份" prop="province">
              <el-input v-model="form.province" placeholder="如：浙江省"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="所在城市" prop="city">
              <el-input v-model="form.city" placeholder="如：杭州市"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="详细地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入详细地址"></el-input>
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="门票价格">
              <el-input-number v-model="form.ticketPrice" :min="0" :precision="2" style="width: 100%"
                placeholder="0表示免费"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话">
              <el-input v-model="form.phone" placeholder="景区联系电话"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="开放时间">
          <el-input v-model="form.openTime" placeholder="如：08:00-18:00"></el-input>
        </el-form-item>
        <el-form-item label="景点简介" prop="description">
          <el-input type="textarea" v-model="form.description" :rows="3" placeholder="请输入景点简介（100字以内）"
            maxlength="100" show-word-limit></el-input>
        </el-form-item>
        <el-form-item label="详细介绍">
          <el-input type="textarea" v-model="form.detail" :rows="5" placeholder="请输入详细介绍，包括景点特色、历史背景、游玩攻略等">
          </el-input>
        </el-form-item>
        <el-form-item label="景点标签">
          <el-input v-model="form.tags" placeholder="多个标签用逗号分隔，如：自然风光,历史文化,世界遗产"></el-input>
        </el-form-item>
        <el-form-item label="封面图片">
          <el-upload class="cover-uploader" action="/api/file/upload/img" :show-file-list="false"
            :on-success="handleCoverSuccess" :on-error="handleUploadError" name="file">
            <img v-if="form.coverImage"
              :src="form.coverImage.startsWith('http') ? form.coverImage : `/api${form.coverImage}`"
              class="cover-preview">
            <div v-else class="cover-uploader-placeholder">
              <i class="el-icon-plus"></i>
              <span>上传封面</span>
            </div>
          </el-upload>
          <div class="upload-tip">建议尺寸：800x600，支持jpg/png格式</div>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm" :loading="submitting">保存</el-button>
      </div>
    </el-dialog>

    <!-- 论坛详情对话框 -->
    <el-dialog title="帖子详情" :visible.sync="forumDetailDialogVisible" width="700px">
      <div v-if="currentForum" class="forum-detail">
        <h3>{{ currentForum.title }}</h3>
        <div class="detail-meta">
          <span><i class="el-icon-user"></i> {{ currentForum.user?.username }}</span>
          <span><i class="el-icon-time"></i> {{ formatTime(currentForum.createdAt) }}</span>
          <el-tag v-if="currentForum.scenic" type="warning" size="small">
            <i class="el-icon-place"></i> {{ currentForum.scenic?.name }}
          </el-tag>
        </div>
        <div class="detail-content">{{ currentForum.content }}</div>
        <div class="detail-stats">
          <span><i class="el-icon-view"></i> {{ currentForum.viewCount }} 浏览</span>
          <span><i class="el-icon-chat-dot-round"></i> {{ currentForum.replyCount }} 回复</span>
          <span><i class="el-icon-star-off"></i> {{ currentForum.likeCount }} 点赞</span>
        </div>
      </div>
    </el-dialog>

    <!-- 关联景点对话框 -->
    <el-dialog title="关联景点" :visible.sync="linkScenicDialogVisible" width="500px">
      <el-form label-width="100px">
        <el-form-item label="当前帖子">
          <span class="current-forum-title">{{ currentForum?.title }}</span>
        </el-form-item>
        <el-form-item label="选择景点">
          <el-select v-model="linkScenicId" placeholder="请选择要关联的景点" style="width: 100%" filterable clearable>
            <el-option v-for="s in scenicOptions" :key="s.id" :label="s.name" :value="s.id">
              <span>{{ s.name }}</span>
              <span style="float: right; color: #909399; font-size: 12px;">{{ s.province }} {{ s.city }}</span>
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="linkScenicDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitLinkScenic">确定</el-button>
      </div>
    </el-dialog>

    <!-- 投诉详情对话框 -->
    <el-dialog title="投诉详情" :visible.sync="complaintDetailDialogVisible" width="650px">
      <div v-if="currentComplaint" class="complaint-detail">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="投诉用户">{{ currentComplaint.user?.username }}</el-descriptions-item>
          <el-descriptions-item label="投诉类型">{{ getComplaintTypeText(currentComplaint.type) }}</el-descriptions-item>
          <el-descriptions-item label="关联订单">#{{ currentComplaint.orderId }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="getComplaintStatusType(currentComplaint.status)" size="small">
              {{ getComplaintStatusText(currentComplaint.status) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="投诉标题" :span="2">{{ currentComplaint.title }}</el-descriptions-item>
          <el-descriptions-item label="投诉内容" :span="2">{{ currentComplaint.content }}</el-descriptions-item>
          <el-descriptions-item label="商家回复" :span="2" v-if="currentComplaint.merchantReply">
            {{ currentComplaint.merchantReply }}
          </el-descriptions-item>
          <el-descriptions-item label="管理员处理" :span="2" v-if="currentComplaint.adminReply">
            {{ currentComplaint.adminReply }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </el-dialog>

    <!-- 处理投诉对话框 -->
    <el-dialog title="处理投诉" :visible.sync="handleComplaintDialogVisible" width="500px">
      <el-form :model="handleForm" :rules="handleRules" ref="handleForm" label-width="100px">
        <el-form-item label="处理结果" prop="status">
          <el-radio-group v-model="handleForm.status">
            <el-radio :label="2">已解决</el-radio>
            <el-radio :label="3">已关闭</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="处理意见" prop="reply">
          <el-input type="textarea" v-model="handleForm.reply" :rows="4" placeholder="请输入处理意见"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="handleComplaintDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitHandleComplaint">提交</el-button>
      </div>
    </el-dialog>

    <!-- 发布公告对话框 -->
    <el-dialog :title="newsForm.id ? '编辑公告' : '发布公告'" :visible.sync="newsDialogVisible" width="600px">
      <el-form :model="newsForm" :rules="newsRules" ref="newsForm" label-width="100px">
        <el-form-item label="公告标题" prop="title">
          <el-input v-model="newsForm.title" placeholder="请输入公告标题"></el-input>
        </el-form-item>
        <el-form-item label="公告类型" prop="type">
          <el-select v-model="newsForm.type" style="width: 100%">
            <el-option label="活动公告" :value="1"></el-option>
            <el-option label="优惠信息" :value="2"></el-option>
            <el-option label="景区通知" :value="3"></el-option>
            <el-option label="系统公告" :value="4"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="关联景点">
          <el-select v-model="newsForm.scenicId" placeholder="选择景点（可选）" style="width: 100%" clearable filterable>
            <el-option v-for="s in scenicOptions" :key="s.id" :label="s.name" :value="s.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="公告内容" prop="content">
          <el-input type="textarea" v-model="newsForm.content" :rows="6" placeholder="请输入公告内容"></el-input>
        </el-form-item>
        <el-form-item label="发布状态">
          <el-radio-group v-model="newsForm.status">
            <el-radio :label="1">立即发布</el-radio>
            <el-radio :label="0">保存为草稿</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="newsDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitNews">{{ newsForm.status === 1 ? '发布' : '保存' }}</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import Request from '@/utils/request'

export default {
  name: 'ScenicManager',
  data() {
    return {
      activeTab: 'scenic',
      loading: false,
      submitting: false,

      // 统计数据
      stats: {
        totalScenics: 0,
        totalForums: 0,
        pendingComplaints: 0,
        totalViews: 0
      },

      // 景点数据
      scenics: [],
      scenicOptions: [],
      keyword: '',
      filterLevel: '',
      filterStatus: null,
      currentPage: 1,
      pageSize: 10,
      total: 0,

      // 景点表单
      dialogVisible: false,
      isEdit: false,
      form: {
        name: '', level: '', province: '', city: '', address: '',
        ticketPrice: 0, phone: '', openTime: '', description: '', detail: '', tags: '', coverImage: ''
      },
      rules: {
        name: [{ required: true, message: '请输入景点名称', trigger: 'blur' }],
        province: [{ required: true, message: '请输入所在省份', trigger: 'blur' }],
        city: [{ required: true, message: '请输入所在城市', trigger: 'blur' }],
        description: [{ required: true, message: '请输入景点简介', trigger: 'blur' }]
      },

      // 论坛数据
      forums: [],
      forumLoading: false,
      forumKeyword: '',
      forumFilterType: null,
      forumFilterScenic: null,
      forumCurrentPage: 1,
      forumPageSize: 10,
      forumTotal: 0,
      forumDetailDialogVisible: false,
      currentForum: null,
      linkScenicDialogVisible: false,
      linkScenicId: null,

      // 投诉数据
      complaints: [],
      complaintLoading: false,
      complaintFilterStatus: null,
      complaintFilterType: null,
      complaintCurrentPage: 1,
      complaintPageSize: 10,
      complaintTotal: 0,
      complaintDetailDialogVisible: false,
      handleComplaintDialogVisible: false,
      currentComplaint: null,
      handleForm: { status: 2, reply: '' },
      handleRules: {
        status: [{ required: true, message: '请选择处理结果', trigger: 'change' }],
        reply: [{ required: true, message: '请输入处理意见', trigger: 'blur' }]
      },

      // 资讯公告
      newsList: [],
      newsLoading: false,
      newsCurrentPage: 1,
      newsPageSize: 10,
      newsTotal: 0,
      newsDialogVisible: false,
      newsForm: {
        id: null,
        title: '',
        type: 1,
        scenicId: null,
        content: '',
        status: 1
      },
      newsRules: {
        title: [{ required: true, message: '请输入公告标题', trigger: 'blur' }],
        type: [{ required: true, message: '请选择公告类型', trigger: 'change' }],
        content: [{ required: true, message: '请输入公告内容', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.init()
  },
  watch: {
    activeTab(val) {
      if (val === 'forum' && this.forums.length === 0) {
        this.getForums()
      } else if (val === 'complaint' && this.complaints.length === 0) {
        this.getComplaints()
      } else if (val === 'news' && this.newsList.length === 0) {
        this.getNews()
      }
    }
  },
  methods: {
    async init() {
      await this.getScenics()
      await this.getScenicOptions()
      this.getStats()
    },

    getEmptyForm() {
      return {
        name: '', level: '', province: '', city: '', address: '',
        ticketPrice: 0, phone: '', openTime: '', description: '', detail: '', tags: '', coverImage: ''
      }
    },

    formatTime(time) {
      if (!time) return '-'
      const d = new Date(time)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
    },

    // ========== 统计数据 ==========
    async getStats() {
      try {
        // 获取各项统计
        const [scenicRes, forumRes, complaintRes] = await Promise.all([
          Request.get('/scenic/page', { params: { currentPage: 1, size: 1 } }),
          Request.get('/forum/page', { params: { currentPage: 1, size: 1 } }),
          Request.get('/complaint/page', { params: { currentPage: 1, size: 1, status: 0 } })
        ])
        this.stats.totalScenics = scenicRes.data?.total || 0
        this.stats.totalForums = forumRes.data?.total || 0
        this.stats.pendingComplaints = complaintRes.data?.total || 0
        this.stats.totalViews = this.scenics.reduce((sum, s) => sum + (s.viewCount || 0), 0)
      } catch (e) {
        console.error('获取统计失败', e)
      }
    },

    // ========== 景点管理 ==========
    async getScenics() {
      this.loading = true
      try {
        const res = await Request.get('/scenic/page', {
          params: {
            keyword: this.keyword,
            level: this.filterLevel,
            status: this.filterStatus,
            currentPage: this.currentPage,
            size: this.pageSize
          }
        })
        if (res.code === '0') {
          this.scenics = res.data.records
          this.total = res.data.total
          this.stats.totalViews = this.scenics.reduce((sum, s) => sum + (s.viewCount || 0), 0)
        }
      } finally {
        this.loading = false
      }
    },

    async getScenicOptions() {
      const res = await Request.get('/scenic/page', { params: { currentPage: 1, size: 100, status: 1 } })
      if (res.code === '0') {
        this.scenicOptions = res.data.records
      }
    },

    getLevelType(level) {
      const types = { '5A': 'danger', '4A': 'warning', '3A': 'success' }
      return types[level] || 'info'
    },

    showCreateDialog() {
      this.isEdit = false
      this.form = this.getEmptyForm()
      this.dialogVisible = true
    },

    showEditDialog(scenic) {
      this.isEdit = true
      this.form = { ...scenic }
      this.dialogVisible = true
    },

    handleCoverSuccess(res) {
      if (res.code === '0') {
        this.form.coverImage = res.data
        this.$message.success('图片上传成功')
      } else {
        this.$message.error(res.msg || '上传失败')
      }
    },

    handleUploadError(err) {
      console.error('上传错误:', err)
      this.$message.error('图片上传失败，请重试')
    },

    async submitForm() {
      try {
        await this.$refs.form.validate()
      } catch (e) {
        return // 验证失败，不继续执行
      }
      this.submitting = true
      try {
        let res
        if (this.isEdit) {
          res = await Request.put(`/scenic/${this.form.id}`, this.form)
        } else {
          res = await Request.post('/scenic', this.form)
        }
        if (res.code === '0') {
          this.$message.success(this.isEdit ? '更新成功' : '添加成功')
          this.dialogVisible = false
          this.getScenics()
          this.getScenicOptions()
        } else {
          this.$message.error(res.msg || '操作失败')
        }
      } catch (err) {
        console.error('提交失败:', err)
        this.$message.error('提交失败，请检查网络连接')
      } finally {
        this.submitting = false
      }
    },

    async toggleStatus(scenic) {
      const newStatus = scenic.status === 1 ? 0 : 1
      const res = await Request.put(`/scenic/${scenic.id}/status`, null, { params: { status: newStatus } })
      if (res.code === '0') {
        this.$message.success(newStatus === 1 ? '已上架' : '已下架')
        this.getScenics()
      }
    },

    async deleteScenic(scenic) {
      await this.$confirm(`确定要删除景点"${scenic.name}"吗？`, '删除确认', { type: 'warning' })
      const res = await Request.delete(`/scenic/${scenic.id}`)
      if (res.code === '0') {
        this.$message.success('删除成功')
        this.getScenics()
      }
    },

    viewRelatedForums(scenic) {
      this.activeTab = 'forum'
      this.forumFilterScenic = scenic.id
      this.$nextTick(() => {
        this.getForums()
      })
    },

    // ========== 论坛管理 ==========
    async getForums() {
      this.forumLoading = true
      try {
        const res = await Request.get('/forum/page', {
          params: {
            keyword: this.forumKeyword,
            type: this.forumFilterType,
            scenicId: this.forumFilterScenic,
            currentPage: this.forumCurrentPage,
            size: this.forumPageSize
          }
        })
        if (res.code === '0') {
          this.forums = res.data.records
          this.forumTotal = res.data.total
        }
      } finally {
        this.forumLoading = false
      }
    },

    viewForumDetail(forum) {
      this.currentForum = forum
      this.forumDetailDialogVisible = true
    },

    showLinkScenicDialog(forum) {
      this.currentForum = forum
      this.linkScenicId = forum.scenicId || null
      this.linkScenicDialogVisible = true
    },

    async submitLinkScenic() {
      const res = await Request.post(`/forum/${this.currentForum.id}/link-scenic`, null, {
        params: { scenicId: this.linkScenicId }
      })
      if (res.code === '0') {
        this.$message.success('关联成功')
        this.linkScenicDialogVisible = false
        this.getForums()
      }
    },

    async toggleForumTop(forum) {
      await Request.post(`/forum/${forum.id}/top`, null, { params: { isTop: forum.isTop } })
      this.$message.success(forum.isTop ? '已置顶' : '已取消置顶')
    },

    async deleteForum(forum) {
      await this.$confirm('确定要删除这个帖子吗？', '提示', { type: 'warning' })
      const res = await Request.delete(`/forum/${forum.id}`)
      if (res.code === '0') {
        this.$message.success('删除成功')
        this.getForums()
      }
    },

    // ========== 投诉管理 ==========
    async getComplaints() {
      this.complaintLoading = true
      try {
        const res = await Request.get('/complaint/page', {
          params: {
            status: this.complaintFilterStatus,
            type: this.complaintFilterType,
            currentPage: this.complaintCurrentPage,
            size: this.complaintPageSize
          }
        })
        if (res.code === '0') {
          this.complaints = res.data.records
          this.complaintTotal = res.data.total
        }
      } finally {
        this.complaintLoading = false
      }
    },

    showComplaintDetail(complaint) {
      this.currentComplaint = complaint
      this.complaintDetailDialogVisible = true
    },

    showHandleComplaintDialog(complaint) {
      this.currentComplaint = complaint
      this.handleForm = { status: 2, reply: '' }
      this.handleComplaintDialogVisible = true
    },

    async submitHandleComplaint() {
      await this.$refs.handleForm.validate()
      const res = await Request.post(`/complaint/${this.currentComplaint.id}/admin-handle`, null, {
        params: { reply: this.handleForm.reply, status: this.handleForm.status }
      })
      if (res.code === '0') {
        this.$message.success('处理成功')
        this.handleComplaintDialogVisible = false
        this.getComplaints()
        this.getStats()
      }
    },

    getComplaintStatusText(status) {
      return ['待处理', '处理中', '已解决', '已关闭'][status] || '未知'
    },

    getComplaintStatusType(status) {
      return ['warning', 'primary', 'success', 'info'][status] || 'info'
    },

    getComplaintTypeText(type) {
      return ['', '商品质量', '服务态度', '物流问题', '虚假宣传', '其他'][type] || ''
    },

    // ========== 资讯公告 ==========
    async getNews() {
      this.newsLoading = true
      try {
        const res = await Request.get('/news/page', {
          params: { currentPage: this.newsCurrentPage, size: this.newsPageSize }
        })
        if (res.code === '0') {
          this.newsList = res.data?.records || []
          this.newsTotal = res.data?.total || 0
        }
      } catch (e) {
        // 接口可能不存在，显示空列表
        this.newsList = []
      } finally {
        this.newsLoading = false
      }
    },

    showNewsDialog() {
      this.newsForm = { id: null, title: '', type: 1, scenicId: null, content: '', status: 1 }
      this.newsDialogVisible = true
    },

    editNews(news) {
      this.newsForm = { ...news }
      this.newsDialogVisible = true
    },

    async submitNews() {
      await this.$refs.newsForm.validate()
      try {
        let res
        if (this.newsForm.id) {
          res = await Request.put(`/news/${this.newsForm.id}`, this.newsForm)
        } else {
          res = await Request.post('/news', this.newsForm)
        }
        if (res.code === '0') {
          this.$message.success(this.newsForm.id ? '更新成功' : '发布成功')
          this.newsDialogVisible = false
          this.getNews()
        }
      } catch (e) {
        this.$message.warning('资讯功能接口暂未实现')
      }
    },

    async deleteNews(news) {
      await this.$confirm('确定要删除这条公告吗？', '提示', { type: 'warning' })
      try {
        const res = await Request.delete(`/news/${news.id}`)
        if (res.code === '0') {
          this.$message.success('删除成功')
          this.getNews()
        }
      } catch (e) {
        this.$message.warning('资讯功能接口暂未实现')
      }
    },

    getNewsTypeText(type) {
      return ['', '活动公告', '优惠信息', '景区通知', '系统公告'][type] || ''
    },

    getNewsTypeTag(type) {
      return ['', 'danger', 'warning', 'success', 'info'][type] || 'info'
    }
  }
}
</script>

<style scoped>
.scenic-manager {
  padding: 24px;
  background: #f5f7fa;
  min-height: calc(100vh - 120px);
}

/* 页面头部 */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  background: #fff;
  padding: 20px 24px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.header-left h2 {
  margin: 0 0 6px 0;
  font-size: 22px;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-left h2 i {
  color: #FF9800;
}

.header-desc {
  color: #909399;
  font-size: 14px;
  margin: 0;
}

/* 统计卡片 */
.stats-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 24px;
}

.stat-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  transition: transform 0.3s, box-shadow 0.3s;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-icon i {
  font-size: 26px;
  color: #fff;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #303133;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 4px;
}

/* Tab样式 */
.main-tabs {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  overflow: hidden;
}

.main-tabs :deep(.el-tabs__header) {
  margin: 0;
  background: #fafafa;
  border-bottom: 1px solid #ebeef5;
}

.main-tabs :deep(.el-tabs__item) {
  padding: 0 24px;
  height: 52px;
  line-height: 52px;
  font-size: 15px;
}

.main-tabs :deep(.el-tabs__item.is-active) {
  color: #FF9800;
  font-weight: 600;
}

.main-tabs :deep(.el-tabs__content) {
  padding: 24px;
}

/* Tab头部 */
.tab-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 12px 16px;
  background: #FFF8E1;
  border-radius: 8px;
}

.tab-desc {
  margin: 0;
  color: #FF9800;
  font-size: 14px;
}

.tab-desc i {
  margin-right: 6px;
}

/* 筛选栏 */
.filter-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

/* 表格 */
.data-table {
  border-radius: 8px;
  overflow: hidden;
}

.cover-img {
  width: 70px;
  height: 50px;
  border-radius: 6px;
  object-fit: cover;
}

.cover-img-sm {
  width: 60px;
  height: 40px;
  border-radius: 4px;
}

.no-cover {
  width: 70px;
  height: 50px;
  background: #f5f7fa;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #c0c4cc;
  font-size: 24px;
}

.scenic-name {
  font-weight: 600;
  color: #303133;
  margin-bottom: 4px;
}

.scenic-tags {
  display: flex;
  gap: 4px;
  flex-wrap: wrap;
}

.price {
  color: #F56C6C;
  font-weight: 600;
}

.free {
  color: #67C23A;
  font-weight: 500;
}

.text-muted {
  color: #c0c4cc;
}

.data-item {
  margin-right: 12px;
  color: #606266;
  font-size: 13px;
}

.data-item i {
  margin-right: 3px;
  color: #909399;
}

.user-cell {
  display: flex;
  align-items: center;
  gap: 6px;
}

/* 分页 */
.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 表单样式 */
.scenic-form {
  max-height: 60vh;
  overflow-y: auto;
  padding-right: 12px;
}

.cover-uploader {
  border: 2px dashed #dcdfe6;
  border-radius: 8px;
  cursor: pointer;
  width: 200px;
  height: 140px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
}

.cover-uploader:hover {
  border-color: #FF9800;
}

.cover-uploader-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #909399;
}

.cover-uploader-placeholder i {
  font-size: 32px;
  margin-bottom: 8px;
}

.cover-preview {
  width: 200px;
  height: 140px;
  object-fit: cover;
  border-radius: 6px;
}

.upload-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
}

/* 详情弹窗 */
.forum-detail h3 {
  margin: 0 0 16px 0;
  font-size: 18px;
  color: #303133;
}

.detail-meta {
  display: flex;
  gap: 20px;
  color: #909399;
  font-size: 13px;
  margin-bottom: 16px;
  align-items: center;
}

.detail-meta i {
  margin-right: 4px;
}

.detail-content {
  line-height: 1.8;
  color: #606266;
  white-space: pre-wrap;
  padding: 16px;
  background: #f5f7fa;
  border-radius: 8px;
  margin-bottom: 16px;
}

.detail-stats {
  display: flex;
  gap: 24px;
  color: #909399;
}

.detail-stats i {
  margin-right: 4px;
}

.current-forum-title {
  color: #606266;
  font-weight: 500;
}

/* 响应式 */
@media (max-width: 1200px) {
  .stats-row {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .stats-row {
    grid-template-columns: 1fr;
  }

  .page-header {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }
}
</style>
