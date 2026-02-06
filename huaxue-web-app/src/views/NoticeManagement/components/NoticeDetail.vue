<template>
  <el-dialog
    v-model="dialogVisible"
    title="通知详情"
    width="800px"
    append-to-body
    @close="handleClose"
  >
    <div v-if="noticeData" class="notice-detail">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="通知标题" :span="2">
          <span style="font-size: 18px; font-weight: bold">{{ noticeData.noticeTitle }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="通知类型">
          <el-tag v-if="noticeData.noticeType === '1'" type="info">通知</el-tag>
          <el-tag v-else-if="noticeData.noticeType === '2'" type="success">公告</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="优先级">
          <el-tag v-if="noticeData.priority === 0">普通</el-tag>
          <el-tag v-else-if="noticeData.priority === 1" type="warning">重要</el-tag>
          <el-tag v-else-if="noticeData.priority === 2" type="danger">紧急</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag v-if="noticeData.status === '0'" type="success">正常</el-tag>
          <el-tag v-else type="info">关闭</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="阅读次数">
          {{ noticeData.readCount || 0 }}次
        </el-descriptions-item>
        <el-descriptions-item label="发布时间">
          {{ noticeData.publishTime || '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="过期时间">
          {{ noticeData.expireTime || '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">
          {{ noticeData.createTime }}
        </el-descriptions-item>
        <el-descriptions-item label="更新时间">
          {{ noticeData.updateTime || '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="通知内容" :span="2">
          <div class="notice-content">{{ noticeData.noticeContent }}</div>
        </el-descriptions-item>
        <el-descriptions-item v-if="noticeData.remark" label="备注" :span="2">
          {{ noticeData.remark }}
        </el-descriptions-item>
      </el-descriptions>
    </div>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">关闭</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  noticeData: {
    type: Object,
    default: () => null
  }
})

const emit = defineEmits(['update:modelValue'])

const dialogVisible = ref(false)

watch(() => props.modelValue, (val) => {
  dialogVisible.value = val
})

watch(dialogVisible, (val) => {
  emit('update:modelValue', val)
})

const handleClose = () => {
  dialogVisible.value = false
}
</script>

<style scoped lang="scss">
.notice-detail {
  padding: 10px 0;
}

.notice-content {
  white-space: pre-wrap;
  word-break: break-word;
  line-height: 1.6;
  padding: 10px;
  background: #f5f7fa;
  border-radius: 4px;
  min-height: 100px;
}

.dialog-footer {
  text-align: right;
}
</style>
