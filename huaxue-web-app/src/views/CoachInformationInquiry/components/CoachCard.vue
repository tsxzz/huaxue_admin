<template>
  <el-card class="coach-card" shadow="hover" @click="handleCardClick">
    <div class="coach-header">
      <div class="coach-avatar">
        <el-avatar :size="80" :src="getAvatarUrl(coach.user?.avatar)" :icon="UserFilled">
          <template #default>
            <el-icon><UserFilled /></el-icon>
          </template>
        </el-avatar>
      </div>
      <div class="coach-basic-info">
        <h3 class="coach-name">
          <el-icon><User /></el-icon>
          {{ coach.user?.nickName || coach.user?.userName || '未知' }}
        </h3>
        <el-tag :type="getCoachLevelType(coach.coachLevel)" size="large" effect="dark">
          {{ coach.coachLevel || '未设置' }}
        </el-tag>
      </div>
    </div>

    <div class="coach-stats">
      <div class="stat-item">
        <el-icon class="stat-icon"><User /></el-icon>
        <div class="stat-content">
          <div class="stat-value">{{ coach.teachingYears || 0 }}</div>
          <div class="stat-label">教学年限</div>
        </div>
      </div>
      <div class="stat-item">
        <el-icon class="stat-icon"><UserFilled /></el-icon>
        <div class="stat-content">
          <div class="stat-value">{{ coach.totalStudents || 0 }}</div>
          <div class="stat-label">累计学员</div>
        </div>
      </div>
      <div class="stat-item">
        <el-icon class="stat-icon"><Star /></el-icon>
        <div class="stat-content">
          <div class="stat-value">{{ formatRating(coach.averageRating) }}</div>
          <div class="stat-label">平均评分</div>
        </div>
      </div>
    </div>

    <div class="coach-specialty" v-if="coach.specialty">
      <el-icon><List /></el-icon>
      <span class="specialty-text">{{ coach.specialty }}</span>
    </div>

    <div class="coach-introduction" v-if="coach.introduction">
      <p>{{ truncateText(coach.introduction, 60) }}</p>
    </div>

    <div class="coach-footer">
      <div class="coach-rate" v-if="coach.hourlyRate">
        <el-icon><Money /></el-icon>
        <span class="rate-text">¥{{ coach.hourlyRate }}/小时</span>
      </div>
      <el-button type="primary" size="small" @click.stop="handleViewDetail">
        查看详情
      </el-button>
    </div>
  </el-card>
</template>

<script setup>
import { User, UserFilled, Star, List, Money } from '@element-plus/icons-vue'
import { getCurrentInstance } from 'vue'

const props = defineProps({
  coach: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['view-detail'])

const { proxy } = getCurrentInstance()
const baseUrl = import.meta.env.VITE_APP_BASE_API || ''

// 获取头像URL
const getAvatarUrl = (avatar) => {
  if (!avatar || avatar === '' || avatar === 'null' || avatar === 'undefined') {
    return ''
  }
  
  // 如果已经是完整URL或base64，直接返回
  if (avatar.startsWith('http://') || avatar.startsWith('https://') || avatar.startsWith('data:')) {
    return avatar
  }
  
  // 如果已经包含baseUrl，直接返回
  if (avatar.startsWith(baseUrl)) {
    return avatar
  }
  
  // 处理相对路径，修复双斜杠问题
  let cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
  let cleanAvatar = avatar
  
  // 确保 avatar 以 / 开头
  if (!cleanAvatar.startsWith('/')) {
    cleanAvatar = '/' + cleanAvatar
  }
  
  // 去掉开头的多个斜杠，只保留一个
  cleanAvatar = cleanAvatar.replace(/^\/+/, '/')
  
  // 拼接 URL（确保没有双斜杠）
  return cleanBaseUrl + cleanAvatar
}

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

// 格式化评分
const formatRating = (rating) => {
  if (!rating || rating === 0) return '0.0'
  return parseFloat(rating).toFixed(1)
}

// 截断文本
const truncateText = (text, maxLength) => {
  if (!text) return ''
  if (text.length <= maxLength) return text
  return text.substring(0, maxLength) + '...'
}

// 卡片点击事件
const handleCardClick = () => {
  emit('view-detail', props.coach)
}

// 查看详情
const handleViewDetail = () => {
  emit('view-detail', props.coach)
}
</script>

<style scoped>
.coach-card {
  cursor: pointer;
  transition: all 0.3s;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.coach-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.coach-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #ebeef5;
}

.coach-avatar {
  flex-shrink: 0;
}

.coach-basic-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.coach-name {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
}

.coach-stats {
  display: flex;
  justify-content: space-around;
  margin-bottom: 15px;
  padding: 15px 0;
  background-color: #f5f7fa;
  border-radius: 8px;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
}

.stat-icon {
  font-size: 24px;
  color: #409eff;
}

.stat-content {
  text-align: center;
}

.stat-value {
  font-size: 20px;
  font-weight: 600;
  color: #303133;
}

.stat-label {
  font-size: 12px;
  color: #909399;
}

.coach-specialty {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
  padding: 8px 12px;
  background-color: #ecf5ff;
  border-radius: 4px;
  font-size: 14px;
  color: #409eff;
}

.specialty-text {
  flex: 1;
}

.coach-introduction {
  flex: 1;
  margin-bottom: 15px;
  color: #606266;
  font-size: 14px;
  line-height: 1.6;
}

.coach-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #ebeef5;
}

.coach-rate {
  display: flex;
  align-items: center;
  gap: 5px;
  color: #f56c6c;
  font-weight: 600;
  font-size: 16px;
}

.rate-text {
  color: #f56c6c;
}
</style>
