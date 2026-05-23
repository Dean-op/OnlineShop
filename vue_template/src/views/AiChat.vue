<template>
    <div class="ai-chat-page">
      <!-- 复用商品页的头部组件 -->
      <front-header></front-header>
      
      <div class="main-content">
        <!-- 聊天区域卡片 -->
        <div class="chat-section">
          <el-card shadow="never" class="chat-card">
            <!-- 聊天标题栏 -->
            <div class="chat-header">
              <div class="chat-title">
                <i class="el-icon-robot"></i>
                <span>文旅智能助手</span>
              </div>
              <el-button 
                type="text" 
                icon="el-icon-refresh-left" 
                @click="clearChat"
                size="small"
                class="clear-btn"
              >
                清空聊天
              </el-button>
            </div>
  
            <!-- 聊天内容区域（带加载状态） -->
            <div class="chat-content" v-loading="loading">
              <!-- 空聊天状态 -->
              <div class="empty-chat" v-if="chatMessages.length === 0">
                <i class="el-icon-comment"></i>
                <p>开始与文旅智能助手对话吧～</p>
                <p class="hint-text">可以咨询商品信息、景点文化、出行建议等问题</p>
              </div>
  
              <!-- 聊天消息列表 -->
              <div class="message-list" ref="messageContainer">
                <div 
                  v-for="(msg, index) in chatMessages" 
                  :key="index"
                  :class="['message-item', msg.isUser ? 'user-message' : 'ai-message']"
                >
                  <!-- 消息头像 -->
                  <div class="message-avatar">
                    <i :class="msg.isUser ? 'el-icon-user' : 'el-icon-robot'"></i>
                  </div>
                  <!-- 消息内容 -->
                  <div class="message-bubble">
                    <div class="message-content" v-html="formatMessageContent(msg.content)"></div>
                    <div class="message-time">{{ formatTime(msg.timestamp) }}</div>
                  </div>
                </div>
              </div>
            </div>
  
            <!-- 输入区域 -->
            <div class="chat-input">
              <el-input
                v-model="userInput"
                placeholder="请输入你的问题..."
                prefix-icon="el-icon-paperclip"
                suffix-icon="el-icon-send"
                @keyup.enter.native="sendMessage"
                @click="handleInputClick"
                :disabled="loading"
                class="input-field"
              ></el-input>
              <el-button 
                type="primary" 
                icon="el-icon-send" 
                @click="sendMessage"
                :disabled="!userInput.trim() || loading"
                class="send-btn"
              >
                发送
              </el-button>
            </div>
          </el-card>
        </div>
  
        <!-- 常见问题推荐 -->
        <div class="faq-section">
          <div class="faq-header">
            <span class="faq-title">常见问题</span>
          </div>
          <div class="faq-tags">
            <el-tag 
              v-for="(faq, index) in faqList" 
              :key="index"
              :effect="selectedFaq === faq ? 'dark' : 'plain'"
              @click="selectFaq(faq)"
              class="faq-tag"
            >
              {{ faq }}
            </el-tag>
          </div>
        </div>
      </div>
  
      <!-- 复用商品页的底部组件 -->
      <front-footer></front-footer>
    </div>
  </template>
  
  <script>
  // 复用商品页的头部、底部组件
  import FrontHeader from '@/components/front/FrontHeader.vue'
  import FrontFooter from '@/components/front/FrontFooter.vue'
  // 复用商品页的请求工具
  import Request from '@/utils/request'
  // 防抖工具
  import { debounce } from 'lodash'
  
  export default {
    name: 'AiChat',
    components: {
      FrontHeader,
      FrontFooter
    },
    data() {
      return {
        // 聊天相关状态
        chatMessages: [], // 聊天消息列表
        userInput: '',    // 用户输入内容
        loading: false,   // 加载状态
        selectedFaq: '',  // 选中的常见问题
  
        // 常见问题列表
        faqList: [
          '有哪些热门文旅商品？',
          '推荐一些当地特色好物',
          '有什么值得去的景点？',
          '如何选购适合的纪念品？'
        ],
  
        // 防抖函数
        debouncedSend: null
      }
    },
    methods: {
      // 格式化消息内容：处理换行和列表
      formatMessageContent(content) {
        if (!content) return ''
        return content
          .replace(/\n/g, '<br>') // 换行符转HTML换行
          .replace(/- /g, '&nbsp;&nbsp;- ') // 列表项加缩进
          .replace(/(\d+)\. /g, '&nbsp;&nbsp;$1. ') // 数字列表加缩进
      },
  
      // 格式化消息时间
      formatTime(timestamp) {
        const date = new Date(timestamp)
        return `${date.getMonth() + 1}月${date.getDate()}日 ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
      },
  
      // 发送消息（核心：解析后端返回的JSON数据）
      async sendMessage() {
        const inputText = this.userInput.trim()
        if (!inputText || this.loading) return
  
        // 添加用户消息到列表
        const userMsg = {
          content: inputText,
          isUser: true,
          timestamp: Date.now()
        }
        this.chatMessages.push(userMsg)
        this.userInput = ''
        this.scrollToBottom()
  
        // 调用AI接口
        this.loading = true
        try {
          const res = await Request.get('/Ai/rep', {
            params: { question: inputText }
          })
  
          // 解析后端返回的JSON数据，提取AI回答
          if (res && res.choices && res.choices.length > 0) {
            const aiAnswer = res.choices[0].message?.content || '未获取到有效回答'
            this.chatMessages.push({
              content: aiAnswer,
              isUser: false,
              timestamp: Date.now()
            })
          } else {
            this.$message.warning('AI 回复格式异常，请重试')
          }
        } catch (error) {
          console.error('AI 接口调用失败:', error)
          const errorMsg = error.response?.data?.message || error.message || '未知错误'
          this.$message.error('AI 助手暂时无法响应：' + errorMsg)
          this.chatMessages.push({
            content: '抱歉，暂时无法获取回复：' + errorMsg,
            isUser: false,
            timestamp: Date.now()
          })
        } finally {
          this.loading = false
          this.scrollToBottom()
        }
      },
  
      // 清空聊天记录
      clearChat() {
        this.$confirm('确定要清空所有聊天记录吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.chatMessages = []
        }).catch(() => {
          // 取消清空
        })
      },
  
      // 选择常见问题
      selectFaq(faq) {
        this.userInput = faq
        this.selectedFaq = faq
        this.debouncedSend()
      },
  
      // 滚动到最新消息
      scrollToBottom() {
        this.$nextTick(() => {
          const container = this.$refs.messageContainer
          if (container) {
            container.scrollTop = container.scrollHeight
          }
        })
      },
  
      // 输入框点击事件
      handleInputClick() {
        this.selectedFaq = ''
      }
    },
    watch: {
      // 监听输入框变化
      userInput() {
        this.selectedFaq = ''
      }
    },
    created() {
      // 创建防抖函数
      this.debouncedSend = debounce(() => {
        this.sendMessage()
      }, 300)
    },
    mounted() {
      this.scrollToBottom()
    }
  }
  </script>
  
  <style scoped>
  .ai-chat-page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    background-color: #f0f7ff; /* 浅蓝色背景 */
  }
  
  .main-content {
    flex: 1;
    padding: 30px;
    max-width: 1000px;
    margin: 0 auto;
    width: 100%;
    box-sizing: border-box;
  }
  
  /* 聊天区域样式 */
  .chat-section {
    margin-bottom: 20px;
  }
  
  .chat-card {
    border-radius: 16px;
    box-shadow: 0 6px 24px rgba(125, 164, 255, 0.12) !important;
    border: none;
    background-color: #fff;
    overflow: hidden;
  }
  
  /* 聊天头部样式 */
  .chat-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 24px;
    background: linear-gradient(135deg, #4285f4, #5b97f7);
    color: white;
  }
  
  .chat-title {
    display: flex;
    align-items: center;
    font-size: 18px;
    font-weight: 600;
  }
  
  .chat-title i {
    margin-right: 10px;
    font-size: 20px;
  }
  
  .clear-btn {
    color: rgba(255, 255, 255, 0.9);
    transition: all 0.3s;
  }
  
  .clear-btn:hover {
    color: white;
    background-color: rgba(255, 255, 255, 0.15);
  }
  
  /* 聊天内容区域 */
  .chat-content {
    min-height: 450px;
    padding: 24px;
    position: relative;
  }
  
  /* 空聊天状态 */
  .empty-chat {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 60px 0;
    color: #6b8ed1;
  }
  
  .empty-chat i {
    font-size: 64px;
    margin-bottom: 20px;
    color: #b9c9f7;
  }
  
  .empty-chat p {
    font-size: 16px;
    margin: 0 0 8px;
  }
  
  .hint-text {
    font-size: 14px !important;
    color: #94a9e7 !important;
  }
  
  /* 消息列表样式 */
  .message-list {
    height: 450px;
    overflow-y: auto;
    padding-right: 8px;
    scrollbar-width: thin;
  }
  
  .message-list::-webkit-scrollbar {
    width: 6px;
  }
  
  .message-list::-webkit-scrollbar-track {
    background: #f0f5ff;
    border-radius: 3px;
  }
  
  .message-list::-webkit-scrollbar-thumb {
    background-color: #c1d3fe;
    border-radius: 3px;
  }
  
  /* 消息项样式 */
  .message-item {
    display: flex;
    margin-bottom: 20px;
    animation: fadeIn 0.3s ease;
  }
  
  .user-message {
    flex-direction: row-reverse;
  }
  
  /* 消息头像 */
  .message-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  }
  
  .ai-message .message-avatar {
    background: linear-gradient(135deg, #4285f4, #5b97f7);
    color: white;
  }
  
  .user-message .message-avatar {
    background: linear-gradient(135deg, #42a5f5, #64b5f6);
    color: white;
  }
  
  /* 消息气泡 */
  .message-bubble {
    max-width: 75%;
    margin: 0 14px;
  }
  
  .message-content {
    padding: 14px 18px;
    border-radius: 14px;
    line-height: 1.8;
    word-wrap: break-word;
    position: relative;
  }
  
  .ai-message .message-content {
    background-color: #f0f7ff;
    color: #1a365d;
    border: 1px solid #e6f0ff;
  }
  
  .user-message .message-content {
    background: linear-gradient(135deg, #4285f4, #5b97f7);
    color: white;
  }
  
  /* 消息时间 */
  .message-time {
    font-size: 12px;
    margin-top: 6px;
    text-align: left;
    color: #94a9e7;
  }
  
  .user-message .message-time {
    text-align: right;
  }
  
  /* 输入区域样式 */
  .chat-input {
    display: flex;
    gap: 12px;
    padding: 0 24px 24px;
  }
  
  .input-field {
    flex: 1;
  }
  
  .input-field :deep(.el-input__inner) {
    border-radius: 24px;
    height: 48px;
    line-height: 48px;
    border-color: #d1e0fe;
    padding-left: 20px;
    padding-right: 50px;
    transition: all 0.3s;
  }
  
  .input-field :deep(.el-input__inner:focus) {
    border-color: #64b5f6;
    box-shadow: 0 0 0 2px rgba(100, 181, 246, 0.2);
  }
  
  .send-btn {
    border-radius: 24px;
    padding: 0 28px;
    height: 48px;
    background: linear-gradient(135deg, #4285f4, #5b97f7);
    border-color: #4285f4;
    transition: all 0.3s;
  }
  
  .send-btn:hover {
    background: linear-gradient(135deg, #3367d6, #4785f4);
    border-color: #3367d6;
    transform: translateY(-2px);
  }
  
  .send-btn:disabled {
    background: #c9dafc;
    border-color: #c9dafc;
    cursor: not-allowed;
  }
  
  /* 常见问题区域 */
  .faq-section {
    background: white;
    padding: 20px 24px;
    border-radius: 16px;
    box-shadow: 0 6px 24px rgba(125, 164, 255, 0.12);
  }
  
  .faq-header {
    margin-bottom: 16px;
  }
  
  .faq-title {
    font-size: 16px;
    font-weight: 600;
    color: #1a365d;
    display: flex;
    align-items: center;
  }
  
  .faq-title::before {
    content: '';
    display: inline-block;
    width: 4px;
    height: 16px;
    background-color: #4285f4;
    border-radius: 2px;
    margin-right: 8px;
  }
  
  .faq-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
  }
  
  .faq-tag {
    cursor: pointer;
    padding: 6px 16px;
    border-radius: 20px;
    font-size: 14px;
    transition: all 0.3s;
    border-color: #d1e0fe;
    color: #1a365d;
  }
  
  .faq-tag:hover {
    background-color: #f0f7ff;
    transform: translateY(-2px);
  }
  
  .faq-tag:deep(.el-tag--dark) {
    background-color: #4285f4;
    color: white;
    border-color: #4285f4;
  }
  
  /* 加载状态样式 */
  :deep(.el-loading-mask) {
    background-color: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(4px);
  }
  
  :deep(.el-loading-spinner .path) {
    stroke: #4285f4;
  }
  
  /* 动画效果 */
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
  
  /* 响应式布局 */
  @media (max-width: 1200px) {
    .main-content {
      max-width: 960px;
    }
  }
  
  @media (max-width: 768px) {
    .main-content {
      padding: 15px;
    }
  
    .message-bubble {
      max-width: 85%;
    }
  
    .chat-input {
      flex-direction: column;
    }
  
    .send-btn {
      width: 100%;
    }
  }
  </style>
