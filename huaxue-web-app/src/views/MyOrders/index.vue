<template>
  <div class="my-orders-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><Document /></el-icon>
          <h1>我的订单</h1>
        </div>
        <p class="header-desc">查看和管理您的所有订单</p>
      </div>
    </div>

    <!-- 搜索栏 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="queryParams" :inline="true">
        <el-form-item label="订单号">
          <el-input
            v-model="queryParams.orderNo"
            placeholder="请输入订单号"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="订单状态">
          <el-select
            v-model="queryParams.orderStatus"
            placeholder="请选择订单状态"
            clearable
            style="width: 150px"
          >
            <el-option label="待支付" value="0" />
            <el-option label="已支付" value="1" />
            <el-option label="已使用" value="2" />
            <el-option label="已退票" value="3" />
            <el-option label="已取消" value="4" />
          </el-select>
        </el-form-item>
        <el-form-item label="票种名称">
          <el-input
            v-model="queryParams.ticketTypeName"
            placeholder="请输入票种名称"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 订单列表 -->
    <el-card class="table-card" shadow="never">
      <el-table v-loading="loading" :data="orderList" border>
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="订单号" prop="orderNo" width="180" align="center" />
        <el-table-column label="票种名称" prop="ticketTypeName" min-width="150" />
        <el-table-column label="游客姓名" prop="visitorName" width="120" align="center" />
        <el-table-column label="购票数量" prop="ticketCount" width="100" align="center">
          <template #default="scope">{{ scope.row.ticketCount }}张</template>
        </el-table-column>
        <el-table-column label="总金额" prop="totalAmount" width="120" align="center">
          <template #default="scope">
            <span style="color: #f56c6c; font-weight: bold">¥{{ scope.row.totalAmount }}</span>
          </template>
        </el-table-column>
        <el-table-column label="预订日期" prop="bookingDate" width="120" align="center" />
        <el-table-column label="订单状态" prop="orderStatus" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.orderStatus === '0'" type="warning">待支付</el-tag>
            <el-tag v-else-if="scope.row.orderStatus === '1'" type="success">已支付</el-tag>
            <el-tag v-else-if="scope.row.orderStatus === '2'" type="info">已使用</el-tag>
            <el-tag v-else-if="scope.row.orderStatus === '3'" type="danger">已退票</el-tag>
            <el-tag v-else-if="scope.row.orderStatus === '4'">已取消</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="支付方式" prop="paymentMethod" width="100" align="center">
          <template #default="scope">
            <span v-if="scope.row.paymentMethod === '1'">现金</span>
            <span v-else-if="scope.row.paymentMethod === '2'">微信</span>
            <span v-else-if="scope.row.paymentMethod === '3'">支付宝</span>
            <span v-else-if="scope.row.paymentMethod === '4'">银行卡</span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" align="center" />
        <el-table-column label="操作" width="250" align="center" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleViewDetail(scope.row)">查看详情</el-button>
            <el-button
              v-if="scope.row.orderStatus === '0'"
              link
              type="success"
              icon="Money"
              @click="handlePay(scope.row)"
            >
              支付
            </el-button>
            <el-button
              v-if="scope.row.orderStatus === '0'"
              link
              type="danger"
              icon="Close"
              @click="handleCancel(scope.row)"
            >
              取消
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 订单详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="订单详情" width="700px" append-to-body>
      <div v-if="currentOrder" class="order-detail-dialog">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="订单号">{{ currentOrder.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="订单状态">
            <el-tag v-if="currentOrder.orderStatus === '0'" type="warning">待支付</el-tag>
            <el-tag v-else-if="currentOrder.orderStatus === '1'" type="success">已支付</el-tag>
            <el-tag v-else-if="currentOrder.orderStatus === '2'" type="info">已使用</el-tag>
            <el-tag v-else-if="currentOrder.orderStatus === '3'" type="danger">已退票</el-tag>
            <el-tag v-else-if="currentOrder.orderStatus === '4'">已取消</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="票种名称">{{ currentOrder.ticketTypeName }}</el-descriptions-item>
          <el-descriptions-item label="购票数量">{{ currentOrder.ticketCount }}张</el-descriptions-item>
          <el-descriptions-item label="单价">¥{{ currentOrder.unitPrice }}</el-descriptions-item>
          <el-descriptions-item label="总金额">
            <span style="color: #f56c6c; font-weight: bold">¥{{ currentOrder.totalAmount }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="游客姓名">{{ currentOrder.visitorName }}</el-descriptions-item>
          <el-descriptions-item label="手机号">{{ currentOrder.visitorPhone }}</el-descriptions-item>
          <el-descriptions-item label="身份证号">{{ currentOrder.visitorIdCard || '-' }}</el-descriptions-item>
          <el-descriptions-item label="预订日期">{{ currentOrder.bookingDate }}</el-descriptions-item>
          <el-descriptions-item label="使用日期">{{ currentOrder.useDate || '-' }}</el-descriptions-item>
          <el-descriptions-item label="支付方式" :span="2">
            <span v-if="currentOrder.paymentMethod === '1'">现金</span>
            <span v-else-if="currentOrder.paymentMethod === '2'">微信</span>
            <span v-else-if="currentOrder.paymentMethod === '3'">支付宝</span>
            <span v-else-if="currentOrder.paymentMethod === '4'">银行卡</span>
            <span v-else>-</span>
          </el-descriptions-item>
          <el-descriptions-item label="支付时间">{{ currentOrder.paymentTime || '-' }}</el-descriptions-item>
          <el-descriptions-item label="创建时间">{{ currentOrder.createTime }}</el-descriptions-item>
          <el-descriptions-item v-if="currentOrder.refundStatus !== '0'" label="退款状态" :span="2">
            <el-tag v-if="currentOrder.refundStatus === '1'" type="warning">退款中</el-tag>
            <el-tag v-else-if="currentOrder.refundStatus === '2'" type="success">已退款</el-tag>
            <el-tag v-else-if="currentOrder.refundStatus === '3'" type="danger">退款失败</el-tag>
          </el-descriptions-item>
          <el-descriptions-item v-if="currentOrder.refundAmount" label="退款金额" :span="2">
            <span style="color: #f56c6c">¥{{ currentOrder.refundAmount }}</span>
          </el-descriptions-item>
          <el-descriptions-item v-if="currentOrder.refundReason" label="退款原因" :span="2">
            {{ currentOrder.refundReason }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailDialogVisible = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 支付对话框 -->
    <el-dialog v-model="payDialogVisible" title="支付订单" width="500px" append-to-body>
      <div v-if="payOrder" class="pay-dialog">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="订单号">{{ payOrder.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="票种名称">{{ payOrder.ticketTypeName }}</el-descriptions-item>
          <el-descriptions-item label="总金额">
            <span style="color: #f56c6c; font-weight: bold; font-size: 20px">¥{{ payOrder.totalAmount }}</span>
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
          <el-button @click="payDialogVisible = false">取消</el-button>
          <el-button type="primary" :loading="paying" @click="handleConfirmPay">确认支付</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Document, View, ChatLineRound, CreditCard, Money } from '@element-plus/icons-vue'
import { listTicketOrder, getTicketOrder, payTicketOrder, cancelTicketOrder } from '@/api/ticketOrder'
import Pagination from '@/components/Pagination'

// 查询参数
const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  orderNo: null,
  orderStatus: null,
  ticketTypeName: null
})

// 订单列表
const loading = ref(false)
const orderList = ref([])
const total = ref(0)

// 订单详情对话框
const detailDialogVisible = ref(false)
const currentOrder = ref(null)

// 支付对话框
const payDialogVisible = ref(false)
const payOrder = ref(null)
const paymentMethod = ref('2')
const paying = ref(false)

// 查询订单列表
const getList = async () => {
  loading.value = true
  try {
    const params = {
      ...queryParams,
      params: {
        pageNum: queryParams.pageNum,
        pageSize: queryParams.pageSize
      }
    }
    const response = await listTicketOrder(params)
    if (response.code === 200) {
      orderList.value = response.rows || []
      total.value = response.total || 0
    } else {
      ElMessage.error(response.msg || '查询失败')
    }
  } catch (error) {
    console.error('查询订单列表失败:', error)
    ElMessage.error('查询订单列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

// 重置
const resetQuery = () => {
  queryParams.orderNo = null
  queryParams.orderStatus = null
  queryParams.ticketTypeName = null
  handleQuery()
}

// 查看详情
const handleViewDetail = async (row) => {
  try {
    const response = await getTicketOrder(row.id)
    if (response.code === 200) {
      currentOrder.value = response.data
      detailDialogVisible.value = true
    } else {
      ElMessage.error(response.msg || '获取订单详情失败')
    }
  } catch (error) {
    console.error('获取订单详情失败:', error)
    ElMessage.error('获取订单详情失败')
  }
}

// 支付订单
const handlePay = (row) => {
  payOrder.value = row
  paymentMethod.value = '2'
  payDialogVisible.value = true
}

// 确认支付
const handleConfirmPay = () => {
  if (!payOrder.value || !payOrder.value.id) {
    ElMessage.error('订单信息不完整')
    return
  }

  paying.value = true
  payTicketOrder(payOrder.value.id, paymentMethod.value)
    .then((response) => {
      if (response.code === 200) {
        ElMessage.success('支付成功')
        payDialogVisible.value = false
        getList()
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

// 取消订单
const handleCancel = (row) => {
  ElMessageBox.confirm('确定要取消该订单吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      cancelTicketOrder(row.id)
        .then((response) => {
          if (response.code === 200) {
            ElMessage.success('订单已取消')
            getList()
          } else {
            ElMessage.error(response.msg || '取消订单失败')
          }
        })
        .catch((error) => {
          console.error('取消订单失败:', error)
          ElMessage.error(error.msg || '取消订单失败')
        })
    })
    .catch(() => {})
}

// 初始化
onMounted(() => {
  getList()
})
</script>

<style scoped lang="scss">
.my-orders-container {
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
  }
}

.search-card,
.table-card {
  margin-bottom: 20px;
  background: white;
  border-radius: 8px;
}

.order-detail-dialog {
  padding: 10px 0;
}

.pay-dialog {
  padding: 10px 0;
}

.payment-methods {
  .el-radio {
    display: block;
    margin-bottom: 10px;
    height: auto;
    line-height: 32px;
  }
}
</style>
