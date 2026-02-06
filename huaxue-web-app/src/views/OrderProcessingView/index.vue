<template>
  <div class="order-processing-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><ShoppingCart /></el-icon>
          <h1>订单处理</h1>
        </div>
        <p class="header-desc">查看和处理游客订单，包括订单查询、退票等操作</p>
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
        <el-form-item label="游客姓名">
          <el-input
            v-model="queryParams.visitorName"
            placeholder="请输入游客姓名"
            clearable
            style="width: 150px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input
            v-model="queryParams.visitorPhone"
            placeholder="请输入手机号"
            clearable
            style="width: 150px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="票种名称">
          <el-input
            v-model="queryParams.ticketTypeName"
            placeholder="请输入票种名称"
            clearable
            style="width: 150px"
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
        <el-table-column label="票种名称" prop="ticketTypeName" min-width="120" />
        <el-table-column label="游客姓名" prop="visitorName" width="120" align="center" />
        <el-table-column label="手机号" prop="visitorPhone" width="120" align="center" />
        <el-table-column label="购票数量" prop="ticketCount" width="100" align="center">
          <template #default="scope">{{ scope.row.ticketCount }}张</template>
        </el-table-column>
        <el-table-column label="单价" prop="unitPrice" width="100" align="center">
          <template #default="scope">¥{{ scope.row.unitPrice }}</template>
        </el-table-column>
        <el-table-column label="总金额" prop="totalAmount" width="120" align="center">
          <template #default="scope">
            <span style="color: #f56c6c; font-weight: bold">¥{{ scope.row.totalAmount }}</span>
          </template>
        </el-table-column>
        <el-table-column label="已支付" prop="paidAmount" width="100" align="center">
          <template #default="scope">¥{{ scope.row.paidAmount || 0 }}</template>
        </el-table-column>
        <el-table-column label="预订日期" prop="bookingDate" width="120" align="center">
          <template #default="scope">
            <span>{{ parseTime(scope.row.bookingDate, '{y}-{m}-{d}') }}</span>
          </template>
        </el-table-column>
        <el-table-column label="订单状态" prop="orderStatus" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.orderStatus === '0'" type="warning">待支付</el-tag>
            <el-tag v-else-if="scope.row.orderStatus === '1'" type="success">已支付</el-tag>
            <el-tag v-else-if="scope.row.orderStatus === '2'" type="info">已使用</el-tag>
            <el-tag v-else-if="scope.row.orderStatus === '3'" type="danger">已退票</el-tag>
            <el-tag v-else-if="scope.row.orderStatus === '4'">已取消</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" align="center" />
        <el-table-column label="操作" width="250" align="center" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">查看</el-button>
            <el-button
              v-if="scope.row.orderStatus === '1'"
              link
              type="warning"
              icon="RefreshLeft"
              @click="handleRefund(scope.row)"
            >
              退票
            </el-button>
            <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <pagination
          v-show="total > 0"
          :total="total"
          :page="queryParams.pageNum"
          :limit="queryParams.pageSize"
          @pagination="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 订单查看对话框 -->
    <el-dialog title="订单详情" v-model="orderDialogVisible" width="700px" append-to-body>
      <el-descriptions :column="2" border v-if="currentOrder">
        <el-descriptions-item label="订单号">{{ currentOrder.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="票种名称">{{ currentOrder.ticketTypeName }}</el-descriptions-item>
        <el-descriptions-item label="游客姓名">{{ currentOrder.visitorName }}</el-descriptions-item>
        <el-descriptions-item label="手机号">{{ currentOrder.visitorPhone }}</el-descriptions-item>
        <el-descriptions-item label="身份证号">{{ currentOrder.visitorIdCard || '-' }}</el-descriptions-item>
        <el-descriptions-item label="购票数量">{{ currentOrder.ticketCount }}张</el-descriptions-item>
        <el-descriptions-item label="单价">¥{{ currentOrder.unitPrice }}</el-descriptions-item>
        <el-descriptions-item label="总金额">
          <span style="color: #f56c6c; font-weight: bold">¥{{ currentOrder.totalAmount }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="已支付">¥{{ currentOrder.paidAmount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="预订日期">
          {{ parseTime(currentOrder.bookingDate, '{y}-{m}-{d}') }}
        </el-descriptions-item>
        <el-descriptions-item label="使用日期">
          {{ currentOrder.useDate ? parseTime(currentOrder.useDate, '{y}-{m}-{d}') : '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="订单状态">
          <el-tag v-if="currentOrder.orderStatus === '0'" type="warning">待支付</el-tag>
          <el-tag v-else-if="currentOrder.orderStatus === '1'" type="success">已支付</el-tag>
          <el-tag v-else-if="currentOrder.orderStatus === '2'" type="info">已使用</el-tag>
          <el-tag v-else-if="currentOrder.orderStatus === '3'" type="danger">已退票</el-tag>
          <el-tag v-else-if="currentOrder.orderStatus === '4'">已取消</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="支付方式">
          <span v-if="currentOrder.paymentMethod === '1'">现金</span>
          <span v-else-if="currentOrder.paymentMethod === '2'">微信</span>
          <span v-else-if="currentOrder.paymentMethod === '3'">支付宝</span>
          <span v-else-if="currentOrder.paymentMethod === '4'">银行卡</span>
          <span v-else>-</span>
        </el-descriptions-item>
        <el-descriptions-item label="支付时间" :span="2">
          {{ currentOrder.paymentTime ? parseTime(currentOrder.paymentTime, '{y}-{m}-{d} {h}:{i}:{s}') : '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="退款金额" v-if="currentOrder.refundAmount && currentOrder.refundAmount > 0">
          <span style="color: #f56c6c">¥{{ currentOrder.refundAmount }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="退款原因" v-if="currentOrder.refundReason" :span="2">
          {{ currentOrder.refundReason }}
        </el-descriptions-item>
        <el-descriptions-item label="退款时间" v-if="currentOrder.refundTime" :span="2">
          {{ parseTime(currentOrder.refundTime, '{y}-{m}-{d} {h}:{i}:{s}') }}
        </el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="2">
          {{ parseTime(currentOrder.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="orderDialogVisible = false">关 闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 退票对话框 -->
    <el-dialog title="处理退票" v-model="refundDialogVisible" width="500px" append-to-body>
      <el-form ref="refundFormRef" :model="refundForm" :rules="refundRules" label-width="100px">
        <el-form-item label="订单号">
          <el-input v-model="refundForm.orderNo" disabled />
        </el-form-item>
        <el-form-item label="退款金额">
          <el-input v-model="refundForm.refundAmount" disabled>
            <template #prefix>¥</template>
          </el-input>
        </el-form-item>
        <el-form-item label="退款原因" prop="refundReason">
          <el-input
            v-model="refundForm.refundReason"
            type="textarea"
            :rows="4"
            placeholder="请输入退款原因"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="refundDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="submitRefund" :loading="refundSubmitting">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="OrderProcessingView">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ShoppingCart, Search, Refresh, View, RefreshLeft, Delete } from '@element-plus/icons-vue'
import { listTicketOrder, getTicketOrder, delTicketOrder, refundTicket } from '@/api/ticketOrder'
import { parseTime } from '@/utils/ruoyi'
import Pagination from '@/components/Pagination/index.vue'

// 加载状态
const loading = ref(false)
const orderList = ref([])
const total = ref(0)

// 查询参数
const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  orderNo: '',
  visitorName: '',
  visitorPhone: '',
  ticketTypeName: '',
  orderStatus: ''
})

// 查询订单列表
const getList = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: queryParams.pageNum,
      pageSize: queryParams.pageSize,
      orderNo: queryParams.orderNo,
      visitorName: queryParams.visitorName,
      visitorPhone: queryParams.visitorPhone,
      ticketTypeName: queryParams.ticketTypeName,
      orderStatus: queryParams.orderStatus
    }
    if (!params.params) {
      params.params = {}
    }
    params.params.pageNum = queryParams.pageNum
    params.params.pageSize = queryParams.pageSize

    const response = await listTicketOrder(params)
    if (response.code === 200) {
      orderList.value = response.rows || []
      total.value = response.total || 0
    }
  } catch (error) {
    console.error('查询订单列表失败:', error)
    orderList.value = []
    total.value = 0
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
  queryParams.orderNo = ''
  queryParams.visitorName = ''
  queryParams.visitorPhone = ''
  queryParams.ticketTypeName = ''
  queryParams.orderStatus = ''
  handleQuery()
}

// 分页
const handlePageChange = (p) => {
  queryParams.pageNum = p.page
  queryParams.pageSize = p.limit
  getList()
}

// 查看订单
const orderDialogVisible = ref(false)
const currentOrder = ref(null)
const handleView = async (row) => {
  try {
    const response = await getTicketOrder(row.id)
    if (response.code === 200) {
      currentOrder.value = response.data
      orderDialogVisible.value = true
    }
  } catch (error) {
    console.error('获取订单详情失败:', error)
    ElMessage.error('获取订单详情失败')
  }
}

// 退票
const refundDialogVisible = ref(false)
const refundSubmitting = ref(false)
const refundFormRef = ref(null)
const refundForm = reactive({
  id: null,
  orderNo: '',
  refundAmount: '',
  refundReason: ''
})

const refundRules = {
  refundReason: [{ required: true, message: '请输入退款原因', trigger: 'blur' }]
}

const handleRefund = (row) => {
  refundForm.id = row.id
  refundForm.orderNo = row.orderNo
  refundForm.refundAmount = row.paidAmount || row.totalAmount
  refundForm.refundReason = ''
  refundDialogVisible.value = true
}

const submitRefund = () => {
  refundFormRef.value.validate((valid) => {
    if (valid) {
      refundSubmitting.value = true
      refundTicket(refundForm.id, refundForm.refundReason)
        .then(() => {
          ElMessage.success('退票成功')
          refundDialogVisible.value = false
          getList()
        })
        .catch((error) => {
          ElMessage.error(error.msg || '退票失败')
        })
        .finally(() => {
          refundSubmitting.value = false
        })
    }
  })
}

// 删除订单
const handleDelete = (row) => {
  ElMessageBox.confirm('是否确认删除订单"' + row.orderNo + '"？', '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      return delTicketOrder(row.id)
    })
    .then(() => {
      getList()
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

onMounted(() => {
  getList()
})
</script>

<style scoped lang="scss">
.order-processing-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);

  .page-header {
    margin-bottom: 20px;
    
    .header-content {
      .header-title {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 8px;
        
        .title-icon {
          font-size: 32px;
          color: #409eff;
        }
        
        h1 {
          font-size: 28px;
          font-weight: bold;
          color: #303133;
          margin: 0;
        }
      }
      
      .header-desc {
        color: #909399;
        font-size: 14px;
        margin: 0;
      }
    }
  }

  .search-card {
    margin-bottom: 20px;
  }

  .table-card {
    .pagination-wrapper {
      display: flex;
      justify-content: center;
      margin-top: 20px;
    }
  }
}
</style>
