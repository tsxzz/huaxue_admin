<template>
  <div class="equipment-management-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><Box /></el-icon>
          <h1>雪具管理</h1>
        </div>
        <p class="header-desc">管理各类滑雪装备，包括库存、维护和报修</p>
      </div>
    </div>

    <!-- 分类卡片 -->
    <div class="category-cards" v-loading="loading">
      <el-row :gutter="20">
        <el-col
          v-for="category in categories"
          :key="category.value"
          :xs="24"
          :sm="12"
          :md="8"
          :lg="8"
          :xl="4"
          class="category-col"
        >
          <el-card
            class="category-card"
            shadow="hover"
            :body-style="{ padding: '0' }"
            @click="goToCategory(category.value)"
          >
            <div class="card-content">
              <div class="card-icon" :style="{ background: category.gradient }">
                <el-icon :size="48"><Box /></el-icon>
              </div>
              <div class="card-info">
                <h3>{{ category.label }}</h3>
                <p class="card-desc">{{ category.description }}</p>
                <div class="card-stats" v-if="categoryStats[category.value]">
                  <span class="stat-item">
                    <el-icon><Box /></el-icon>
                    总数：{{ categoryStats[category.value].total || 0 }}
                  </span>
                  <span class="stat-item">
                    <el-icon><CircleCheck /></el-icon>
                    可用：{{ categoryStats[category.value].available || 0 }}
                  </span>
                </div>
              </div>
              <div class="card-arrow">
                <el-icon><ArrowRight /></el-icon>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 分类雪具管理弹框 -->
    <CategoryEquipmentDialog
      v-model="categoryDialogVisible"
      :category="currentCategory"
      @refresh="loadStats"
    />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onActivated, watch } from 'vue'
import { useRoute } from 'vue-router'
import { Box, ArrowRight, CircleCheck } from '@element-plus/icons-vue'
import { listEquipment } from '@/api/equipment'
import CategoryEquipmentDialog from './components/CategoryEquipmentDialog.vue'

const route = useRoute()

// 加载状态
const loading = ref(false)

// 分类配置
const categories = ref([
  {
    label: '双板滑雪板',
    value: '1',
    icon: 'Trophy',
    description: '专业双板滑雪装备',
    gradient: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
  },
  {
    label: '单板滑雪板',
    value: '2',
    icon: 'Snowflake',
    description: '单板滑雪装备',
    gradient: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)'
  },
  {
    label: '滑雪杖',
    value: '3',
    icon: 'Umbrella',
    description: '滑雪辅助装备',
    gradient: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)'
  },
  {
    label: '头盔',
    value: '4',
    icon: 'Helmet',
    description: '安全防护装备',
    gradient: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)'
  },
  {
    label: '护目镜',
    value: '5',
    icon: 'Glasses',
    description: '眼部防护装备',
    gradient: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)'
  },
  {
    label: '滑雪服',
    value: '6',
    icon: 'Shirt',
    description: '保暖防护服装',
    gradient: 'linear-gradient(135deg, #30cfd0 0%, #330867 100%)'
  }
])

// 分类统计
const categoryStats = ref({})

// 弹框相关
const categoryDialogVisible = ref(false)
const currentCategory = ref('')

// 打开分类管理弹框
const goToCategory = (category) => {
  currentCategory.value = category
  categoryDialogVisible.value = true
}

// 加载统计数据
const loadStats = async () => {
  loading.value = true
  try {
    // 重置统计数据
    categoryStats.value = {}
    
    // 遍历每个分类，查询统计数据
    for (const category of categories.value) {
      try {
        // 将分页参数放到params中，供后端PageHelper使用
        const requestParams = {
          category: category.value,
          params: {
            pageNum: 1,
            pageSize: 100  // 增加页面大小以获取更准确的统计
          }
        }
        const response = await listEquipment(requestParams)
        if (response.code === 200) {
          const list = response.rows || []
          let total = 0
          let available = 0
          list.forEach(item => {
            total += (item.totalQuantity || 0)
            available += (item.availableQuantity || 0)
          })
          categoryStats.value[category.value] = {
            total,
            available
          }
        }
      } catch (error) {
        console.error(`加载分类 ${category.label} 统计数据失败:`, error)
        // 即使某个分类失败，也继续加载其他分类
        categoryStats.value[category.value] = {
          total: 0,
          available: 0
        }
      }
    }
  } catch (error) {
    console.error('加载统计数据失败:', error)
  } finally {
    loading.value = false
  }
}

// 组件挂载时加载数据
onMounted(() => {
  loadStats()
})

// 组件激活时重新加载数据（从其他页面返回时，如果组件被缓存）
onActivated(() => {
  loadStats()
})
</script>

<style scoped lang="scss">
.equipment-management-container {
  min-height: calc(100vh - 84px);
  background: linear-gradient(135deg, #667eea 0%, #d6cedf 100%);
  padding: 20px;
  
  .page-header {
    margin-bottom: 40px;
    
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
  
  .category-cards {
    .category-col {
      margin-bottom: 20px;
    }
    
    .category-card {
      cursor: pointer;
      border-radius: 16px;
      overflow: hidden;
      transition: all 0.3s;
      height: 100%;
      
      &:hover {
        transform: translateY(-8px);
        box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
      }
      
      .card-content {
        display: flex;
        flex-direction: column;
        height: 100%;
        min-height: 200px;
        
        .card-icon {
          flex: 1;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 30px;
          color: white;
          min-height: 120px;
        }
        
        .card-info {
          padding: 20px;
          background: white;
          flex: 1;
          
          h3 {
            margin: 0 0 8px 0;
            font-size: 20px;
            font-weight: bold;
            color: #303133;
          }
          
          .card-desc {
            margin: 0 0 12px 0;
            font-size: 14px;
            color: #909399;
          }
          
          .card-stats {
            display: flex;
            flex-direction: column;
            gap: 8px;
            
            .stat-item {
              display: flex;
              align-items: center;
              gap: 6px;
              font-size: 13px;
              color: #606266;
              
              .el-icon {
                color: #409eff;
              }
            }
          }
        }
        
        .card-arrow {
          padding: 15px;
          background: #f5f7fa;
          text-align: center;
          color: #909399;
          transition: all 0.3s;
          
          .el-icon {
            font-size: 20px;
          }
        }
        
        &:hover .card-arrow {
          background: #409eff;
          color: white;
        }
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .equipment-management-container {
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
  }
}
</style>
