<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-header">
          <h2>
            <el-icon><List /></el-icon>
            约课管理
          </h2>
        </div>
      </template>

      <!-- 搜索区域 -->
      <div class="search-section">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-input
              v-model="queryParams.studentName"
              placeholder="请输入学员姓名"
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
              v-model="queryParams.status"
              placeholder="预约状态"
              clearable
              @change="handleQuery"
            >
              <el-option label="全部" value="" />
              <el-option label="待确认" value="0" />
              <el-option label="已确认" value="1" />
              <el-option label="已完成" value="2" />
              <el-option label="已取消" value="3" />
            </el-select>
          </el-col>
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
            <el-button type="primary" @click="handleQuery">
              <el-icon><Search /></el-icon>
              搜索
            </el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-col>
        </el-row>
      </div>

      <!-- 预约列表 -->
      <el-table v-loading="loading" :data="appointmentList" border>
        <el-table-column label="学员姓名" prop="studentName" width="120" />
        <el-table-column label="课程名称" prop="courseName" width="150" show-overflow-tooltip />
        <el-table-column label="预约日期" prop="appointmentDate" width="120" align="center">
          <template #default="scope">
            {{ formatDate(scope.row.appointmentDate) }}
          </template>
        </el-table-column>
        <el-table-column label="课程时间" width="180" align="center">
          <template #default="scope">
            {{ formatTime(scope.row.startTime) }} - {{ formatTime(scope.row.endTime) }}
          </template>
        </el-table-column>
        <el-table-column label="价格" prop="price" width="100" align="center">
          <template #default="scope">
            ¥{{ scope.row.price }}
          </template>
        </el-table-column>
        <el-table-column label="支付状态" prop="paymentStatus" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getPaymentStatusType(scope.row.paymentStatus)">
              {{ getPaymentStatusText(scope.row.paymentStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="预约状态" prop="status" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" align="center" />
        <el-table-column label="操作" width="280" align="center" fixed="right">
          <template #default="scope">
            <el-button
              link
              type="success"
              size="small"
              v-if="scope.row.status === '0'"
              @click="handleConfirm(scope.row)"
            >
              确认
            </el-button>
            <el-button
              link
              type="warning"
              size="small"
              v-if="scope.row.status === '1'"
              @click="handleComplete(scope.row)"
            >
              完成
            </el-button>
            <el-button
              link
              type="primary"
              size="small"
              v-if="scope.row.status !== '3' && scope.row.status !== '2'"
              @click="handleCancel(scope.row)"
            >
              退课
            </el-button>
            <el-button
              link
              type="info"
              size="small"
              @click="handleViewDetail(scope.row)"
            >
              详情
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
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

    <!-- 详情对话框 -->
    <el-dialog
      v-model="detailVisible"
      title="预约详情"
      width="600px"
    >
      <el-descriptions :column="2" border v-if="currentAppointment">
        <el-descriptions-item label="学员姓名">
          {{ currentAppointment.studentName }}
        </el-descriptions-item>
        <el-descriptions-item label="课程名称">
          {{ currentAppointment.courseName }}
        </el-descriptions-item>
        <el-descriptions-item label="预约日期">
          {{ formatDate(currentAppointment.appointmentDate) }}
        </el-descriptions-item>
        <el-descriptions-item label="课程时间">
          {{ formatTime(currentAppointment.startTime) }} - {{ formatTime(currentAppointment.endTime) }}
        </el-descriptions-item>
        <el-descriptions-item label="课程价格">
          ¥{{ currentAppointment.price }}
        </el-descriptions-item>
        <el-descriptions-item label="支付状态">
          <el-tag :type="getPaymentStatusType(currentAppointment.paymentStatus)">
            {{ getPaymentStatusText(currentAppointment.paymentStatus) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="预约状态">
          <el-tag :type="getStatusType(currentAppointment.status)">
            {{ getStatusText(currentAppointment.status) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="取消原因" v-if="currentAppointment.cancelReason">
          {{ currentAppointment.cancelReason }}
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">
          {{ currentAppointment.createTime }}
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>

    <!-- 退课对话框 -->
    <el-dialog
      v-model="cancelVisible"
      title="退课确认"
      width="500px"
    >
      <el-form :model="cancelForm" label-width="100px">
        <el-form-item label="取消原因">
          <el-input
            v-model="cancelForm.cancelReason"
            type="textarea"
            :rows="4"
            placeholder="请输入取消原因（可选）"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="cancelVisible = false">取消</el-button>
          <el-button type="danger" @click="handleConfirmCancel">确认退课</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { List, Search } from '@element-plus/icons-vue'
import { listCoachAppointment, confirmCourseAppointment, completeCourseAppointment, cancelCourseAppointment, getCourseAppointment } from '@/api/courseAppointment'
import { getCourse } from '@/api/course'

const loading = ref(false)
const appointmentList = ref([])
const total = ref(0)
const detailVisible = ref(false)
const cancelVisible = ref(false)
const currentAppointment = ref(null)
const dateRange = ref([])

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  studentName: '',
  status: '',
  startDate: '',
  endDate: ''
})

const cancelForm = reactive({
  cancelReason: ''
})

const loadData = async () => {
  loading.value = true
  try {
    const response = await listCoachAppointment(queryParams)
    appointmentList.value = response.rows || []
    total.value = response.total || 0
    
    // 加载课程名称
    for (const appointment of appointmentList.value) {
      if (appointment.courseId && !appointment.courseName) {
        try {
          const courseResponse = await getCourse(appointment.courseId)
          if (courseResponse.data) {
            appointment.courseName = courseResponse.data.courseName
          }
        } catch (error) {
          console.error('加载课程信息失败', error)
        }
      }
    }
  } catch (error) {
    ElMessage.error('加载预约列表失败')
  } finally {
    loading.value = false
  }
}

const handleQuery = () => {
  queryParams.pageNum = 1
  loadData()
}

const handleReset = () => {
  queryParams.studentName = ''
  queryParams.status = ''
  queryParams.startDate = ''
  queryParams.endDate = ''
  dateRange.value = []
  handleQuery()
}

const handleDateRangeChange = (dates) => {
  if (dates && dates.length === 2) {
    queryParams.startDate = dates[0]
    queryParams.endDate = dates[1]
  } else {
    queryParams.startDate = ''
    queryParams.endDate = ''
  }
  handleQuery()
}

const handleViewDetail = async (row) => {
  try {
    const response = await getCourseAppointment(row.id)
    currentAppointment.value = response.data
    if (currentAppointment.value.courseId && !currentAppointment.value.courseName) {
      const courseResponse = await getCourse(currentAppointment.value.courseId)
      if (courseResponse.data) {
        currentAppointment.value.courseName = courseResponse.data.courseName
      }
    }
    detailVisible.value = true
  } catch (error) {
    ElMessage.error('加载详情失败')
  }
}

// 确认预约
const handleConfirm = async (row) => {
  try {
    await ElMessageBox.confirm('确定要确认此预约吗？', '提示', {
      type: 'warning'
    })
    await confirmCourseAppointment(row.id)
    ElMessage.success('确认成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('确认失败')
    }
  }
}

// 完成预约
const handleComplete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要标记此预约为已完成吗？', '提示', {
      type: 'warning'
    })
    await completeCourseAppointment(row.id)
    ElMessage.success('操作成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('操作失败')
    }
  }
}

const handleCancel = (row) => {
  currentAppointment.value = row
  cancelForm.cancelReason = ''
  cancelVisible.value = true
}

const handleConfirmCancel = async () => {
  try {
    await cancelCourseAppointment(currentAppointment.value.id, cancelForm.cancelReason)
    ElMessage.success('退课成功')
    cancelVisible.value = false
    loadData()
  } catch (error) {
    ElMessage.error('退课失败')
  }
}

const formatDate = (date) => {
  if (!date) return ''
  return date
}

const formatTime = (time) => {
  if (!time) return ''
  return time.substring(0, 5)
}

const getPaymentStatusType = (status) => {
  const map = {
    '0': 'warning',
    '1': 'success',
    '2': 'info'
  }
  return map[status] || 'info'
}

const getPaymentStatusText = (status) => {
  const map = {
    '0': '未支付',
    '1': '已支付',
    '2': '已退款'
  }
  return map[status] || '未知'
}

const getStatusType = (status) => {
  const map = {
    '0': 'warning',
    '1': 'success',
    '2': 'info',
    '3': 'danger'
  }
  return map[status] || 'info'
}

const getStatusText = (status) => {
  const map = {
    '0': '待确认',
    '1': '已确认',
    '2': '已完成',
    '3': '已取消'
  }
  return map[status] || '未知'
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

.search-section {
  margin-bottom: 20px;
}

.pagination-container {
  margin-top: 20px;
  text-align: right;
}
</style>
