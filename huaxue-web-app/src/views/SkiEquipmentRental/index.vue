<template>
  <div class="equipment-rental-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><ShoppingCart /></el-icon>
          <h1>雪具租赁</h1>
        </div>
        <p class="header-desc">选择可租赁的雪具，填写租赁信息完成租赁</p>
      </div>
      <el-button type="primary" icon="List" @click="showRentalList = !showRentalList">
        {{ showRentalList ? '返回租赁' : '查看租赁记录' }}
      </el-button>
    </div>

    <!-- 租赁记录列表 -->
    <div v-if="showRentalList" class="rental-list-section">
      <el-card class="search-card" shadow="never">
        <el-form :inline="true" :model="rentalQueryParams" class="search-form">
          <el-form-item label="租赁单号">
            <el-input
              v-model="rentalQueryParams.rentalNo"
              placeholder="请输入租赁单号"
              clearable
              style="width: 200px"
              @keyup.enter="handleRentalQuery"
            />
          </el-form-item>
          <el-form-item label="租赁人">
            <el-input
              v-model="rentalQueryParams.renterName"
              placeholder="请输入租赁人姓名"
              clearable
              style="width: 150px"
            />
          </el-form-item>
          <el-form-item label="电话">
            <el-input
              v-model="rentalQueryParams.renterPhone"
              placeholder="请输入电话"
              clearable
              style="width: 150px"
            />
          </el-form-item>
          <el-form-item label="状态">
            <el-select
              v-model="rentalQueryParams.status"
              placeholder="请选择状态"
              clearable
              style="width: 150px"
            >
              <el-option label="待支付" :value="0" />
              <el-option label="租赁中" :value="1" />
              <el-option label="已归还" :value="2" />
              <el-option label="已取消" :value="3" />
              <el-option label="逾期" :value="4" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="Search" @click="handleRentalQuery">查询</el-button>
            <el-button icon="Refresh" @click="resetRentalQuery">重置</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <el-table
        v-loading="rentalLoading"
        :data="rentalList"
        stripe
        style="width: 100%"
      >
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="rentalNo" label="租赁单号" width="180" />
        <el-table-column prop="equipmentName" label="雪具名称" min-width="150" />
        <el-table-column prop="rentalQuantity" label="租赁数量" width="100" align="center" />
        <el-table-column prop="renterName" label="租赁人" width="120" />
        <el-table-column prop="renterPhone" label="电话" width="130" />
        <el-table-column prop="rentalStartTime" label="开始时间" width="180" />
        <el-table-column prop="expectedReturnTime" label="预计归还" width="180" />
        <el-table-column prop="rentalDays" label="租赁天数" width="100" align="center" />
        <el-table-column prop="totalAmount" label="总金额" width="100" align="right">
          <template #default="scope">
            <span v-if="scope.row.totalAmount">¥{{ scope.row.totalAmount }}</span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getRentalStatusType(scope.row.status)">
              {{ getRentalStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right" align="center">
          <template #default="scope">
            <el-button
              v-if="scope.row.status === 1"
              type="success"
              size="small"
              icon="CircleCheck"
              @click="handleReturn(scope.row)"
            >
              归还
            </el-button>
            <el-button
              v-if="scope.row.status === 0 || scope.row.status === 1"
              type="warning"
              size="small"
              icon="Close"
              @click="handleCancel(scope.row)"
            >
              取消
            </el-button>
            <el-button
              type="danger"
              size="small"
              icon="Delete"
              @click="handleDeleteRental(scope.row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="rentalTotal > 0"
        :total="rentalTotal"
        v-model:page="rentalQueryParams.pageNum"
        v-model:limit="rentalQueryParams.pageSize"
        @pagination="getRentalList"
      />
    </div>

    <!-- 可租赁雪具列表 -->
    <div v-else class="rental-equipment-section">
      <!-- 分类筛选 -->
      <el-card class="filter-card" shadow="never">
        <el-radio-group v-model="selectedCategory" @change="handleCategoryChange">
          <el-radio-button label="">全部</el-radio-button>
          <el-radio-button label="1">双板滑雪板</el-radio-button>
          <el-radio-button label="2">单板滑雪板</el-radio-button>
          <el-radio-button label="3">滑雪杖</el-radio-button>
          <el-radio-button label="4">头盔</el-radio-button>
          <el-radio-button label="5">护目镜</el-radio-button>
          <el-radio-button label="6">滑雪服</el-radio-button>
        </el-radio-group>
      </el-card>

      <!-- 可租赁雪具列表 -->
      <div class="equipment-grid" v-loading="loading">
        <el-empty v-if="availableEquipmentList.length === 0 && !loading" description="暂无可租赁的雪具" :image-size="200" />
        
        <el-row :gutter="20">
          <el-col
            v-for="equipment in availableEquipmentList"
            :key="equipment.id"
            :xs="24"
            :sm="12"
            :md="8"
            :lg="6"
            class="equipment-col"
          >
            <el-card class="equipment-card" shadow="hover">
              <div class="card-image">
                <el-image
                  v-if="equipment.imageUrl"
                  :src="getImageUrl(equipment.imageUrl)"
                  :preview-src-list="[getImageUrl(equipment.imageUrl)]"
                  fit="cover"
                  style="width: 100%; height: 200px;"
                >
                  <template #error>
                    <div class="image-slot">
                      <el-icon><Picture /></el-icon>
                    </div>
                  </template>
                </el-image>
                <div v-else class="image-slot">
                  <el-icon><Picture /></el-icon>
                </div>
              </div>
              <div class="card-content">
                <h3>{{ equipment.name }}</h3>
                <div class="card-info">
                  <div class="info-item">
                    <span class="label">品牌：</span>
                    <span>{{ equipment.brand || '-' }}</span>
                  </div>
                  <div class="info-item">
                    <span class="label">型号：</span>
                    <span>{{ equipment.model || '-' }}</span>
                  </div>
                  <div class="info-item">
                    <span class="label">可用数量：</span>
                    <span class="quantity">{{ equipment.availableQuantity || 0 }}</span>
                  </div>
                  <div class="info-item">
                    <span class="label">租赁价格：</span>
                    <span class="price">¥{{ equipment.rentalPrice || 0 }}/天</span>
                  </div>
                </div>
                <el-button
                  type="primary"
                  :disabled="!equipment.availableQuantity || equipment.availableQuantity === 0"
                  style="width: 100%; margin-top: 10px;"
                  @click="handleRent(equipment)"
                >
                  {{ equipment.availableQuantity > 0 ? '立即租赁' : '暂无库存' }}
                </el-button>
              </div>
            </el-card>
          </el-col>
        </el-row>
        
        <!-- 分页组件 -->
        <pagination
          v-show="equipmentTotal > 0"
          :total="equipmentTotal"
          :page="equipmentQueryParams.pageNum"
          :limit="equipmentQueryParams.pageSize"
          @pagination="handleEquipmentPageChange"
        />
      </div>
    </div>

    <!-- 租赁对话框 -->
    <el-dialog
      v-model="rentalDialogVisible"
      title="雪具租赁"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="rentalFormRef"
        :model="rentalForm"
        :rules="rentalRules"
        label-width="120px"
      >
        <el-form-item label="雪具名称">
          <el-input v-model="rentalForm.equipmentName" disabled />
        </el-form-item>
        <el-form-item label="可用数量">
          <el-input v-model="rentalForm.availableQuantity" disabled />
        </el-form-item>
        <el-form-item label="租赁数量" prop="rentalQuantity">
          <el-input-number
            v-model="rentalForm.rentalQuantity"
            :min="1"
            :max="rentalForm.availableQuantity"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="租赁人姓名" prop="renterName">
          <el-input v-model="rentalForm.renterName" placeholder="请输入租赁人姓名" />
        </el-form-item>
        <el-form-item label="租赁人电话" prop="renterPhone">
          <el-input v-model="rentalForm.renterPhone" placeholder="请输入租赁人电话" />
        </el-form-item>
        <el-form-item label="身份证号" prop="renterIdCard">
          <el-input v-model="rentalForm.renterIdCard" placeholder="请输入身份证号（可选）" />
        </el-form-item>
        <el-form-item label="租赁开始时间" prop="rentalStartTime">
          <el-date-picker
            v-model="rentalForm.rentalStartTime"
            type="datetime"
            placeholder="选择开始时间"
            style="width: 100%"
            value-format="YYYY-MM-DD HH:mm:ss"
          />
        </el-form-item>
        <el-form-item label="预计归还时间" prop="expectedReturnTime">
          <el-date-picker
            v-model="rentalForm.expectedReturnTime"
            type="datetime"
            placeholder="选择归还时间"
            style="width: 100%"
            value-format="YYYY-MM-DD HH:mm:ss"
            :disabled-date="disabledDate"
          />
        </el-form-item>
        <el-form-item label="押金">
          <el-input-number
            v-model="rentalForm.deposit"
            :min="0"
            :precision="2"
            style="width: 100%"
            placeholder="请输入押金（可选）"
          />
        </el-form-item>
        <el-form-item label="备注">
          <el-input
            v-model="rentalForm.remark"
            type="textarea"
            :rows="3"
            placeholder="请输入备注（可选）"
          />
        </el-form-item>
        <el-form-item label="预计费用">
          <div class="fee-info">
            <div>单价：¥{{ rentalForm.unitPrice || 0 }}/天</div>
            <div>天数：{{ rentalForm.rentalDays || 0 }} 天</div>
            <div class="total-fee">总金额：¥{{ rentalForm.totalAmount || 0 }}</div>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="rentalDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmitRental" :loading="submitLoading">确认租赁</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ShoppingCart, List, Search, Refresh, CircleCheck, Close, Delete, Picture } from '@element-plus/icons-vue'
import { listEquipment } from '@/api/equipment'
import { listRental, addRental, delRental, returnEquipment, cancelRental } from '@/api/equipmentRental'
import Pagination from '@/components/Pagination/index.vue'

// 响应式数据
const loading = ref(false)
const rentalLoading = ref(false)
const submitLoading = ref(false)
const showRentalList = ref(false)
const availableEquipmentList = ref([]) // 当前页显示的数据
const allAvailableEquipmentList = ref([]) // 所有有可用数量的雪具（用于前端分页）
const equipmentTotal = ref(0) // 可租赁雪具总数（过滤后的总数）
const equipmentQueryParams = reactive({
  pageNum: 1,
  pageSize: 12 // 每页显示12个（卡片式布局，3x4或4x3）
})
const rentalList = ref([])
const rentalTotal = ref(0)
const rentalDialogVisible = ref(false)
const rentalFormRef = ref(null)
const selectedCategory = ref('')

const rentalForm = reactive({
  equipmentId: null,
  equipmentName: '',
  availableQuantity: 0,
  rentalQuantity: 1,
  renterName: '',
  renterPhone: '',
  renterIdCard: '',
  rentalStartTime: '',
  expectedReturnTime: '',
  deposit: null,
  remark: '',
  unitPrice: null,
  rentalDays: 0,
  totalAmount: null,
  status: 1 // 直接设为租赁中
})

const rentalQueryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  rentalNo: '',
  renterName: '',
  renterPhone: '',
  status: null
})

const rentalRules = {
  rentalQuantity: [
    { required: true, message: '请输入租赁数量', trigger: 'blur' },
    { type: 'number', min: 1, message: '租赁数量必须大于0', trigger: 'blur' }
  ],
  renterName: [
    { required: true, message: '请输入租赁人姓名', trigger: 'blur' }
  ],
  renterPhone: [
    { required: true, message: '请输入租赁人电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ],
  rentalStartTime: [
    { required: true, message: '请选择租赁开始时间', trigger: 'change' }
  ],
  expectedReturnTime: [
    { required: true, message: '请选择预计归还时间', trigger: 'change' }
  ]
}

// 获取图片URL
const getImageUrl = (url) => {
  if (!url) return ''
  const baseUrl = import.meta.env.VITE_APP_BASE_API || ''
  
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url
  }
  
  if (url.startsWith(baseUrl)) {
    return url
  }
  
  if (url.startsWith('/profile/')) {
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    return cleanBaseUrl + url
  }
  
  const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
  return cleanBaseUrl + '/profile/upload/' + url
}

// 获取租赁状态类型
const getRentalStatusType = (status) => {
  const typeMap = {
    0: 'info',    // 待支付
    1: 'success', // 租赁中
    2: '',        // 已归还
    3: 'warning', // 已取消
    4: 'danger'   // 逾期
  }
  return typeMap[status] || 'info'
}

// 获取租赁状态文本
const getRentalStatusText = (status) => {
  const textMap = {
    0: '待支付',
    1: '租赁中',
    2: '已归还',
    3: '已取消',
    4: '逾期'
  }
  return textMap[status] || '未知'
}

// 查询可租赁雪具列表（使用雪具管理的数据，支持分页）
const getAvailableEquipmentList = async () => {
  loading.value = true
  try {
    // 不限制状态，查询所有雪具（使用雪具管理的数据源）
    const queryParams = {
      pageNum: equipmentQueryParams.pageNum,
      pageSize: equipmentQueryParams.pageSize
    }
    if (selectedCategory.value) {
      queryParams.category = selectedCategory.value
    }
    
    // 将分页参数放到params中，供后端PageHelper使用
    if (!queryParams.params) {
      queryParams.params = {}
    }
    queryParams.params.pageNum = equipmentQueryParams.pageNum
    queryParams.params.pageSize = equipmentQueryParams.pageSize
    
    const response = await listEquipment(queryParams)
    if (response.code === 200) {
      // 显示所有雪具，不进行过滤（保证分页准确）
      // 只有 availableQuantity > 0 的才能租赁（通过按钮禁用状态控制）
      availableEquipmentList.value = response.rows || []
      equipmentTotal.value = response.total || 0
    } else {
      ElMessage.error(response.msg || '查询失败')
    }
  } catch (error) {
    console.error('查询可租赁雪具列表失败:', error)
    ElMessage.error('查询失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 查询租赁记录列表
const getRentalList = async () => {
  rentalLoading.value = true
  try {
    const response = await listRental(rentalQueryParams)
    if (response.code === 200) {
      rentalList.value = response.rows || []
      rentalTotal.value = response.total || 0
    } else {
      ElMessage.error(response.msg || '查询失败')
    }
  } catch (error) {
    console.error('查询租赁记录失败:', error)
    ElMessage.error('查询失败，请稍后重试')
  } finally {
    rentalLoading.value = false
  }
}

// 分类变化
const handleCategoryChange = () => {
  equipmentQueryParams.pageNum = 1 // 切换分类时重置到第一页
  getAvailableEquipmentList()
}

// 分页变化
const handleEquipmentPageChange = (pagination) => {
  if (pagination) {
    equipmentQueryParams.pageNum = pagination.page
    equipmentQueryParams.pageSize = pagination.limit
  }
  getAvailableEquipmentList()
}

// 查询租赁记录
const handleRentalQuery = () => {
  rentalQueryParams.pageNum = 1
  getRentalList()
}

// 重置查询
const resetRentalQuery = () => {
  rentalQueryParams.rentalNo = ''
  rentalQueryParams.renterName = ''
  rentalQueryParams.renterPhone = ''
  rentalQueryParams.status = null
  handleRentalQuery()
}

// 打开租赁对话框
const handleRent = (equipment) => {
  if (!equipment.availableQuantity || equipment.availableQuantity === 0) {
    ElMessage.warning('该雪具暂无可用数量')
    return
  }
  
  // 重置表单
  Object.assign(rentalForm, {
    equipmentId: equipment.id,
    equipmentName: equipment.name,
    availableQuantity: equipment.availableQuantity,
    rentalQuantity: 1,
    renterName: '',
    renterPhone: '',
    renterIdCard: '',
    rentalStartTime: '',
    expectedReturnTime: '',
    deposit: null,
    remark: '',
    unitPrice: equipment.rentalPrice || null,
    rentalDays: 0,
    totalAmount: null
  })
  
  rentalDialogVisible.value = true
}

// 禁用日期（归还时间不能早于开始时间）
const disabledDate = (time) => {
  if (rentalForm.rentalStartTime) {
    const startTime = new Date(rentalForm.rentalStartTime)
    return time.getTime() < startTime.getTime()
  }
  return false
}

// 计算费用
const calculateFee = () => {
  if (rentalForm.rentalStartTime && rentalForm.expectedReturnTime && rentalForm.unitPrice) {
    const start = new Date(rentalForm.rentalStartTime)
    const end = new Date(rentalForm.expectedReturnTime)
    const days = Math.ceil((end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24))
    rentalForm.rentalDays = days > 0 ? days : 1
    
    if (rentalForm.rentalQuantity && rentalForm.unitPrice) {
      rentalForm.totalAmount = rentalForm.unitPrice * rentalForm.rentalQuantity * rentalForm.rentalDays
    }
  }
}

// 监听时间变化，自动计算费用
watch([() => rentalForm.rentalStartTime, () => rentalForm.expectedReturnTime, () => rentalForm.rentalQuantity], () => {
  calculateFee()
})

// 提交租赁
const handleSubmitRental = () => {
  rentalFormRef.value?.validate((valid) => {
    if (valid) {
      if (rentalForm.rentalQuantity > rentalForm.availableQuantity) {
        ElMessage.warning('租赁数量不能超过可用数量')
        return
      }
      
      submitLoading.value = true
      addRental(rentalForm).then(response => {
        if (response.code === 200) {
          ElMessage.success('租赁成功')
          rentalDialogVisible.value = false
          getAvailableEquipmentList() // 刷新可租赁列表
        } else {
          ElMessage.error(response.msg || '租赁失败')
        }
      }).catch(error => {
        console.error('租赁失败:', error)
        ElMessage.error(error.msg || '租赁失败')
      }).finally(() => {
        submitLoading.value = false
      })
    } else {
      ElMessage.warning('请完善表单信息')
    }
  })
}

// 归还
const handleReturn = (row) => {
  ElMessageBox.confirm(
    `确定要归还"${row.equipmentName}"吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    returnEquipment(row.id).then(response => {
      if (response.code === 200) {
        ElMessage.success('归还成功')
        getRentalList()
        getAvailableEquipmentList() // 刷新可租赁列表
      } else {
        ElMessage.error(response.msg || '归还失败')
      }
    }).catch(error => {
      console.error('归还失败:', error)
      ElMessage.error(error.msg || '归还失败')
    })
  }).catch(() => {})
}

// 取消租赁
const handleCancel = (row) => {
  ElMessageBox.confirm(
    `确定要取消租赁"${row.equipmentName}"吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    cancelRental(row.id).then(response => {
      if (response.code === 200) {
        ElMessage.success('取消成功')
        getRentalList()
        getAvailableEquipmentList() // 刷新可租赁列表
      } else {
        ElMessage.error(response.msg || '取消失败')
      }
    }).catch(error => {
      console.error('取消失败:', error)
      ElMessage.error(error.msg || '取消失败')
    })
  }).catch(() => {})
}

// 删除租赁记录
const handleDeleteRental = (row) => {
  ElMessageBox.confirm(
    `确定要删除租赁记录"${row.rentalNo}"吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    delRental([row.id]).then(response => {
      if (response.code === 200) {
        ElMessage.success('删除成功')
        getRentalList()
        getAvailableEquipmentList() // 刷新可租赁列表
      } else {
        ElMessage.error(response.msg || '删除失败')
      }
    }).catch(error => {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    })
  }).catch(() => {})
}

// 监听显示租赁列表
watch(showRentalList, (val) => {
  if (val) {
    getRentalList()
  } else {
    getAvailableEquipmentList()
  }
})

onMounted(() => {
  getAvailableEquipmentList()
})
</script>

<style scoped lang="scss">
.equipment-rental-container {
  min-height: calc(100vh - 84px);
  background: linear-gradient(135deg, #667eea 0%, #d6cedf 100%);
  padding: 20px;
  
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    
    .header-content {
      .header-title {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 10px;
        
        .title-icon {
          font-size: 32px;
          color: white;
        }
        
        h1 {
          margin: 0;
          font-size: 32px;
          font-weight: bold;
          color: white;
          text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }
      }
      
      .header-desc {
        margin: 0;
        font-size: 16px;
        color: white;
        opacity: 0.9;
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
      }
    }
  }
  
  .filter-card {
    margin-bottom: 20px;
    border-radius: 8px;
  }
  
  .equipment-grid {
    .equipment-col {
      margin-bottom: 20px;
    }
    
    .equipment-card {
      border-radius: 12px;
      overflow: hidden;
      transition: all 0.3s;
      
      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
      }
      
      .card-image {
        width: 100%;
        height: 200px;
        overflow: hidden;
        background: #f5f7fa;
        
        .image-slot {
          display: flex;
          justify-content: center;
          align-items: center;
          width: 100%;
          height: 100%;
          color: #909399;
          font-size: 48px;
        }
      }
      
      .card-content {
        padding: 15px;
        
        h3 {
          margin: 0 0 12px 0;
          font-size: 18px;
          font-weight: bold;
          color: #303133;
        }
        
        .card-info {
          .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
            
            .label {
              color: #909399;
            }
            
            .quantity {
              color: #67c23a;
              font-weight: 600;
            }
            
            .price {
              color: #f56c6c;
              font-weight: 600;
            }
          }
        }
      }
    }
  }
  
  .rental-list-section {
    background: white;
    border-radius: 8px;
    padding: 20px;
    
    .search-card {
      margin-bottom: 20px;
      border-radius: 8px;
    }
  }
  
  .fee-info {
    padding: 10px;
    background: #f5f7fa;
    border-radius: 4px;
    
    div {
      margin-bottom: 5px;
      font-size: 14px;
      
      &.total-fee {
        margin-top: 10px;
        padding-top: 10px;
        border-top: 1px solid #dcdfe6;
        font-size: 16px;
        font-weight: bold;
        color: #f56c6c;
      }
    }
  }
}
</style>
