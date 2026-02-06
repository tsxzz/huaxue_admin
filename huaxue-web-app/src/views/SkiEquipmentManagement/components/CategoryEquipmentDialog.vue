<template>
  <el-dialog
    v-model="visible"
    :title="dialogTitle"
    width="90%"
    :close-on-click-modal="false"
    @close="handleClose"
    class="category-equipment-dialog"
  >
    <!-- 搜索和操作栏 -->
    <el-card class="toolbar-card" shadow="never">
      <el-row :gutter="20">
        <el-col :span="18">
          <el-form :model="queryParams" :inline="true" class="search-form">
            <el-form-item label="雪具名称">
              <el-input
                v-model="queryParams.name"
                placeholder="请输入雪具名称"
                clearable
                style="width: 200px"
                @keyup.enter="handleQuery"
              >
                <template #prefix>
                  <el-icon><Search /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item label="品牌">
              <el-input
                v-model="queryParams.brand"
                placeholder="请输入品牌"
                clearable
                style="width: 150px"
              />
            </el-form-item>
            
            <el-form-item label="状态">
              <el-select
                v-model="queryParams.status"
                placeholder="请选择状态"
                clearable
                style="width: 150px"
              >
                <el-option label="缺货" :value="0" />
                <el-option label="可用" :value="1" />
                <el-option label="部分可用" :value="2" />
                <el-option label="维修中" :value="3" />
              </el-select>
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
              <el-button icon="Refresh" @click="resetQuery">重置</el-button>
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="6" style="text-align: right">
          <el-button type="primary" icon="Plus" @click="handleAdd">新增雪具</el-button>
        </el-col>
      </el-row>
    </el-card>

    <!-- 雪具列表 -->
    <div class="equipment-list" v-loading="loading">
      <el-empty v-if="equipmentList.length === 0 && !loading" description="暂无雪具信息" :image-size="150" />
      
      <el-table
        v-else
        :data="equipmentList"
        stripe
        style="width: 100%"
        max-height="500"
      >
        <el-table-column type="index" label="序号" width="60" align="center" />
        
        <el-table-column label="雪具图片" width="100" align="center">
          <template #default="scope">
            <el-image
              v-if="scope.row.imageUrl"
              :src="getImageUrl(scope.row.imageUrl)"
              :preview-src-list="[getImageUrl(scope.row.imageUrl)]"
              fit="cover"
              style="width: 60px; height: 60px; border-radius: 4px;"
            >
              <template #error>
                <div class="image-slot">
                  <el-icon><Picture /></el-icon>
                </div>
              </template>
            </el-image>
            <span v-else class="no-image">暂无图片</span>
          </template>
        </el-table-column>
        
        <el-table-column prop="equipmentCode" label="雪具编号" width="120" />
        <el-table-column prop="name" label="雪具名称" min-width="150" />
        <el-table-column prop="brand" label="品牌" width="100" />
        <el-table-column prop="model" label="型号" width="100" />
        <el-table-column prop="size" label="尺寸/规格" width="100" />
        <el-table-column prop="color" label="颜色" width="80" />
        
        <el-table-column label="库存信息" width="200" align="center">
          <template #default="scope">
            <div class="quantity-info">
              <div>总数：<span class="number">{{ scope.row.totalQuantity || 0 }}</span></div>
              <div>可用：<span class="number success">{{ scope.row.availableQuantity || 0 }}</span></div>
              <div>维修：<span class="number warning">{{ scope.row.maintenanceQuantity || 0 }}</span></div>
              <div>报废：<span class="number danger">{{ scope.row.scrapQuantity || 0 }}</span></div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="状态" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="rentalPrice" label="租赁价格" width="100" align="right">
          <template #default="scope">
            <span v-if="scope.row.rentalPrice">¥{{ scope.row.rentalPrice }}/天</span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="400" fixed="right" align="center">
          <template #default="scope">
            <el-button type="primary" size="small" icon="Edit" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="warning" size="small" icon="Tools" @click="handleMaintenance(scope.row)">报修</el-button>
            <el-button type="success" size="small" icon="CircleCheck" @click="handleCompleteMaintenance(scope.row)">完成维修</el-button>
            <el-button type="danger" size="small" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页 -->
      <pagination
        v-show="total > 0"
        :total="total"
        :page="queryParams.pageNum"
        :limit="queryParams.pageSize"
        @pagination="handlePageChange"
      />
    </div>

    <!-- 新增/编辑对话框 -->
    <EquipmentDialog
      v-model="dialogVisible"
      :equipment="currentEquipment"
      :loading="submitLoading"
      @submit="handleSubmit"
    />

    <!-- 报修对话框 -->
    <el-dialog
      v-model="maintenanceDialogVisible"
      title="报修雪具"
      width="400px"
      append-to-body
    >
      <el-form :model="maintenanceForm" label-width="100px">
        <el-form-item label="雪具名称">
          <el-input v-model="maintenanceForm.name" disabled />
        </el-form-item>
        <el-form-item label="可用数量">
          <el-input v-model="maintenanceForm.availableQuantity" disabled />
        </el-form-item>
        <el-form-item label="报修数量" required>
          <el-input-number
            v-model="maintenanceForm.quantity"
            :min="1"
            :max="maintenanceForm.availableQuantity"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="maintenanceDialogVisible = false">取消</el-button>
        <el-button type="warning" @click="confirmMaintenance" :loading="submitLoading">确认报修</el-button>
      </template>
    </el-dialog>

    <!-- 完成维修对话框 -->
    <el-dialog
      v-model="completeDialogVisible"
      title="完成维修"
      width="400px"
      append-to-body
    >
      <el-form :model="completeForm" label-width="100px">
        <el-form-item label="雪具名称">
          <el-input v-model="completeForm.name" disabled />
        </el-form-item>
        <el-form-item label="维修中数量">
          <el-input v-model="completeForm.maintenanceQuantity" disabled />
        </el-form-item>
        <el-form-item label="完成数量" required>
          <el-input-number
            v-model="completeForm.quantity"
            :min="1"
            :max="completeForm.maintenanceQuantity"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="completeDialogVisible = false">取消</el-button>
        <el-button type="success" @click="confirmCompleteMaintenance" :loading="submitLoading">确认完成</el-button>
      </template>
    </el-dialog>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, computed, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Plus, Edit, Tools, CircleCheck, Delete, Picture } from '@element-plus/icons-vue'
import { listEquipment, delEquipment, reportMaintenance, completeMaintenance, addEquipment, updateEquipment } from '@/api/equipment'
import EquipmentDialog from './EquipmentDialog.vue'
import Pagination from '@/components/Pagination/index.vue'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  category: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update:modelValue', 'refresh'])

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

// 分类映射
const categoryMap = {
  '1': '双板滑雪板',
  '2': '单板滑雪板',
  '3': '滑雪杖',
  '4': '头盔',
  '5': '护目镜',
  '6': '滑雪服'
}

const dialogTitle = computed(() => {
  const categoryName = categoryMap[props.category] || '雪具'
  return `${categoryName}管理`
})

// 响应式数据
const loading = ref(false)
const submitLoading = ref(false)
const equipmentList = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const maintenanceDialogVisible = ref(false)
const completeDialogVisible = ref(false)
const currentEquipment = ref(null)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  name: '',
  brand: '',
  category: props.category,
  status: null
})

const maintenanceForm = reactive({
  id: null,
  name: '',
  availableQuantity: 0,
  quantity: 1
})

const completeForm = reactive({
  id: null,
  name: '',
  maintenanceQuantity: 0,
  quantity: 1
})

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

// 获取状态类型
const getStatusType = (status) => {
  const typeMap = {
    0: 'info',    // 缺货
    1: 'success', // 可用
    2: 'warning', // 部分可用
    3: 'danger'   // 维修中
  }
  return typeMap[status] || 'info'
}

// 获取状态文本
const getStatusText = (status) => {
  const textMap = {
    0: '缺货',
    1: '可用',
    2: '部分可用',
    3: '维修中'
  }
  return textMap[status] || '未知'
}

// 查询列表（支持分页）
const getList = async () => {
  loading.value = true
  try {
    queryParams.category = props.category
    
    // 将分页参数放到params中，供后端PageHelper使用
    const requestParams = { ...queryParams }
    if (!requestParams.params) {
      requestParams.params = {}
    }
    requestParams.params.pageNum = queryParams.pageNum
    requestParams.params.pageSize = queryParams.pageSize
    
    const response = await listEquipment(requestParams)
    if (response.code === 200) {
      equipmentList.value = response.rows || []
      total.value = response.total || 0
    } else {
      ElMessage.error(response.msg || '查询失败')
    }
  } catch (error) {
    console.error('查询雪具列表失败:', error)
    ElMessage.error('查询失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 查询按钮
const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

// 重置查询
const resetQuery = () => {
  queryParams.name = ''
  queryParams.brand = ''
  queryParams.status = null
  handleQuery()
}

// 分页变化
const handlePageChange = (pagination) => {
  if (pagination) {
    queryParams.pageNum = pagination.page
    queryParams.pageSize = pagination.limit
  }
  getList()
}

// 新增
const handleAdd = () => {
  currentEquipment.value = null
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row) => {
  currentEquipment.value = { ...row }
  dialogVisible.value = true
}

// 报修
const handleMaintenance = (row) => {
  if (row.availableQuantity === 0) {
    ElMessage.warning('该雪具没有可用数量，无法报修')
    return
  }
  maintenanceForm.id = row.id
  maintenanceForm.name = row.name
  maintenanceForm.availableQuantity = row.availableQuantity
  maintenanceForm.quantity = 1
  maintenanceDialogVisible.value = true
}

// 确认报修
const confirmMaintenance = async () => {
  if (!maintenanceForm.quantity || maintenanceForm.quantity <= 0) {
    ElMessage.warning('请输入报修数量')
    return
  }
  submitLoading.value = true
  try {
    await reportMaintenance(maintenanceForm.id, maintenanceForm.quantity)
    ElMessage.success('报修成功')
    maintenanceDialogVisible.value = false
    getList()
    emit('refresh') // 通知父组件刷新统计数据
  } catch (error) {
    console.error('报修失败:', error)
    ElMessage.error(error.msg || '报修失败')
  } finally {
    submitLoading.value = false
  }
}

// 完成维修
const handleCompleteMaintenance = (row) => {
  if (row.maintenanceQuantity === 0) {
    ElMessage.warning('该雪具没有维修中的数量')
    return
  }
  completeForm.id = row.id
  completeForm.name = row.name
  completeForm.maintenanceQuantity = row.maintenanceQuantity
  completeForm.quantity = 1
  completeDialogVisible.value = true
}

// 确认完成维修
const confirmCompleteMaintenance = async () => {
  if (!completeForm.quantity || completeForm.quantity <= 0) {
    ElMessage.warning('请输入完成数量')
    return
  }
  submitLoading.value = true
  try {
    await completeMaintenance(completeForm.id, completeForm.quantity)
    ElMessage.success('维修完成')
    completeDialogVisible.value = false
    getList()
    emit('refresh') // 通知父组件刷新统计数据
  } catch (error) {
    console.error('完成维修失败:', error)
    ElMessage.error(error.msg || '操作失败')
  } finally {
    submitLoading.value = false
  }
}

// 删除
const handleDelete = (row) => {
  ElMessageBox.confirm(
    `确定要删除雪具"${row.name}"吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      await delEquipment([row.id])
      ElMessage.success('删除成功')
      getList()
      emit('refresh') // 通知父组件刷新统计数据
    } catch (error) {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

// 提交表单
const handleSubmit = async (formData) => {
  submitLoading.value = true
  try {
    if (formData.id) {
      // 编辑
      await updateEquipment(formData)
      ElMessage.success('修改成功')
    } else {
      // 新增
      // 确保分类与当前页面一致
      formData.category = props.category || formData.category
      await addEquipment(formData)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    getList()
    emit('refresh') // 通知父组件刷新统计数据
  } catch (error) {
    console.error('操作失败:', error)
    ElMessage.error(error.msg || '操作失败')
  } finally {
    submitLoading.value = false
  }
}

// 关闭对话框
const handleClose = () => {
  // 重置查询条件
  queryParams.pageNum = 1
  queryParams.name = ''
  queryParams.brand = ''
  queryParams.status = null
}

// 监听弹框显示状态，打开时加载数据
watch(visible, (val) => {
  if (val) {
    // 弹框打开时，重置查询条件并加载数据
    queryParams.category = props.category
    queryParams.pageNum = 1
    queryParams.name = ''
    queryParams.brand = ''
    queryParams.status = null
    // 延迟一下，确保弹框完全打开后再请求
    setTimeout(() => {
      getList()
    }, 100)
  }
})
</script>

<style scoped lang="scss">
.category-equipment-dialog {
  :deep(.el-dialog__body) {
    padding: 20px;
    max-height: calc(90vh - 200px);
    overflow-y: auto;
  }
  
  .toolbar-card {
    margin-bottom: 20px;
    border-radius: 8px;
    
    .search-form {
      margin: 0;
    }
  }
  
  .equipment-list {
    .image-slot {
      display: flex;
      justify-content: center;
      align-items: center;
      width: 60px;
      height: 60px;
      background: #f5f7fa;
      color: #909399;
      border-radius: 4px;
    }
    
    .no-image {
      color: #909399;
      font-size: 12px;
    }
    
    .quantity-info {
      display: flex;
      flex-direction: column;
      gap: 4px;
      font-size: 13px;
      
      .number {
        font-weight: 600;
        
        &.success {
          color: #67c23a;
        }
        
        &.warning {
          color: #e6a23c;
        }
        
        &.danger {
          color: #f56c6c;
        }
      }
    }
  }
}
</style>
