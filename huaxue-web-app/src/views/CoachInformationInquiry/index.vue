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

      <!-- 协同过滤推荐区：与下方「全部教练」视觉分区 + 可解释抽屉 -->
      <div class="recommendation-zone" v-if="recommendedCoaches.length > 0">
        <div class="recommendation-zone-inner">
          <div class="recommendation-zone-head">
            <div class="recommendation-zone-title-block">
              <el-icon class="recommendation-zone-icon"><Cpu /></el-icon>
              <div class="recommendation-zone-text">
                <div class="recommendation-zone-heading">
                  <span class="recommendation-zone-h3">协同过滤 · 为您推荐</span>
                  <el-tag type="primary" effect="plain" size="small">算法排序</el-tag>
                </div>
                <p class="recommendation-zone-sub">
                  以下排序由协同过滤算法生成，与下方默认列表不同。
                </p>
              </div>
            </div>
            <el-button type="primary" plain @click="cfExplainVisible = true">
              <el-icon class="btn-icon"><QuestionFilled /></el-icon>
              推荐分怎么来的？（流程 + 图表 + 名次表）
            </el-button>
          </div>
          <el-row :gutter="20" class="recommendation-cards-row">
            <el-col
              v-for="(coach, idx) in recommendedCoaches"
              :key="coach.coachId"
              :xs="24"
              :sm="12"
              :md="8"
              :lg="6"
              class="recommendation-col"
            >
              <CoachCard
                :coach="convertRecommendationToCoach(coach)"
                :show-recommendation="true"
                :recommendation-rank="idx + 1"
                :recommendation-score="coach.recommendationScore"
                :recommendation-reason="coach.recommendationReason"
                @view-detail="handleViewDetail"
              />
            </el-col>
          </el-row>
        </div>
      </div>

      <!-- 与推荐区的分界：强调「全部教练」非协同过滤排序 -->
      <div v-if="recommendedCoaches.length > 0" class="all-coaches-boundary">
        <div class="boundary-line" />
        <div class="boundary-content">
          <el-icon><UserFilled /></el-icon>
          <span class="boundary-title">全部教练列表</span>
          <span class="boundary-hint">以下为查询与筛选结果，排序规则与上方协同过滤推荐区不同</span>
        </div>
        <div class="boundary-line" />
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

    <CollaborativeFilteringExplainDrawer
      v-model="cfExplainVisible"
      :coaches="recommendedCoaches"
    />
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { Search, Refresh, UserFilled, Cpu, QuestionFilled } from '@element-plus/icons-vue'
import CoachCard from './components/CoachCard.vue'
import CoachDetailDialog from './components/CoachDetailDialog.vue'
import CollaborativeFilteringExplainDrawer from './components/CollaborativeFilteringExplainDrawer.vue'
import { listCoachInfo } from '@/api/coachInfo'
import { getCoachRecommendations } from '@/api/coachRecommendation'

const loading = ref(false)
const coachList = ref([])
const total = ref(0)
const detailDialogVisible = ref(false)
const selectedCoach = ref(null)
const recommendedCoaches = ref([])
const loadingRecommendations = ref(false)
const cfExplainVisible = ref(false)

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

// 加载推荐教练
const loadRecommendations = async () => {
  loadingRecommendations.value = true
  try {
    const response = await getCoachRecommendations(6, 'hybrid')
    if (response.code === 200 && response.rows) {
      recommendedCoaches.value = response.rows || []
    }
  } catch (error) {
    console.error('加载推荐教练失败:', error)
    recommendedCoaches.value = []
  } finally {
    loadingRecommendations.value = false
  }
}

// 将推荐DTO转换为教练对象
const convertRecommendationToCoach = (recommendation) => {
  return {
    id: recommendation.coachId,
    userId: recommendation.userId,
    coachLevel: recommendation.coachLevel,
    specialty: recommendation.specialty,
    hourlyRate: recommendation.hourlyRate,
    averageRating: recommendation.averageRating,
    teachingYears: 0, // 推荐数据中没有，设为默认值
    totalStudents: 0, // 推荐数据中没有，设为默认值
    introduction: '', // 推荐数据中没有，设为默认值
    user: {
      userName: recommendation.coachName,
      nickName: recommendation.coachName,
      avatar: recommendation.avatar || null // 添加头像信息
    }
  }
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
  loadRecommendations()
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

/* —— 协同过滤推荐区：与「全部教练」强视觉对比 —— */
.recommendation-zone {
  margin-bottom: 28px;
  border-radius: 12px;
  background: linear-gradient(135deg, #ecf5ff 0%, #f0f9ff 45%, #fafcff 100%);
  border: 1px solid #c6e2ff;
  box-shadow: 0 4px 16px rgba(64, 158, 255, 0.12);
  position: relative;
  overflow: hidden;
}

.recommendation-zone::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5px;
  background: linear-gradient(180deg, #409eff 0%, #79bbff 50%, #a0cfff 100%);
  border-radius: 12px 0 0 12px;
}

.recommendation-zone-inner {
  padding: 20px 20px 12px 24px;
}

.recommendation-zone-head {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.recommendation-zone-title-block {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  min-width: 0;
  flex: 1;
}

.recommendation-zone-icon {
  font-size: 36px;
  color: #409eff;
  flex-shrink: 0;
  margin-top: 2px;
}

.recommendation-zone-text {
  min-width: 0;
}

.recommendation-zone-heading {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
  margin-bottom: 6px;
}

.recommendation-zone-h3 {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
  letter-spacing: 0.02em;
}

.recommendation-zone-sub {
  margin: 0;
  font-size: 13px;
  color: #606266;
  line-height: 1.6;
  max-width: 640px;
}

.recommendation-cards-row {
  margin-top: 4px;
}

.recommendation-col {
  margin-bottom: 20px;
}

.recommendation-zone-head .btn-icon {
  margin-right: 4px;
  vertical-align: middle;
}

/* 全部教练分界条 */
.all-coaches-boundary {
  display: flex;
  align-items: center;
  gap: 14px;
  margin: 8px 0 24px;
  flex-wrap: wrap;
}

.all-coaches-boundary .boundary-line {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, transparent, #dcdfe6 15%, #dcdfe6 85%, transparent);
  min-width: 40px;
}

.boundary-content {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 13px;
  color: #909399;
}

.boundary-title {
  font-weight: 600;
  color: #606266;
}

.boundary-hint {
  color: #a8abb2;
}
</style>
