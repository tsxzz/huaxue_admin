<template>
  <el-row :gutter="20">
    <el-col :span="6">
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-icon" style="background-color: #409eff;">
            <el-icon><Document /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">完成课程数</div>
            <div class="stat-value">{{ performance.totalCompletedCourses || 0 }}</div>
          </div>
        </div>
      </el-card>
    </el-col>
    <el-col :span="6">
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-icon" style="background-color: #67c23a;">
            <el-icon><Money /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">总收入</div>
            <div class="stat-value">¥{{ formatMoney(performance.totalRevenue) }}</div>
          </div>
        </div>
      </el-card>
    </el-col>
    <el-col :span="6">
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-icon" style="background-color: #e6a23c;">
            <el-icon><Wallet /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">已支付收入</div>
            <div class="stat-value">¥{{ formatMoney(performance.paidRevenue) }}</div>
          </div>
        </div>
      </el-card>
    </el-col>
    <el-col :span="6">
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-icon" style="background-color: #f56c6c;">
            <el-icon><CreditCard /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">待支付收入</div>
            <div class="stat-value">¥{{ formatMoney(performance.unpaidRevenue) }}</div>
          </div>
        </div>
      </el-card>
    </el-col>
  </el-row>
</template>

<script setup>
import { Document, Money, Wallet, CreditCard } from '@element-plus/icons-vue'

const props = defineProps({
  performance: {
    type: Object,
    default: () => ({
      totalCompletedCourses: 0,
      totalRevenue: 0,
      paidRevenue: 0,
      unpaidRevenue: 0
    })
  }
})

const formatMoney = (amount) => {
  if (!amount) return '0.00'
  return parseFloat(amount).toFixed(2)
}
</script>

<style scoped>
.stat-card {
  margin-bottom: 20px;
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 15px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 28px;
}

.stat-info {
  flex: 1;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
}
</style>
