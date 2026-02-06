<template>
  <div class="app-container home">
    <!-- 游客/教练/前台 - 简化版首页 -->
    <template v-if="isSimpleUser">
      <!-- 欢迎横幅 -->
      <el-row :gutter="20" class="welcome-section">
        <el-col :span="24">
          <el-card class="welcome-card" shadow="hover">
            <div class="welcome-content">
              <h1 class="welcome-title">🏂 欢迎来到滑雪场</h1>
              <p class="welcome-desc">{{ welcomeMessage }}</p>
              <div class="welcome-time">
                <el-icon><Clock /></el-icon>
                <span>{{ currentTime }}</span>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <!-- 通知公告 -->
      <el-row :gutter="20" class="notice-section">
        <el-col :span="24">
          <NoticeList ref="noticeListRef" />
        </el-col>
      </el-row>

      <!-- 快捷功能 -->
      <el-row :gutter="20" class="quick-features-section">
        <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="feature in quickFeatures" :key="feature.name">
          <el-card class="quick-feature-card" shadow="hover" @click="handleQuickFeature(feature)">
            <div class="feature-icon-wrapper">
              <el-icon :size="40" :color="feature.color">
                <component :is="feature.icon" />
              </el-icon>
            </div>
            <h3 class="feature-title">{{ feature.title }}</h3>
            <p class="feature-desc">{{ feature.desc }}</p>
          </el-card>
        </el-col>
      </el-row>
    </template>

    <!-- 管理员 - 完整版首页 -->
    <template v-else>
      <!-- 欢迎横幅 -->
      <el-row :gutter="20" class="welcome-section">
        <el-col :span="24">
          <el-card class="welcome-card" shadow="hover">
            <div class="welcome-content">
              <h1 class="welcome-title">🏂 欢迎使用滑雪场管理系统</h1>
              <p class="welcome-desc">专业的滑雪场运营管理平台，为您提供全方位的管理解决方案</p>
              <div class="welcome-time">
                <el-icon><Clock /></el-icon>
                <span>{{ currentTime }}</span>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <!-- 数据统计卡片 -->
      <el-row :gutter="20" class="stats-section">
      <el-col :xs="24" :sm="12" :md="6" :lg="6">
        <el-card class="stat-card stat-card-primary" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon :size="40"><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.todayVisitors }}</div>
              <div class="stat-label">今日访客</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6" :lg="6">
        <el-card class="stat-card stat-card-success" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon :size="40"><ShoppingCart /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.todayOrders }}</div>
              <div class="stat-label">今日订单</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6" :lg="6">
        <el-card class="stat-card stat-card-warning" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon :size="40"><Money /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">¥{{ stats.todayRevenue }}</div>
              <div class="stat-label">今日营收</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6" :lg="6">
        <el-card class="stat-card stat-card-info" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon :size="40"><Calendar /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.activeSlopes }}</div>
              <div class="stat-label">开放雪道</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 通知公告 -->
    <el-row :gutter="20" class="notice-section">
      <el-col :span="24">
        <NoticeList ref="noticeListRef" />
      </el-col>
    </el-row>

    <!-- 功能模块 -->
    <el-row :gutter="20" class="features-section">
      <el-col :xs="24" :sm="12" :md="8" :lg="8">
        <el-card class="feature-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <el-icon><Ticket /></el-icon>
              <span>票务管理</span>
            </div>
          </template>
          <div class="feature-content">
            <p>• 门票销售与预订管理</p>
            <p>• 票务统计与报表分析</p>
            <p>• 会员优惠与折扣管理</p>
            <el-button type="primary" link @click="goTicketSales">进入管理 →</el-button>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="8">
        <el-card class="feature-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <el-icon><Location /></el-icon>
              <span>雪道管理</span>
            </div>
          </template>
          <div class="feature-content">
            <p>• 雪道信息查询与维护</p>
            <p>• 雪道状态实时监控</p>
            <p>• 雪道维护计划管理</p>
            <el-button type="primary" link @click="goSlopeInfo">进入管理 →</el-button>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="8">
        <el-card class="feature-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <el-icon><Box /></el-icon>
              <span>雪具管理</span>
            </div>
          </template>
          <div class="feature-content">
            <p>• 滑雪设备租赁管理</p>
            <p>• 设备库存与维护</p>
            <p>• 设备使用统计分析</p>
            <el-button type="primary" link @click="goEquipment">进入管理 →</el-button>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="8">
        <el-card class="feature-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <el-icon><UserFilled /></el-icon>
              <span>教练信息查询</span>
            </div>
          </template>
          <div class="feature-content">
            <p>• 教练信息查询与管理</p>
            <p>• 教练预约与排班</p>
            <p>• 课程安排与管理</p>
            <el-button type="primary" link @click="goCoach">进入管理 →</el-button>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="8">
        <el-card class="feature-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <el-icon><DataAnalysis /></el-icon>
              <span>数据统计</span>
            </div>
          </template>
          <div class="feature-content">
            <p>• 运营数据统计分析</p>
            <p>• 财务报表生成</p>
            <p>• 业绩详情查看</p>
            <el-button type="primary" link @click="goStatistics">进入管理 →</el-button>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="8">
        <el-card class="feature-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <el-icon><Message /></el-icon>
              <span>消息管理</span>
            </div>
          </template>
          <div class="feature-content">
            <p>• 公告通知发布</p>
            <p>• 留言板管理</p>
            <p>• 客户反馈处理</p>
            <el-button type="primary" link @click="goMessageBoard">进入管理 →</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 系统信息 -->
    <el-row :gutter="20" class="info-section">
      <el-col :xs="24" :sm="24" :md="12" :lg="12">
        <el-card class="info-card">
          <template #header>
            <div class="card-header">
              <el-icon><InfoFilled /></el-icon>
              <span>系统信息</span>
            </div>
          </template>
          <div class="info-content">
            <p><strong>系统名称：</strong>滑雪场管理系统</p>
            <p><strong>当前版本：</strong>v{{ version }}</p>
            <p><strong>系统时间：</strong>{{ currentTime }}</p>
            <p><strong>运行状态：</strong><el-tag type="success" size="small">正常运行</el-tag></p>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12" :lg="12">
        <el-card class="info-card">
          <template #header>
            <div class="card-header">
              <el-icon><Guide /></el-icon>
              <span>快速操作</span>
            </div>
          </template>
          <div class="quick-actions">
            <el-button type="primary" icon="Plus" @click="goTicketSales">新增订单</el-button>
            <el-button type="success" icon="Edit" @click="goSlopeMaintenance">编辑雪道</el-button>
            <el-button type="warning" icon="View" @click="goStatistics">查看报表</el-button>
            <el-button type="info" icon="Setting" @click="goSystemConfig">系统设置</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
    </template>
  </div>
</template>

<script setup name="Index">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { Clock, User, ShoppingCart, Money, Calendar, Ticket, Location, Box, UserFilled, DataAnalysis, Message, InfoFilled, Guide, Document, Setting } from '@element-plus/icons-vue'
import NoticeList from '@/views/index/components/NoticeList.vue'
import useUserStore from '@/store/modules/user'

const router = useRouter()
const userStore = useUserStore()
const noticeListRef = ref(null)

const version = ref('1.0.0')
const currentTime = ref('')
let timeInterval = null

// 判断是否为简化用户（游客、教练、前台、后勤人员）
// 角色键：admin(超级管理员), common(普通角色), Tourist(游客), Coach(教练), Frontdesk(雪场前台), houqing(后勤人员)
const isSimpleUser = computed(() => {
  const roles = userStore.roles || []
  // 只有超级管理员(admin)显示完整版，其他角色都显示简化版
  return !roles.includes('admin')
})

// 欢迎消息（根据角色显示不同内容）
const welcomeMessage = computed(() => {
  const roles = userStore.roles || []
  const userName = userStore.name || '游客'
  
  if (roles.includes('Coach')) {
    return `欢迎，${userName}教练！这里是您的教练工作台`
  } else if (roles.includes('Frontdesk')) {
    return `欢迎，${userName}！雪场前台工作台`
  } else if (roles.includes('Tourist')) {
    return `欢迎，${userName}！查看最新通知和公告信息`
  } else if (roles.includes('houqing')) {
    return `欢迎，${userName}！后勤管理工作台`
  } else {
    return `欢迎，${userName}！查看最新通知和公告信息`
  }
})

// 快捷功能（根据角色显示不同功能）
const quickFeatures = computed(() => {
  const roles = userStore.roles || []
  
  if (roles.includes('Coach')) {
    // 教练角色
    return [
      { name: 'appointment', title: '我的预约', desc: '查看和管理预约信息', icon: 'Calendar', color: '#409eff', path: '/CoachAppointment' },
      { name: 'schedule', title: '课程安排', desc: '查看课程时间表', icon: 'Document', color: '#67c23a', path: '/Curriculum' },
      { name: 'info', title: '个人信息', desc: '查看和编辑个人信息', icon: 'UserFilled', color: '#e6a23c', path: '/user/profile' }
    ]
  } else if (roles.includes('Frontdesk')) {
    // 雪场前台角色
    return [
      { name: 'order', title: '订单处理', desc: '处理游客订单', icon: 'ShoppingCart', color: '#409eff', path: '/OrderProcessingView' },
      { name: 'ticket', title: '票务管理', desc: '门票销售和管理', icon: 'Ticket', color: '#67c23a', path: '/TicketSales' },
      { name: 'equipment', title: '雪具管理', desc: '雪具租赁管理', icon: 'Box', color: '#e6a23c', path: '/SkiEquipmentManagement' },
      { name: 'info', title: '个人信息', desc: '查看和编辑个人信息', icon: 'UserFilled', color: '#909399', path: '/user/profile' }
    ]
  } else if (roles.includes('Tourist')) {
    // 游客角色
    return [
      { name: 'booking', title: '门票预订', desc: '在线预订滑雪门票', icon: 'Ticket', color: '#409eff', path: '/TicketBooking' },
      { name: 'order', title: '我的订单', desc: '查看我的订单', icon: 'Document', color: '#67c23a', path: '/my-orders' },
      { name: 'slope', title: '雪道信息', desc: '查看雪道信息', icon: 'Location', color: '#e6a23c', path: '/SkiSlopeInformationInquiry' },
      { name: 'coach', title: '教练信息', desc: '查看教练信息', icon: 'UserFilled', color: '#909399', path: '/CoachInformationInquiry' },
      { name: 'equipment', title: '雪具租赁', desc: '在线租赁雪具', icon: 'Box', color: '#f56c6c', path: '/SkiEquipmentManagement' },
      { name: 'profile', title: '个人中心', desc: '个人信息管理', icon: 'Setting', color: '#606266', path: '/user/profile' }
    ]
  } else if (roles.includes('houqing')) {
    // 后勤人员角色
    return [
      { name: 'equipment', title: '雪具管理', desc: '雪具库存和维护', icon: 'Box', color: '#409eff', path: '/SkiEquipmentManagement' },
      { name: 'slope', title: '雪道维护', desc: '雪道维护管理', icon: 'Location', color: '#67c23a', path: '/Slopemaintenance' },
      { name: 'info', title: '个人信息', desc: '查看和编辑个人信息', icon: 'UserFilled', color: '#e6a23c', path: '/user/profile' }
    ]
  } else {
    // 普通角色或其他角色（默认显示游客功能）
    return [
      { name: 'booking', title: '门票预订', desc: '在线预订滑雪门票', icon: 'Ticket', color: '#409eff', path: '/TicketBooking' },
      { name: 'order', title: '我的订单', desc: '查看我的订单', icon: 'Document', color: '#67c23a', path: '/my-orders' },
      { name: 'slope', title: '雪道信息', desc: '查看雪道信息', icon: 'Location', color: '#e6a23c', path: '/SkiSlopeInformationInquiry' },
      { name: 'coach', title: '教练信息', desc: '查看教练信息', icon: 'UserFilled', color: '#909399', path: '/CoachInformationInquiry' },
      { name: 'equipment', title: '雪具租赁', desc: '在线租赁雪具', icon: 'Box', color: '#f56c6c', path: '/SkiEquipmentManagement' },
      { name: 'profile', title: '个人中心', desc: '个人信息管理', icon: 'Setting', color: '#606266', path: '/user/profile' }
    ]
  }
})

// 统计数据
const stats = ref({
  todayVisitors: 128,
  todayOrders: 56,
  todayRevenue: '128,500',
  activeSlopes: 8
})

// 快捷功能点击
const handleQuickFeature = (feature) => {
  if (feature.path) {
    router.push(feature.path)
  }
}

// 更新时间
const updateTime = () => {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')
  const seconds = String(now.getSeconds()).padStart(2, '0')
  currentTime.value = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

onMounted(() => {
  updateTime()
  timeInterval = setInterval(updateTime, 1000)
})

onUnmounted(() => {
  if (timeInterval) {
    clearInterval(timeInterval)
  }
})

// 快速跳转各业务模块（路径根据你的菜单实际路径可自行调整）
const goTicketSales = () => {
  router.push('/TicketSales')
}

const goSlopeInfo = () => {
  router.push('/Slopemaintenance')
}

const goEquipment = () => {
  router.push('/SkiEquipmentManagement')
}

const goCoach = () => {
  router.push('/Coach')
}

const goStatistics = () => {
  router.push('/OperationalDataStatistics')
}

const goMessageBoard = () => {
  router.push('/MessageBoard')
}

const goSlopeMaintenance = () => {
  router.push('/Slopemaintenance')
}

const goSystemConfig = () => {
  router.push('/system/config')
}
</script>

<style scoped lang="scss">
.home {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);

  // 欢迎区域
  .welcome-section {
    margin-bottom: 20px;
    
    .welcome-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border: none;
      color: white;
      
      :deep(.el-card__body) {
        padding: 30px;
      }
      
      .welcome-content {
        text-align: center;
        
        .welcome-title {
          font-size: 32px;
          font-weight: bold;
          margin-bottom: 10px;
          color: white;
        }
        
        .welcome-desc {
          font-size: 16px;
          margin-bottom: 15px;
          opacity: 0.9;
        }
        
        .welcome-time {
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
          font-size: 14px;
          opacity: 0.8;
        }
      }
    }
  }

  // 统计卡片
  .stats-section {
    margin-bottom: 20px;
    
    .stat-card {
      border: none;
      transition: all 0.3s;
      
      &:hover {
        transform: translateY(-5px);
      }
      
      :deep(.el-card__body) {
        padding: 20px;
      }
      
      .stat-content {
        display: flex;
        align-items: center;
        gap: 15px;
        
        .stat-icon {
          width: 60px;
          height: 60px;
          border-radius: 10px;
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
            margin-bottom: 5px;
          }
          
          .stat-label {
            font-size: 14px;
            color: #909399;
          }
        }
      }
      
      &.stat-card-primary .stat-icon {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      }
      
      &.stat-card-success .stat-icon {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      }
      
      &.stat-card-warning .stat-icon {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      }
      
      &.stat-card-info .stat-icon {
        background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      }
    }
  }

  // 通知公告区域
  .notice-section {
    margin-bottom: 20px;
  }

  // 快捷功能区域（简化版）
  .quick-features-section {
    margin-bottom: 20px;
    
    .quick-feature-card {
      margin-bottom: 20px;
      border: none;
      cursor: pointer;
      transition: all 0.3s;
      text-align: center;
      height: 100%;
      
      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      }
      
      :deep(.el-card__body) {
        padding: 30px 20px;
      }
      
      .feature-icon-wrapper {
        margin-bottom: 15px;
        display: flex;
        justify-content: center;
      }
      
      .feature-title {
        font-size: 18px;
        font-weight: 600;
        color: #303133;
        margin: 0 0 10px 0;
      }
      
      .feature-desc {
        font-size: 14px;
        color: #909399;
        margin: 0;
        line-height: 1.6;
      }
    }
  }

  // 功能模块
  .features-section {
    margin-bottom: 20px;
    
    .feature-card {
      margin-bottom: 20px;
      border: none;
      transition: all 0.3s;
      
      &:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      }
      
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
      
      .feature-content {
        p {
          margin: 8px 0;
          color: #606266;
          line-height: 1.8;
        }
        
        .el-button {
          margin-top: 10px;
        }
      }
    }
  }

  // 信息区域
  .info-section {
    .info-card {
      border: none;
      
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
      
      .info-content {
        p {
          margin: 12px 0;
          color: #606266;
          line-height: 1.8;
          
          strong {
            color: #303133;
          }
        }
      }
      
      .quick-actions {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        
        .el-button {
          flex: 1;
          min-width: 120px;
        }
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .home {
    .welcome-section .welcome-card .welcome-content .welcome-title {
      font-size: 24px;
    }
    
    .stats-section .stat-card .stat-content .stat-info .stat-value {
      font-size: 22px;
    }
  }
}
</style>
