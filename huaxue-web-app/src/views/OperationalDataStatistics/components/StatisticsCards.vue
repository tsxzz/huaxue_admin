<template>
  <div class="statistics-cards">
    <!-- 门票订单统计 -->
    <el-card class="stat-card" shadow="hover">
      <div class="stat-header">
        <el-icon class="stat-icon ticket"><Ticket /></el-icon>
        <span class="stat-title">门票订单</span>
      </div>
      <div class="stat-content">
        <div class="stat-item">
          <span class="stat-label">总订单数</span>
          <span class="stat-value">{{ ticketStats.totalOrders || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">已支付</span>
          <span class="stat-value success">{{ ticketStats.paidOrders || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">待支付</span>
          <span class="stat-value warning">{{ ticketStats.pendingOrders || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">总收入</span>
          <span class="stat-value amount">¥{{ formatAmount(ticketStats.totalRevenue) }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">已支付收入</span>
          <span class="stat-value amount">¥{{ formatAmount(ticketStats.paidRevenue) }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">总游客数</span>
          <span class="stat-value">{{ ticketStats.totalVisitors || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">平均订单金额</span>
          <span class="stat-value">¥{{ formatAmount(ticketStats.avgOrderAmount) }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">转化率</span>
          <span class="stat-value">{{ formatPercent(ticketStats.conversionRate) }}%</span>
        </div>
      </div>
    </el-card>

    <!-- 雪具租赁统计 -->
    <el-card class="stat-card" shadow="hover">
      <div class="stat-header">
        <el-icon class="stat-icon rental"><ShoppingBag /></el-icon>
        <span class="stat-title">雪具租赁</span>
      </div>
      <div class="stat-content">
        <div class="stat-item">
          <span class="stat-label">总租赁数</span>
          <span class="stat-value">{{ rentalStats.totalRentals || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">租赁中</span>
          <span class="stat-value info">{{ rentalStats.activeRentals || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">已归还</span>
          <span class="stat-value success">{{ rentalStats.returnedRentals || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">待支付</span>
          <span class="stat-value warning">{{ rentalStats.pendingRentals || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">总收入</span>
          <span class="stat-value amount">¥{{ formatAmount(rentalStats.totalRevenue) }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">已支付收入</span>
          <span class="stat-value amount">¥{{ formatAmount(rentalStats.paidRevenue) }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">总租赁人数</span>
          <span class="stat-value">{{ rentalStats.totalRenters || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">设备利用率</span>
          <span class="stat-value">{{ formatPercent(rentalStats.utilizationRate) }}%</span>
        </div>
      </div>
    </el-card>

    <!-- 用户统计 -->
    <el-card class="stat-card" shadow="hover">
      <div class="stat-header">
        <el-icon class="stat-icon user"><User /></el-icon>
        <span class="stat-title">用户统计</span>
      </div>
      <div class="stat-content">
        <div class="stat-item">
          <span class="stat-label">总用户数</span>
          <span class="stat-value">{{ userStats.totalUsers || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">活跃用户</span>
          <span class="stat-value success">{{ userStats.activeUsers || 0 }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">新增用户</span>
          <span class="stat-value info">{{ userStats.newUsers || 0 }}</span>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { Ticket, ShoppingBag, User } from '@element-plus/icons-vue'

const props = defineProps({
  ticketStats: {
    type: Object,
    default: () => ({})
  },
  rentalStats: {
    type: Object,
    default: () => ({})
  },
  userStats: {
    type: Object,
    default: () => ({})
  }
})

const formatAmount = (amount) => {
  if (!amount || amount === 0) return '0.00'
  return parseFloat(amount).toFixed(2)
}

const formatPercent = (percent) => {
  if (!percent || percent === 0) return '0.00'
  return parseFloat(percent).toFixed(2)
}
</script>

<style scoped lang="scss">
.statistics-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-bottom: 20px;

  .stat-card {
    .stat-header {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 2px solid #f0f0f0;

      .stat-icon {
        font-size: 24px;

        &.ticket {
          color: #409eff;
        }

        &.rental {
          color: #67c23a;
        }

        &.user {
          color: #e6a23c;
        }
      }

      .stat-title {
        font-size: 18px;
        font-weight: bold;
        color: #303133;
      }
    }

    .stat-content {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 15px;

      .stat-item {
        display: flex;
        flex-direction: column;
        gap: 5px;

        .stat-label {
          font-size: 13px;
          color: #909399;
        }

        .stat-value {
          font-size: 20px;
          font-weight: bold;
          color: #303133;

          &.success {
            color: #67c23a;
          }

          &.warning {
            color: #e6a23c;
          }

          &.info {
            color: #909399;
          }

          &.amount {
            color: #f56c6c;
          }
        }
      }
    }
  }
}

@media (max-width: 1200px) {
  .statistics-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .statistics-cards {
    grid-template-columns: 1fr;
  }
}
</style>
