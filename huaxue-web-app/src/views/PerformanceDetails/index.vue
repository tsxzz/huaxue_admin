<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-header">
          <h2>
            <el-icon><TrendCharts /></el-icon>
            业绩明细
          </h2>
        </div>
      </template>

      <!-- 日期范围选择 -->
      <div class="filter-section">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-date-picker
              v-model="dateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              value-format="YYYY-MM-DD"
              @change="handleDateRangeChange"
            />
          </el-col>
          <el-col :span="4">
            <el-button type="primary" @click="loadData">
              <el-icon><Search /></el-icon>
              查询
            </el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-col>
        </el-row>
      </div>

      <!-- 统计卡片 -->
      <PerformanceCards :performance="performance" />

      <!-- 图表区域 -->
      <el-row :gutter="20">
        <el-col :span="12">
          <MonthlyRevenueChart :monthly-data="performance.monthlyData || []" />
        </el-col>
        <el-col :span="12">
          <CourseTypeChart :course-type-data="performance.courseTypeData || []" />
        </el-col>
      </el-row>

      <!-- 课程列表 -->
      <CourseList :course-list="performance.recentCourses || []" :loading="loading" />
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { TrendCharts, Search } from '@element-plus/icons-vue'
import { getCoachPerformance } from '@/api/coachPerformance'
import PerformanceCards from './components/PerformanceCards.vue'
import MonthlyRevenueChart from './components/MonthlyRevenueChart.vue'
import CourseTypeChart from './components/CourseTypeChart.vue'
import CourseList from './components/CourseList.vue'

const loading = ref(false)
const dateRange = ref([])
const performance = ref({
  totalCompletedCourses: 0,
  totalRevenue: 0,
  paidRevenue: 0,
  unpaidRevenue: 0,
  monthlyData: [],
  courseTypeData: [],
  recentCourses: []
})

const queryParams = reactive({
  startDate: '',
  endDate: ''
})

const loadData = async () => {
  loading.value = true
  try {
    const response = await getCoachPerformance(queryParams)
    performance.value = response.data || {
      totalCompletedCourses: 0,
      totalRevenue: 0,
      paidRevenue: 0,
      unpaidRevenue: 0,
      monthlyData: [],
      courseTypeData: [],
      recentCourses: []
    }
  } catch (error) {
    console.error('加载业绩数据失败', error)
  } finally {
    loading.value = false
  }
}

const handleDateRangeChange = (dates) => {
  if (dates && dates.length === 2) {
    queryParams.startDate = dates[0]
    queryParams.endDate = dates[1]
  } else {
    queryParams.startDate = ''
    queryParams.endDate = ''
  }
  loadData()
}

const handleReset = () => {
  dateRange.value = []
  queryParams.startDate = ''
  queryParams.endDate = ''
  loadData()
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.page-header {
  display: flex;
  align-items: center;
  gap: 10px;
}

.page-header h2 {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
}

.filter-section {
  margin-bottom: 20px;
}
</style>
