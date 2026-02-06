<template>
  <div class="usage-record-list">
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
        <el-form-item label="审批状态">
          <el-select
            v-model="queryParams.approvalStatus"
            placeholder="请选择审批状态"
            clearable
            style="width: 150px"
          >
            <el-option label="待审批" value="0" />
            <el-option label="已批准" value="1" />
            <el-option label="已拒绝" value="2" />
          </el-select>
        </el-form-item>
        <el-form-item label="归还状态">
          <el-select
            v-model="queryParams.returnStatus"
            placeholder="请选择归还状态"
            clearable
            style="width: 150px"
          >
            <el-option label="未归还" value="0" />
            <el-option label="已归还" value="1" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
          <el-button type="primary" icon="Plus" @click="handleAdd">新增领用</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 记录列表 -->
    <el-card class="table-card" shadow="never">
      <el-table v-loading="loading" :data="recordList" border>
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="物资编码" prop="materialCode" width="120" />
        <el-table-column label="物资名称" prop="materialName" min-width="150" />
        <el-table-column label="领用数量" prop="quantity" width="100" align="center" />
        <el-table-column label="领用人" prop="userName" width="120" />
        <el-table-column label="所属部门" prop="department" width="120" />
        <el-table-column label="用途说明" prop="usagePurpose" min-width="150" show-overflow-tooltip />
        <el-table-column label="审批状态" prop="approvalStatus" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.approvalStatus === '0'" type="warning">待审批</el-tag>
            <el-tag v-else-if="scope.row.approvalStatus === '1'" type="success">已批准</el-tag>
            <el-tag v-else-if="scope.row.approvalStatus === '2'" type="danger">已拒绝</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="归还状态" prop="returnStatus" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.returnStatus === '0'" type="info">未归还</el-tag>
            <el-tag v-else type="success">已归还</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="领用时间" prop="usageTime" width="180" align="center" />
        <el-table-column label="操作" width="250" align="center" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">查看</el-button>
            <el-button
              v-if="scope.row.approvalStatus === '0'"
              link
              type="success"
              icon="CircleCheck"
              @click="handleApprove(scope.row, '1')"
            >
              批准
            </el-button>
            <el-button
              v-if="scope.row.approvalStatus === '0'"
              link
              type="danger"
              icon="Close"
              @click="handleApprove(scope.row, '2')"
            >
              拒绝
            </el-button>
            <el-button
              v-if="scope.row.approvalStatus === '1' && scope.row.returnStatus === '0'"
              link
              type="warning"
              icon="RefreshLeft"
              @click="handleReturn(scope.row)"
            >
              归还
            </el-button>
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

    <!-- 领用表单对话框 -->
    <UsageForm v-model="formDialogVisible" @success="handleFormSuccess" />

    <!-- 审批对话框 -->
    <ApproveDialog
      v-model="approveDialogVisible"
      :record="currentRecord"
      :approval-status="currentApprovalStatus"
      @success="handleApproveSuccess"
    />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Refresh, Plus, View, Delete, CircleCheck, Close, RefreshLeft } from '@element-plus/icons-vue'
import { listMaterialUsage, delMaterialUsage, approveUsage, returnMaterial } from '@/api/material'
import UsageForm from './UsageForm.vue'
import ApproveDialog from './ApproveDialog.vue'

const loading = ref(false)
const recordList = ref([])
const total = ref(0)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  materialName: '',
  approvalStatus: '',
  returnStatus: ''
})

const formDialogVisible = ref(false)
const approveDialogVisible = ref(false)
const currentRecord = ref(null)
const currentApprovalStatus = ref('1')

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
  
  listMaterialUsage(params)
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
  queryParams.approvalStatus = ''
  queryParams.returnStatus = ''
  handleQuery()
}

// 新增
const handleAdd = () => {
  formDialogVisible.value = true
}

// 查看
const handleView = (row) => {
  ElMessage.info('查看详情功能')
}

// 审批
const handleApprove = (row, status) => {
  currentRecord.value = row
  currentApprovalStatus.value = status
  approveDialogVisible.value = true
}

// 归还
const handleReturn = (row) => {
  ElMessageBox.confirm('确定要归还该物资吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      return returnMaterial(row.id)
    })
    .then(() => {
      ElMessage.success('归还成功')
      getList()
    })
    .catch(() => {})
}

// 删除
const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该记录吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      return delMaterialUsage(row.id)
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

// 审批成功回调
const handleApproveSuccess = () => {
  approveDialogVisible.value = false
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
.usage-record-list {
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
