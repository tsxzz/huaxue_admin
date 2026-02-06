<template>
  <el-dialog
    v-model="visible"
    :title="course ? `${course.courseName} - 时间安排` : '时间安排'"
    width="900px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <div class="schedule-container">
      <div class="schedule-header">
        <el-button type="primary" @click="handleAddSchedule">
          <el-icon><Plus /></el-icon>
          添加时间安排
        </el-button>
      </div>
      <el-table :data="scheduleList" border v-loading="loading">
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
        <el-table-column label="状态" prop="status" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" align="center" fixed="right">
          <template #default="scope">
            <el-button link type="primary" size="small" @click="handleEdit(scope.row)">
              修改
            </el-button>
            <el-button link type="danger" size="small" @click="handleDelete(scope.row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 时间安排表单对话框 -->
    <el-dialog
      v-model="scheduleFormVisible"
      :title="scheduleForm.id ? '修改时间安排' : '添加时间安排'"
      width="500px"
      append-to-body
    >
      <el-form ref="scheduleFormRef" :model="scheduleForm" :rules="scheduleRules" label-width="100px">
        <el-form-item label="课程日期" prop="scheduleDate">
          <el-date-picker
            v-model="scheduleForm.scheduleDate"
            type="date"
            placeholder="选择日期"
            style="width: 100%"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-time-picker
            v-model="scheduleForm.startTime"
            format="HH:mm"
            value-format="HH:mm:ss"
            placeholder="选择开始时间"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-time-picker
            v-model="scheduleForm.endTime"
            format="HH:mm"
            value-format="HH:mm:ss"
            placeholder="选择结束时间"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="可预约名额" prop="availableSlots">
          <el-input-number
            v-model="scheduleForm.availableSlots"
            :min="1"
            :max="10"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="scheduleFormVisible = false">取消</el-button>
          <el-button type="primary" @click="handleScheduleSubmit">确定</el-button>
        </div>
      </template>
    </el-dialog>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { getCourseScheduleByCourseId, addCourseSchedule, updateCourseSchedule, delCourseSchedule } from '@/api/course'

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

const emit = defineEmits(['update:modelValue'])

const visible = ref(false)
const scheduleFormVisible = ref(false)
const loading = ref(false)
const scheduleList = ref([])
const scheduleFormRef = ref(null)

const scheduleForm = reactive({
  id: null,
  courseId: null,
  scheduleDate: '',
  startTime: '',
  endTime: '',
  availableSlots: 1
})

const scheduleRules = {
  scheduleDate: [
    { required: true, message: '请选择课程日期', trigger: 'change' }
  ],
  startTime: [
    { required: true, message: '请选择开始时间', trigger: 'change' }
  ],
  endTime: [
    { required: true, message: '请选择结束时间', trigger: 'change' }
  ],
  availableSlots: [
    { required: true, message: '请输入可预约名额', trigger: 'blur' }
  ]
}

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
    const response = await getCourseScheduleByCourseId(props.course.id)
    // AjaxResult 返回的数据在 data 字段中
    scheduleList.value = (response && response.data) ? response.data : (Array.isArray(response) ? response : [])
  } catch (error) {
    ElMessage.error('加载时间安排失败')
  } finally {
    loading.value = false
  }
}

const handleAddSchedule = () => {
  if (!props.course || !props.course.id) {
    ElMessage.error('课程信息不存在')
    return
  }
  resetScheduleForm()
  scheduleForm.courseId = props.course.id
  scheduleFormVisible.value = true
}

const handleEdit = (row) => {
  if (!props.course || !props.course.id) {
    ElMessage.error('课程信息不存在')
    return
  }
  scheduleForm.id = row.id
  scheduleForm.courseId = row.courseId
  scheduleForm.scheduleDate = row.scheduleDate
  scheduleForm.startTime = row.startTime
  scheduleForm.endTime = row.endTime
  scheduleForm.availableSlots = row.availableSlots
  scheduleFormVisible.value = true
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除此时间安排吗？', '提示', {
      type: 'warning'
    })
    await delCourseSchedule(row.id)
    ElMessage.success('删除成功')
    loadScheduleList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleScheduleSubmit = () => {
  scheduleFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (scheduleForm.id) {
          await updateCourseSchedule(scheduleForm)
          ElMessage.success('修改成功')
        } else {
          await addCourseSchedule(scheduleForm)
          ElMessage.success('添加成功')
        }
        scheduleFormVisible.value = false
        loadScheduleList()
      } catch (error) {
        ElMessage.error(scheduleForm.id ? '修改失败' : '添加失败')
      }
    }
  })
}

const resetScheduleForm = () => {
  scheduleForm.id = null
  scheduleForm.courseId = null
  scheduleForm.scheduleDate = ''
  scheduleForm.startTime = ''
  scheduleForm.endTime = ''
  scheduleForm.availableSlots = 1
  scheduleFormRef.value?.clearValidate()
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

const getStatusType = (status) => {
  const map = {
    '0': 'success',
    '1': 'warning',
    '2': 'danger'
  }
  return map[status] || 'info'
}

const getStatusText = (status) => {
  const map = {
    '0': '可预约',
    '1': '已满',
    '2': '已取消'
  }
  return map[status] || '未知'
}
</script>

<style scoped>
.schedule-container {
  padding: 10px 0;
}

.schedule-header {
  margin-bottom: 15px;
  text-align: right;
}
</style>
