<template>
  <div class="material-list">
    <!-- 搜索栏 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="queryParams" :inline="true">
        <el-form-item label="物资编码">
          <el-input
            v-model="queryParams.materialCode"
            placeholder="请输入物资编码"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="物资名称">
          <el-input
            v-model="queryParams.materialName"
            placeholder="请输入物资名称"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="物资类型">
          <el-select
            v-model="queryParams.materialType"
            placeholder="请选择物资类型"
            clearable
            style="width: 150px"
          >
            <el-option label="急救药品" value="1" />
            <el-option label="医疗用品" value="2" />
            <el-option label="其他" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="queryParams.status"
            placeholder="请选择状态"
            clearable
            style="width: 120px"
          >
            <el-option label="正常" value="0" />
            <el-option label="停用" value="1" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
          <el-button type="primary" icon="Plus" @click="handleAdd">新增</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 物资列表 -->
    <el-card class="table-card" shadow="never">
      <el-table v-loading="loading" :data="materialList" border>
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="物资编码" prop="materialCode" width="150" align="center" />
        <el-table-column label="物资名称" prop="materialName" min-width="150" />
        <el-table-column label="物资类型" prop="materialType" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.materialType === '1'" type="danger">急救药品</el-tag>
            <el-tag v-else-if="scope.row.materialType === '2'" type="warning">医疗用品</el-tag>
            <el-tag v-else>其他</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="规格型号" prop="specification" width="120" />
        <el-table-column label="单位" prop="unit" width="80" align="center" />
        <el-table-column label="当前库存" prop="currentStock" width="100" align="center">
          <template #default="scope">
            <span :class="{ 'low-stock': scope.row.isLowStock }">
              {{ scope.row.currentStock || 0 }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="安全库存" prop="safetyStock" width="100" align="center" />
        <el-table-column label="有效期至" prop="expiryDate" width="120" align="center">
          <template #default="scope">
            <span :class="{ 'expiring-soon': scope.row.isExpiringSoon }">
              {{ scope.row.expiryDate || '-' }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="存放位置" prop="storageLocation" width="120" />
        <el-table-column label="状态" prop="status" width="80" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.status === '0'" type="success">正常</el-tag>
            <el-tag v-else type="info">停用</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" align="center" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">查看</el-button>
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button link type="success" icon="Plus" @click="handleStockIn(scope.row)">入库</el-button>
            <el-button link type="warning" icon="Minus" @click="handleStockOut(scope.row)">出库</el-button>
            <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="queryParams.pageNum"
          v-model:page-size="queryParams.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 物资表单对话框 -->
    <MaterialForm
      v-model="formDialogVisible"
      :material-id="currentMaterialId"
      @success="handleFormSuccess"
    />

    <!-- 出入库对话框 -->
    <StockDialog
      v-model="stockDialogVisible"
      :material="currentMaterial"
      :operation-type="currentOperationType"
      @success="handleStockSuccess"
    />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Refresh, Plus, View, Edit, Delete, Minus } from '@element-plus/icons-vue'
import { listMaterial, delMaterial } from '@/api/material'
import MaterialForm from './MaterialForm.vue'
import StockDialog from './StockDialog.vue'

const loading = ref(false)
const materialList = ref([])
const total = ref(0)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  materialCode: '',
  materialName: '',
  materialType: '',
  status: ''
})

const formDialogVisible = ref(false)
const currentMaterialId = ref(null)

const stockDialogVisible = ref(false)
const currentMaterial = ref(null)
const currentOperationType = ref('1') // 1入库 2出库

// 查询列表
const getList = () => {
  loading.value = true
  const params = {
    ...queryParams,
    params: {
      pageNum: queryParams.pageNum,
      pageSize: queryParams.pageSize
    }
  }
  
  listMaterial(params)
    .then(response => {
      materialList.value = response.rows || []
      total.value = response.total || 0
    })
    .catch(() => {
      materialList.value = []
      total.value = 0
    })
    .finally(() => {
      loading.value = false
    })
}

// 搜索
const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

// 重置
const resetQuery = () => {
  queryParams.materialCode = ''
  queryParams.materialName = ''
  queryParams.materialType = ''
  queryParams.status = ''
  handleQuery()
}

// 新增
const handleAdd = () => {
  currentMaterialId.value = null
  formDialogVisible.value = true
}

// 查看
const handleView = (row) => {
  currentMaterialId.value = row.id
  formDialogVisible.value = true
}

// 修改
const handleUpdate = (row) => {
  currentMaterialId.value = row.id
  formDialogVisible.value = true
}

// 入库
const handleStockIn = (row) => {
  currentMaterial.value = row
  currentOperationType.value = '1'
  stockDialogVisible.value = true
}

// 出库
const handleStockOut = (row) => {
  currentMaterial.value = row
  currentOperationType.value = '2'
  stockDialogVisible.value = true
}

// 删除
const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该物资吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      return delMaterial(row.id)
    })
    .then(() => {
      ElMessage.success('删除成功')
      getList()
    })
    .catch(() => {})
}

// 表单成功回调
const handleFormSuccess = () => {
  formDialogVisible.value = false
  getList()
}

// 出入库成功回调
const handleStockSuccess = () => {
  stockDialogVisible.value = false
  getList()
}

// 分页
const handlePageChange = (page) => {
  queryParams.pageNum = page
  getList()
}

const handleSizeChange = (size) => {
  queryParams.pageSize = size
  queryParams.pageNum = 1
  getList()
}

onMounted(() => {
  getList()
})
</script>

<style scoped lang="scss">
.material-list {
  .search-card {
    margin-bottom: 20px;
  }

  .table-card {
    .low-stock {
      color: #f56c6c;
      font-weight: bold;
    }

    .expiring-soon {
      color: #e6a23c;
      font-weight: bold;
    }

    .pagination-wrapper {
      display: flex;
      justify-content: center;
      margin-top: 20px;
    }
  }
}
</style>
