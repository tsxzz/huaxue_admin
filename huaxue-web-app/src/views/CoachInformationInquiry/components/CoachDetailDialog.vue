<template>
  <el-dialog
    v-model="visible"
    title="教练详细信息"
    width="920px"
    :close-on-click-modal="false"
  >
    <div class="coach-detail" v-if="coach">
      <!-- 基本信息 -->
      <el-card class="detail-section" shadow="never">
        <template #header>
          <div class="section-header">
            <el-icon><User /></el-icon>
            <span>基本信息</span>
          </div>
        </template>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="姓名">
            {{ coach.user?.nickName || coach.user?.userName || '未知' }}
          </el-descriptions-item>
          <el-descriptions-item label="教练等级">
            <el-tag :type="getCoachLevelType(coach.coachLevel)">
              {{ coach.coachLevel || '未设置' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="教学年限">
            {{ coach.teachingYears || 0 }} 年
          </el-descriptions-item>
          <el-descriptions-item label="课时费" v-if="coach.hourlyRate">
            ¥{{ coach.hourlyRate }}/小时
          </el-descriptions-item>
          <el-descriptions-item label="手机号码" v-if="coach.user?.phonenumber">
            {{ coach.user.phonenumber }}
          </el-descriptions-item>
          <el-descriptions-item label="邮箱" v-if="coach.user?.email">
            {{ coach.user.email }}
          </el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 擅长领域 -->
      <el-card class="detail-section" shadow="never" v-if="coach.specialty">
        <template #header>
          <div class="section-header">
            <el-icon><List /></el-icon>
            <span>擅长领域</span>
          </div>
        </template>
        <div class="specialty-content">
          {{ coach.specialty }}
        </div>
      </el-card>

      <!-- 个人简介 -->
      <el-card class="detail-section" shadow="never" v-if="coach.introduction">
        <template #header>
          <div class="section-header">
            <el-icon><Document /></el-icon>
            <span>个人简介</span>
          </div>
        </template>
        <div class="introduction-content">
          {{ coach.introduction }}
        </div>
      </el-card>

      <!-- 专业证书 -->
      <el-card class="detail-section" shadow="never" v-if="coach.certificate">
        <template #header>
          <div class="section-header">
            <el-icon><Trophy /></el-icon>
            <span>专业证书</span>
          </div>
        </template>
        <div class="certificate-content">
          <div v-if="isJsonString(coach.certificate)">
            <div v-for="(cert, index) in parseCertificates(coach.certificate)" :key="index" class="cert-item">
              <el-icon><CircleCheck /></el-icon>
              <span>{{ cert }}</span>
            </div>
          </div>
          <div v-else>
            {{ coach.certificate }}
          </div>
        </div>
      </el-card>

      <!-- 开设课程（可预约） -->
      <el-card class="detail-section" shadow="never">
        <template #header>
          <div class="section-header section-header-row">
            <div class="section-title">
              <el-icon><Reading /></el-icon>
              <span>开设课程</span>
            </div>
            <el-button
              v-if="coachUserId"
              link
              type="primary"
              @click="goCoachAppointmentPage"
            >
              教练预约页筛选该教练
            </el-button>
          </div>
        </template>
        <div v-loading="coursesLoading">
          <el-empty
            v-if="!coursesLoading && coachCourses.length === 0"
            description="该教练暂未开设可预约课程"
            :image-size="80"
          />
          <el-table v-else :data="coachCourses" border size="small" max-height="320">
            <el-table-column prop="courseName" label="课程名称" min-width="140" show-overflow-tooltip />
            <el-table-column prop="courseType" label="类型" width="100" align="center" />
            <el-table-column prop="duration" label="时长(分)" width="90" align="center" />
            <el-table-column label="价格" width="90" align="right">
              <template #default="scope">
                ¥{{ scope.row.price }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120" align="center" fixed="right">
              <template #default="scope">
                <el-button type="primary" size="small" @click="openBookCourse(scope.row)">
                  预约
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-card>

      <!-- 统计数据 -->
      <el-card class="detail-section" shadow="never">
        <template #header>
          <div class="section-header">
            <el-icon><DataAnalysis /></el-icon>
            <span>统计数据</span>
          </div>
        </template>
        <el-row :gutter="20">
          <el-col :span="6">
            <el-statistic title="累计学员数" :value="coach.totalStudents || 0">
              <template #suffix>
                <span style="font-size: 14px">人</span>
              </template>
            </el-statistic>
          </el-col>
          <el-col :span="6">
            <el-statistic title="当前学员数" :value="coach.currentStudents || 0">
              <template #suffix>
                <span style="font-size: 14px">人</span>
              </template>
            </el-statistic>
          </el-col>
          <el-col :span="6">
            <el-statistic title="累计教学时长" :value="coach.totalTeachingHours || 0">
              <template #suffix>
                <span style="font-size: 14px">小时</span>
              </template>
            </el-statistic>
          </el-col>
          <el-col :span="6">
            <el-statistic title="平均评分" :value="coach.averageRating || 0" :precision="2">
              <template #suffix>
                <span style="font-size: 14px">分</span>
              </template>
            </el-statistic>
          </el-col>
        </el-row>
        <div class="rating-display" v-if="coach.averageRating">
          <el-rate
            :model-value="parseFloat(coach.averageRating)"
            disabled
            show-score
            text-color="#ff9900"
            :score-template="`${parseFloat(coach.averageRating).toFixed(1)} (${coach.ratingCount || 0}条评价)`"
          />
        </div>
      </el-card>
    </div>

    <template #footer>
      <el-button @click="handleClose">关闭</el-button>
    </template>
  </el-dialog>

  <ScheduleDialog
    v-model="scheduleVisible"
    :course="currentCourse"
    @appointment-success="handleAppointmentSuccess"
  />
</template>

<script setup>
import { ref, watch, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, List, Document, Trophy, CircleCheck, DataAnalysis, Reading } from '@element-plus/icons-vue'
import { publicListCourse } from '@/api/course'
import ScheduleDialog from '@/views/CoachAppointment/components/ScheduleDialog.vue'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  coach: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['update:modelValue'])

const visible = ref(false)
const router = useRouter()

const coachCourses = ref([])
const coursesLoading = ref(false)
const scheduleVisible = ref(false)
const currentCourse = ref(null)

/** 课程表的 coachId 对应 sys_user 的用户 ID，与教练信息里的 userId 一致 */
const coachUserId = computed(() => {
  if (!props.coach) return null
  return props.coach.userId ?? props.coach.user?.userId ?? null
})

const loadCoachCourses = async () => {
  const uid = coachUserId.value
  if (!uid) {
    coachCourses.value = []
    return
  }
  coursesLoading.value = true
  try {
    const res = await publicListCourse({
      pageNum: 1,
      pageSize: 100,
      coachId: uid
    })
    coachCourses.value = res.rows || []
  } catch (e) {
    coachCourses.value = []
    ElMessage.error('加载该教练课程失败')
  } finally {
    coursesLoading.value = false
  }
}

const openBookCourse = (course) => {
  currentCourse.value = course
  scheduleVisible.value = true
}

const goCoachAppointmentPage = () => {
  const uid = coachUserId.value
  if (!uid) return
  visible.value = false
  router.push({ path: '/CoachAppointment', query: { coachId: String(uid) } })
}

const handleAppointmentSuccess = () => {
  ElMessage.success('预约成功')
  loadCoachCourses()
}

watch(() => props.modelValue, (val) => {
  visible.value = val
  if (val && props.coach) {
    loadCoachCourses()
  }
  if (!val) {
    coachCourses.value = []
    scheduleVisible.value = false
    currentCourse.value = null
  }
})

watch(visible, (val) => {
  emit('update:modelValue', val)
})

// 获取教练等级标签类型
const getCoachLevelType = (level) => {
  const levelMap = {
    '初级': 'info',
    '中级': 'success',
    '高级': 'warning',
    '专业': 'danger'
  }
  return levelMap[level] || 'info'
}

// 判断是否为JSON字符串
const isJsonString = (str) => {
  if (!str) return false
  try {
    JSON.parse(str)
    return true
  } catch {
    return false
  }
}

// 解析证书JSON
const parseCertificates = (certStr) => {
  try {
    const certObj = JSON.parse(certStr)
    if (certObj.certificates && Array.isArray(certObj.certificates)) {
      return certObj.certificates
    }
    return []
  } catch {
    return []
  }
}

// 关闭对话框
const handleClose = () => {
  visible.value = false
}
</script>

<style scoped>
.coach-detail {
  max-height: 70vh;
  overflow-y: auto;
}

.detail-section {
  margin-bottom: 20px;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  font-size: 16px;
}

.section-header-row {
  justify-content: space-between;
  width: 100%;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 8px;
}

.specialty-content,
.introduction-content {
  padding: 10px;
  line-height: 1.8;
  color: #606266;
}

.certificate-content {
  padding: 10px;
}

.cert-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
  padding: 8px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.cert-item:last-child {
  margin-bottom: 0;
}

.rating-display {
  margin-top: 20px;
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
}
</style>
