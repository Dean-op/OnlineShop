<template>
  <div class="forum-manager">
    <div class="page-header">
      <h2>论坛管理</h2>
    </div>

    <div class="filter-bar">
      <el-input v-model="keyword" placeholder="搜索帖子..." prefix-icon="el-icon-search" clearable style="width: 250px"
        @keyup.enter.native="getForums">
      </el-input>
      <el-select v-model="filterType" placeholder="帖子类型" clearable @change="getForums">
        <el-option label="话题讨论" :value="1"></el-option>
        <el-option label="文化分享" :value="2"></el-option>
      </el-select>
    </div>

    <el-table :data="forums" v-loading="loading" stripe>
      <el-table-column prop="id" label="ID" width="80"></el-table-column>
      <el-table-column label="封面" width="100">
        <template slot-scope="scope">
          <el-image v-if="scope.row.coverImage" :src="scope.row.coverImage.startsWith('http') ? scope.row.coverImage : `/api${scope.row.coverImage}`"
            fit="cover" style="width: 60px; height: 40px; border-radius: 4px">
          </el-image>
        </template>
      </el-table-column>
      <el-table-column prop="title" label="标题" min-width="180"></el-table-column>
      <el-table-column label="类型" width="100">
        <template slot-scope="scope">
          <el-tag :type="scope.row.type === 1 ? 'primary' : 'success'" size="small">
            {{ scope.row.type === 1 ? '话题讨论' : '文化分享' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="发布者" width="100">
        <template slot-scope="scope">{{ scope.row.user?.username }}</template>
      </el-table-column>
      <el-table-column label="浏览/回复/点赞" width="130">
        <template slot-scope="scope">
          {{ scope.row.viewCount }} / {{ scope.row.replyCount }} / {{ scope.row.likeCount }}
        </template>
      </el-table-column>
      <el-table-column label="置顶" width="80">
        <template slot-scope="scope">
          <el-switch v-model="scope.row.isTop" :active-value="1" :inactive-value="0" @change="toggleTop(scope.row)">
          </el-switch>
        </template>
      </el-table-column>
      <el-table-column prop="createdAt" label="发布时间" width="160">
        <template slot-scope="scope">{{ formatTime(scope.row.createdAt) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="120" fixed="right">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="viewForum(scope.row)">查看</el-button>
          <el-button type="text" size="small" style="color: #f56c6c" @click="deleteForum(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination-wrapper">
      <el-pagination background :current-page.sync="currentPage" :page-size="pageSize" :total="total"
        layout="total, prev, pager, next" @current-change="getForums">
      </el-pagination>
    </div>

    <!-- 查看详情对话框 -->
    <el-dialog title="帖子详情" :visible.sync="detailDialogVisible" width="700px">
      <div v-if="currentForum" class="forum-detail">
        <h3>{{ currentForum.title }}</h3>
        <div class="detail-meta">
          <span>发布者：{{ currentForum.user?.username }}</span>
          <span>发布时间：{{ formatTime(currentForum.createdAt) }}</span>
        </div>
        <div class="detail-content">{{ currentForum.content }}</div>
        <div v-if="currentForum.product" class="related-product">
          关联商品：{{ currentForum.product.name }}
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import Request from '@/utils/request'
import { formatTime } from '@/utils/time'

export default {
  name: 'ForumManager',
  data() {
    return {
      loading: false,
      forums: [],
      keyword: '',
      filterType: null,
      currentPage: 1,
      pageSize: 10,
      total: 0,
      detailDialogVisible: false,
      currentForum: null
    }
  },
  created() {
    this.getForums()
  },
  methods: {
    formatTime,
    async getForums() {
      this.loading = true
      try {
        const res = await Request.get('/forum/page', {
          params: {
            keyword: this.keyword,
            type: this.filterType,
            currentPage: this.currentPage,
            size: this.pageSize
          }
        })
        if (res.code === '0') {
          this.forums = res.data.records
          this.total = res.data.total
        }
      } finally {
        this.loading = false
      }
    },
    viewForum(forum) {
      this.currentForum = forum
      this.detailDialogVisible = true
    },
    async toggleTop(forum) {
      await Request.post(`/forum/${forum.id}/top`, null, {
        params: { isTop: forum.isTop }
      })
      this.$message.success(forum.isTop ? '已置顶' : '已取消置顶')
    },
    async deleteForum(forum) {
      await this.$confirm('确定要删除这个帖子吗？', '提示', { type: 'warning' })
      const res = await Request.delete(`/forum/${forum.id}`)
      if (res.code === '0') {
        this.$message.success('删除成功')
        this.getForums()
      }
    }
  }
}
</script>

<style scoped>
.forum-manager {
  padding: 20px;
}
.page-header {
  margin-bottom: 20px;
}
.page-header h2 {
  margin: 0;
  font-size: 20px;
  color: #303133;
}
.filter-bar {
  margin-bottom: 20px;
  display: flex;
  gap: 12px;
}
.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
.forum-detail h3 {
  margin: 0 0 16px 0;
  font-size: 18px;
  color: #303133;
}
.detail-meta {
  color: #909399;
  font-size: 13px;
  margin-bottom: 16px;
  display: flex;
  gap: 20px;
}
.detail-content {
  line-height: 1.8;
  color: #606266;
  white-space: pre-wrap;
}
.related-product {
  margin-top: 16px;
  padding: 12px;
  background: #FFF8E1;
  border-radius: 6px;
  color: #FF9800;
}
</style>
