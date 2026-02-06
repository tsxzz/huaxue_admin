<template>
  <div class="slope-inquiry-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><Location /></el-icon>
          <h1>雪道信息查询</h1>
        </div>
        <p class="header-desc">探索我们的雪道，选择适合您的滑雪路线</p>
      </div>
    </div>

    <!-- 搜索和筛选区域 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="queryParams" :inline="true" class="search-form">
        <el-form-item label="雪道名称">
          <el-input
            v-model="queryParams.name"
            placeholder="请输入雪道名称"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
        </el-form-item>
        
        <el-form-item label="难度等级">
          <el-select
            v-model="queryParams.difficulty"
            placeholder="请选择难度等级"
            clearable
            style="width: 150px"
          >
            <el-option label="初级" value="1" />
            <el-option label="中级" value="2" />
            <el-option label="高级" value="3" />
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 雪道列表 -->
    <div class="slope-list" v-loading="loading">
      <div v-if="slopeList.length === 0 && !loading" class="empty-state">
        <el-empty description="暂无雪道信息" :image-size="200" />
      </div>
      
      <el-row :gutter="20" v-else class="slope-row">
        <el-col
          v-for="slope in slopeList"
          :key="slope.id"
          :xs="24"
          :sm="12"
          :md="12"
          :lg="8"
          :xl="6"
          class="slope-col"
        >
          <SlopeInfoCard :slope="slope" />
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Location, Search } from '@element-plus/icons-vue'
import { publicListSlope } from '@/api/slope'
import SlopeInfoCard from './components/SlopeInfoCard.vue'

// 响应式数据
const loading = ref(false)
const slopeList = ref([])

const queryParams = reactive({
  name: '',
  difficulty: '',
  status: 1 // 只查询开放的雪道
})

// 查询列表
const getList = async () => {
  loading.value = true
  try {
    const response = await publicListSlope(queryParams)
    if (response.code === 200) {
      slopeList.value = response.data || []
    } else {
      ElMessage.error(response.msg || '查询失败')
      slopeList.value = []
    }
  } catch (error) {
    console.error('查询雪道列表失败:', error)
    ElMessage.error('查询失败，请稍后重试')
    slopeList.value = []
  } finally {
    loading.value = false
  }
}

// 查询按钮
const handleQuery = () => {
  getList()
}

// 重置查询
const resetQuery = () => {
  queryParams.name = ''
  queryParams.difficulty = ''
  getList()
}

// 组件挂载时加载数据
onMounted(() => {
  getList()
})
</script>

<style scoped lang="scss">
.slope-inquiry-container {
  min-height: calc(100vh - 84px);
  background: linear-gradient(135deg, #667eea 0%, #d6cedf 100%);
  padding: 20px;
  
  .page-header {
    margin-bottom: 30px;
    
    .header-content {
      text-align: center;
      color: white;
      
      .header-title {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        margin-bottom: 10px;
        
        .title-icon {
          font-size: 32px;
        }
        
        h1 {
          margin: 0;
          font-size: 32px;
          font-weight: bold;
          text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }
      }
      
      .header-desc {
        margin: 0;
        font-size: 16px;
        opacity: 0.9;
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
      }
    }
  }
  
  .search-card {
    margin-bottom: 30px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    
    .search-form {
      margin: 0;
    }
  }
  
  .slope-list {
    min-height: 400px;
    
    .empty-state {
      padding: 60px 20px;
      background: white;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    
    .slope-row {
      margin-bottom: 0;
    }
    
    .slope-col {
      margin-bottom: 20px;
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .slope-inquiry-container {
    padding: 15px;
    
    .page-header {
      .header-content {
        .header-title {
          h1 {
            font-size: 24px;
          }
        }
        
        .header-desc {
          font-size: 14px;
        }
      }
    }
    
    .search-card {
      :deep(.el-form) {
        .el-form-item {
          margin-bottom: 15px;
        }
      }
    }
  }
}
</style>
