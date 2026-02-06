<template>
  <div class="expiry-monitor">
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :md="8" :lg="6">
        <el-card class="stat-card stat-card-danger" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon :size="40"><Warning /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ expiringSoonCount }}</div>
              <div class="stat-label">即将过期（30天内）</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="6">
        <el-card class="stat-card stat-card-warning" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon :size="40"><Box /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ lowStockCount }}</div>
              <div class="stat-label">库存不足</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 即将过期的物资 -->
    <el-card class="monitor-card" shadow="never">
      <template #header>
        <div class="card-header">
          <el-icon><Warning /></el-icon>
          <span>即将过期的物资（30天内）</span>
        </div>
      </template>
      <el-table v-loading="expiringLoading" :data="expiringList" border>
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="物资编码" prop="materialCode" width="120" />
        <el-table-column label="物资名称" prop="materialName" min-width="150" />
        <el-table-column label="有效期至" prop="expiryDate" width="120" align="center">
          <template #default="scope">
            <span class="expiring-soon">{{ scope.row.expiryDate }}</span>
          </template>
        </el-table-column>
        <el-table-column label="当前库存" prop="currentStock" width="100" align="center" />
        <el-table-column label="存放位置" prop="storageLocation" width="120" />
        <el-table-column label="操作" width="150" align="center">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 库存不足的物资 -->
    <el-card class="monitor-card" shadow="never" style="margin-top: 20px">
      <template #header>
        <div class="card-header">
          <el-icon><Box /></el-icon>
          <span>库存不足的物资</span>
        </div>
      </template>
      <el-table v-loading="lowStockLoading" :data="lowStockList" border>
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="物资编码" prop="materialCode" width="120" />
        <el-table-column label="物资名称" prop="materialName" min-width="150" />
        <el-table-column label="当前库存" prop="currentStock" width="100" align="center">
          <template #default="scope">
            <span class="low-stock">{{ scope.row.currentStock || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column label="安全库存" prop="safetyStock" width="100" align="center" />
        <el-table-column label="差额" width="100" align="center">
          <template #default="scope">
            <span class="low-stock">
              {{ (scope.row.safetyStock || 0) - (scope.row.currentStock || 0) }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="存放位置" prop="storageLocation" width="120" />
        <el-table-column label="操作" width="150" align="center">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">查看</el-button>
            <el-button link type="success" icon="Plus" @click="handleStockIn(scope.row)">入库</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Warning, Box, View, Plus } from '@element-plus/icons-vue'
import { getExpiringSoonMaterials, getLowStockMaterials } from '@/api/material'

const expiringLoading = ref(false)
const lowStockLoading = ref(false)
const expiringList = ref([])
const lowStockList = ref([])
const expiringSoonCount = ref(0)
const lowStockCount = ref(0)

// 加载即将过期的物资
const loadExpiringSoon = () => {
  expiringLoading.value = true
  getExpiringSoonMaterials()
    .then(response => {
      expiringList.value = response.data || []
      expiringSoonCount.value = expiringList.value.length
    })
    .catch(() => {
      expiringList.value = []
      expiringSoonCount.value = 0
    })
    .finally(() => {
      expiringLoading.value = false
    })
}

// 加载库存不足的物资
const loadLowStock = () => {
  lowStockLoading.value = true
  getLowStockMaterials()
    .then(response => {
      lowStockList.value = response.data || []
      lowStockCount.value = lowStockList.value.length
    })
    .catch(() => {
      lowStockList.value = []
      lowStockCount.value = 0
    })
    .finally(() => {
      lowStockLoading.value = false
    })
}

// 查看
const handleView = (row) => {
  ElMessage.info('查看详情功能')
}

// 入库
const handleStockIn = (row) => {
  ElMessage.info('入库功能')
}

onMounted(() => {
  loadExpiringSoon()
  loadLowStock()
})
</script>

<style scoped lang="scss">
.expiry-monitor {
  .stats-row {
    margin-bottom: 20px;
    
    .stat-card {
      border: none;
      
      .stat-content {
        display: flex;
        align-items: center;
        gap: 16px;
        
        .stat-icon {
          width: 60px;
          height: 60px;
          border-radius: 8px;
          display: flex;
          align-items: center;
          justify-content: center;
          color: white;
        }
        
        .stat-info {
          flex: 1;
          
          .stat-value {
            font-size: 28px;
            font-weight: bold;
            color: #303133;
            margin-bottom: 4px;
          }
          
          .stat-label {
            font-size: 14px;
            color: #909399;
          }
        }
      }
      
      &.stat-card-danger .stat-icon {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      }
      
      &.stat-card-warning .stat-icon {
        background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
      }
    }
  }

  .monitor-card {
    .card-header {
      display: flex;
      align-items: center;
      gap: 8px;
      font-weight: bold;
      font-size: 16px;
      
      .el-icon {
        font-size: 20px;
        color: #409eff;
      }
    }
    
    .expiring-soon {
      color: #e6a23c;
      font-weight: bold;
    }
    
    .low-stock {
      color: #f56c6c;
      font-weight: bold;
    }
  }
}
</style>
