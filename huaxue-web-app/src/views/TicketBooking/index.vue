<template>
  <div class="ticket-booking-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><Ticket /></el-icon>
          <h1>门票预订</h1>
        </div>
        <p class="header-desc">选择您需要的门票类型，填写预订信息完成预订</p>
        <div class="header-actions">
          <el-button type="primary" icon="Document" @click="goToMyOrders">查看我的订单</el-button>
        </div>
      </div>
    </div>

    <!-- 票种选择区域 -->
    <el-card class="ticket-type-card" shadow="never">
      <template #header>
        <div class="card-header">
          <span class="card-title">选择票种</span>
        </div>
      </template>
      <div v-loading="ticketTypeLoading" class="ticket-type-list">
        <el-row :gutter="20">
          <el-col
            v-for="ticketType in ticketTypeList"
            :key="ticketType.id"
            :xs="24"
            :sm="12"
            :md="8"
            :lg="6"
            class="ticket-type-item"
          >
            <el-card
              :class="{ active: selectedTicketType?.id === ticketType.id }"
              class="ticket-card"
              shadow="hover"
              @click="selectTicketType(ticketType)"
            >
              <div class="ticket-image">
                <el-image
                  v-if="ticketType.imageUrl"
                  :src="getImageUrl(ticketType.imageUrl)"
                  fit="cover"
                  style="width: 100%; height: 150px"
                >
                  <template #error>
                    <div class="image-slot">
                      <el-icon><Picture /></el-icon>
                    </div>
                  </template>
                </el-image>
                <div v-else class="image-placeholder">
                  <el-icon><Ticket /></el-icon>
                </div>
              </div>
              <div class="ticket-info">
                <h3 class="ticket-name">{{ ticketType.ticketName }}</h3>
                <div class="ticket-type-tag">
                  <el-tag v-if="ticketType.ticketType === '1'" type="success">全天票</el-tag>
                  <el-tag v-else-if="ticketType.ticketType === '2'" type="info">半天票</el-tag>
                  <el-tag v-else-if="ticketType.ticketType === '3'" type="warning">夜场票</el-tag>
                  <el-tag v-else-if="ticketType.ticketType === '4'" type="primary">季票</el-tag>
                  <el-tag v-else-if="ticketType.ticketType === '5'">年票</el-tag>
                </div>
                <div class="ticket-price">
                  <span class="price-label">价格：</span>
                  <span class="price-value">¥{{ ticketType.price }}</span>
                </div>
                <div class="ticket-validity" v-if="ticketType.validDays">
                  有效期：{{ ticketType.validDays }}天
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
        <el-empty v-if="!ticketTypeLoading && ticketTypeList.length === 0" description="暂无可用票种" />
      </div>
    </el-card>

    <!-- 预订信息表单 -->
    <el-card v-if="selectedTicketType" class="booking-form-card" shadow="never">
      <template #header>
        <div class="card-header">
          <span class="card-title">填写预订信息</span>
        </div>
      </template>
      <el-form ref="bookingFormRef" :model="bookingForm" :rules="bookingRules" label-width="120px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="票种名称">
              <el-input v-model="selectedTicketType.ticketName" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="单价">
              <el-input :value="'¥' + selectedTicketType.price" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="购票数量" prop="ticketCount">
              <el-input-number
                v-model="bookingForm.ticketCount"
                :min="1"
                :max="10"
                style="width: 100%"
                @change="calculateTotal"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="预订日期" prop="bookingDate">
              <el-date-picker
                v-model="bookingForm.bookingDate"
                type="date"
                placeholder="选择预订日期"
                style="width: 100%"
                :disabled-date="disabledDate"
                value-format="YYYY-MM-DD"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="游客姓名" prop="visitorName">
              <el-input v-model="bookingForm.visitorName" placeholder="请输入游客姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="手机号" prop="visitorPhone">
              <el-input v-model="bookingForm.visitorPhone" placeholder="请输入手机号" maxlength="11" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="身份证号" prop="visitorIdCard">
          <el-input v-model="bookingForm.visitorIdCard" placeholder="请输入身份证号（选填）" maxlength="18" />
        </el-form-item>
        <el-form-item label="总金额">
          <div class="total-amount">
            <span class="amount-label">合计：</span>
            <span class="amount-value">¥{{ totalAmount.toFixed(2) }}</span>
          </div>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="large" :loading="submitting" @click="submitBooking">
            提交预订
          </el-button>
          <el-button size="large" @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 订单确认对话框 -->
    <el-dialog v-model="orderDialogVisible" title="订单确认" width="600px" append-to-body>
      <div v-if="currentOrder" class="order-detail">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="订单号">{{ currentOrder.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="票种名称">{{ currentOrder.ticketTypeName }}</el-descriptions-item>
          <el-descriptions-item label="游客姓名">{{ currentOrder.visitorName }}</el-descriptions-item>
          <el-descriptions-item label="手机号">{{ currentOrder.visitorPhone }}</el-descriptions-item>
          <el-descriptions-item label="购票数量">{{ currentOrder.ticketCount }}张</el-descriptions-item>
          <el-descriptions-item label="总金额">
            <span style="color: #f56c6c; font-weight: bold">¥{{ currentOrder.totalAmount }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="预订日期" :span="2">
            {{ currentOrder.bookingDate }}
          </el-descriptions-item>
          <el-descriptions-item label="订单状态" :span="2">
            <el-tag type="warning">待支付</el-tag>
          </el-descriptions-item>
        </el-descriptions>
        <div class="payment-methods" style="margin-top: 20px">
          <div style="margin-bottom: 10px; font-weight: bold">选择支付方式：</div>
          <el-radio-group v-model="paymentMethod">
            <el-radio label="2">
              <el-icon><ChatLineRound /></el-icon>
              微信支付
            </el-radio>
            <el-radio label="3">
              <el-icon><CreditCard /></el-icon>
              支付宝
            </el-radio>
            <el-radio label="4">
              <el-icon><Money /></el-icon>
              银行卡
            </el-radio>
          </el-radio-group>
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="orderDialogVisible = false">取消</el-button>
          <el-button @click="handleViewOrderDetail">查看详情</el-button>
          <el-button type="primary" :loading="paying" @click="handlePay">立即支付</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 订单详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="订单详情" width="700px" append-to-body>
      <div v-if="orderDetail" class="order-detail-dialog">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="订单号">{{ orderDetail.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="订单状态">
            <el-tag v-if="orderDetail.orderStatus === '0'" type="warning">待支付</el-tag>
            <el-tag v-else-if="orderDetail.orderStatus === '1'" type="success">已支付</el-tag>
            <el-tag v-else-if="orderDetail.orderStatus === '2'" type="info">已使用</el-tag>
            <el-tag v-else-if="orderDetail.orderStatus === '3'" type="danger">已退票</el-tag>
            <el-tag v-else-if="orderDetail.orderStatus === '4'">已取消</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="票种名称">{{ orderDetail.ticketTypeName }}</el-descriptions-item>
          <el-descriptions-item label="购票数量">{{ orderDetail.ticketCount }}张</el-descriptions-item>
          <el-descriptions-item label="单价">¥{{ orderDetail.unitPrice }}</el-descriptions-item>
          <el-descriptions-item label="总金额">
            <span style="color: #f56c6c; font-weight: bold">¥{{ orderDetail.totalAmount }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="游客姓名">{{ orderDetail.visitorName }}</el-descriptions-item>
          <el-descriptions-item label="手机号">{{ orderDetail.visitorPhone }}</el-descriptions-item>
          <el-descriptions-item label="身份证号">{{ orderDetail.visitorIdCard || '-' }}</el-descriptions-item>
          <el-descriptions-item label="预订日期">{{ orderDetail.bookingDate }}</el-descriptions-item>
          <el-descriptions-item label="使用日期">{{ orderDetail.useDate || '-' }}</el-descriptions-item>
          <el-descriptions-item label="支付方式" :span="2">
            <span v-if="orderDetail.paymentMethod === '1'">现金</span>
            <span v-else-if="orderDetail.paymentMethod === '2'">微信</span>
            <span v-else-if="orderDetail.paymentMethod === '3'">支付宝</span>
            <span v-else-if="orderDetail.paymentMethod === '4'">银行卡</span>
            <span v-else>-</span>
          </el-descriptions-item>
          <el-descriptions-item label="支付时间">{{ orderDetail.paymentTime || '-' }}</el-descriptions-item>
          <el-descriptions-item label="创建时间">{{ orderDetail.createTime }}</el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailDialogVisible = false">关闭</el-button>
          <el-button type="primary" @click="goToMyOrders">查看我的订单</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Ticket,
  Picture,
  ChatLineRound,
  CreditCard,
  Money,
  Document
} from '@element-plus/icons-vue'
import { publicListTicketType } from '@/api/ticketType'
import { addTicketOrder, payTicketOrder, cancelTicketOrder, getTicketOrder } from '@/api/ticketOrder'

// 票种列表
const ticketTypeLoading = ref(false)
const ticketTypeList = ref([])
const selectedTicketType = ref(null)

// 预订表单
const bookingFormRef = ref(null)
const bookingForm = reactive({
  ticketTypeId: null,
  ticketCount: 1,
  bookingDate: '',
  visitorName: '',
  visitorPhone: '',
  visitorIdCard: ''
})

// 表单验证规则
const bookingRules = {
  ticketCount: [{ required: true, message: '请选择购票数量', trigger: 'blur' }],
  bookingDate: [{ required: true, message: '请选择预订日期', trigger: 'change' }],
  visitorName: [{ required: true, message: '请输入游客姓名', trigger: 'blur' }],
  visitorPhone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  visitorIdCard: [
    { pattern: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/, message: '请输入正确的身份证号', trigger: 'blur' }
  ]
}

// 计算总金额
const totalAmount = computed(() => {
  if (!selectedTicketType.value || !bookingForm.ticketCount) {
    return 0
  }
  return selectedTicketType.value.price * bookingForm.ticketCount
})

// 计算总金额方法
const calculateTotal = () => {
  // 计算逻辑已在computed中实现
}

// 禁用过去的日期
const disabledDate = (time) => {
  return time.getTime() < Date.now() - 8.64e7
}

// 路由
const router = useRouter()

// 提交状态
const submitting = ref(false)
const paying = ref(false)

// 订单对话框
const orderDialogVisible = ref(false)
const currentOrder = ref(null)
const paymentMethod = ref('2') // 默认微信支付

// 订单详情对话框
const detailDialogVisible = ref(false)
const orderDetail = ref(null)

// 查询票种列表（公开接口）
const getTicketTypeList = async () => {
  ticketTypeLoading.value = true
  try {
    const params = {
      status: '0', // 只查询正常状态的票种
      params: {
        pageNum: 1,
        pageSize: 100
      }
    }
    const response = await publicListTicketType(params)
    if (response.code === 200) {
      ticketTypeList.value = response.rows || []
    }
  } catch (error) {
    console.error('查询票种列表失败:', error)
    ElMessage.error('查询票种列表失败')
  } finally {
    ticketTypeLoading.value = false
  }
}

// 选择票种
const selectTicketType = (ticketType) => {
  selectedTicketType.value = ticketType
  bookingForm.ticketTypeId = ticketType.id
  resetForm()
}

// 提交预订
const submitBooking = () => {
  bookingFormRef.value.validate((valid) => {
    if (valid) {
      if (!selectedTicketType.value) {
        ElMessage.warning('请先选择票种')
        return
      }

      submitting.value = true
      const orderData = {
        ticketTypeId: selectedTicketType.value.id,
        ticketTypeName: selectedTicketType.value.ticketName,
        ticketCount: bookingForm.ticketCount,
        unitPrice: selectedTicketType.value.price,
        totalAmount: totalAmount.value,
        bookingDate: bookingForm.bookingDate,
        visitorName: bookingForm.visitorName,
        visitorPhone: bookingForm.visitorPhone,
        visitorIdCard: bookingForm.visitorIdCard || '',
        orderStatus: '0' // 待支付
      }

      addTicketOrder(orderData)
        .then((response) => {
          if (response.code === 200) {
            currentOrder.value = response.data || orderData
            orderDialogVisible.value = true
            ElMessage.success('预订成功，请完成支付')
          } else {
            ElMessage.error(response.msg || '预订失败')
          }
        })
        .catch((error) => {
          console.error('预订失败:', error)
          ElMessage.error(error.msg || '预订失败')
        })
        .finally(() => {
          submitting.value = false
        })
    }
  })
}

// 支付订单
const handlePay = () => {
  if (!currentOrder.value || !currentOrder.value.id) {
    ElMessage.error('订单信息不完整')
    return
  }

  paying.value = true
  payTicketOrder(currentOrder.value.id, paymentMethod.value)
    .then((response) => {
      if (response.code === 200) {
        ElMessage.success('支付成功')
        orderDialogVisible.value = false
        // 重置表单
        resetForm()
        selectedTicketType.value = null
        // 可以跳转到订单详情页面
        ElMessageBox.confirm('支付成功！是否查看订单详情？', '提示', {
          confirmButtonText: '查看',
          cancelButtonText: '返回',
          type: 'success'
        })
          .then(() => {
            // 跳转到我的订单页面
            router.push({ path: '/my-orders' })
          })
          .catch(() => {})
      } else {
        ElMessage.error(response.msg || '支付失败')
      }
    })
    .catch((error) => {
      console.error('支付失败:', error)
      ElMessage.error(error.msg || '支付失败')
    })
    .finally(() => {
      paying.value = false
    })
}

// 重置表单
const resetForm = () => {
  bookingForm.ticketCount = 1
  bookingForm.bookingDate = ''
  bookingForm.visitorName = ''
  bookingForm.visitorPhone = ''
  bookingForm.visitorIdCard = ''
  bookingFormRef.value?.resetFields()
}

// 查看订单详情
const handleViewOrderDetail = async () => {
  if (!currentOrder.value || !currentOrder.value.id) {
    ElMessage.warning('订单信息不完整')
    return
  }
  
  try {
    const response = await getTicketOrder(currentOrder.value.id)
    if (response.code === 200) {
      orderDetail.value = response.data
      detailDialogVisible.value = true
      orderDialogVisible.value = false
    } else {
      ElMessage.error(response.msg || '获取订单详情失败')
    }
  } catch (error) {
    console.error('获取订单详情失败:', error)
    ElMessage.error('获取订单详情失败')
  }
}

// 跳转到我的订单页面
const goToMyOrders = () => {
  router.push({ path: '/my-orders' })
}

// 获取图片URL（处理相对路径和绝对路径）
const getImageUrl = (url) => {
  if (!url) return ''
  const baseUrl = import.meta.env.VITE_APP_BASE_API || ''
  
  // 如果已经是完整URL，直接返回
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url
  }
  
  // 如果已经包含baseUrl，直接返回
  if (url.startsWith(baseUrl)) {
    return url
  }
  
  // 如果是/profile/开头的路径，拼接baseUrl
  if (url.startsWith('/profile/')) {
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    return cleanBaseUrl + url
  }
  
  // 如果是/upload/开头的路径，拼接baseUrl和/profile
  if (url.startsWith('/upload/')) {
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    return cleanBaseUrl + '/profile' + url
  }
  
  // 其他情况，拼接baseUrl和/profile/upload/
  const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
  const cleanUrl = url.startsWith('/') ? url : '/' + url
  return cleanBaseUrl + '/profile/upload/' + cleanUrl.replace(/^\/+/, '')
}

onMounted(() => {
  getTicketTypeList()
})
</script>

<style scoped lang="scss">
.ticket-booking-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);
}

.page-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 8px;
  padding: 30px;
  margin-bottom: 20px;
  color: white;

  .header-content {
    .header-title {
      display: flex;
      align-items: center;
      margin-bottom: 10px;

      .title-icon {
        font-size: 32px;
        margin-right: 12px;
      }

      h1 {
        font-size: 28px;
        font-weight: bold;
        margin: 0;
      }
    }

    .header-desc {
      font-size: 14px;
      opacity: 0.9;
      margin: 0;
    }

    .header-actions {
      margin-top: 15px;
    }
  }
}

.ticket-type-card,
.booking-form-card {
  margin-bottom: 20px;
  background: white;
  border-radius: 8px;

  .card-header {
    .card-title {
      font-size: 18px;
      font-weight: bold;
      color: #303133;
    }
  }
}

.ticket-type-list {
  .ticket-type-item {
    margin-bottom: 20px;
  }

  .ticket-card {
    cursor: pointer;
    transition: all 0.3s;
    border: 2px solid transparent;

    &:hover {
      transform: translateY(-5px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    &.active {
      border-color: #409eff;
      box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
    }

    .ticket-image {
      width: 100%;
      height: 150px;
      overflow: hidden;
      border-radius: 4px;
      margin-bottom: 10px;
      background: #f5f7fa;
      display: flex;
      align-items: center;
      justify-content: center;

      .image-placeholder {
        font-size: 48px;
        color: #c0c4cc;
      }

      .image-slot {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 100%;
        background: #f5f7fa;
        color: #909399;
        font-size: 30px;
      }
    }

    .ticket-info {
      .ticket-name {
        font-size: 16px;
        font-weight: bold;
        margin: 0 0 8px 0;
        color: #303133;
      }

      .ticket-type-tag {
        margin-bottom: 8px;
      }

      .ticket-price {
        margin-bottom: 4px;

        .price-label {
          font-size: 14px;
          color: #909399;
        }

        .price-value {
          font-size: 20px;
          font-weight: bold;
          color: #f56c6c;
        }
      }

      .ticket-validity {
        font-size: 12px;
        color: #909399;
      }
    }
  }
}

.total-amount {
  .amount-label {
    font-size: 16px;
    color: #606266;
  }

  .amount-value {
    font-size: 24px;
    font-weight: bold;
    color: #f56c6c;
    margin-left: 10px;
  }
}

.order-detail {
  .payment-methods {
    padding: 15px;
    background: #f5f7fa;
    border-radius: 4px;

    :deep(.el-radio) {
      margin-right: 20px;
      margin-bottom: 10px;
    }
  }
}

.order-detail-dialog {
  padding: 10px 0;
}
</style>
