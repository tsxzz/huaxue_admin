<template>
  <el-card class="notice-list-card" shadow="hover">
    <template #header>
      <div class="card-header">
        <el-icon><Bell /></el-icon>
        <span>通知公告</span>
        <el-button
          v-if="noticeList.length > 0"
          link
          type="primary"
          size="small"
          style="margin-left: auto"
          @click="viewAll"
        >
          查看更多 →
        </el-button>
      </div>
    </template>
    <div v-loading="loading" class="notice-content">
      <div v-if="noticeList.length === 0" class="empty-notice">
        <el-empty description="暂无通知公告" :image-size="80" />
      </div>
      <div v-else class="notice-items">
        <div
          v-for="notice in noticeList"
          :key="notice.id"
          class="notice-item"
          :class="{ 'notice-urgent': notice.priority === 2, 'notice-important': notice.priority === 1 }"
          @click="handleViewDetail(notice)"
        >
          <div class="notice-header">
            <div class="notice-title-row">
              <el-tag
                v-if="notice.priority === 2"
                type="danger"
                size="small"
                effect="dark"
                class="priority-tag"
              >
                紧急
              </el-tag>
              <el-tag
                v-else-if="notice.priority === 1"
                type="warning"
                size="small"
                effect="dark"
                class="priority-tag"
              >
                重要
              </el-tag>
              <el-tag
                :type="notice.noticeType === '1' ? 'info' : 'success'"
                size="small"
                class="type-tag"
              >
                {{ notice.noticeType === '1' ? '通知' : '公告' }}
              </el-tag>
              <span class="notice-title">{{ notice.noticeTitle }}</span>
            </div>
            <span class="notice-time">{{ formatTime(notice.publishTime || notice.createTime) }}</span>
          </div>
          <div v-if="notice.noticeContent" class="notice-summary">
            {{ getSummary(notice.noticeContent) }}
          </div>
        </div>
      </div>
    </div>

    <!-- 通知详情对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      :title="currentNotice?.noticeTitle"
      width="800px"
      append-to-body
      @close="handleCloseDetail"
    >
      <div v-if="currentNotice" class="notice-detail-content">
        <div class="detail-header">
          <div class="detail-tags">
            <el-tag
              v-if="currentNotice.priority === 2"
              type="danger"
              size="small"
              effect="dark"
            >
              紧急
            </el-tag>
            <el-tag
              v-else-if="currentNotice.priority === 1"
              type="warning"
              size="small"
              effect="dark"
            >
              重要
            </el-tag>
            <el-tag
              :type="currentNotice.noticeType === '1' ? 'info' : 'success'"
              size="small"
            >
              {{ currentNotice.noticeType === '1' ? '通知' : '公告' }}
            </el-tag>
          </div>
          <div class="detail-meta">
            <span>
              <el-icon><Clock /></el-icon>
              发布时间：{{ currentNotice.publishTime || currentNotice.createTime }}
            </span>
            <span v-if="currentNotice.readCount">
              <el-icon><View /></el-icon>
              阅读次数：{{ currentNotice.readCount }}
            </span>
          </div>
        </div>
        <div class="detail-content">
          <div class="content-text">{{ currentNotice.noticeContent }}</div>
        </div>
        <div v-if="currentNotice.expireTime" class="detail-footer">
          <el-alert
            :title="`本通知将于 ${currentNotice.expireTime} 过期`"
            type="info"
            :closable="false"
            show-icon
          />
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailDialogVisible = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 所有通知列表对话框 -->
    <el-dialog
      v-model="allNoticeDialogVisible"
      title="所有通知公告"
      width="900px"
      append-to-body
    >
      <div v-loading="allNoticeLoading" class="all-notice-content">
        <div v-if="allNoticeList.length === 0" class="empty-notice">
          <el-empty description="暂无通知公告" :image-size="100" />
        </div>
        <div v-else class="all-notice-items">
          <el-card
            v-for="notice in allNoticeList"
            :key="notice.id"
            class="all-notice-item"
            :class="{ 'notice-urgent': notice.priority === 2, 'notice-important': notice.priority === 1 }"
            shadow="hover"
            @click="handleViewDetail(notice)"
          >
            <div class="all-notice-card-content">
              <div class="notice-header">
                <div class="notice-title-row">
                  <el-tag
                    v-if="notice.priority === 2"
                    type="danger"
                    size="small"
                    effect="dark"
                    class="priority-tag"
                  >
                    紧急
                  </el-tag>
                  <el-tag
                    v-else-if="notice.priority === 1"
                    type="warning"
                    size="small"
                    effect="dark"
                    class="priority-tag"
                  >
                    重要
                  </el-tag>
                  <el-tag
                    :type="notice.noticeType === '1' ? 'info' : 'success'"
                    size="small"
                    class="type-tag"
                  >
                    {{ notice.noticeType === '1' ? '通知' : '公告' }}
                  </el-tag>
                  <h4 class="notice-title">{{ notice.noticeTitle }}</h4>
                </div>
                <span class="notice-time">{{ formatTime(notice.publishTime || notice.createTime) }}</span>
              </div>
              <div v-if="notice.noticeContent" class="notice-summary">
                {{ getSummary(notice.noticeContent) }}
              </div>
            </div>
          </el-card>
        </div>
        <!-- 分页 -->
        <div v-if="allNoticeTotal > 0" class="pagination-wrapper">
          <el-pagination
            v-model:current-page="allNoticePageNum"
            v-model:page-size="allNoticePageSize"
            :total="allNoticeTotal"
            :page-sizes="[10, 20, 30]"
            layout="total, sizes, prev, pager, next"
            @size-change="getAllNoticeList"
            @current-change="getAllNoticeList"
          />
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="allNoticeDialogVisible = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Bell, Clock, View } from '@element-plus/icons-vue'
import { publicListNotice, getNotice } from '@/api/notice'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const noticeList = ref([])

// 详情对话框
const detailDialogVisible = ref(false)
const currentNotice = ref(null)

// 所有通知对话框
const allNoticeDialogVisible = ref(false)
const allNoticeLoading = ref(false)
const allNoticeList = ref([])
const allNoticeTotal = ref(0)
const allNoticePageNum = ref(1)
const allNoticePageSize = ref(10)

// 获取通知列表
const getNoticeList = async () => {
  loading.value = true
  try {
    const params = {
      status: '0', // 只查询正常状态的通知
      params: {
        pageNum: 1,
        pageSize: 5 // 首页只显示5条
      }
    }
    const response = await publicListNotice(params)
    if (response.code === 200) {
      noticeList.value = response.rows || []
    }
  } catch (error) {
    console.error('获取通知列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 格式化时间
const formatTime = (timeStr) => {
  if (!timeStr) return ''
  const date = new Date(timeStr)
  const now = new Date()
  const diff = now - date
  
  // 小于1小时显示分钟
  if (diff < 3600000) {
    const minutes = Math.floor(diff / 60000)
    return minutes <= 0 ? '刚刚' : `${minutes}分钟前`
  }
  
  // 小于24小时显示小时
  if (diff < 86400000) {
    const hours = Math.floor(diff / 3600000)
    return `${hours}小时前`
  }
  
  // 小于7天显示天数
  if (diff < 604800000) {
    const days = Math.floor(diff / 86400000)
    return `${days}天前`
  }
  
  // 超过7天显示具体日期
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${month}-${day}`
}

// 获取内容摘要
const getSummary = (content) => {
  if (!content) return ''
  // 移除HTML标签（如果有）
  const text = content.replace(/<[^>]*>/g, '')
  // 截取前50个字符
  return text.length > 50 ? text.substring(0, 50) + '...' : text
}

// 查看详情
const handleViewDetail = async (notice) => {
  try {
    const response = await getNotice(notice.id)
    if (response.code === 200) {
      currentNotice.value = response.data
      detailDialogVisible.value = true
      // 刷新列表以更新阅读次数
      getNoticeList()
      // 如果所有通知对话框打开，也刷新
      if (allNoticeDialogVisible.value) {
        getAllNoticeList()
      }
    } else {
      ElMessage.error(response.msg || '获取通知详情失败')
    }
  } catch (error) {
    console.error('获取通知详情失败:', error)
    ElMessage.error('获取通知详情失败')
  }
}

// 关闭详情
const handleCloseDetail = () => {
  currentNotice.value = null
}

// 查看更多 - 显示所有通知对话框
const viewAll = () => {
  allNoticeDialogVisible.value = true
  allNoticePageNum.value = 1
  getAllNoticeList()
}

// 获取所有通知列表
const getAllNoticeList = async () => {
  allNoticeLoading.value = true
  try {
    const params = {
      status: '0', // 只查询正常状态的通知
      params: {
        pageNum: allNoticePageNum.value,
        pageSize: allNoticePageSize.value
      }
    }
    const response = await publicListNotice(params)
    if (response.code === 200) {
      allNoticeList.value = response.rows || []
      allNoticeTotal.value = response.total || 0
    }
  } catch (error) {
    console.error('获取通知列表失败:', error)
    ElMessage.error('获取通知列表失败')
  } finally {
    allNoticeLoading.value = false
  }
}

onMounted(() => {
  getNoticeList()
})

// 暴露刷新方法供父组件调用
defineExpose({
  refresh: getNoticeList
})
</script>

<style scoped lang="scss">
.notice-list-card {
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
  
  .notice-content {
    min-height: 200px;
    
    .empty-notice {
      padding: 40px 0;
    }
    
    .notice-items {
      .notice-item {
        padding: 15px;
        margin-bottom: 12px;
        background: #f5f7fa;
        border-radius: 8px;
        border-left: 4px solid #409eff;
        cursor: pointer;
        transition: all 0.3s;
        
        &:hover {
          background: #ecf5ff;
          transform: translateX(5px);
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        &:last-child {
          margin-bottom: 0;
        }
        
        &.notice-urgent {
          border-left-color: #f56c6c;
          background: #fef0f0;
          
          &:hover {
            background: #fde2e2;
          }
        }
        
        &.notice-important {
          border-left-color: #e6a23c;
          background: #fdf6ec;
          
          &:hover {
            background: #faecd8;
          }
        }
        
        .notice-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin-bottom: 8px;
          
          .notice-title-row {
            display: flex;
            align-items: center;
            gap: 8px;
            flex: 1;
            
            .priority-tag {
              flex-shrink: 0;
            }
            
            .type-tag {
              flex-shrink: 0;
            }
            
            .notice-title {
              font-size: 15px;
              font-weight: 600;
              color: #303133;
              flex: 1;
              overflow: hidden;
              text-overflow: ellipsis;
              white-space: nowrap;
            }
          }
          
          .notice-time {
            font-size: 12px;
            color: #909399;
            flex-shrink: 0;
            margin-left: 10px;
          }
        }
        
        .notice-summary {
          font-size: 13px;
          color: #606266;
          line-height: 1.6;
          margin-top: 8px;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          line-clamp: 2;
          -webkit-box-orient: vertical;
        }
      }
    }
  }
}

.notice-detail-content {
  .detail-header {
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid #ebeef5;

    .detail-tags {
      display: flex;
      gap: 8px;
      margin-bottom: 10px;
    }

    .detail-meta {
      display: flex;
      gap: 20px;
      font-size: 13px;
      color: #909399;

      span {
        display: flex;
        align-items: center;
        gap: 4px;
      }
    }
  }

  .detail-content {
    margin-bottom: 20px;

    .content-text {
      white-space: pre-wrap;
      word-break: break-word;
      line-height: 1.8;
      font-size: 14px;
      color: #303133;
      padding: 15px;
      background: #f5f7fa;
      border-radius: 4px;
      min-height: 100px;
    }
  }

  .detail-footer {
    margin-top: 20px;
  }
}

.all-notice-content {
  max-height: 600px;
  overflow-y: auto;

  .all-notice-items {
    .all-notice-item {
      margin-bottom: 12px;
      cursor: pointer;
      transition: all 0.3s;
      border-left: 4px solid #409eff;

      &:hover {
        transform: translateX(5px);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      }

      &.notice-urgent {
        border-left-color: #f56c6c;
        background: #fef0f0;

        &:hover {
          background: #fde2e2;
        }
      }

      &.notice-important {
        border-left-color: #e6a23c;
        background: #fdf6ec;

        &:hover {
          background: #faecd8;
        }
      }

      .all-notice-card-content {
        .notice-header {
          margin-bottom: 10px;

          .notice-title-row {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;

            .notice-title {
              font-size: 16px;
              font-weight: 600;
              color: #303133;
              margin: 0;
              flex: 1;
            }
          }

          .notice-time {
            font-size: 12px;
            color: #909399;
          }
        }
      }
    }
  }

  .pagination-wrapper {
    margin-top: 20px;
    display: flex;
    justify-content: center;
  }
}
</style>
