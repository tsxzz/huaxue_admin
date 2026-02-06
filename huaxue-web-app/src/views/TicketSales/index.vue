<template>
  <div class="ticket-sales-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><Ticket /></el-icon>
          <h1>门票销售管理</h1>
        </div>
        <p class="header-desc">管理门票类型、价格设置</p>
      </div>
    </div>

    <!-- 票种管理内容 -->
    <div class="tab-content">
      <!-- 搜索栏 -->
          <el-card class="search-card" shadow="never">
            <el-form :model="ticketTypeQueryParams" :inline="true">
              <el-form-item label="票种名称">
                <el-input
                  v-model="ticketTypeQueryParams.ticketName"
                  placeholder="请输入票种名称"
                  clearable
                  style="width: 200px"
                  @keyup.enter="handleTicketTypeQuery"
                />
              </el-form-item>
              <el-form-item label="票种类型">
                <el-select
                  v-model="ticketTypeQueryParams.ticketType"
                  placeholder="请选择票种类型"
                  clearable
                  style="width: 150px"
                >
                  <el-option label="全天票" value="1" />
                  <el-option label="半天票" value="2" />
                  <el-option label="夜场票" value="3" />
                  <el-option label="季票" value="4" />
                  <el-option label="年票" value="5" />
                </el-select>
              </el-form-item>
              <el-form-item label="状态">
                <el-select
                  v-model="ticketTypeQueryParams.status"
                  placeholder="请选择状态"
                  clearable
                  style="width: 120px"
                >
                  <el-option label="正常" value="0" />
                  <el-option label="停用" value="1" />
                </el-select>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" icon="Search" @click="handleTicketTypeQuery">搜索</el-button>
                <el-button icon="Refresh" @click="resetTicketTypeQuery">重置</el-button>
                <el-button type="primary" icon="Plus" @click="handleAddTicketType">新增</el-button>
              </el-form-item>
            </el-form>
          </el-card>

          <!-- 票种列表 -->
          <el-card class="table-card" shadow="never">
            <el-table v-loading="ticketTypeLoading" :data="ticketTypeList" border>
              <el-table-column label="序号" type="index" width="60" align="center" />
              <el-table-column label="票种编码" prop="ticketCode" width="120" align="center" />
              <el-table-column label="票种名称" prop="ticketName" min-width="150" />
              <el-table-column label="票种类型" prop="ticketType" width="100" align="center">
                <template #default="scope">
                  <el-tag v-if="scope.row.ticketType === '1'" type="success">全天票</el-tag>
                  <el-tag v-else-if="scope.row.ticketType === '2'" type="info">半天票</el-tag>
                  <el-tag v-else-if="scope.row.ticketType === '3'" type="warning">夜场票</el-tag>
                  <el-tag v-else-if="scope.row.ticketType === '4'" type="primary">季票</el-tag>
                  <el-tag v-else-if="scope.row.ticketType === '5'">年票</el-tag>
                </template>
              </el-table-column>
              <el-table-column label="价格" prop="price" width="100" align="center">
                <template #default="scope">
                  <span style="color: #f56c6c; font-weight: bold">¥{{ scope.row.price }}</span>
                </template>
              </el-table-column>
              <el-table-column label="有效期" prop="validDays" width="100" align="center">
                <template #default="scope">{{ scope.row.validDays }}天</template>
              </el-table-column>
              <el-table-column label="状态" prop="status" width="80" align="center">
                <template #default="scope">
                  <el-tag v-if="scope.row.status === '0'" type="success">正常</el-tag>
                  <el-tag v-else type="danger">停用</el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="250" align="center" fixed="right">
                <template #default="scope">
                  <el-button link type="primary" icon="Edit" @click="handleUpdateTicketType(scope.row)">修改</el-button>
                  <el-button link type="danger" icon="Delete" @click="handleDeleteTicketType(scope.row)">删除</el-button>
                </template>
              </el-table-column>
            </el-table>

            <!-- 分页 -->
            <pagination
              v-show="ticketTypeTotal > 0"
              :total="ticketTypeTotal"
              :page="ticketTypeQueryParams.pageNum"
              :limit="ticketTypeQueryParams.pageSize"
              @pagination="handleTicketTypePageChange"
            />
          </el-card>
    </div>

    <!-- 票种新增/修改对话框 -->
    <el-dialog
      :title="ticketTypeDialogTitle"
      v-model="ticketTypeDialogVisible"
      width="600px"
      append-to-body
    >
      <el-form ref="ticketTypeFormRef" :model="ticketTypeForm" :rules="ticketTypeRules" label-width="100px">
        <el-form-item label="票种编码" prop="ticketCode">
          <el-input v-model="ticketTypeForm.ticketCode" placeholder="请输入票种编码" />
        </el-form-item>
        <el-form-item label="票种名称" prop="ticketName">
          <el-input v-model="ticketTypeForm.ticketName" placeholder="请输入票种名称" />
        </el-form-item>
        <el-form-item label="票种类型" prop="ticketType">
          <el-select v-model="ticketTypeForm.ticketType" placeholder="请选择票种类型" style="width: 100%">
            <el-option label="全天票" value="1" />
            <el-option label="半天票" value="2" />
            <el-option label="夜场票" value="3" />
            <el-option label="季票" value="4" />
            <el-option label="年票" value="5" />
          </el-select>
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number
            v-model="ticketTypeForm.price"
            :precision="2"
            :min="0"
            :step="10"
            style="width: 100%"
            placeholder="请输入价格"
          />
        </el-form-item>
        <el-form-item label="有效期" prop="validDays">
          <el-input-number
            v-model="ticketTypeForm.validDays"
            :min="1"
            style="width: 100%"
            placeholder="请输入有效期（天）"
          />
        </el-form-item>
        <el-form-item label="票种图片">
          <image-upload v-model="ticketTypeForm.imageUrl" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="ticketTypeForm.status">
            <el-radio label="0">正常</el-radio>
            <el-radio label="1">停用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="ticketTypeForm.sortOrder" :min="0" style="width: 100%" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input
            v-model="ticketTypeForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入票种描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="ticketTypeDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="submitTicketTypeForm">确 定</el-button>
        </div>
      </template>
    </el-dialog>

  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Ticket, Search, Refresh, Plus, Edit, Delete, View, RefreshLeft } from '@element-plus/icons-vue'
import { listTicketType, getTicketType, addTicketType, updateTicketType, delTicketType } from '@/api/ticketType'
import { parseTime } from '@/utils/ruoyi'
import ImageUpload from '@/components/ImageUpload'
import Pagination from '@/components/Pagination/index.vue'

// ========== 票种管理 ==========
const ticketTypeLoading = ref(false)
const ticketTypeList = ref([])
const ticketTypeTotal = ref(0)
const ticketTypeQueryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  ticketName: '',
  ticketType: '',
  status: ''
})

// 票种对话框
const ticketTypeDialogVisible = ref(false)
const ticketTypeDialogTitle = ref('')
const ticketTypeFormRef = ref(null)
const ticketTypeForm = reactive({
  id: null,
  ticketCode: '',
  ticketName: '',
  ticketType: '',
  price: null,
  validDays: 1,
  imageUrl: '',
  status: '0',
  sortOrder: 0,
  description: ''
})
const ticketTypeRules = {
  ticketCode: [{ required: true, message: '票种编码不能为空', trigger: 'blur' }],
  ticketName: [{ required: true, message: '票种名称不能为空', trigger: 'blur' }],
  ticketType: [{ required: true, message: '票种类型不能为空', trigger: 'change' }],
  price: [{ required: true, message: '价格不能为空', trigger: 'blur' }]
}

// 查询票种列表
const getTicketTypeList = async () => {
  ticketTypeLoading.value = true
  try {
    const params = {
      pageNum: ticketTypeQueryParams.pageNum,
      pageSize: ticketTypeQueryParams.pageSize,
      ticketName: ticketTypeQueryParams.ticketName,
      ticketType: ticketTypeQueryParams.ticketType,
      status: ticketTypeQueryParams.status
    }
    if (!params.params) {
      params.params = {}
    }
    params.params.pageNum = ticketTypeQueryParams.pageNum
    params.params.pageSize = ticketTypeQueryParams.pageSize

    const response = await listTicketType(params)
    if (response.code === 200) {
      ticketTypeList.value = response.rows || []
      ticketTypeTotal.value = response.total || 0
    }
  } catch (error) {
    console.error('查询票种列表失败:', error)
  } finally {
    ticketTypeLoading.value = false
  }
}

// 搜索
const handleTicketTypeQuery = () => {
  ticketTypeQueryParams.pageNum = 1
  getTicketTypeList()
}

// 重置
const resetTicketTypeQuery = () => {
  ticketTypeQueryParams.ticketName = ''
  ticketTypeQueryParams.ticketType = ''
  ticketTypeQueryParams.status = ''
  handleTicketTypeQuery()
}

// 分页
const handleTicketTypePageChange = (p) => {
  ticketTypeQueryParams.pageNum = p.page
  ticketTypeQueryParams.pageSize = p.limit
  getTicketTypeList()
}

// 新增
const handleAddTicketType = () => {
  resetTicketTypeForm()
  ticketTypeDialogTitle.value = '新增票种'
  ticketTypeDialogVisible.value = true
}

// 修改
const handleUpdateTicketType = async (row) => {
  try {
    const response = await getTicketType(row.id)
    if (response.code === 200) {
      Object.assign(ticketTypeForm, response.data)
      ticketTypeDialogTitle.value = '修改票种'
      ticketTypeDialogVisible.value = true
    }
  } catch (error) {
    console.error('获取票种详情失败:', error)
  }
}

// 删除
const handleDeleteTicketType = (row) => {
  ElMessageBox.confirm('是否确认删除票种"' + row.ticketName + '"？', '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      return delTicketType(row.id)
    })
    .then(() => {
      getTicketTypeList()
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

// 重置表单
const resetTicketTypeForm = () => {
  ticketTypeForm.id = null
  ticketTypeForm.ticketCode = ''
  ticketTypeForm.ticketName = ''
  ticketTypeForm.ticketType = ''
  ticketTypeForm.price = null
  ticketTypeForm.validDays = 1
  ticketTypeForm.imageUrl = ''
  ticketTypeForm.status = '0'
  ticketTypeForm.sortOrder = 0
  ticketTypeForm.description = ''
  ticketTypeFormRef.value?.resetFields()
}

// 提交表单
const submitTicketTypeForm = () => {
  ticketTypeFormRef.value.validate((valid) => {
    if (valid) {
      if (ticketTypeForm.id != null) {
        updateTicketType(ticketTypeForm)
          .then(() => {
            ElMessage.success('修改成功')
            ticketTypeDialogVisible.value = false
            getTicketTypeList()
          })
      } else {
        addTicketType(ticketTypeForm)
          .then(() => {
            ElMessage.success('新增成功')
            ticketTypeDialogVisible.value = false
            getTicketTypeList()
          })
      }
    }
  })
}

onMounted(() => {
  getTicketTypeList()
})
</script>

<style scoped lang="scss">
.ticket-sales-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);
}

.page-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 8px;
  padding: 30px;
  margin-bottom: 20px;
  color: white;

  .header-content {
    .header-title {
      display: flex;
      align-items: center;
      margin-bottom: 10px;

      .title-icon {
        font-size: 32px;
        margin-right: 12px;
      }

      h1 {
        font-size: 28px;
        font-weight: bold;
        margin: 0;
      }
    }

    .header-desc {
      font-size: 14px;
      opacity: 0.9;
      margin: 0;
    }
  }
}

.tab-content {
  background: white;
  border-radius: 8px;
  padding: 20px;

  .search-card {
    margin-bottom: 20px;
  }

  .table-card {
    :deep(.el-table) {
      .el-table__cell {
        padding: 12px 0;
      }
    }
  }
}
</style>
