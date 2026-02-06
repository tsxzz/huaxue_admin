<template>
  <el-dialog
    v-model="visible"
    :title="course ? `${course.courseName} - 时间安排` : '时间安排'"
    width="800px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <div class="schedule-container" v-loading="loading">
      <el-table :data="scheduleList" border>
        <el-table-column label="日期" prop="scheduleDate" width="120" align="center">
          <template #default="scope">
            {{ formatDate(scope.row.scheduleDate) }}
          </template>
        </el-table-column>
        <el-table-column label="开始时间" prop="startTime" width="120" align="center">
          <template #default="scope">
            {{ formatTime(scope.row.startTime) }}
          </template>
        </el-table-column>
        <el-table-column label="结束时间" prop="endTime" width="120" align="center">
          <template #default="scope">
            {{ formatTime(scope.row.endTime) }}
          </template>
        </el-table-column>
        <el-table-column label="可预约名额" prop="availableSlots" width="100" align="center" />
        <el-table-column label="已预约名额" prop="bookedSlots" width="100" align="center" />
        <el-table-column label="剩余名额" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getRemainingTag(scope.row)">
              {{ scope.row.availableSlots - scope.row.bookedSlots }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" align="center" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              size="small"
              :disabled="scope.row.availableSlots <= scope.row.bookedSlots"
              @click="handleAppointment(scope.row)"
            >
              预约
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 预约确认对话框 -->
    <el-dialog
      v-model="appointmentFormVisible"
      title="确认预约"
      width="500px"
      append-to-body
    >
      <el-form :model="appointmentForm" label-width="100px" v-if="course">
        <el-form-item label="课程名称">
          <span>{{ course.courseName }}</span>
        </el-form-item>
        <el-form-item label="课程日期">
          <span>{{ formatDate(selectedSchedule.scheduleDate) }}</span>
        </el-form-item>
        <el-form-item label="课程时间">
          <span>{{ formatTime(selectedSchedule.startTime) }} - {{ formatTime(selectedSchedule.endTime) }}</span>
        </el-form-item>
        <el-form-item label="课程价格">
          <span style="color: #f56c6c; font-size: 18px; font-weight: 600">¥{{ course.price }}</span>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="appointmentFormVisible = false">取消</el-button>
          <el-button type="primary" @click="handleConfirmAppointment">确认预约</el-button>
        </div>
      </template>
    </el-dialog>
  </el-dialog>
</template>

<script setup>
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { publicGetCourseScheduleByCourseId } from '@/api/course'
import { addCourseAppointment } from '@/api/courseAppointment'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  course: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['update:modelValue', 'appointment-success'])

const visible = ref(false)
const loading = ref(false)
const scheduleList = ref([])
const appointmentFormVisible = ref(false)
const selectedSchedule = ref({})

const appointmentForm = ref({})

watch(() => props.modelValue, (val) => {
  visible.value = val
  if (val && props.course) {
    loadScheduleList()
  }
})

watch(visible, (val) => {
  emit('update:modelValue', val)
})

const loadScheduleList = async () => {
  if (!props.course?.id) return
  loading.value = true
  try {
    const response = await publicGetCourseScheduleByCourseId(props.course.id)
    // AjaxResult 返回的数据在 data 字段中
    scheduleList.value = (response && response.data) ? response.data : (Array.isArray(response) ? response : [])
  } catch (error) {
    ElMessage.error('加载时间安排失败')
  } finally {
    loading.value = false
  }
}

const handleAppointment = (schedule) => {
  if (!props.course) {
    ElMessage.error('课程信息不存在')
    return
  }
  if (schedule.availableSlots <= schedule.bookedSlots) {
    ElMessage.warning('该时间段已满，无法预约')
    return
  }
  selectedSchedule.value = schedule
  appointmentFormVisible.value = true
}

const handleConfirmAppointment = async () => {
  if (!props.course) {
    ElMessage.error('课程信息不存在')
    return
  }
  try {
    const appointmentData = {
      courseId: props.course.id,
      scheduleId: selectedSchedule.value.id,
      coachId: props.course.coachId,
      appointmentDate: selectedSchedule.value.scheduleDate,
      startTime: selectedSchedule.value.startTime,
      endTime: selectedSchedule.value.endTime,
      price: props.course.price,
      studentName: '' // 后端会自动设置
    }
    await addCourseAppointment(appointmentData)
    ElMessage.success('预约成功')
    appointmentFormVisible.value = false
    visible.value = false
    emit('appointment-success')
    loadScheduleList()
  } catch (error) {
    ElMessage.error('预约失败，请重试')
  }
}

const handleClose = () => {
  visible.value = false
  scheduleList.value = []
}

const formatDate = (date) => {
  if (!date) return ''
  return date
}

const formatTime = (time) => {
  if (!time) return ''
  return time.substring(0, 5)
}

const getRemainingTag = (schedule) => {
  const remaining = schedule.availableSlots - schedule.bookedSlots
  if (remaining === 0) return 'danger'
  if (remaining <= 2) return 'warning'
  return 'success'
}
</script>

<style scoped>
.schedule-container {
  padding: 10px 0;
}
</style>
