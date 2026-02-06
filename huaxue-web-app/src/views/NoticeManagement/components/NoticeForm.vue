<template>
  <el-dialog
    v-model="dialogVisible"
    :title="formData.id ? '编辑通知' : '新增通知'"
    width="800px"
    append-to-body
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="formData"
      :rules="rules"
      label-width="100px"
    >
      <el-form-item label="通知标题" prop="noticeTitle">
        <el-input
          v-model="formData.noticeTitle"
          placeholder="请输入通知标题"
          maxlength="200"
          show-word-limit
        />
      </el-form-item>
      <el-form-item label="通知类型" prop="noticeType">
        <el-radio-group v-model="formData.noticeType">
          <el-radio label="1">通知</el-radio>
          <el-radio label="2">公告</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="优先级" prop="priority">
        <el-radio-group v-model="formData.priority">
          <el-radio :label="0">普通</el-radio>
          <el-radio :label="1">重要</el-radio>
          <el-radio :label="2">紧急</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="通知内容" prop="noticeContent">
        <el-input
          v-model="formData.noticeContent"
          type="textarea"
          :rows="8"
          placeholder="请输入通知内容"
          maxlength="5000"
          show-word-limit
        />
      </el-form-item>
      <el-form-item label="发布时间">
        <el-date-picker
          v-model="formData.publishTime"
          type="datetime"
          placeholder="选择发布时间"
          value-format="YYYY-MM-DD HH:mm:ss"
          style="width: 100%"
        />
      </el-form-item>
      <el-form-item label="过期时间">
        <el-date-picker
          v-model="formData.expireTime"
          type="datetime"
          placeholder="选择过期时间（选填）"
          value-format="YYYY-MM-DD HH:mm:ss"
          style="width: 100%"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-radio-group v-model="formData.status">
          <el-radio label="0">正常</el-radio>
          <el-radio label="1">关闭</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="备注">
        <el-input
          v-model="formData.remark"
          type="textarea"
          :rows="3"
          placeholder="请输入备注"
          maxlength="500"
          show-word-limit
        />
      </el-form-item>
    </el-form>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { ElMessage } from 'element-plus'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  formData: {
    type: Object,
    default: () => ({})
  }
})

const emit = defineEmits(['update:modelValue', 'submit'])

const dialogVisible = ref(false)
const formRef = ref(null)
const submitting = ref(false)

const rules = {
  noticeTitle: [
    { required: true, message: '请输入通知标题', trigger: 'blur' },
    { max: 200, message: '通知标题不能超过200个字符', trigger: 'blur' }
  ],
  noticeType: [
    { required: true, message: '请选择通知类型', trigger: 'change' }
  ],
  noticeContent: [
    { required: true, message: '请输入通知内容', trigger: 'blur' }
  ],
  status: [
    { required: true, message: '请选择状态', trigger: 'change' }
  ]
}

watch(() => props.modelValue, (val) => {
  dialogVisible.value = val
})

watch(dialogVisible, (val) => {
  emit('update:modelValue', val)
})

const handleClose = () => {
  dialogVisible.value = false
  formRef.value?.resetFields()
}

const handleSubmit = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      submitting.value = true
      emit('submit', { ...props.formData })
      setTimeout(() => {
        submitting.value = false
      }, 500)
    }
  })
}
</script>

<style scoped>
.dialog-footer {
  text-align: right;
}
</style>
