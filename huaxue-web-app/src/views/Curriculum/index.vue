<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-header">
          <h2>
            <el-icon><Document /></el-icon>
            课程设置
          </h2>
        </div>
      </template>

      <div class="toolbar">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>
          新增课程
        </el-button>
      </div>

      <CourseList
        :course-list="courseList"
        :loading="loading"
        @schedule="handleSchedule"
        @update="handleUpdate"
        @delete="handleDelete"
      />

      <div class="pagination-container">
        <el-pagination
          v-model:current-page="queryParams.pageNum"
          v-model:page-size="queryParams.pageSize"
          :page-sizes="[10, 20, 30, 50]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleQuery"
          @current-change="handleQuery"
        />
      </div>
    </el-card>

    <!-- 课程表单 -->
    <CourseForm
      v-model="formVisible"
      :course="currentCourse"
      @submit="handleSubmit"
    />

    <!-- 时间安排对话框 -->
    <ScheduleDialog
      v-model="scheduleVisible"
      :course="currentCourse"
    />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Document, Plus } from '@element-plus/icons-vue'
import { listCourse, addCourse, updateCourse, delCourse } from '@/api/course'
import CourseList from './components/CourseList.vue'
import CourseForm from './components/CourseForm.vue'
import ScheduleDialog from './components/ScheduleDialog.vue'

const loading = ref(false)
const courseList = ref([])
const total = ref(0)
const formVisible = ref(false)
const scheduleVisible = ref(false)
const currentCourse = ref(null)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  courseName: '',
  courseType: '',
  status: '0'
})

const loadData = async () => {
  loading.value = true
  try {
    const response = await listCourse(queryParams)
    courseList.value = response.rows || []
    total.value = response.total || 0
  } catch (error) {
    ElMessage.error('加载课程列表失败')
  } finally {
    loading.value = false
  }
}

const handleQuery = () => {
  queryParams.pageNum = 1
  loadData()
}

const handleAdd = () => {
  currentCourse.value = null
  formVisible.value = true
}

const handleUpdate = (row) => {
  currentCourse.value = { ...row }
  formVisible.value = true
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除此课程吗？删除后相关的时间安排也会被删除。', '提示', {
      type: 'warning'
    })
    await delCourse(row.id)
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleSchedule = (row) => {
  currentCourse.value = row
  scheduleVisible.value = true
}

const handleSubmit = async (formData) => {
  try {
    if (formData.id) {
      await updateCourse(formData)
      ElMessage.success('修改成功')
    } else {
      await addCourse(formData)
      ElMessage.success('新增成功')
    }
    loadData()
  } catch (error) {
    ElMessage.error(formData.id ? '修改失败' : '新增失败')
  }
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

.toolbar {
  margin-bottom: 20px;
}

.pagination-container {
  margin-top: 20px;
  text-align: right;
}
</style>
