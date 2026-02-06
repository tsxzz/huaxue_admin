<template>
  <el-card class="slope-info-card" shadow="hover">
    <!-- 雪道图片 -->
    <div class="slope-image-wrapper" v-if="slope.imageUrl">
      <el-image
        :src="getImageUrl(slope.imageUrl)"
        :preview-src-list="[getImageUrl(slope.imageUrl)]"
        fit="cover"
        :preview-teleported="true"
        class="slope-image"
      >
        <template #error>
          <div class="image-slot">
            <el-icon><Picture /></el-icon>
          </div>
        </template>
      </el-image>
    </div>
    <div class="image-placeholder" v-else>
      <el-icon class="placeholder-icon"><Picture /></el-icon>
      <span>暂无图片</span>
    </div>
    
    <!-- 雪道信息 -->
    <div class="slope-content">
      <div class="slope-header">
        <h3 class="slope-name">
          <el-icon><Location /></el-icon>
          {{ slope.name }}
        </h3>
        <el-tag :type="getDifficultyType(slope.difficulty)" size="large" effect="dark">
          {{ getDifficultyText(slope.difficulty) }}
        </el-tag>
      </div>
      
      <div class="slope-details">
        <div class="detail-item">
          <el-icon class="detail-icon"><Document /></el-icon>
          <span class="detail-label">编号：</span>
          <span class="detail-value">{{ slope.slopeCode }}</span>
        </div>
        
        <div class="detail-item">
          <el-icon class="detail-icon"><DataLine /></el-icon>
          <span class="detail-label">长度：</span>
          <span class="detail-value">{{ slope.length }}米</span>
        </div>
        
        <div class="detail-item">
          <el-icon class="detail-icon"><Grid /></el-icon>
          <span class="detail-label">宽度：</span>
          <span class="detail-value">{{ slope.width }}米</span>
        </div>
        
        <div class="detail-item">
          <el-icon class="detail-icon"><User /></el-icon>
          <span class="detail-label">最大容量：</span>
          <span class="detail-value">{{ slope.maxCapacity }}人</span>
        </div>
      </div>
      
      <div class="slope-description" v-if="slope.description">
        <el-icon><ChatDotRound /></el-icon>
        <p>{{ slope.description }}</p>
      </div>
    </div>
  </el-card>
</template>

<script setup>
import { Location, Picture, Document, DataLine, Grid, User, ChatDotRound } from '@element-plus/icons-vue'
import { getCurrentInstance } from 'vue'

const props = defineProps({
  slope: {
    type: Object,
    required: true
  }
})

const { proxy } = getCurrentInstance()
const baseUrl = import.meta.env.VITE_APP_BASE_API || ''

// 获取完整图片URL
const getImageUrl = (url) => {
  if (!url) return ''
  
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url
  }
  
  if (url.startsWith(baseUrl)) {
    return url
  }
  
  // 处理 Windows 本地路径
  if (url.includes('\\') || url.match(/^[A-Za-z]:/)) {
    const uploadIndex = url.toLowerCase().indexOf('upload')
    if (uploadIndex !== -1) {
      let relativePath = url.substring(uploadIndex).replace(/\\/g, '/')
      if (!relativePath.startsWith('/')) {
        relativePath = '/' + relativePath
      }
      if (relativePath.includes('/profile/upload/')) {
        const finalPath = relativePath.substring(relativePath.indexOf('/profile/'))
        return (baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl) + finalPath
      }
      const finalPath = '/profile/upload' + relativePath.substring('/upload'.length)
      return (baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl) + finalPath
    }
  }
  
  if (url.startsWith('/profile/')) {
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    return cleanBaseUrl + url
  }
  
  if (url.startsWith('/upload/')) {
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    return cleanBaseUrl + '/profile' + url
  }
  
  if (url.startsWith('/')) {
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    if (url.includes('upload')) {
      return cleanBaseUrl + '/profile' + url
    }
    return cleanBaseUrl + '/profile/upload' + url
  }
  
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
</script>

<style scoped lang="scss">
.slope-info-card {
  height: 100%;
  transition: all 0.3s;
  border-radius: 12px;
  overflow: hidden;
  
  &:hover {
    transform: translateY(-8px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  }
  
  .slope-image-wrapper {
    width: 100%;
    height: 240px;
    overflow: hidden;
    position: relative;
    
    .slope-image {
      width: 100%;
      height: 100%;
      cursor: pointer;
      transition: transform 0.3s;
      
      &:hover {
        transform: scale(1.05);
      }
    }
    
    .image-slot {
      display: flex;
      justify-content: center;
      align-items: center;
      width: 100%;
      height: 100%;
      background: #f5f7fa;
      color: #909399;
      font-size: 30px;
    }
  }
  
  .image-placeholder {
    width: 100%;
    height: 240px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    
    .placeholder-icon {
      font-size: 48px;
      margin-bottom: 10px;
      opacity: 0.8;
    }
    
    span {
      font-size: 14px;
      opacity: 0.9;
    }
  }
  
  .slope-content {
    padding: 20px;
    
    .slope-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 2px solid #f0f0f0;
      
      .slope-name {
        margin: 0;
        font-size: 20px;
        font-weight: bold;
        color: #303133;
        display: flex;
        align-items: center;
        gap: 8px;
        
        .el-icon {
          color: #409eff;
          font-size: 22px;
        }
      }
    }
    
    .slope-details {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-bottom: 20px;
      
      .detail-item {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 12px;
        background: #f8f9fa;
        border-radius: 8px;
        transition: all 0.3s;
        
        &:hover {
          background: #e9ecef;
          transform: translateX(4px);
        }
        
        .detail-icon {
          color: #409eff;
          font-size: 18px;
        }
        
        .detail-label {
          color: #909399;
          font-size: 14px;
        }
        
        .detail-value {
          color: #303133;
          font-weight: 600;
          font-size: 14px;
        }
      }
    }
    
    .slope-description {
      padding: 16px;
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      border-radius: 8px;
      border-left: 4px solid #409eff;
      
      display: flex;
      gap: 10px;
      
      .el-icon {
        color: #409eff;
        font-size: 18px;
        margin-top: 2px;
        flex-shrink: 0;
      }
      
      p {
        margin: 0;
        color: #606266;
        line-height: 1.6;
        font-size: 14px;
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .slope-info-card {
    .slope-content {
      .slope-details {
        grid-template-columns: 1fr;
      }
    }
  }
}
</style>
