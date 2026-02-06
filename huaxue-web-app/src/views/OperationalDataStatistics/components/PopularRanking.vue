<template>
  <div class="popular-ranking">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <el-icon><Trophy /></el-icon>
          <span>{{ title }}</span>
        </div>
      </template>
      <el-table :data="data" border stripe>
        <el-table-column type="index" label="排名" width="60" align="center" />
        <el-table-column :prop="nameProp" label="名称" min-width="150" />
        <el-table-column :prop="countProp" label="数量" width="100" align="center">
          <template #default="scope">
            <el-tag type="info">{{ scope.row[countProp] }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column :prop="amountProp" label="金额" width="120" align="center">
          <template #default="scope">
            <span style="color: #f56c6c; font-weight: bold">¥{{ formatAmount(scope.row[amountProp]) }}</span>
          </template>
        </el-table-column>
      </el-table>
      <el-empty v-if="!data || data.length === 0" description="暂无数据" />
    </el-card>
  </div>
</template>

<script setup>
import { Trophy } from '@element-plus/icons-vue'

const props = defineProps({
  title: {
    type: String,
    default: '热门排行'
  },
  data: {
    type: Array,
    default: () => []
  },
  nameProp: {
    type: String,
    default: 'name'
  },
  countProp: {
    type: String,
    default: 'count'
  },
  amountProp: {
    type: String,
    default: 'amount'
  }
})

const formatAmount = (amount) => {
  if (!amount || amount === 0) return '0.00'
  return parseFloat(amount).toFixed(2)
}
</script>

<style scoped lang="scss">
.popular-ranking {
  .card-header {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 16px;
    font-weight: bold;
    color: #303133;

    .el-icon {
      color: #e6a23c;
      font-size: 20px;
    }
  }
}
</style>
