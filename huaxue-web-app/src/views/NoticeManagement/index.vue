<template>
  <div class="notice-management-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><Bell /></el-icon>
          <h1>通知管理</h1>
        </div>
        <p class="header-desc">发布和管理系统通知、公告信息</p>
      </div>
    </div>

    <!-- 搜索栏 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="queryParams" :inline="true">
        <el-form-item label="通知标题">
          <el-input
            v-model="queryParams.noticeTitle"
            placeholder="请输入通知标题"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="通知类型">
          <el-select
            v-model="queryParams.noticeType"
            placeholder="请选择通知类型"
            clearable
            style="width: 150px"
          >
            <el-option label="通知" value="1" />
            <el-option label="公告" value="2" />
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
            <el-option label="关闭" value="1" />
          </el-select>
        </el-form-item>
        <el-form-item label="优先级">
          <el-select
            v-model="queryParams.priority"
            placeholder="请选择优先级"
            clearable
            style="width: 120px"
          >
            <el-option label="普通" :value="0" />
            <el-option label="重要" :value="1" />
            <el-option label="紧急" :value="2" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
          <el-button type="primary" icon="Plus" @click="handleAdd">新增</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 通知列表 -->
    <el-card class="table-card" shadow="never">
      <el-table v-loading="loading" :data="noticeList" border>
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="通知标题" prop="noticeTitle" min-width="200" show-overflow-tooltip />
        <el-table-column label="通知类型" prop="noticeType" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.noticeType === '1'" type="info">通知</el-tag>
            <el-tag v-else-if="scope.row.noticeType === '2'" type="success">公告</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="优先级" prop="priority" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.priority === 0">普通</el-tag>
            <el-tag v-else-if="scope.row.priority === 1" type="warning">重要</el-tag>
            <el-tag v-else-if="scope.row.priority === 2" type="danger">紧急</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" prop="status" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.status === '0'" type="success">正常</el-tag>
            <el-tag v-else type="info">关闭</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="阅读次数" prop="readCount" width="100" align="center">
          <template #default="scope">{{ scope.row.readCount || 0 }}</template>
        </el-table-column>
        <el-table-column label="发布时间" prop="publishTime" width="180" align="center" />
        <el-table-column label="创建时间" prop="createTime" width="180" align="center" />
        <el-table-column label="操作" width="300" align="center" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleViewDetail(scope.row)">查看</el-button>
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button
              v-if="scope.row.status === '1'"
              link
              type="success"
              icon="Promotion"
              @click="handlePublish(scope.row)"
            >
              发布
            </el-button>
            <el-button
              v-else
              link
              type="warning"
              icon="Close"
              @click="handleClose(scope.row)"
            >
              关闭
            </el-button>
            <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 通知表单对话框 -->
    <NoticeForm
      v-model="formDialogVisible"
      :form-data="currentForm"
      @submit="handleFormSubmit"
    />

    <!-- 通知详情对话框 -->
    <NoticeDetail
      v-model="detailDialogVisible"
      :notice-data="currentNotice"
    />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Bell } from '@element-plus/icons-vue'
import { listNotice, getNotice, addNotice, updateNotice, delNotice, publishNotice, closeNotice } from '@/api/notice'
import Pagination from '@/components/Pagination'
import NoticeForm from './components/NoticeForm.vue'
import NoticeDetail from './components/NoticeDetail.vue'

// 查询参数
const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  noticeTitle: null,
  noticeType: null,
  status: null,
  priority: null
})

// 通知列表
const loading = ref(false)
const noticeList = ref([])
const total = ref(0)

// 表单对话框
const formDialogVisible = ref(false)
const currentForm = ref({})

// 详情对话框
const detailDialogVisible = ref(false)
const currentNotice = ref(null)

// 查询通知列表
const getList = async () => {
  loading.value = true
  try {
    const params = {
      ...queryParams,
      params: {
        pageNum: queryParams.pageNum,
        pageSize: queryParams.pageSize
      }
    }
    const response = await listNotice(params)
    if (response.code === 200) {
      noticeList.value = response.rows || []
      total.value = response.total || 0
    } else {
      ElMessage.error(response.msg || '查询失败')
    }
  } catch (error) {
    console.error('查询通知列表失败:', error)
    ElMessage.error('查询通知列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

// 重置
const resetQuery = () => {
  queryParams.noticeTitle = null
  queryParams.noticeType = null
  queryParams.status = null
  queryParams.priority = null
  handleQuery()
}

// 新增
const handleAdd = () => {
  currentForm.value = {
    noticeTitle: '',
    noticeType: '1',
    noticeContent: '',
    status: '0',
    priority: 0,
    publishTime: null,
    expireTime: null,
    remark: ''
  }
  formDialogVisible.value = true
}

// 修改
const handleUpdate = (row) => {
  currentForm.value = { ...row }
  formDialogVisible.value = true
}

// 查看详情
const handleViewDetail = async (row) => {
  try {
    const response = await getNotice(row.id)
    if (response.code === 200) {
      currentNotice.value = response.data
      detailDialogVisible.value = true
      // 刷新列表以更新阅读次数
      getList()
    } else {
      ElMessage.error(response.msg || '获取通知详情失败')
    }
  } catch (error) {
    console.error('获取通知详情失败:', error)
    ElMessage.error('获取通知详情失败')
  }
}

// 表单提交
const handleFormSubmit = async (formData) => {
  try {
    let response
    if (formData.id) {
      // 编辑
      response = await updateNotice(formData)
    } else {
      // 新增
      response = await addNotice(formData)
    }

    if (response.code === 200) {
      ElMessage.success(formData.id ? '修改成功' : '新增成功')
      formDialogVisible.value = false
      getList()
    } else {
      ElMessage.error(response.msg || '操作失败')
    }
  } catch (error) {
    console.error('操作失败:', error)
    ElMessage.error(error.msg || '操作失败')
  }
}

// 发布通知
const handlePublish = (row) => {
  ElMessageBox.confirm('确定要发布该通知吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'info'
  })
    .then(() => {
      publishNotice(row.id)
        .then((response) => {
          if (response.code === 200) {
            ElMessage.success('发布成功')
            getList()
          } else {
            ElMessage.error(response.msg || '发布失败')
          }
        })
        .catch((error) => {
          console.error('发布失败:', error)
          ElMessage.error(error.msg || '发布失败')
        })
    })
    .catch(() => {})
}

// 关闭通知
const handleClose = (row) => {
  ElMessageBox.confirm('确定要关闭该通知吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      closeNotice(row.id)
        .then((response) => {
          if (response.code === 200) {
            ElMessage.success('关闭成功')
            getList()
          } else {
            ElMessage.error(response.msg || '关闭失败')
          }
        })
        .catch((error) => {
          console.error('关闭失败:', error)
          ElMessage.error(error.msg || '关闭失败')
        })
    })
    .catch(() => {})
}

// 删除通知
const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该通知吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      delNotice([row.id])
        .then((response) => {
          if (response.code === 200) {
            ElMessage.success('删除成功')
            getList()
          } else {
            ElMessage.error(response.msg || '删除失败')
          }
        })
        .catch((error) => {
          console.error('删除失败:', error)
          ElMessage.error(error.msg || '删除失败')
        })
    })
    .catch(() => {})
}

// 初始化
onMounted(() => {
  getList()
})
</script>

<style scoped lang="scss">
.notice-management-container {
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

.search-card,
.table-card {
  margin-bottom: 20px;
  background: white;
  border-radius: 8px;
}
</style>
