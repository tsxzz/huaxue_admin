<template>
  <el-card class="list-card">
    <template #header>
      <div class="card-header">
        <span>最近完成的课程</span>
      </div>
    </template>
    <el-table :data="courseList" border v-loading="loading">
      <el-table-column label="课程名称" prop="courseName" width="150" />
      <el-table-column label="课程类型" prop="courseType" width="120" />
      <el-table-column label="学员姓名" prop="studentName" width="120" />
      <el-table-column label="预约日期" prop="appointmentDate" width="120" align="center" />
      <el-table-column label="课程价格" prop="price" width="120" align="center">
        <template #default="scope">
          ¥{{ formatMoney(scope.row.price) }}
        </template>
      </el-table-column>
      <el-table-column label="支付状态" prop="paymentStatus" width="100" align="center">
        <template #default="scope">
          <el-tag :type="getPaymentStatusType(scope.row.paymentStatus)">
            {{ getPaymentStatusText(scope.row.paymentStatus) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="预约状态" prop="status" width="100" align="center">
        <template #default="scope">
          <el-tag :type="getStatusType(scope.row.status)">
            {{ getStatusText(scope.row.status) }}
          </el-tag>
        </template>
      </el-table-column>
    </el-table>
  </el-card>
</template>

<script setup>
import { defineProps } from 'vue'

const props = defineProps({
  courseList: {
    type: Array,
    default: () => []
  },
  loading: {
    type: Boolean,
    default: false
  }
})

const formatMoney = (amount) => {
  if (!amount) return '0.00'
  return parseFloat(amount).toFixed(2)
}

const getPaymentStatusType = (status) => {
  const map = {
    '0': 'warning',
    '1': 'success',
    '2': 'info'
  }
  return map[status] || 'info'
}

const getPaymentStatusText = (status) => {
  const map = {
    '0': '未支付',
    '1': '已支付',
    '2': '已退款'
  }
  return map[status] || '未知'
}

const getStatusType = (status) => {
  const map = {
    '0': 'warning',
    '1': 'success',
    '2': 'info',
    '3': 'danger'
  }
  return map[status] || 'info'
}

const getStatusText = (status) => {
  const map = {
    '0': '待确认',
    '1': '已确认',
    '2': '已完成',
    '3': '已取消'
  }
  return map[status] || '未知'
}
</script>

<style scoped>
.list-card {
  margin-bottom: 20px;
}

.card-header {
  font-weight: 600;
  font-size: 16px;
}
</style>
