<template>
  <div class="operational-statistics-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><DataAnalysis /></el-icon>
          <h1>运营数据统计</h1>
        </div>
        <p class="header-desc">查看门票销售、雪具租赁和用户运营的详细数据</p>
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
        <el-form-item label="统计类型">
          <el-select v-model="queryParams.type" style="width: 150px">
            <el-option label="按日统计" value="daily" />
            <el-option label="按周统计" value="weekly" />
            <el-option label="按月统计" value="monthly" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 统计卡片 -->
    <StatisticsCards
      v-loading="loading"
      :ticket-stats="statistics.ticketOrderStatistics"
      :rental-stats="statistics.rentalStatistics"
      :user-stats="statistics.userStatistics"
    />

    <!-- 趋势图表 -->
    <div class="charts-section">
      <el-card class="chart-card" shadow="never" v-if="statistics.orderTrendList && statistics.orderTrendList.length > 0">
        <TrendChart :data="statistics.orderTrendList" title="订单趋势" />
      </el-card>

      <el-card class="chart-card" shadow="never" v-if="statistics.rentalTrendList && statistics.rentalTrendList.length > 0">
        <TrendChart :data="statistics.rentalTrendList" title="租赁趋势" />
      </el-card>
    </div>

    <!-- 热门排行和用户增长 -->
    <div class="bottom-section">
      <div class="ranking-section">
        <PopularRanking
          title="热门票种排行"
          :data="statistics.popularTicketList"
          name-prop="ticketName"
          count-prop="orderCount"
          amount-prop="totalAmount"
        />
      </div>

      <div class="ranking-section">
        <PopularRanking
          title="热门设备排行"
          :data="statistics.popularEquipmentList"
          name-prop="equipmentName"
          count-prop="rentalCount"
          amount-prop="totalAmount"
        />
      </div>

      <div class="growth-section">
        <el-card shadow="never" v-if="statistics.userStatistics && statistics.userStatistics.userGrowthList && statistics.userStatistics.userGrowthList.length > 0">
          <UserGrowthChart :data="statistics.userStatistics.userGrowthList" />
        </el-card>
      </div>
    </div>

    <!-- 空状态 -->
    <el-empty v-if="!loading && (!statistics.orderTrendList || statistics.orderTrendList.length === 0)" description="暂无数据" />
  </div>
</template>

<script setup name="OperationalDataStatistics">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { DataAnalysis, Search, Refresh } from '@element-plus/icons-vue'
import { getOperationalStatistics } from '@/api/operationalStatistics'
import StatisticsCards from './components/StatisticsCards.vue'
import TrendChart from './components/TrendChart.vue'
import PopularRanking from './components/PopularRanking.vue'
import UserGrowthChart from './components/UserGrowthChart.vue'

// 加载状态
const loading = ref(false)

// 查询参数
const queryParams = reactive({
  startDate: null,
  endDate: null,
  type: 'daily'
})

// 统计数据
const statistics = reactive({
  ticketOrderStatistics: {},
  rentalStatistics: {},
  userStatistics: {},
  orderTrendList: [],
  rentalTrendList: [],
  popularTicketList: [],
  popularEquipmentList: []
})

// 查询统计数据
const getStatistics = async () => {
  loading.value = true
  try {
    const params = {
      startDate: queryParams.startDate,
      endDate: queryParams.endDate,
      type: queryParams.type
    }
    
    const response = await getOperationalStatistics(params.startDate, params.endDate, params.type)
    if (response.code === 200 && response.data) {
      const data = response.data
      statistics.ticketOrderStatistics = data.ticketOrderStatistics || {}
      statistics.rentalStatistics = data.rentalStatistics || {}
      statistics.userStatistics = data.userStatistics || {}
      statistics.orderTrendList = data.orderTrendList || []
      statistics.rentalTrendList = data.rentalTrendList || []
      statistics.popularTicketList = data.popularTicketList || []
      statistics.popularEquipmentList = data.popularEquipmentList || []
    }
  } catch (error) {
    console.error('获取运营统计数据失败:', error)
    ElMessage.error('获取运营统计数据失败')
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
  const endDate = new Date()
  const startDate = new Date()
  startDate.setDate(startDate.getDate() - 30)
  
  queryParams.endDate = formatDate(endDate)
  queryParams.startDate = formatDate(startDate)
  queryParams.type = 'daily'
  
  getStatistics()
}

onMounted(() => {
  // 默认不设置日期范围，查询所有数据
  // 如果数据库中有历史数据，可以设置一个更早的日期范围
  // const endDate = new Date()
  // const startDate = new Date()
  // startDate.setDate(startDate.getDate() - 365) // 查询最近一年
  // queryParams.endDate = formatDate(endDate)
  // queryParams.startDate = formatDate(startDate)
  
  // 不设置日期范围，查询所有数据
  queryParams.endDate = null
  queryParams.startDate = null
  
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
.operational-statistics-container {
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

  .charts-section {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
    margin-bottom: 20px;

    .chart-card {
      padding: 20px;
    }
  }

  .bottom-section {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;

    .ranking-section {
      min-height: 400px;
    }

    .growth-section {
      grid-column: 1 / -1;
    }
  }
}

@media (max-width: 1200px) {
  .operational-statistics-container {
    .charts-section {
      grid-template-columns: 1fr;
    }

    .bottom-section {
      grid-template-columns: 1fr;
    }
  }
}
</style>
