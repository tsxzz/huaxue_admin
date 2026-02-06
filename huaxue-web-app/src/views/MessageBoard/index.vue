<template>
  <div class="message-board-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><Message /></el-icon>
          <h1>留言板</h1>
        </div>
        <p class="header-desc">分享您的想法，与其他用户交流</p>
      </div>
    </div>

    <!-- 发布留言区域 -->
    <el-card class="post-card" shadow="never" v-if="isLoggedIn">
      <div class="post-header">
        <el-avatar :size="40" :src="userAvatar">{{ userName?.charAt(0) }}</el-avatar>
        <div class="post-user-info">
          <div class="user-name">{{ userName || '游客' }}</div>
          <div class="post-tip">写下您的留言...</div>
        </div>
      </div>
      <el-input
        v-model="newMessage.content"
        type="textarea"
        :rows="4"
        placeholder="请输入留言内容..."
        maxlength="500"
        show-word-limit
        class="post-input"
      />
      <div class="post-actions">
        <el-button type="primary" icon="Promotion" @click="handlePostMessage" :loading="posting">
          发布留言
        </el-button>
        <el-button icon="RefreshLeft" @click="resetPostForm">清空</el-button>
      </div>
    </el-card>

    <!-- 留言列表 -->
    <div class="messages-list">
      <el-card
        v-for="message in messageList"
        :key="message.id"
        class="message-card"
        shadow="hover"
      >
        <!-- 主留言 -->
        <div class="message-item">
          <div class="message-header">
            <el-avatar :size="40" :src="getAvatar(message.userName)">
              {{ message.userName?.charAt(0) || '匿' }}
            </el-avatar>
            <div class="message-info">
              <div class="message-user">
                <span class="user-name">{{ message.userName || '匿名用户' }}</span>
                <el-tag v-if="isAdmin" size="small" type="danger" style="margin-left: 8px">管理员</el-tag>
              </div>
              <div class="message-time">{{ formatTime(message.createTime) }}</div>
            </div>
            <div class="message-actions">
              <el-button
                v-if="canDelete(message)"
                link
                type="danger"
                icon="Delete"
                size="small"
                @click="handleDelete(message.id)"
              >
                删除
              </el-button>
            </div>
          </div>
          <div class="message-content">{{ message.content }}</div>
          <div class="message-footer">
            <el-button
              link
              :type="message.isLiked ? 'danger' : ''"
              @click="handleLike(message)"
            >
              <el-icon>
                <component :is="message.isLiked ? StarFilled : Star" />
              </el-icon>
              {{ message.likeCount || 0 }}
            </el-button>
            <el-button link icon="ChatLineRound" @click="toggleReply(message)">
              {{ message.replyCount || 0 }} 条回复
            </el-button>
          </div>

          <!-- 回复输入框 -->
          <div v-if="message.showReply && isLoggedIn" class="reply-input-area">
            <el-input
              v-model="message.replyContent"
              type="textarea"
              :rows="2"
              placeholder="写下您的回复..."
              maxlength="200"
              show-word-limit
            />
            <div class="reply-actions">
              <el-button type="primary" size="small" @click="handleReply(message)" :loading="replying">
                回复
              </el-button>
              <el-button size="small" @click="cancelReply(message)">取消</el-button>
            </div>
          </div>

          <!-- 回复列表 -->
          <div v-if="message.replies && message.replies.length > 0" class="replies-list">
            <div
              v-for="reply in message.replies"
              :key="reply.id"
              class="reply-item"
            >
              <el-avatar :size="32" :src="getAvatar(reply.userName)">
                {{ reply.userName?.charAt(0) || '匿' }}
              </el-avatar>
              <div class="reply-content-wrapper">
                <div class="reply-header">
                  <span class="reply-user-name">{{ reply.userName || '匿名用户' }}</span>
                  <span class="reply-time">{{ formatTime(reply.createTime) }}</span>
                  <el-button
                    v-if="canDelete(reply)"
                    link
                    type="danger"
                    icon="Delete"
                    size="small"
                    style="margin-left: auto"
                    @click="handleDelete(reply.id)"
                  >
                    删除
                  </el-button>
                </div>
                <div class="reply-content">{{ reply.content }}</div>
              </div>
            </div>
          </div>
        </div>
      </el-card>

      <!-- 空状态 -->
      <el-empty v-if="!loading && messageList.length === 0" description="暂无留言，快来发表第一条吧！" />
    </div>

    <!-- 分页 -->
    <div class="pagination-wrapper" v-if="total > 0">
      <el-pagination
        v-model:current-page="queryParams.pageNum"
        v-model:page-size="queryParams.pageSize"
        :page-sizes="[10, 20, 50, 100]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handlePageChange"
      />
    </div>
  </div>
</template>

<script setup name="MessageBoard">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Message, Star, StarFilled, ChatLineRound, Delete, Promotion, RefreshLeft } from '@element-plus/icons-vue'
import { listMessageBoard, addMessageBoard, delMessageBoard, toggleLike } from '@/api/messageBoard'
import useUserStore from '@/store/modules/user'

const userStore = useUserStore()

// 响应式数据
const loading = ref(false)
const posting = ref(false)
const replying = ref(false)
const messageList = ref([])
const total = ref(0)

// 查询参数
const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  status: '0'
})

// 新留言表单
const newMessage = reactive({
  content: '',
  parentId: null
})

// 计算属性
const isLoggedIn = computed(() => {
  return userStore.token && userStore.token.length > 0
})

const userName = computed(() => {
  return userStore.name || '游客'
})

const userAvatar = computed(() => {
  return userStore.avatar || ''
})

const isAdmin = computed(() => {
  return userStore.roles && userStore.roles.includes('admin')
})

// 获取头像
const getAvatar = (name) => {
  // 可以根据用户名生成头像，这里简化处理
  return ''
}

// 格式化时间
const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  const now = new Date()
  const diff = now - date
  
  if (diff < 60000) {
    return '刚刚'
  } else if (diff < 3600000) {
    return Math.floor(diff / 60000) + '分钟前'
  } else if (diff < 86400000) {
    return Math.floor(diff / 3600000) + '小时前'
  } else if (diff < 604800000) {
    return Math.floor(diff / 86400000) + '天前'
  } else {
    return date.toLocaleDateString('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    })
  }
}

// 判断是否可以删除
const canDelete = (message) => {
  if (!isLoggedIn.value) return false
  if (isAdmin.value) return true
  return message.userId === userStore.id
}

// 查询留言列表
const getList = () => {
  loading.value = true
  const params = {
    ...queryParams,
    params: {
      pageNum: queryParams.pageNum,
      pageSize: queryParams.pageSize
    }
  }
  
  listMessageBoard(params)
    .then(response => {
      messageList.value = response.rows || []
      total.value = response.total || 0
      
      // 初始化回复输入框状态
      messageList.value.forEach(msg => {
        msg.showReply = false
        msg.replyContent = ''
      })
    })
    .catch(() => {
      messageList.value = []
      total.value = 0
    })
    .finally(() => {
      loading.value = false
    })
}

// 发布留言
const handlePostMessage = () => {
  if (!isLoggedIn.value) {
    ElMessage.warning('请先登录')
    return
  }
  
  if (!newMessage.content || newMessage.content.trim().length === 0) {
    ElMessage.warning('请输入留言内容')
    return
  }
  
  if (newMessage.content.trim().length > 500) {
    ElMessage.warning('留言内容不能超过500字')
    return
  }
  
  posting.value = true
  const messageData = {
    content: newMessage.content.trim(),
    parentId: null,
    status: '0'
  }
  
  addMessageBoard(messageData)
    .then(() => {
      ElMessage.success('发布成功')
      resetPostForm()
      getList()
    })
    .catch(() => {
      ElMessage.error('发布失败')
    })
    .finally(() => {
      posting.value = false
    })
}

// 重置发布表单
const resetPostForm = () => {
  newMessage.content = ''
  newMessage.parentId = null
}

// 切换回复输入框
const toggleReply = (message) => {
  if (!isLoggedIn.value) {
    ElMessage.warning('请先登录')
    return
  }
  message.showReply = !message.showReply
  if (!message.showReply) {
    message.replyContent = ''
  }
}

// 取消回复
const cancelReply = (message) => {
  message.showReply = false
  message.replyContent = ''
}

// 回复留言
const handleReply = (message) => {
  if (!message.replyContent || message.replyContent.trim().length === 0) {
    ElMessage.warning('请输入回复内容')
    return
  }
  
  if (message.replyContent.trim().length > 200) {
    ElMessage.warning('回复内容不能超过200字')
    return
  }
  
  replying.value = true
  const replyData = {
    content: message.replyContent.trim(),
    parentId: message.id,
    status: '0'
  }
  
  addMessageBoard(replyData)
    .then(() => {
      ElMessage.success('回复成功')
      cancelReply(message)
      getList()
    })
    .catch(() => {
      ElMessage.error('回复失败')
    })
    .finally(() => {
      replying.value = false
    })
}

// 点赞/取消点赞
const handleLike = (message) => {
  if (!isLoggedIn.value) {
    ElMessage.warning('请先登录')
    return
  }
  
  toggleLike(message.id)
    .then(() => {
      // 更新点赞状态
      message.isLiked = !message.isLiked
      if (message.isLiked) {
        message.likeCount = (message.likeCount || 0) + 1
      } else {
        message.likeCount = Math.max(0, (message.likeCount || 0) - 1)
      }
    })
    .catch(() => {
      ElMessage.error('操作失败')
    })
}

// 删除留言
const handleDelete = (id) => {
  ElMessageBox.confirm('确定要删除这条留言吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      return delMessageBoard(id)
    })
    .then(() => {
      ElMessage.success('删除成功')
      getList()
    })
    .catch(() => {
      // 用户取消或删除失败
    })
}

// 分页相关
const handlePageChange = (page) => {
  queryParams.pageNum = page
  getList()
}

const handleSizeChange = (size) => {
  queryParams.pageSize = size
  queryParams.pageNum = 1
  getList()
}

// 初始化
onMounted(() => {
  getList()
})
</script>

<style scoped lang="scss">
.message-board-container {
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

  .post-card {
    margin-bottom: 20px;
    
    .post-header {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 16px;
      
      .post-user-info {
        flex: 1;
        
        .user-name {
          font-weight: 600;
          color: #303133;
          margin-bottom: 4px;
        }
        
        .post-tip {
          font-size: 12px;
          color: #909399;
        }
      }
    }
    
    .post-input {
      margin-bottom: 12px;
    }
    
    .post-actions {
      display: flex;
      justify-content: flex-end;
      gap: 12px;
    }
  }

  .messages-list {
    .message-card {
      margin-bottom: 20px;
      
      .message-item {
        .message-header {
          display: flex;
          align-items: flex-start;
          gap: 12px;
          margin-bottom: 12px;
          
          .message-info {
            flex: 1;
            
            .message-user {
              display: flex;
              align-items: center;
              margin-bottom: 4px;
              
              .user-name {
                font-weight: 600;
                color: #303133;
              }
            }
            
            .message-time {
              font-size: 12px;
              color: #909399;
            }
          }
          
          .message-actions {
            display: flex;
            gap: 8px;
          }
        }
        
        .message-content {
          color: #606266;
          line-height: 1.8;
          margin-bottom: 12px;
          white-space: pre-wrap;
          word-break: break-word;
        }
        
        .message-footer {
          display: flex;
          gap: 16px;
          padding-top: 12px;
          border-top: 1px solid #f0f0f0;
        }
        
        .reply-input-area {
          margin-top: 16px;
          padding-top: 16px;
          border-top: 1px solid #f0f0f0;
          
          .reply-actions {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            margin-top: 8px;
          }
        }
        
        .replies-list {
          margin-top: 16px;
          padding-top: 16px;
          border-top: 1px solid #f0f0f0;
          
          .reply-item {
            display: flex;
            gap: 12px;
            margin-bottom: 16px;
            
            &:last-child {
              margin-bottom: 0;
            }
            
            .reply-content-wrapper {
              flex: 1;
              
              .reply-header {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 6px;
                
                .reply-user-name {
                  font-weight: 600;
                  color: #409eff;
                  font-size: 14px;
                }
                
                .reply-time {
                  font-size: 12px;
                  color: #909399;
                }
              }
              
              .reply-content {
                color: #606266;
                line-height: 1.6;
                white-space: pre-wrap;
                word-break: break-word;
              }
            }
          }
        }
      }
    }
  }

  .pagination-wrapper {
    display: flex;
    justify-content: center;
    margin-top: 20px;
  }
}
</style>
