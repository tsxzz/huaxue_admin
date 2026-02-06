<template>
  <el-dialog
    :model-value="modelValue"
    :title="approvalStatus === '1' ? '批准领用' : '拒绝领用'"
    width="500px"
    @update:model-value="$emit('update:modelValue', $event)"
    @close="handleClose"
  >
    <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
      <el-form-item label="物资名称">
        <el-input :value="record?.materialName" disabled />
      </el-form-item>
      <el-form-item label="领用数量">
        <el-input :value="record?.quantity" disabled />
      </el-form-item>
      <el-form-item label="领用人">
        <el-input :value="record?.userName" disabled />
      </el-form-item>
      <el-form-item label="审批意见" prop="approvalRemark">
        <el-input
          v-model="form.approvalRemark"
          type="textarea"
          :rows="4"
          :placeholder="approvalStatus === '1' ? '请输入批准意见（可选）' : '请输入拒绝原因'"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button @click="handleClose">取消</el-button>
      <el-button
        :type="approvalStatus === '1' ? 'success' : 'danger'"
        @click="handleSubmit"
        :loading="submitting"
      >
        {{ approvalStatus === '1' ? '批准' : '拒绝' }}
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { approveUsage } from '@/api/material'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  record: {
    type: Object,
    default: null
  },
  approvalStatus: {
    type: String,
    default: '1'
  }
})

const emit = defineEmits(['update:modelValue', 'success'])

const formRef = ref(null)
const submitting = ref(false)

const form = reactive({
  approvalRemark: ''
})

const rules = {
  approvalRemark: [
    { required: props.approvalStatus === '2', message: '请输入拒绝原因', trigger: 'blur' }
  ]
}

// 重置表单
const resetForm = () => {
  form.approvalRemark = ''
  formRef.value?.clearValidate()
}

// 提交
const handleSubmit = () => {
  formRef.value?.validate(valid => {
    if (valid) {
      submitting.value = true
      approveUsage(props.record.id, {
        approvalStatus: props.approvalStatus,
        approvalRemark: form.approvalRemark
      })
        .then(() => {
          ElMessage.success(props.approvalStatus === '1' ? '批准成功' : '拒绝成功')
          emit('success')
        })
        .finally(() => {
          submitting.value = false
        })
    }
  })
}

// 关闭
const handleClose = () => {
  emit('update:modelValue', false)
  resetForm()
}

watch(() => props.modelValue, (val) => {
  if (val) {
    resetForm()
  }
})
</script>
