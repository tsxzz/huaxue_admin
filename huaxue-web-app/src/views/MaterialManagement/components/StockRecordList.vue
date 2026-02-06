<template>
  <div class="stock-record-list">
    <!-- 搜索栏 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="queryParams" :inline="true">
        <el-form-item label="物资名称">
          <el-input
            v-model="queryParams.materialName"
            placeholder="请输入物资名称"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="操作类型">
          <el-select
            v-model="queryParams.operationType"
            placeholder="请选择操作类型"
            clearable
            style="width: 150px"
          >
            <el-option label="入库" value="1" />
            <el-option label="出库" value="2" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 记录列表 -->
    <el-card class="table-card" shadow="never">
      <el-table v-loading="loading" :data="recordList" border>
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="物资编码" prop="materialCode" width="120" />
        <el-table-column label="物资名称" prop="materialName" min-width="150" />
        <el-table-column label="操作类型" prop="operationType" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.operationType === '1'" type="success">入库</el-tag>
            <el-tag v-else type="warning">出库</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="数量" prop="quantity" width="100" align="center" />
        <el-table-column label="单价" prop="unitPrice" width="100" align="center">
          <template #default="scope">
            <span v-if="scope.row.unitPrice">¥{{ scope.row.unitPrice }}</span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="总金额" prop="totalAmount" width="120" align="center">
          <template #default="scope">
            <span v-if="scope.row.totalAmount">¥{{ scope.row.totalAmount }}</span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="操作人" prop="operatorName" width="120" />
        <el-table-column label="操作时间" prop="operationTime" width="180" align="center" />
        <el-table-column label="操作" width="150" align="center" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">查看</el-button>
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
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Refresh, View, Delete } from '@element-plus/icons-vue'
import { listMaterialStock, delMaterialStock } from '@/api/material'

const loading = ref(false)
const recordList = ref([])
const total = ref(0)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  materialName: '',
  operationType: ''
})

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
  
  listMaterialStock(params)
    .then(response => {
      recordList.value = response.rows || []
      total.value = response.total || 0
    })
    .catch(() => {
      recordList.value = []
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
  queryParams.materialName = ''
  queryParams.operationType = ''
  handleQuery()
}

// 查看
const handleView = (row) => {
  // 可以打开详情对话框
  ElMessage.info('查看详情功能')
}

// 删除
const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该记录吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      return delMaterialStock(row.id)
    })
    .then(() => {
      ElMessage.success('删除成功')
      getList()
    })
    .catch(() => {})
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
.stock-record-list {
  .search-card {
    margin-bottom: 20px;
  }

  .table-card {
    .pagination-wrapper {
      display: flex;
      justify-content: center;
      margin-top: 20px;
    }
  }
}
</style>
