<template>
  <div class="material-management-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><Box /></el-icon>
          <h1>物资管理</h1>
        </div>
        <p class="header-desc">急救药品的出入库登记、库存管理、领用管控及效期监控</p>
      </div>
    </div>

    <!-- 标签页 -->
    <el-tabs v-model="activeTab" class="management-tabs">
      <!-- 物资管理 -->
      <el-tab-pane label="物资管理" name="material">
        <MaterialList ref="materialListRef" />
      </el-tab-pane>

      <!-- 出入库记录 -->
      <el-tab-pane label="出入库记录" name="stock">
        <StockRecordList ref="stockRecordListRef" />
      </el-tab-pane>

      <!-- 领用记录 -->
      <el-tab-pane label="领用记录" name="usage">
        <UsageRecordList ref="usageRecordListRef" />
      </el-tab-pane>

      <!-- 效期监控 -->
      <el-tab-pane label="效期监控" name="expiry">
        <ExpiryMonitor ref="expiryMonitorRef" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup name="MaterialManagement">
import { ref } from 'vue'
import { Box } from '@element-plus/icons-vue'
import MaterialList from './components/MaterialList.vue'
import StockRecordList from './components/StockRecordList.vue'
import UsageRecordList from './components/UsageRecordList.vue'
import ExpiryMonitor from './components/ExpiryMonitor.vue'

const activeTab = ref('material')
const materialListRef = ref(null)
const stockRecordListRef = ref(null)
const usageRecordListRef = ref(null)
const expiryMonitorRef = ref(null)
</script>

<style scoped lang="scss">
.material-management-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);

  .page-header {
    margin-bottom: 20px;
    
    .header-content {
      .header-title {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 8px;
        
        .title-icon {
          font-size: 32px;
          color: #409eff;
        }
        
        h1 {
          font-size: 28px;
          font-weight: bold;
          color: #303133;
          margin: 0;
        }
      }
      
      .header-desc {
        color: #909399;
        font-size: 14px;
        margin: 0;
      }
    }
  }

  .management-tabs {
    :deep(.el-tabs__content) {
      padding: 20px 0;
    }
  }
}
</style>
