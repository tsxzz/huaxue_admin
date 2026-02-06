<template>
  <el-dialog
    v-model="visible"
    :title="dialogTitle"
    width="600px"
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="form"
      :rules="rules"
      label-width="100px"
    >
      <el-form-item label="雪道名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入雪道名称" />
      </el-form-item>
      
      <el-form-item label="雪道编号" prop="slopeCode">
        <el-input v-model="form.slopeCode" placeholder="请输入雪道编号" />
      </el-form-item>
      
      <el-form-item label="难度等级" prop="difficulty">
        <el-select v-model="form.difficulty" placeholder="请选择难度等级" style="width: 100%">
          <el-option label="初级" value="1" />
          <el-option label="中级" value="2" />
          <el-option label="高级" value="3" />
        </el-select>
      </el-form-item>
      
      <el-form-item label="长度(米)" prop="length">
        <el-input-number v-model="form.length" :min="0" :precision="0" style="width: 100%" />
      </el-form-item>
      
      <el-form-item label="宽度(米)" prop="width">
        <el-input-number v-model="form.width" :min="0" :precision="0" style="width: 100%" />
      </el-form-item>
      
      <el-form-item label="最大容量" prop="maxCapacity">
        <el-input-number v-model="form.maxCapacity" :min="0" :precision="0" style="width: 100%" />
      </el-form-item>
      
      <el-form-item label="状态" prop="status">
        <el-radio-group v-model="form.status">
          <el-radio :label="1">开放</el-radio>
          <el-radio :label="0">关闭</el-radio>
        </el-radio-group>
      </el-form-item>
      
      <el-form-item label="描述" prop="description">
        <el-input
          v-model="form.description"
          type="textarea"
          :rows="3"
          placeholder="请输入雪道描述"
        />
      </el-form-item>
      
      <el-form-item label="雪道图片" prop="imageUrl">
        <ImageUpload v-model="form.imageUrl" :limit="1" :fileSize="5" :fileType="['png', 'jpg', 'jpeg', 'gif']" />
      </el-form-item>
    </el-form>
    
    <template #footer>
      <el-button @click="handleClose">取消</el-button>
      <el-button type="primary" @click="handleSubmit" :loading="loading">确定</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, watch, computed, onMounted, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import ImageUpload from '@/components/ImageUpload'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  slope: {
    type: Object,
    default: null
  },
  loading: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue', 'submit'])

const formRef = ref(null)
const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const dialogTitle = computed(() => {
  return props.slope ? '编辑雪道' : '新增雪道'
})

const form = reactive({
  id: null,
  name: '',
  slopeCode: '',
  difficulty: '1',
  length: 0,
  width: 0,
  maxCapacity: 0,
  status: 1,
  description: '',
  imageUrl: ''
})

const rules = {
  name: [
    { required: true, message: '请输入雪道名称', trigger: 'blur' }
  ],
  slopeCode: [
    { required: true, message: '请输入雪道编号', trigger: 'blur' }
  ],
  difficulty: [
    { required: true, message: '请选择难度等级', trigger: 'change' }
  ],
  length: [
    { required: true, message: '请输入长度', trigger: 'blur' },
    { type: 'number', min: 0, message: '长度必须大于0', trigger: 'blur' }
  ],
  width: [
    { required: true, message: '请输入宽度', trigger: 'blur' },
    { type: 'number', min: 0, message: '宽度必须大于0', trigger: 'blur' }
  ],
  maxCapacity: [
    { required: true, message: '请输入最大容量', trigger: 'blur' },
    { type: 'number', min: 0, message: '最大容量必须大于0', trigger: 'blur' }
  ]
}

// 重置表单函数
const resetForm = () => {
  Object.assign(form, {
    id: null,
    name: '',
    slopeCode: '',
    difficulty: '1',
    length: 0,
    width: 0,
    maxCapacity: 0,
    status: 1,
    description: '',
    imageUrl: ''
  })
  // 使用 nextTick 确保 formRef 已经初始化
  if (formRef.value) {
    formRef.value.resetFields()
  }
}

// 关闭对话框
const handleClose = () => {
  visible.value = false
  resetForm()
}

// 提交表单
const handleSubmit = () => {
  formRef.value?.validate((valid) => {
    if (valid) {
      emit('submit', { ...form })
    } else {
      ElMessage.warning('请完善表单信息')
    }
  })
}

// 填充表单数据
const fillForm = (slopeData) => {
  if (slopeData) {
    Object.assign(form, {
      id: slopeData.id,
      name: slopeData.name || '',
      slopeCode: slopeData.slopeCode || '',
      difficulty: slopeData.difficulty || '1',
      length: slopeData.length || 0,
      width: slopeData.width || 0,
      maxCapacity: slopeData.maxCapacity || 0,
      status: slopeData.status !== undefined ? slopeData.status : 1,
      description: slopeData.description || '',
      imageUrl: slopeData.imageUrl || ''
    })
  } else {
    resetForm()
  }
}

// 监听slope变化，填充表单
watch(() => props.slope, (newVal) => {
  fillForm(newVal)
})

// 监听对话框显示状态
watch(visible, (val) => {
  if (!val) {
    resetForm()
  } else {
    // 对话框打开时，填充表单数据
    nextTick(() => {
      fillForm(props.slope)
    })
  }
})

// 组件挂载时初始化
onMounted(() => {
  if (props.slope) {
    fillForm(props.slope)
  }
})
</script>

<style scoped lang="scss">
:deep(.el-dialog__body) {
  padding: 20px;
}
</style>
