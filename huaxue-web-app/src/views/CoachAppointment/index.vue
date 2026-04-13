<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-header">
          <h2>
            <el-icon><Calendar /></el-icon>
            教练预约
          </h2>
        </div>
      </template>

      <!-- 标签页 -->
      <el-tabs v-model="activeTab" @tab-change="handleTabChange">
        <el-tab-pane label="课程预约" name="courses">
          <!-- 搜索区域 -->
      <div class="search-section">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-input
              v-model="queryParams.courseName"
              placeholder="请输入课程名称"
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
              v-model="queryParams.courseType"
              placeholder="课程类型"
              clearable
              @change="handleQuery"
            >
              <el-option label="全部" value="" />
              <el-option label="初级滑雪" value="初级滑雪" />
              <el-option label="中级滑雪" value="中级滑雪" />
              <el-option label="高级技巧" value="高级技巧" />
              <el-option label="自由式滑雪" value="自由式滑雪" />
              <el-option label="单板滑雪" value="单板滑雪" />
              <el-option label="双板滑雪" value="双板滑雪" />
            </el-select>
          </el-col>
          <el-col :span="4">
            <el-select
              v-model="queryParams.coachId"
              placeholder="选择教练"
              clearable
              filterable
              @change="handleQuery"
            >
              <el-option
                v-for="coach in coachList"
                :key="coach.id"
                :label="coach.user?.nickName || coach.user?.userName"
                :value="coach.userId"
              />
            </el-select>
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

      <!-- 课程列表 -->
      <div class="course-grid" v-loading="loading">
        <CoachCourseCard
          v-for="course in courseList"
          :key="course.id"
          :course="course"
          @view-schedule="handleViewSchedule"
        />
        <el-empty v-if="!loading && courseList.length === 0" description="暂无课程" />
      </div>

          <!-- 分页 -->
          <div class="pagination-container">
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
        </el-tab-pane>

        <el-tab-pane label="我的预约" name="myAppointments">
          <!-- 我的预约列表 -->
          <div class="appointment-section">
            <el-table v-loading="appointmentLoading" :data="appointmentList" border>
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
              <el-table-column label="操作" width="250" align="center" fixed="right">
                <template #default="scope">
                  <el-button
                    link
                    type="success"
                    size="small"
                    v-if="scope.row.paymentStatus === '0'"
                    @click="handlePayAppointment(scope.row)"
                  >
                    支付
                  </el-button>
                  <el-button
                    link
                    type="primary"
                    size="small"
                    v-if="scope.row.status !== '3' && scope.row.status !== '2'"
                    @click="handleCancelAppointment(scope.row)"
                  >
                    退课
                  </el-button>
                  <el-button
                    link
                    type="info"
                    size="small"
                    @click="handleViewAppointmentDetail(scope.row)"
                  >
                    详情
                  </el-button>
                </template>
              </el-table-column>
            </el-table>

            <!-- 分页 -->
            <div class="pagination-container">
              <el-pagination
                v-model:current-page="appointmentQueryParams.pageNum"
                v-model:page-size="appointmentQueryParams.pageSize"
                :page-sizes="[10, 20, 30, 50]"
                :total="appointmentTotal"
                layout="total, sizes, prev, pager, next, jumper"
                @size-change="loadMyAppointments"
                @current-change="loadMyAppointments"
              />
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <!-- 时间安排对话框 -->
    <ScheduleDialog
      v-model="scheduleVisible"
      :course="currentCourse"
      @appointment-success="handleAppointmentSuccess"
    />

    <!-- 预约详情对话框 -->
    <el-dialog
      v-model="appointmentDetailVisible"
      title="预约详情"
      width="600px"
    >
      <el-descriptions :column="2" border v-if="currentAppointment">
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
        <el-descriptions-item label="支付方式" v-if="currentAppointment.paymentMethod">
          <span v-if="currentAppointment.paymentMethod === '1'">现金</span>
          <span v-else-if="currentAppointment.paymentMethod === '2'">微信</span>
          <span v-else-if="currentAppointment.paymentMethod === '3'">支付宝</span>
          <span v-else-if="currentAppointment.paymentMethod === '4'">银行卡</span>
          <span v-else>-</span>
        </el-descriptions-item>
        <el-descriptions-item label="支付时间" v-if="currentAppointment.paymentTime">
          {{ currentAppointment.paymentTime }}
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

    <!-- 支付对话框 -->
    <el-dialog
      v-model="payAppointmentVisible"
      title="支付预约"
      width="500px"
    >
      <el-form :model="payForm" label-width="100px" v-if="currentAppointment">
        <el-form-item label="课程名称">
          <span>{{ currentAppointment.courseName }}</span>
        </el-form-item>
        <el-form-item label="预约日期">
          <span>{{ formatDate(currentAppointment.appointmentDate) }}</span>
        </el-form-item>
        <el-form-item label="课程时间">
          <span>{{ formatTime(currentAppointment.startTime) }} - {{ formatTime(currentAppointment.endTime) }}</span>
        </el-form-item>
        <el-form-item label="支付金额">
          <span style="color: #f56c6c; font-size: 18px; font-weight: 600">¥{{ currentAppointment.price }}</span>
        </el-form-item>
        <el-form-item label="支付方式" prop="paymentMethod">
          <el-radio-group v-model="payForm.paymentMethod">
            <el-radio label="1">现金</el-radio>
            <el-radio label="2">微信</el-radio>
            <el-radio label="3">支付宝</el-radio>
            <el-radio label="4">银行卡</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="payAppointmentVisible = false">取消</el-button>
          <el-button type="primary" @click="handleConfirmPayAppointment">确认支付</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 退课对话框 -->
    <el-dialog
      v-model="cancelAppointmentVisible"
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
          <el-button @click="cancelAppointmentVisible = false">取消</el-button>
          <el-button type="danger" @click="handleConfirmCancelAppointment">确认退课</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { Calendar, Search } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { publicListCourse, getCourse } from '@/api/course'
import { listCoachInfo } from '@/api/coachInfo'
import { listStudentAppointment, payCourseAppointment, cancelCourseAppointment, getCourseAppointment } from '@/api/courseAppointment'
import CoachCourseCard from './components/CoachCourseCard.vue'
import ScheduleDialog from './components/ScheduleDialog.vue'

const route = useRoute()
const activeTab = ref('courses')
const loading = ref(false)
const courseList = ref([])
const coachList = ref([])
const total = ref(0)
const scheduleVisible = ref(false)
const currentCourse = ref(null)

// 我的预约相关
const appointmentLoading = ref(false)
const appointmentList = ref([])
const appointmentTotal = ref(0)
const appointmentDetailVisible = ref(false)
const payAppointmentVisible = ref(false)
const cancelAppointmentVisible = ref(false)
const currentAppointment = ref(null)
const payForm = reactive({
  paymentMethod: '2' // 默认微信支付
})
const cancelForm = reactive({
  cancelReason: ''
})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 12,
  courseName: '',
  courseType: '',
  coachId: null
})

const appointmentQueryParams = reactive({
  pageNum: 1,
  pageSize: 10
})

const loadData = async () => {
  loading.value = true
  try {
    const response = await publicListCourse(queryParams)
    courseList.value = response.rows || []
    total.value = response.total || 0
  } catch (error) {
    console.error('加载课程列表失败', error)
  } finally {
    loading.value = false
  }
}

const loadCoachList = async () => {
  try {
    const response = await listCoachInfo({})
    coachList.value = response.rows || response.data || []
  } catch (error) {
    console.error('加载教练列表失败', error)
  }
}

const handleQuery = () => {
  queryParams.pageNum = 1
  loadData()
}

const handleReset = () => {
  queryParams.courseName = ''
  queryParams.courseType = ''
  queryParams.coachId = null
  handleQuery()
}

const handleViewSchedule = (course) => {
  currentCourse.value = course
  scheduleVisible.value = true
}

const handleAppointmentSuccess = () => {
  // 预约成功后可以刷新列表或显示提示
  loadData()
  // 如果当前在"我的预约"标签页，也刷新预约列表
  if (activeTab.value === 'myAppointments') {
    loadMyAppointments()
  }
}

const handleTabChange = (tabName) => {
  if (tabName === 'myAppointments') {
    loadMyAppointments()
  }
}

// 加载我的预约列表
const loadMyAppointments = async () => {
  appointmentLoading.value = true
  try {
    const response = await listStudentAppointment(appointmentQueryParams)
    appointmentList.value = response.rows || []
    appointmentTotal.value = response.total || 0
    
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
    appointmentLoading.value = false
  }
}

// 查看预约详情
const handleViewAppointmentDetail = async (row) => {
  try {
    const response = await getCourseAppointment(row.id)
    currentAppointment.value = response.data
    if (currentAppointment.value.courseId && !currentAppointment.value.courseName) {
      const courseResponse = await getCourse(currentAppointment.value.courseId)
      if (courseResponse.data) {
        currentAppointment.value.courseName = courseResponse.data.courseName
      }
    }
    appointmentDetailVisible.value = true
  } catch (error) {
    ElMessage.error('加载详情失败')
  }
}

// 支付
const handlePayAppointment = (row) => {
  currentAppointment.value = row
  payForm.paymentMethod = '2' // 默认微信支付
  payAppointmentVisible.value = true
}

// 确认支付
const handleConfirmPayAppointment = async () => {
  try {
    await payCourseAppointment(currentAppointment.value.id, payForm.paymentMethod)
    ElMessage.success('支付成功')
    payAppointmentVisible.value = false
    loadMyAppointments()
  } catch (error) {
    ElMessage.error('支付失败')
  }
}

// 退课
const handleCancelAppointment = (row) => {
  currentAppointment.value = row
  cancelForm.cancelReason = ''
  cancelAppointmentVisible.value = true
}

// 确认退课
const handleConfirmCancelAppointment = async () => {
  try {
    await cancelCourseAppointment(currentAppointment.value.id, cancelForm.cancelReason)
    ElMessage.success('退课成功')
    cancelAppointmentVisible.value = false
    loadMyAppointments()
  } catch (error) {
    ElMessage.error('退课失败')
  }
}

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  return date
}

// 格式化时间
const formatTime = (time) => {
  if (!time) return ''
  return time.substring(0, 5)
}

// 获取支付状态类型
const getPaymentStatusType = (status) => {
  const map = {
    '0': 'warning',
    '1': 'success',
    '2': 'info'
  }
  return map[status] || 'info'
}

// 获取支付状态文本
const getPaymentStatusText = (status) => {
  const map = {
    '0': '未支付',
    '1': '已支付',
    '2': '已退款'
  }
  return map[status] || '未知'
}

// 获取预约状态类型
const getStatusType = (status) => {
  const map = {
    '0': 'warning',
    '1': 'success',
    '2': 'info',
    '3': 'danger'
  }
  return map[status] || 'info'
}

// 获取预约状态文本
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
  const cid = route.query.coachId
  if (cid != null && cid !== '') {
    const n = Number(cid)
    if (!Number.isNaN(n)) {
      queryParams.coachId = n
    }
  }
  loadData()
  loadCoachList()
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

.course-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.pagination-container {
  margin-top: 20px;
  text-align: right;
}

.appointment-section {
  margin-top: 20px;
}
</style>
