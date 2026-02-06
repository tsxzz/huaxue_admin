<template>
  <el-dialog
    v-model="visible"
    title="教练详细信息"
    width="800px"
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
</template>

<script setup>
import { ref, watch } from 'vue'
import { User, List, Document, Trophy, CircleCheck, DataAnalysis } from '@element-plus/icons-vue'

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

watch(() => props.modelValue, (val) => {
  visible.value = val
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
