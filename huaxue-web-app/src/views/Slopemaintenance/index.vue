<template>
  <div class="app-container">
    <div class="header-section">
      <h1>雪道维护管理</h1>
      <el-button type="primary" icon="Plus" @click="handleAdd">新增雪道</el-button>
    </div>

    <!-- 搜索栏 -->
    <el-card class="search-card" shadow="never">
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="雪道名称">
          <el-input
            v-model="queryParams.name"
            placeholder="请输入雪道名称"
            clearable
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="雪道编号">
          <el-input
            v-model="queryParams.slopeCode"
            placeholder="请输入雪道编号"
            clearable
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="难度等级">
          <el-select v-model="queryParams.difficulty" placeholder="请选择" clearable>
            <el-option label="初级" value="1" />
            <el-option label="中级" value="2" />
            <el-option label="高级" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryParams.status" placeholder="请选择" clearable>
            <el-option label="开放" :value="1" />
            <el-option label="关闭" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 雪道卡片列表 -->
    <div v-loading="loading" class="slope-list">
      <el-row :gutter="20">
        <el-col
          v-for="slope in slopeList"
          :key="slope.id"
          :xs="24"
          :sm="12"
          :md="8"
          :lg="6"
        >
          <SlopeCard
            :slope="slope"
            @edit="handleEdit"
            @delete="handleDelete"
            @status-change="handleStatusChange"
          />
        </el-col>
      </el-row>
      
      <!-- 空状态 -->
      <el-empty v-if="!loading && slopeList.length === 0" description="暂无雪道数据" />
    </div>

    <!-- 新增/编辑对话框 -->
    <SlopeDialog
      v-model="dialogVisible"
      :slope="currentSlope"
      :loading="submitLoading"
      @submit="handleSubmit"
    />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search, Refresh } from '@element-plus/icons-vue'
import { listSlope, getSlope, addSlope, updateSlope, delSlope, changeSlopeStatus } from '@/api/slope'
import SlopeCard from './components/SlopeCard.vue'
import SlopeDialog from './components/SlopeDialog.vue'

// 响应式数据
const loading = ref(false)
const submitLoading = ref(false)
const slopeList = ref([])
const dialogVisible = ref(false)
const currentSlope = ref(null)

// 查询参数
const queryParams = reactive({
  name: '',
  slopeCode: '',
  difficulty: '',
  status: ''
})

// 查询列表
const getList = async () => {
  loading.value = true
  try {
    const response = await listSlope(queryParams)
    slopeList.value = response.rows || response.data || []
  } catch (error) {
    console.error('查询雪道列表失败:', error)
    ElMessage.error('查询雪道列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleQuery = () => {
  getList()
}

// 重置搜索
const resetQuery = () => {
  Object.assign(queryParams, {
    name: '',
    slopeCode: '',
    difficulty: '',
    status: ''
  })
  getList()
}

// 新增
const handleAdd = () => {
  currentSlope.value = null
  dialogVisible.value = true
}

// 编辑
const handleEdit = (slope) => {
  currentSlope.value = slope
  dialogVisible.value = true
}

// 删除
const handleDelete = async (id) => {
  try {
    await delSlope(id)
    ElMessage.success('删除成功')
    getList()
  } catch (error) {
    console.error('删除失败:', error)
    ElMessage.error('删除失败')
  }
}

// 状态变更
const handleStatusChange = async (id, status) => {
  try {
    await changeSlopeStatus(id, status)
    ElMessage.success('状态更新成功')
    getList()
  } catch (error) {
    console.error('状态更新失败:', error)
    ElMessage.error('状态更新失败')
    // 恢复原状态
    getList()
  }
}

// 提交表单（新增/编辑）
const handleSubmit = async (formData) => {
  submitLoading.value = true
  try {
    if (formData.id) {
      // 编辑
      await updateSlope(formData)
      ElMessage.success('修改成功')
    } else {
      // 新增
      await addSlope(formData)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    getList()
  } catch (error) {
    console.error('操作失败:', error)
    ElMessage.error('操作失败')
  } finally {
    submitLoading.value = false
  }
}

// 组件挂载时加载数据
onMounted(() => {
  getList()
})
</script>

<style scoped lang="scss">
.app-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);

  .header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    h1 {
      font-size: 24px;
      font-weight: bold;
      color: #303133;
      margin: 0;
    }
  }

  .search-card {
    margin-bottom: 20px;

    :deep(.el-card__body) {
      padding: 20px;
    }

    .search-form {
      .el-form-item {
        margin-bottom: 0;
      }
    }
  }

  .slope-list {
    min-height: 400px;
  }
}
</style>
