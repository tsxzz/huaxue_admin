<template>
  <el-card class="course-card" shadow="hover">
    <div class="course-header">
      <h3>{{ course.courseName }}</h3>
      <el-tag :type="getCourseTypeTag(course.courseType)">
        {{ course.courseType }}
      </el-tag>
    </div>
    <div class="course-info">
      <div class="info-item">
        <el-icon><Clock /></el-icon>
        <span>时长：{{ course.duration }}分钟</span>
      </div>
      <div class="info-item">
        <el-icon><Money /></el-icon>
        <span>价格：¥{{ course.price }}</span>
      </div>
      <div class="info-item">
        <el-icon><User /></el-icon>
        <span>最大学员数：{{ course.maxStudents }}人</span>
      </div>
    </div>
    <div class="course-description" v-if="course.description">
      <p>{{ course.description }}</p>
    </div>
    <div class="course-footer">
      <el-button type="primary" @click="handleViewSchedule">
        查看时间安排
      </el-button>
    </div>
  </el-card>
</template>

<script setup>
import { Clock, Money, User } from '@element-plus/icons-vue'

const props = defineProps({
  course: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['view-schedule'])

const getCourseTypeTag = (type) => {
  const map = {
    '初级滑雪': 'success',
    '中级滑雪': 'warning',
    '高级技巧': 'danger',
    '自由式滑雪': 'info'
  }
  return map[type] || 'info'
}

const handleViewSchedule = () => {
  emit('view-schedule', props.course)
}
</script>

<style scoped>
.course-card {
  margin-bottom: 20px;
  transition: all 0.3s;
}

.course-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.course-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
}

.course-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #303133;
}

.course-info {
  margin-bottom: 15px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  color: #606266;
  font-size: 14px;
}

.course-description {
  margin-bottom: 15px;
  padding: 10px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.course-description p {
  margin: 0;
  color: #606266;
  font-size: 14px;
  line-height: 1.6;
}

.course-footer {
  text-align: right;
  padding-top: 10px;
  border-top: 1px solid #ebeef5;
}
</style>
