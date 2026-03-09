<template>
  <div class="financial-statistics-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><Money /></el-icon>
          <h1>财务统计</h1>
        </div>
        <p class="header-desc">查看门票销售、雪具租赁和教练课程的财务统计数据</p>
      </div>
    </div>

    <!-- 查询条件 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="queryParams" :inline="true">
        <el-form-item label="开始日期">
          <el-date-picker
            v-model="queryParams.startDate"
            type="date"
            placeholder="选择开始日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 200px"
          />
        </el-form-item>
        <el-form-item label="结束日期">
          <el-date-picker
            v-model="queryParams.endDate"
            type="date"
            placeholder="选择结束日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 200px"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 统计卡片 -->
    <div class="statistics-cards" v-loading="loading">
      <el-card class="stat-card" shadow="hover">
        <div class="stat-content">
          <div class="stat-icon total">
            <el-icon><Money /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">总收入</div>
            <div class="stat-value">¥{{ formatAmount(statistics.totalRevenue) }}</div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card" shadow="hover">
        <div class="stat-content">
          <div class="stat-icon ticket">
            <el-icon><Ticket /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">门票收入</div>
            <div class="stat-value">¥{{ formatAmount(statistics.ticketRevenue) }}</div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card" shadow="hover">
        <div class="stat-content">
          <div class="stat-icon rental">
            <el-icon><ShoppingBag /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">租赁收入</div>
            <div class="stat-value">¥{{ formatAmount(statistics.rentalRevenue) }}</div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card" shadow="hover">
        <div class="stat-content">
          <div class="stat-icon course">
            <el-icon><UserFilled /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">课程总收入</div>
            <div class="stat-value">¥{{ formatAmount(statistics.courseRevenue) }}</div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card" shadow="hover">
        <div class="stat-content">
          <div class="stat-icon coach">
            <el-icon><Avatar /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">教练收入（30%）</div>
            <div class="stat-value">¥{{ formatAmount(statistics.coachRevenue) }}</div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card" shadow="hover">
        <div class="stat-content">
          <div class="stat-icon resort">
            <el-icon><OfficeBuilding /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-label">雪场收入（70%）</div>
            <div class="stat-value">¥{{ formatAmount(statistics.resortRevenue) }}</div>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 图表区域 -->
    <div class="charts-section">
      <!-- 日收入趋势 -->
      <el-card class="chart-card" shadow="never" v-if="statistics.dailyRevenueList && statistics.dailyRevenueList.length > 0">
        <RevenueTrendChart :data="statistics.dailyRevenueList" type="daily" />
      </el-card>

      <!-- 月收入趋势 -->
      <el-card class="chart-card" shadow="never" v-if="statistics.monthlyRevenueList && statistics.monthlyRevenueList.length > 0">
        <RevenueTrendChart :data="statistics.monthlyRevenueList" type="monthly" />
      </el-card>

      <!-- 收入来源占比 -->
      <el-card class="chart-card" shadow="never" v-if="statistics.revenueSourceList && statistics.revenueSourceList.length > 0">
        <RevenueSourceChart :data="statistics.revenueSourceList" />
      </el-card>

      <!-- 支付方式统计 -->
      <el-card class="chart-card" shadow="never" v-if="statistics.paymentMethodList && statistics.paymentMethodList.length > 0">
        <PaymentMethodChart :data="statistics.paymentMethodList" />
      </el-card>
    </div>

    <!-- 空状态 -->
    <el-empty v-if="!loading && (!statistics.dailyRevenueList || statistics.dailyRevenueList.length === 0)" description="暂无数据" />
  </div>
</template>

<script setup name="FinancialStatistics">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Money, Ticket, ShoppingBag, Search, Refresh, UserFilled, Avatar, OfficeBuilding } from '@element-plus/icons-vue'
import { getFinancialStatistics } from '@/api/financialStatistics'
import RevenueTrendChart from './components/RevenueTrendChart.vue'
import RevenueSourceChart from './components/RevenueSourceChart.vue'
import PaymentMethodChart from './components/PaymentMethodChart.vue'

// 加载状态
const loading = ref(false)

// 查询参数
const queryParams = reactive({
  startDate: null,
  endDate: null
})

// 统计数据
const statistics = reactive({
  totalRevenue: 0,
  ticketRevenue: 0,
  rentalRevenue: 0,
  courseRevenue: 0,
  coachRevenue: 0,
  resortRevenue: 0,
  dailyRevenueList: [],
  monthlyRevenueList: [],
  revenueSourceList: [],
  paymentMethodList: []
})

// 格式化金额
const formatAmount = (amount) => {
  if (!amount || amount === 0) return '0.00'
  return parseFloat(amount).toFixed(2)
}

// 查询统计数据
const getStatistics = async () => {
  loading.value = true
  try {
    const params = {
      startDate: queryParams.startDate,
      endDate: queryParams.endDate
    }
    
    const response = await getFinancialStatistics(params.startDate, params.endDate)
    if (response.code === 200 && response.data) {
      const data = response.data
      statistics.totalRevenue = data.totalRevenue || 0
      statistics.ticketRevenue = data.ticketRevenue || 0
      statistics.rentalRevenue = data.rentalRevenue || 0
      statistics.courseRevenue = data.courseRevenue || 0
      statistics.coachRevenue = data.coachRevenue || 0
      statistics.resortRevenue = data.resortRevenue || 0
      statistics.dailyRevenueList = data.dailyRevenueList || []
      statistics.monthlyRevenueList = data.monthlyRevenueList || []
      statistics.revenueSourceList = data.revenueSourceList || []
      statistics.paymentMethodList = data.paymentMethodList || []
    }
  } catch (error) {
    console.error('获取财务统计数据失败:', error)
    ElMessage.error('获取财务统计数据失败')
  } finally {
    loading.value = false
  }
}

// 查询
const handleQuery = () => {
  getStatistics()
}

// 重置
const resetQuery = () => {
  queryParams.startDate = null
  queryParams.endDate = null
  getStatistics()
}

onMounted(() => {
  // 默认查询最近30天的数据
  const endDate = new Date()
  const startDate = new Date()
  startDate.setDate(startDate.getDate() - 30)
  
  queryParams.endDate = formatDate(endDate)
  queryParams.startDate = formatDate(startDate)
  
  getStatistics()
})

// 格式化日期
const formatDate = (date) => {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}
</script>

<style scoped lang="scss">
.financial-statistics-container {
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
          color: #67c23a;
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

  .statistics-cards {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 20px;

    @media (max-width: 1400px) {
      grid-template-columns: repeat(2, 1fr);
    }

    .stat-card {
      .stat-content {
        display: flex;
        align-items: center;
        gap: 20px;

        .stat-icon {
          width: 60px;
          height: 60px;
          border-radius: 12px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 28px;
          color: white;

          &.total {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          }

          &.ticket {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
          }

          &.rental {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
          }

          &.course {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
          }

          &.coach {
            background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
          }

          &.resort {
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
          }
        }

        .stat-info {
          flex: 1;

          .stat-label {
            font-size: 14px;
            color: #909399;
            margin-bottom: 8px;
          }

          .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #303133;
          }
        }
      }
    }
  }

  .charts-section {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;

    .chart-card {
      padding: 20px;
    }
  }
}

@media (max-width: 1200px) {
  .financial-statistics-container {
    .statistics-cards {
      grid-template-columns: repeat(2, 1fr);
    }

    .charts-section {
      grid-template-columns: 1fr;
    }
  }
}

@media (max-width: 768px) {
  .financial-statistics-container {
    .statistics-cards {
      grid-template-columns: 1fr;
    }
  }
}
</style>
