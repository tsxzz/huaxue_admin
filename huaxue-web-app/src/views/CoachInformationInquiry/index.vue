<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-header">
          <h2>
            <el-icon><UserFilled /></el-icon>
            教练信息查询
          </h2>
        </div>
      </template>

      <!-- 搜索和筛选区域 -->
      <div class="search-section">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-input
              v-model="queryParams.searchValue"
              placeholder="请输入教练姓名或用户名"
              clearable
              @clear="handleQuery"
              @keyup.enter="handleQuery"
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
          </el-col>
          <el-col :span="4">
            <el-select
              v-model="queryParams.coachLevel"
              placeholder="教练等级"
              clearable
              @change="handleQuery"
            >
              <el-option label="全部" value="" />
              <el-option label="初级" value="初级" />
              <el-option label="中级" value="中级" />
              <el-option label="高级" value="高级" />
              <el-option label="专业" value="专业" />
            </el-select>
          </el-col>
          <el-col :span="4">
            <el-select
              v-model="queryParams.sortBy"
              placeholder="排序方式"
              @change="handleQuery"
            >
              <el-option label="默认排序" value="" />
              <el-option label="评分最高" value="rating" />
              <el-option label="学员最多" value="students" />
              <el-option label="年限最长" value="years" />
            </el-select>
          </el-col>
          <el-col :span="10">
            <el-button type="primary" @click="handleQuery">
              <el-icon><Search /></el-icon>
              搜索
            </el-button>
            <el-button @click="resetQuery">
              <el-icon><Refresh /></el-icon>
              重置
            </el-button>
          </el-col>
        </el-row>
      </div>

      <!-- 统计信息 -->
      <div class="stats-section" v-if="coachList.length > 0">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-statistic title="教练总数" :value="total">
              <template #suffix>
                <span style="font-size: 14px">人</span>
              </template>
            </el-statistic>
          </el-col>
          <el-col :span="6">
            <el-statistic title="高级教练" :value="highLevelCount">
              <template #suffix>
                <span style="font-size: 14px">人</span>
              </template>
            </el-statistic>
          </el-col>
          <el-col :span="6">
            <el-statistic title="累计学员" :value="totalStudents">
              <template #suffix>
                <span style="font-size: 14px">人</span>
              </template>
            </el-statistic>
          </el-col>
          <el-col :span="6">
            <el-statistic title="平均评分" :value="averageRating" :precision="2">
              <template #suffix>
                <span style="font-size: 14px">分</span>
              </template>
            </el-statistic>
          </el-col>
        </el-row>
      </div>

      <!-- 教练卡片列表 -->
      <div class="coach-list" v-loading="loading">
        <el-empty v-if="!loading && coachList.length === 0" description="暂无教练信息" />
        <el-row :gutter="20" v-else>
          <el-col
            v-for="coach in coachList"
            :key="coach.id"
            :xs="24"
            :sm="12"
            :md="8"
            :lg="6"
            style="margin-bottom: 20px"
          >
            <CoachCard :coach="coach" @view-detail="handleViewDetail" />
          </el-col>
        </el-row>
      </div>

      <!-- 分页 -->
      <div class="pagination-section" v-if="total > 0">
        <el-pagination
          v-model:current-page="queryParams.pageNum"
          v-model:page-size="queryParams.pageSize"
          :page-sizes="[12, 24, 36, 48]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleQuery"
          @current-change="handleQuery"
        />
      </div>
    </el-card>

    <!-- 教练详情对话框 -->
    <CoachDetailDialog
      v-model="detailDialogVisible"
      :coach="selectedCoach"
    />
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { Search, Refresh, UserFilled } from '@element-plus/icons-vue'
import CoachCard from './components/CoachCard.vue'
import CoachDetailDialog from './components/CoachDetailDialog.vue'
import { listCoachInfo } from '@/api/coachInfo'

const loading = ref(false)
const coachList = ref([])
const total = ref(0)
const detailDialogVisible = ref(false)
const selectedCoach = ref(null)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 12,
  searchValue: '',
  coachLevel: '',
  sortBy: ''
})

// 统计信息
const highLevelCount = computed(() => {
  return coachList.value.filter(c => 
    c.coachLevel === '高级' || c.coachLevel === '专业'
  ).length
})

const totalStudents = computed(() => {
  return coachList.value.reduce((sum, c) => sum + (c.totalStudents || 0), 0)
})

const averageRating = computed(() => {
  const ratings = coachList.value
    .filter(c => c.averageRating && c.averageRating > 0)
    .map(c => parseFloat(c.averageRating))
  if (ratings.length === 0) return 0
  const sum = ratings.reduce((a, b) => a + b, 0)
  return sum / ratings.length
})

// 查询教练列表
const getList = () => {
  loading.value = true
  listCoachInfo(queryParams)
    .then(response => {
      if (response.code === 200) {
        let list = response.rows || []
        
        // 前端搜索过滤
        if (queryParams.searchValue) {
          const search = queryParams.searchValue.toLowerCase()
          list = list.filter(coach => {
            const userName = (coach.user?.userName || '').toLowerCase()
            const nickName = (coach.user?.nickName || '').toLowerCase()
            return userName.includes(search) || nickName.includes(search)
          })
        }

        // 前端等级过滤（如果后端没有过滤）
        if (queryParams.coachLevel) {
          list = list.filter(coach => coach.coachLevel === queryParams.coachLevel)
        }

        // 前端排序
        if (queryParams.sortBy === 'rating') {
          list.sort((a, b) => (b.averageRating || 0) - (a.averageRating || 0))
        } else if (queryParams.sortBy === 'students') {
          list.sort((a, b) => (b.totalStudents || 0) - (a.totalStudents || 0))
        } else if (queryParams.sortBy === 'years') {
          list.sort((a, b) => (b.teachingYears || 0) - (a.teachingYears || 0))
        }

        coachList.value = list
        total.value = response.total || list.length
      }
    })
    .finally(() => {
      loading.value = false
    })
}

// 搜索
const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

// 重置
const resetQuery = () => {
  queryParams.searchValue = ''
  queryParams.coachLevel = ''
  queryParams.sortBy = ''
  queryParams.pageNum = 1
  handleQuery()
}

// 查看详情
const handleViewDetail = (coach) => {
  selectedCoach.value = coach
  detailDialogVisible.value = true
}

onMounted(() => {
  getList()
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
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
}

.search-section {
  margin-bottom: 20px;
  padding: 20px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.stats-section {
  margin-bottom: 30px;
  padding: 20px;
  background-color: #fafafa;
  border-radius: 4px;
}

.coach-list {
  min-height: 400px;
}

.pagination-section {
  margin-top: 30px;
  display: flex;
  justify-content: center;
}
</style>
