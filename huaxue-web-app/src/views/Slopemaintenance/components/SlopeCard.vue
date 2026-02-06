<template>
  <el-card class="slope-card" shadow="hover" :class="{ 'closed': !slope.status }">
    <template #header>
      <div class="card-header">
        <div class="slope-name">
          <el-icon><Location /></el-icon>
          <span>{{ slope.name }}</span>
        </div>
        <el-switch
          v-model="slope.status"
          :active-value="1"
          :inactive-value="0"
          active-text="开放"
          inactive-text="关闭"
          @change="handleStatusChange"
        />
      </div>
    </template>
    
    <div class="card-body">
      <!-- 雪道图片 -->
      <div class="slope-image" v-if="slope.imageUrl">
        <el-image
          :src="getImageUrl(slope.imageUrl)"
          :preview-src-list="[getImageUrl(slope.imageUrl)]"
          fit="cover"
          :preview-teleported="true"
          style="width: 100%; height: 200px; cursor: pointer;"
        />
      </div>
      
      <div class="slope-info">
        <div class="info-item">
          <span class="label">雪道编号：</span>
          <span class="value">{{ slope.slopeCode }}</span>
        </div>
        <div class="info-item">
          <span class="label">难度等级：</span>
          <el-tag :type="getDifficultyType(slope.difficulty)">
            {{ getDifficultyText(slope.difficulty) }}
          </el-tag>
        </div>
        <div class="info-item">
          <span class="label">长度：</span>
          <span class="value">{{ slope.length }}米</span>
        </div>
        <div class="info-item">
          <span class="label">宽度：</span>
          <span class="value">{{ slope.width }}米</span>
        </div>
        <div class="info-item">
          <span class="label">最大容量：</span>
          <span class="value">{{ slope.maxCapacity }}人</span>
        </div>
        <div class="info-item" v-if="slope.description">
          <span class="label">描述：</span>
          <span class="value">{{ slope.description }}</span>
        </div>
      </div>
      
      <div class="card-actions">
        <el-button type="primary" icon="Edit" @click="handleEdit">编辑</el-button>
        <el-button type="danger" icon="Delete" @click="handleDelete">删除</el-button>
      </div>
    </div>
  </el-card>
</template>

<script setup>
import { Location, Edit, Delete } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCurrentInstance } from 'vue'

const props = defineProps({
  slope: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['edit', 'delete', 'status-change'])

const { proxy } = getCurrentInstance()
const baseUrl = import.meta.env.VITE_APP_BASE_API || ''

// 获取完整图片URL
const getImageUrl = (url) => {
  if (!url) return ''
  
  // 如果是完整的 HTTP/HTTPS URL，直接返回
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url
  }
  
  // 如果已经包含 baseUrl，直接返回
  if (url.startsWith(baseUrl)) {
    return url
  }
  
  // 处理 Windows 本地路径（如 D:\ruoyi\uploadPath\...）
  // 需要转换为 /profile/upload/... 格式
  if (url.includes('\\') || url.match(/^[A-Za-z]:/)) {
    // 查找 upload 目录的位置
    const uploadIndex = url.toLowerCase().indexOf('upload')
    if (uploadIndex !== -1) {
      // 提取 upload 后面的路径，并转换为正斜杠
      let relativePath = url.substring(uploadIndex).replace(/\\/g, '/')
      // 确保以 / 开头
      if (!relativePath.startsWith('/')) {
        relativePath = '/' + relativePath
      }
      // 如果路径中已经包含 /profile/upload/，直接使用
      if (relativePath.includes('/profile/upload/')) {
        const finalPath = relativePath.substring(relativePath.indexOf('/profile/'))
        return (baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl) + finalPath
      }
      // 否则添加 /profile/ 前缀
      const finalPath = '/profile/upload' + relativePath.substring('/upload'.length)
      return (baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl) + finalPath
    }
  }
  
  // 如果以 /profile/ 开头，直接拼接 baseUrl（修复双斜杠问题）
  if (url.startsWith('/profile/')) {
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    return cleanBaseUrl + url
  }
  
  // 如果以 /upload/ 开头，添加 /profile 前缀
  if (url.startsWith('/upload/')) {
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    return cleanBaseUrl + '/profile' + url
  }
  
  // 如果以 / 开头，添加 /profile/upload 前缀（假设是相对路径）
  if (url.startsWith('/')) {
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    // 检查是否已经是完整路径格式
    if (url.includes('upload')) {
      return cleanBaseUrl + '/profile' + url
    }
    return cleanBaseUrl + '/profile/upload' + url
  }
  
  // 默认情况：添加 /profile/upload/ 前缀
  const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
  return cleanBaseUrl + '/profile/upload/' + url
}

// 难度等级类型映射
const getDifficultyType = (difficulty) => {
  const typeMap = {
    '1': 'success',  // 初级
    '2': 'warning',  // 中级
    '3': 'danger'    // 高级
  }
  return typeMap[difficulty] || 'info'
}

// 难度等级文本映射
const getDifficultyText = (difficulty) => {
  const textMap = {
    '1': '初级',
    '2': '中级',
    '3': '高级'
  }
  return textMap[difficulty] || '未知'
}

// 处理状态变更
const handleStatusChange = (value) => {
  emit('status-change', props.slope.id, value)
}

// 处理编辑
const handleEdit = () => {
  emit('edit', props.slope)
}

// 处理删除
const handleDelete = () => {
  ElMessageBox.confirm(
    `确定要删除雪道"${props.slope.name}"吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    emit('delete', props.slope.id)
  }).catch(() => {
    // 取消删除
  })
}
</script>

<style scoped lang="scss">
.slope-card {
  margin-bottom: 20px;
  transition: all 0.3s;
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }
  
  &.closed {
    opacity: 0.7;
    border-left: 4px solid #f56c6c;
  }
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .slope-name {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 18px;
      font-weight: bold;
      color: #303133;
      
      .el-icon {
        color: #409eff;
      }
    }
  }
  
  .card-body {
    .slope-image {
      margin-bottom: 20px;
      border-radius: 8px;
      overflow: hidden;
      cursor: pointer;
      transition: transform 0.3s;
      
      &:hover {
        transform: scale(1.02);
      }
      
      img {
        width: 100%;
        height: 200px;
        object-fit: cover;
        display: block;
      }
    }
    
    .slope-info {
      margin-bottom: 20px;
      
      .info-item {
        display: flex;
        align-items: center;
        margin-bottom: 12px;
        font-size: 14px;
        
        .label {
          color: #909399;
          min-width: 90px;
        }
        
        .value {
          color: #303133;
          flex: 1;
        }
      }
    }
    
    .card-actions {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      padding-top: 15px;
      border-top: 1px solid #ebeef5;
    }
  }
}
</style>
