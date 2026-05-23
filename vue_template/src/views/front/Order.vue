<template>
  <div class="order-page">
    <front-header></front-header>
    <div class="main-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <h2>我的订单</h2>
        <div class="order-count">共 {{ total }} 个订单</div>
      </div>

      <!-- 订单列表 -->
      <div class="order-content" v-loading="loading">
        <!-- 空订单提示 -->
        <el-empty v-if="!loading && orders.length === 0" :image-size="200" class="empty-order">
          <template slot="description">
            <div class="empty-text">
              <p class="main-text">您还没有任何订单</p>
              <p class="sub-text">快去选购心仪的商品吧</p>
            </div>
          </template>
          <el-button type="primary" size="medium" @click="$router.push('/products')">
            <i class="el-icon-shopping-cart-2"></i>
            去购物
          </el-button>
        </el-empty>

        <!-- 订单列表 -->
        <div v-else class="order-list">
          <div v-for="order in orders" :key="order.id" class="order-item">
            <div class="order-header">
              <span class="order-id">订单号：{{ order.id }}</span>
              <span class="order-time">{{ formatTime(order.createdAt) }}</span>
              <div class="status-wrapper">
                <span class="order-status" :class="getStatusClass(order.status)">
                  {{ getStatusText(order.status) }}
                </span>
                <i class="el-icon-delete delete-icon" @click="handleDelete(order)"></i>
              </div>
            </div>

            <!-- 修改订单商品和收货信息的布局 -->
            <div class="order-products">
              <div class="product-info">
                <el-image :src="order.product.imageUrl?.startsWith('http') ? order.product.imageUrl : `/api${order.product.imageUrl}`" fit="cover"
                  class="product-image">
                  <div slot="error" class="image-slot">
                    <i class="el-icon-picture-outline"></i>
                  </div>
                </el-image>
                <div class="product-details">
                  <h3 class="product-name">{{ order.product.name }}</h3>
                  <div class="product-price">
                    <span class="price" :class="{ 'discount': order.product.isDiscount }">
                      ¥{{ order.product.isDiscount ? order.product.discountPrice : order.price }}
                    </span>
                    <span class="original-price" v-if="order.product.isDiscount">
                      ¥{{ order.price }}
                    </span>
                    <span class="quantity">x{{ order.quantity }}</span>
                  </div>
                  <!-- Add inventory and quantity controls -->
                  <div class="quantity-controls">
                    <span class="inventory">库存: {{ order.product.stock || 0 }}</span>
                    <div class="quantity-adjust" v-if="order.status === 0">
                      <el-input-number 
                        v-model="order.quantity" 
                        :min="1" 
                        :max="order.product.stock" 
                        size="small"
                        @change="handleQuantityChange(order)"
                      ></el-input-number>
                    </div>
                  </div>
                </div>
                <!-- 收货信息移到这里 -->
                <div class="delivery-info">
                  <div class="info-item">
                    <i class="el-icon-phone"></i>
                    <span>{{ order.recvPhone || '暂无联系电话' }}</span>
                  </div>
                  <div class="info-item">
                    <i class="el-icon-location"></i>
                    <span>{{ order.recvAddress || '暂无收货地址' }}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 平台介入状态提示 -->
            <div class="intervention-status-bar" v-if="order.platformIntervention > 0">
              <div class="intervention-info" v-if="order.platformIntervention === 1">
                <i class="el-icon-loading"></i>
                <span>已申请平台介入，等待平台处理</span>
              </div>
              <div class="intervention-info" v-else-if="order.platformIntervention === 2">
                <i class="el-icon-loading"></i>
                <span>平台处理中，请耐心等待</span>
              </div>
              <div class="intervention-info resolved" v-else-if="order.platformIntervention === 3">
                <i class="el-icon-circle-check"></i>
                <span>平台已介入处理</span>
                <span class="intervention-result" v-if="order.refundStatus === 3">（已同意退款）</span>
                <span class="intervention-result rejected" v-else-if="order.refundStatus === 4">（已拒绝退款）</span>
              </div>
              <div class="intervention-remark" v-if="order.platformRemark">
                <span class="remark-label">平台处理意见：</span>{{ order.platformRemark }}
              </div>
            </div>

            <div class="order-footer">
              <div class="order-total">
                总计：<span class="total-price">¥{{ order.totalPrice }}</span>
              </div>
              <div class="order-actions">
                <el-button v-if="order.status === 0" type="primary" size="small" @click="showPaymentDialog(order)">
                  立即支付
                </el-button>
                <el-button v-if="order.status === 2" type="success" size="small" @click="handleConfirm(order)">
                  确认收货
                </el-button>
                <el-button v-if="order.status === 3" type="warning" size="small" @click="handleReview(order)">
                  评价
                </el-button>
                <el-button v-if="[1, 2, 3].includes(order.status)" type="danger" size="small" @click="showRefundDialog(order)">
                  申请退款
                </el-button>
                <el-button v-if="order.status === 7 && order.platformIntervention === 0" type="warning" size="small" @click="showPlatformInterventionDialog(order)">
                  申请平台介入
                </el-button>
                <el-button v-if="[1, 2, 3].includes(order.status)" type="warning" size="small" plain @click="goToComplaint(order)">
                  投诉
                </el-button>
                <el-button v-if="order.status === 0" type="danger" size="small" @click="handleCancel(order)">
                  取消订单
                </el-button>
                <el-button v-if="[0, 1].includes(order.status)" type="warning" size="small" @click="showAddressDialog(order)">
                  修改收货信息
                </el-button>
                <el-button 
                  v-if="[3, 4, 6].includes(order.status)" 
                  type="danger" 
                  size="small" 
                  @click="handleDelete(order)">
                  <i class="el-icon-delete"></i>
                  删除订单
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="total > 0">
          <el-pagination background :current-page.sync="currentPage" :page-size="pageSize" :total="total" layout="prev, pager, next, jumper"
            @current-change="getOrders">
          </el-pagination>
        </div>
      </div>
    </div>
    <front-footer></front-footer>

    <!-- 添加支付方式选择对话框 -->
    <el-dialog title="选择支付方式" :visible.sync="paymentDialogVisible" width="30%">
      <div class="payment-options">
        <el-radio v-model="paymentMethod" label="balance">微信支付</el-radio>
        <el-radio v-model="paymentMethod" label="alipay">支付宝支付</el-radio>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="paymentDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmPayment">确认支付</el-button>
      </span>
    </el-dialog>

    <!-- 修改收货信息对话框 -->
    <el-dialog title="修改收货信息" :visible.sync="addressDialogVisible" width="500px">
      <div v-if="!showAddressForm">
        <!-- 已有地址列表 -->
        <div class="address-list-section">
          <div class="section-header">
            <div class="section-title">选择收货地址</div>
            <el-button type="text" icon="el-icon-plus" @click="showAddressForm = true">
              新增地址
            </el-button>
          </div>
          <div class="address-list">
            <el-radio-group v-model="selectedAddressId" class="address-radio-group">
              <el-radio v-for="addr in addresses" :key="addr.id" :label="addr.id" class="address-radio-item">
                <div class="address-content">
                  <div class="address-info">
                    <div class="phone">{{ addr.phone }}</div>
                    <div class="address-detail">{{ addr.address }}</div>
                  </div>
                </div>
              </el-radio>
            </el-radio-group>
          </div>
        </div>
      </div>

      <!-- 新增地址表单 -->
      <div v-else>
        <div class="form-header">
          <div class="section-title">新增地址</div>
          <el-button type="text" icon="el-icon-back" @click="showAddressForm = false">
            返回地址列表
          </el-button>
        </div>
        <el-form :model="addressForm" :rules="addressRules" ref="addressForm" label-width="80px">
          <el-form-item label="联系电话" prop="phone">
            <el-input v-model="addressForm.phone" placeholder="请输入联系电话"></el-input>
          </el-form-item>
          <el-form-item label="收货地址" prop="address">
            <el-input type="textarea" v-model="addressForm.address" :rows="3" placeholder="请输入详细收货地址"></el-input>
          </el-form-item>
          <el-form-item>
            <el-checkbox v-model="saveToAddressBook">保存到地址簿</el-checkbox>
          </el-form-item>
        </el-form>
      </div>

      <div slot="footer">
        <el-button @click="addressDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="updateOrderAddress">确定</el-button>
      </div>
    </el-dialog>

    <!-- 修改退款申请对话框 -->
    <el-dialog title="申请退款" :visible.sync="refundDialogVisible" width="400px">
      <el-form :model="refundForm" :rules="refundRules" ref="refundForm" label-width="80px">
        <el-form-item label="退款原因" prop="reason">
          <el-select v-model="refundForm.reason" placeholder="请选择退款原因" style="width: 100%">
            <el-option label="商品质量问题" value="商品质量问题"></el-option>
            <el-option label="商品与描述不符" value="商品与描述不符"></el-option>
            <el-option label="发货太慢" value="发货太慢"></el-option>
            <el-option label="其他原因" value="其他原因"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="refundDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitRefund">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 申请平台介入对话框 -->
    <el-dialog title="申请平台介入" :visible.sync="platformInterventionDialogVisible" width="500px">
      <el-alert
        title="提示"
        type="warning"
        description="如果商家拒绝退款或长时间未处理，您可以申请平台介入。平台客服将会审核您的申请并做出公正的处理。"
        :closable="false"
        show-icon
        style="margin-bottom: 20px">
      </el-alert>
      <el-form :model="platformInterventionForm" :rules="platformInterventionRules" ref="platformInterventionForm" label-width="100px">
        <el-form-item label="介入原因" prop="reason">
          <el-input
            type="textarea"
            v-model="platformInterventionForm.reason"
            :rows="5"
            placeholder="请详细说明您申请平台介入的原因，例如：商家拒绝退款的理由不合理、商家长时间未处理退款申请等"
            maxlength="500"
            show-word-limit>
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="platformInterventionDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitPlatformIntervention">提交申请</el-button>
      </div>
    </el-dialog>

    <!-- 修改评价对话框 -->
    <el-dialog title="商品评价" :visible.sync="reviewDialogVisible" width="500px">
      <div v-if="currentOrder" class="review-product-info">
        <el-image :src="currentOrder.product.imageUrl?.startsWith('http') ? currentOrder.product.imageUrl : `/api${currentOrder.product.imageUrl}`" fit="cover"
          class="review-product-image">
        </el-image>
        <div class="review-product-detail">
          <div class="review-product-name">{{ currentOrder.product.name }}</div>
          <div class="review-product-price">
            <span class="price">¥{{ currentOrder.price }}</span>
            <span class="quantity">x {{ currentOrder.quantity }}</span>
          </div>
        </div>
      </div>

      <el-form :model="reviewForm" :rules="reviewRules" ref="reviewForm" label-width="80px" class="review-form" v-if="currentOrder">
        <el-form-item label="评分" prop="rating">
          <el-rate v-model="reviewForm.rating" :colors="['#99A9BF', '#F7BA2A', '#FF9900']" show-text :texts="['很差', '较差', '一般', '较好', '很好']">
          </el-rate>
        </el-form-item>
        <el-form-item label="评价内容" prop="content">
          <el-input type="textarea" v-model="reviewForm.content" :rows="4" placeholder="请分享您对商品的使用体验..."></el-input>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button @click="reviewDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitReview">提交评价</el-button>
      </div>
    </el-dialog>

    <!-- 添加删除订单对话框 -->
    <el-dialog
      title="删除订单"
      :visible.sync="deleteDialogVisible"
      width="30%">
      <span>确定要删除该订单吗？删除后将无法恢复。</span>
      <span slot="footer" class="dialog-footer">
        <el-button @click="deleteDialogVisible = false">取消</el-button>
        <el-button type="danger" @click="confirmDelete">确定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import FrontHeader from '@/components/front/FrontHeader.vue'
import FrontFooter from '@/components/front/FrontFooter.vue'
import Request from '@/utils/request'
import { formatTime } from '@/utils/time'

export default {
  name: 'Order',
  components: {
    FrontHeader,
    FrontFooter
  },
  data() {
    return {
      userInfo: JSON.parse(localStorage.getItem('frontUser') || '{}'),
      loading: false,
      orders: [],
      currentPage: 1,
      pageSize: 10,
      total: 0,
      paymentDialogVisible: false,
      paymentMethod: 'balance',
      currentOrder: null,
      addressDialogVisible: false,
      selectedAddressId: null,
      addresses: [],
      saveToAddressBook: false,
      addressForm: {
        phone: '',
        address: ''
      },
      currentEditOrder: null,
      addressRules: {
        phone: [
          { required: true, message: '请输入联系电话', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
        ],
        address: [
          { required: true, message: '请输入收货地址', trigger: 'blur' }
        ]
      },
      showAddressForm: false,
      refundDialogVisible: false,
      refundForm: {
        reason: ''
      },
      refundRules: {
        reason: [
          { required: true, message: '请选择退款原因', trigger: 'change' }
        ]
      },
      currentRefundOrder: null,
      platformInterventionDialogVisible: false,
      platformInterventionForm: {
        reason: ''
      },
      platformInterventionRules: {
        reason: [
          { required: true, message: '请填写介入原因', trigger: 'blur' },
          { min: 10, max: 500, message: '介入原因长度在 10 到 500 个字符', trigger: 'blur' }
        ]
      },
      currentInterventionOrder: null,
      reviewDialogVisible: false,
      reviewForm: {
        rating: 5,
        content: ''
      },
      reviewRules: {
        rating: [
          { required: true, message: '请选择评分', trigger: 'change' }
        ],
        content: [
          { required: true, message: '请填写评价内容', trigger: 'blur' },
          { min: 5, max: 500, message: '评价内容长度在 5 到 500 个字符', trigger: 'blur' }
        ]
      },
      deleteDialogVisible: false,
      currentDeleteOrder: null,
    }
  },
  created() {
    this.getOrders()
  },
  mounted() {
    this.userInfo = JSON.parse(localStorage.getItem('frontUser') || '{}')
  },
  methods: {
    isLogin() {
      const userStr = localStorage.getItem('frontUser')
      if (!userStr) {
        this.$message({
          type: 'warning',
          message: '请先登录'
        })
        this.$router.push('/login')
        return
      }
    },
    formatTime,
    async getOrders() {
      this.isLogin()
      this.loading = true
      try {
        const userId = this.userInfo.id
        const res = await Request.get('/order/page', {
          params: {
            userId,
            currentPage: this.currentPage,
            size: this.pageSize
          }
        })
        if (res.code === '0') {
          if (res.data.total === 0) {
            this.orders = []
            this.total = 0
          } else {
            this.orders = res.data.records
            this.total = res.data.total
          }
        }
      } catch (error) {
        console.error('获取订单列表失败:', error)
        this.$message.error('获取订单列表失败')
      } finally {
        this.loading = false
      }
        
      },

      getStatusText(status) {
        const statusMap = {
          0: '待支付',
          1: '已支付',
          2: '已发货',
          3: '已完成',
          4: '已取消',
          5: '退款中',
          6: '已退款',
          7: '退款失败'
        }
        return statusMap[status] || '未知状态'
      },

      getStatusClass(status) {
        const classMap = {
          0: 'pending',
          1: 'paid',
          2: 'shipped',
          3: 'completed',
          4: 'cancelled',
          5: 'refunding',
          6: 'refunded',
          7: 'refund-failed'
        }
        return classMap[status] || ''
      },
      async handleAlipay(order) {
    this.isLogin()
    try {
        console.log('发起支付请求，订单ID:', order.id);
        
        // 直接在新窗口打开支付页面
        window.open(`/api/alipay/pay/${order.id}`, '_blank');
        this.paymentDialogVisible = false;
        
    } catch (error) {
        console.error('支付请求异常:', error);
        this.$message.error('支付请求失败：' + error.message);
    }
},


    async handleConfirm(order) {
        try {
          await this.$confirm('确认已收到商品吗？', '提示', {
            type: 'warning'
          })
          const res = await Request.put(`/order/${order.id}/status?status=3`);
          if (res.code === '0') {
            this.$message.success('确认收货成功')
            this.getOrders()
          }
        } catch (error) {
          if (error !== 'cancel') {
            console.error('确认收货失败:', error)
            this.$message.error('确认收货失败')
          }
        }
      },

      handleReview(order) {
        // 确保order包含完整的商品信息
        this.currentOrder = {
          ...order,
          product: {
            ...order.product
          }
        }
        this.reviewForm = {
          rating: 5,
          content: ''
        }
        this.reviewDialogVisible = true
      },

    async handleCancel(order) {
        this.isLogin()
        try {
          await this.$confirm('确定要取消订单吗？', '提示', {
            type: 'warning'
          })
          const res = await Request.put(`/order/${order.id}/status?status=4`);
          if (res.code === '0') {
            this.$message.success('订单已取消')
            this.getOrders()
          }
        } catch (error) {
          if (error !== 'cancel') {
            console.error('取消订单失败:', error)
            this.$message.error('取消订单失败')
          }
        }
      },

      showPaymentDialog(order) {
        this.isLogin()
        this.currentOrder = order
        this.paymentMethod = 'balance' // 默认选择余额支付
        this.paymentDialogVisible = true
      },

    async confirmPayment() {
        try {
          if (this.paymentMethod === 'balance') {
            // 使用余额支付
            const res = await Request.put(`/order/${this.currentOrder.id}/pay`)

            if (res.code === '0') {
              this.$message.success('支付成功')
              this.paymentDialogVisible = false
              this.getOrders() // 刷新订单列表
            } else {
              this.$message.error(res.msg || '支付失败')
            }
          } else if (this.paymentMethod === 'alipay') {
            this.handleAlipay(this.currentOrder)
          }
        } catch (error) {
          console.error('支付失败:', error)
          this.$message.error('支付失败')
        }
      },

    async getAddresses() {
        this.isLogin()
        try {
          const userId = this.userInfo.id
          const res = await Request.get(`/address/user/${userId}`)
          if (res.code === '0') {
            this.addresses = res.data
          }
        } catch (error) {
          console.error('获取地址列表失败:', error)
          this.$message.error('获取地址列表失败')
        }
      },

      formatAddress(addr) {
        return `${addr.phone} ${addr.address}`
      },

      showAddressDialog(order) {
        this.currentEditOrder = order
        this.addressForm = {
          phone: order.recvPhone || '',
          address: order.recvAddress || ''
        }
        this.selectedAddressId = null
        this.saveToAddressBook = false
        this.showAddressForm = false
        this.addressDialogVisible = true
        this.getAddresses()
      },

    async updateOrderAddress() {
        try {
          if (this.showAddressForm) {
            // 如果是新增地址，验证表单
            await this.$refs.addressForm.validate()
          } else if (!this.selectedAddressId) {
            // 如果是选择已有地址，验证是否已选择
            this.$message.warning('请选择收货地址')
            return
          }

          let phone, address
          if (this.showAddressForm) {
            // 使用表单数据
            phone = this.addressForm.phone
            address = this.addressForm.address
          } else {
            // 使用选中的地址
            const selectedAddress = this.addresses.find(addr => addr.id === this.selectedAddressId)
            phone = selectedAddress.phone
            address = selectedAddress.address
          }

          // 更新订单收货信息
          const orderRes = await Request.put(`/order/${this.currentEditOrder.id}/address`, null, {
            params: {
              address,
              phone
            }
          })

          if (orderRes.code === '0') {
            // 如果是新增地址且勾选了保存
            if (this.showAddressForm && this.saveToAddressBook) {
              const userId = this.userInfo.id
              await Request.post('/address', {
                userId,
                phone,
                address
              })
            }

            this.$message.success('收货信息更新成功')
            this.addressDialogVisible = false
            this.getOrders() // 刷新订单列表
          }
        } catch (error) {
          if (error !== 'cancel') {
            console.error('更新收货信息失败:', error)
            this.$message.error('更新收货信息失败')
          }
        }
      },

      // 显示退款对话框
      showRefundDialog(order) {
        this.currentRefundOrder = order
        this.refundForm = {
          reason: ''
        }
        this.refundDialogVisible = true
      },

      // 显示平台介入对话框
      showPlatformInterventionDialog(order) {
        this.currentInterventionOrder = order
        this.platformInterventionForm = {
          reason: ''
        }
        this.platformInterventionDialogVisible = true
      },

      // 提交平台介入申请
      async submitPlatformIntervention() {
        try {
          await this.$refs.platformInterventionForm.validate()

          const res = await Request.post(`/order/${this.currentInterventionOrder.id}/platform-intervention`, null, {
            params: {
              reason: this.platformInterventionForm.reason
            }
          })

          if (res.code === '0') {
            this.$message.success('平台介入申请已提交，请耐心等待平台处理')
            this.platformInterventionDialogVisible = false
            this.getOrders()
          } else {
            this.$message.error(res.msg || '申请失败')
          }
        } catch (error) {
          if (error !== 'cancel') {
            console.error('申请平台介入失败:', error)
            this.$message.error('申请失败，请稍后重试')
          }
        }
      },

      // 提交退款申请
      submitRefund() {
        this.$refs.refundForm.validate(async (valid) => {
          if (valid) {
            try {
              const res = await Request.put(`/order/${this.currentRefundOrder.id}`, {
                id: this.currentRefundOrder.id,
                status: 5,                    // 设置订单状态为退款中
                last_status: this.currentRefundOrder.status,  // 保存当前状态
                refund_status: 1,             // 设置退款状态为申请退款
                refund_reason: this.refundForm.reason,  // 退款原因
                refund_time: new Date().toISOString()   // 申请时间
              })

              if (res.code === '0') {
                this.$message.success('退款申请已提交，请等待商家处理')
                this.refundDialogVisible = false
                this.getOrders()
              } else {
                this.$message.error(res.msg || '退款申请失败')
              }
            } catch (error) {
              console.error('退款申请失败:', error)
              this.$message.error('退款申请失败')
            }
          }
        })
      },

    // 提交评价
    async submitReview() {
        try {
          await this.$refs.reviewForm.validate()
          this.isLogin()
          const reviewData = {
            userId: this.userInfo.id,
            productId: this.currentOrder.product.id,
            rating: this.reviewForm.rating,
            content: this.reviewForm.content
          }

          const res = await Request.post('/review', reviewData)
          if (res.code === '0') {
            this.$message.success('评价成功')
            this.reviewDialogVisible = false
            // 更新订单状态为已评价
            await Request.put(`/order/${this.currentOrder.id}/status?status=3`)
            this.getOrders()
          }
        } catch (error) {
          if (error !== 'cancel') {
            console.error('评价失败:', error)
            this.$message.error('评价失败')
          }
        }
      },
    async handleQuantityChange(order) {
      try {
        // 创建更新订单对象
        const updateOrder = {
          id: order.id,
          quantity: order.quantity,
          totalPrice: order.quantity * (order.product.isDiscount ? order.product.discountPrice : order.price)
        };

        const res = await Request.put(`/order/${order.id}`, updateOrder);
        
        if (res.code === '0') {
          // 更新本地订单总价
          order.totalPrice = updateOrder.totalPrice;
          this.$message.success('数量修改成功');
        } else {
          this.$message.error(res.msg || '修改失败');
          // 修改失败时重新获取订单列表
          this.getOrders();
        }
      } catch (error) {
        console.error('修改数量失败:', error);
        this.$message.error('修改数量失败');
        // 修改失败时重新获取订单列表
        this.getOrders();
      }
    },
    handleDelete(order) {
      this.currentDeleteOrder = order;
      this.deleteDialogVisible = true;
    },
    goToComplaint(order) {
      this.$router.push('/complaint')
    },
    async confirmDelete() {
      try {
        const res = await Request.delete(`/order/${this.currentDeleteOrder.id}`);
        if (res.code === '0') {
          this.$message.success('订单删除成功');
          this.deleteDialogVisible = false;
          this.getOrders(); // 刷新订单列表
        } else {
          this.$message.error(res.msg || '删除失败');
        }
      } catch (error) {
        console.error('删除订单失败:', error);
        this.$message.error('删除订单失败');
      }
    }
  },
  computed: {
    orderStatusText() {
      const statusMap = {
        0: '待支付',
        1: '已支付',
        2: '已发货',
        3: '已完成',
        4: '已取消',
        5: '退款中',
        6: '已退款',
        7: '退款失败'
      }
      return (status) => statusMap[status] || '未知状态'
    },

    orderStatusType() {
      const typeMap = {
        0: 'warning',
        1: 'primary',
        2: 'success',
        3: 'success',
        4: 'info',
        5: 'warning',
        6: 'info',
        7: 'danger'
      }
      return (status) => typeMap[status] || 'info'
    }
  }
}
</script>

<style scoped>
.order-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f8f9fa;
}

.main-content {
  flex: 1;
  padding: 40px;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}

/* 页面标题样式 */
.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 30px;
  background: white;
  padding: 24px 30px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.page-header h2 {
  font-size: 28px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
  position: relative;
  display: inline-block;
}

.page-header h2::after {
  content: "";
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 100%;
  height: 4px;
  background: #0f2ea8;
  border-radius: 2px;
  opacity: 0.8;
}

.order-count {
  color: #606266;
  font-size: 15px;
  font-weight: 500;
  background: #f0f2f5;
  padding: 8px 16px;
  border-radius: 20px;
}

/* 订单列表样式 */
.order-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.order-item {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16px;
  border-bottom: 1px solid #ebeef5;
  margin-bottom: 16px;
}

.order-id {
  color: #606266;
  font-size: 14px;
}

.order-time {
  color: #909399;
  font-size: 14px;
}

.status-wrapper {
  display: flex;
  align-items: center;
  gap: 16px;
}

.order-status {
  font-size: 14px;
  font-weight: 500;
  padding: 4px 12px;
  border-radius: 12px;
}

.order-status.pending {
  color: #e6a23c;
  background: rgba(230, 162, 60, 0.1);
}

.order-status.paid {
  color: #409eff;
  background: rgba(64, 158, 255, 0.1);
}

.order-status.shipped {
  color: #0f2ea8;
  background: rgba(103, 194, 58, 0.1);
}

.order-status.completed {
  color: #0f2ea8;
  background: rgba(103, 194, 58, 0.1);
}

.order-status.cancelled {
  color: #909399;
  background: rgba(144, 147, 153, 0.1);
}

.order-status.refunding {
  color: #e6a23c;
  background: rgba(230, 162, 60, 0.1);
}

.order-status.refunded {
  color: #909399;
  background: rgba(144, 147, 153, 0.1);
}

.order-status.refund-failed {
  color: #f56c6c;
  background: rgba(245, 108, 108, 0.1);
}

.order-products {
  padding: 20px 0;
  margin-top: 16px;
}

.product-info {
  display: grid;
  grid-template-columns: 80px 1fr 300px;
  gap: 20px;
  align-items: center;
}

.product-image {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
}

.product-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.product-name {
  margin: 0;
  font-size: 16px;
  color: #303133;
}

.product-price {
  display: flex;
  align-items: center;
  gap: 8px;
}

.price {
  color: #ff4757;
  font-size: 16px;
  font-weight: 600;
}

.price.discount {
  color: #ff4757;
  font-weight: 700;
}

.original-price {
  color: #909399;
  font-size: 13px;
  text-decoration: line-through;
  margin: 0 8px;
}

.quantity {
  color: #909399;
  font-size: 14px;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 16px;
  border-top: 1px solid #ebeef5;
}

.order-total {
  color: #606266;
  font-size: 14px;
}

.total-price {
  color: #ff4757;
  font-size: 18px;
  font-weight: 600;
}

.order-actions {
  display: flex;
  gap: 8px;
}

/* 分页样式 */
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin: 40px 0;
  padding: 20px 0;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled).active) {
  background-color: #0f2ea8;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled):hover) {
  color: #0f2ea8;
}

/* 加载状态样式 */
:deep(.el-loading-mask) {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(4px);
}

.payment-options {
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

/* 修改收货信息样式 */
.delivery-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 12px 16px;
  background: #f8f9fa;
  border-radius: 8px;
  justify-self: end;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #606266;
  font-size: 14px;
}

.info-item i {
  color: #0f2ea8;
  font-size: 16px;
}

.info-item span {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #606266;
}

/* 添加空值样式 */
.info-item span:empty::before,
.info-item span:only-child {
  content: "暂无信息";
  color: #909399;
  font-style: italic;
}

/* 修改收货信息按钮样式 */
.order-actions .el-button--warning {
  background: linear-gradient(135deg, #f0ad4e, #ff9800);
  border: none;
  color: white;
}

.order-actions .el-button--warning:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(240, 173, 78, 0.3);
}

/* 对话框样式优化 */
:deep(.el-dialog) {
  border-radius: 8px;
}

:deep(.el-dialog__header) {
  padding: 20px;
  border-bottom: 1px solid #f0f2f5;
}

:deep(.el-dialog__body) {
  padding: 24px 20px;
}

:deep(.el-dialog__footer) {
  padding: 16px 20px;
  border-top: 1px solid #f0f2f5;
}

.address-select-section {
  margin-bottom: 24px;
}

.section-title {
  font-size: 14px;
  color: #606266;
  margin-bottom: 12px;
}

.address-select {
  width: 100%;
}

.address-divider {
  display: flex;
  align-items: center;
  margin: 24px 0;
  color: #909399;
}

.address-divider::before,
.address-divider::after {
  content: "";
  flex: 1;
  height: 1px;
  background: #dcdfe6;
  margin: 0 16px;
}

.address-option {
  padding: 8px 0;
}

.phone {
  font-weight: 500;
  color: #606266;
  margin-bottom: 4px;
}

.address-detail {
  color: #909399;
  font-size: 13px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.form-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.address-radio-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
  width: 100%;
}

.address-radio-item {
  width: 100%;
  margin: 0;
  padding: 12px;
  border: 1px solid #dcdfe6;
  border-radius: 8px;
  transition: all 0.3s;
  display: flex !important;
  align-items: flex-start;
}

.address-radio-item:hover {
  border-color: #0f2ea8;
}

:deep(.el-radio__input) {
  margin-top: 2px;
}

.address-content {
  margin-left: 8px;
  flex: 1;
}

.address-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.phone {
  font-weight: 500;
  color: #606266;
}

.address-detail {
  color: #909399;
  font-size: 13px;
  line-height: 1.4;
}

:deep(.el-radio__label) {
  padding-left: 0;
}

:deep(.el-radio__input.is-checked + .el-radio__label) {
  color: #606266;
}

:deep(.el-radio__input.is-checked .el-radio__inner) {
  background-color: #0f2ea8;
  border-color: #0f2ea8;
}

.refund-info {
  padding: 20px;
  background: #f8f9fa;
  border-radius: 8px;
  margin-bottom: 20px;
}

.refund-info p {
  margin: 8px 0;
  color: #606266;
}

.refund-operation {
  padding: 0 20px;
}

/* 评价对话框样式 */
.review-product-info {
  display: flex;
  gap: 16px;
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
  margin-bottom: 24px;
}

.review-product-image {
  width: 80px;
  height: 80px;
  border-radius: 4px;
}

.review-product-detail {
  flex: 1;
}

.review-product-name {
  font-size: 16px;
  color: #303133;
  margin-bottom: 8px;
}

.review-product-price {
  display: flex;
  align-items: center;
  gap: 8px;
}

.review-product-price .price {
  color: #ff4757;
  font-weight: 600;
}

.review-product-price .quantity {
  color: #909399;
}

.review-form {
  padding: 20px 0;
}

:deep(.el-rate) {
  margin-top: 8px;
}

:deep(.el-rate__text) {
  margin-left: 10px;
  font-size: 14px;
}

:deep(.el-textarea__inner) {
  font-family: inherit;
}

:deep(.el-dialog__body) {
  padding: 20px;
}

/* 添加空订单样式 */
.empty-order {
  padding: 60px 0;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.empty-text {
  margin: 16px 0;
}

.empty-text .main-text {
  font-size: 16px;
  color: #606266;
  margin-bottom: 8px;
}

.empty-text .sub-text {
  font-size: 14px;
  color: #909399;
}

:deep(.el-empty__image) {
  opacity: 0.8;
}

:deep(.el-button) {
  padding: 12px 24px;
  font-size: 14px;
}

:deep(.el-button i) {
  margin-right: 6px;
  font-size: 16px;
}

:deep(.el-button:hover) {
  transform: translateY(-1px);
  box-shadow: 0 2px 12px rgba(103, 194, 58, 0.2);
}

.quantity-controls {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-top: 8px;
}

.inventory {
  color: #909399;
  font-size: 13px;
  background: #f5f7fa;
  padding: 4px 8px;
  border-radius: 4px;
}

.quantity-adjust {
  display: flex;
  align-items: center;
}

:deep(.el-input-number) {
  width: 120px;
}

:deep(.el-input-number .el-input__inner) {
  text-align: center;
}

:deep(.el-input-number__decrease),
:deep(.el-input-number__increase) {
  background-color: #f5f7fa;
  border-color: #dcdfe6;
}

:deep(.el-input-number__decrease:hover:not(.is-disabled) ~ .el-input .el-input__inner:not(.is-disabled),
.el-input-number__increase:hover:not(.is-disabled) ~ .el-input .el-input__inner:not(.is-disabled)) {
  border-color: #0f2ea8;
}

.delete-icon {
  color: #909399;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.3s;
}

.delete-icon:hover {
  color: #f56c6c;
}

/* 平台介入状态样式 */
.intervention-status-bar {
  margin-top: 12px;
  padding: 12px 16px;
  background: #fdf6ec;
  border-radius: 8px;
  border-left: 3px solid #e6a23c;
}

.intervention-info {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #e6a23c;
  font-size: 14px;
}

.intervention-info.resolved {
  color: #67c23a;
}

.intervention-info.resolved .intervention-result.rejected {
  color: #f56c6c;
}

.intervention-remark {
  margin-top: 8px;
  font-size: 13px;
  color: #606266;
  line-height: 1.5;
}

.intervention-remark .remark-label {
  font-weight: 600;
  color: #909399;
}
</style> 