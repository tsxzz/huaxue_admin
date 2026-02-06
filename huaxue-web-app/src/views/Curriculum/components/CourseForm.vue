<template>
  <el-dialog
    v-model="visible"
    :title="form.id ? '修改课程' : '新增课程'"
    width="600px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
      <el-form-item label="课程名称" prop="courseName">
        <el-input v-model="form.courseName" placeholder="请输入课程名称" />
      </el-form-item>
      <el-form-item label="课程类型" prop="courseType">
        <el-select v-model="form.courseType" placeholder="请选择课程类型" style="width: 100%">
          <el-option label="初级滑雪" value="初级滑雪" />
          <el-option label="中级滑雪" value="中级滑雪" />
          <el-option label="高级技巧" value="高级技巧" />
          <el-option label="自由式滑雪" value="自由式滑雪" />
          <el-option label="单板滑雪" value="单板滑雪" />
          <el-option label="双板滑雪" value="双板滑雪" />
        </el-select>
      </el-form-item>
      <el-form-item label="课程描述" prop="description">
        <el-input
          v-model="form.description"
          type="textarea"
          :rows="4"
          placeholder="请输入课程描述"
        />
      </el-form-item>
      <el-form-item label="课程时长" prop="duration">
        <el-input-number
          v-model="form.duration"
          :min="30"
          :max="180"
          :step="30"
          placeholder="分钟"
          style="width: 100%"
        />
        <span style="margin-left: 10px; color: #909399">分钟</span>
      </el-form-item>
      <el-form-item label="课程价格" prop="price">
        <el-input-number
          v-model="form.price"
          :min="0"
          :precision="2"
          placeholder="元"
          style="width: 100%"
        />
        <span style="margin-left: 10px; color: #909399">元</span>
      </el-form-item>
      <el-form-item label="最大学员数" prop="maxStudents">
        <el-input-number
          v-model="form.maxStudents"
          :min="1"
          :max="10"
          placeholder="人"
          style="width: 100%"
        />
        <span style="margin-left: 10px; color: #909399">人</span>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-radio-group v-model="form.status">
          <el-radio label="0">正常</el-radio>
          <el-radio label="1">停用</el-radio>
        </el-radio-group>
      </el-form-item>
    </el-form>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
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
  course: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['update:modelValue', 'submit'])

const visible = ref(false)
const formRef = ref(null)

const form = reactive({
  id: null,
  courseName: '',
  courseType: '',
  description: '',
  duration: 60,
  price: 0,
  maxStudents: 1,
  status: '0'
})

const rules = {
  courseName: [
    { required: true, message: '请输入课程名称', trigger: 'blur' }
  ],
  courseType: [
    { required: true, message: '请选择课程类型', trigger: 'change' }
  ],
  duration: [
    { required: true, message: '请输入课程时长', trigger: 'blur' }
  ],
  price: [
    { required: true, message: '请输入课程价格', trigger: 'blur' }
  ],
  maxStudents: [
    { required: true, message: '请输入最大学员数', trigger: 'blur' }
  ]
}

watch(() => props.modelValue, (val) => {
  visible.value = val
  if (val) {
    if (props.course) {
      Object.assign(form, props.course)
    } else {
      resetForm()
    }
  }
})

watch(visible, (val) => {
  emit('update:modelValue', val)
})

const resetForm = () => {
  form.id = null
  form.courseName = ''
  form.courseType = ''
  form.description = ''
  form.duration = 60
  form.price = 0
  form.maxStudents = 1
  form.status = '0'
  formRef.value?.clearValidate()
}

const handleClose = () => {
  visible.value = false
  resetForm()
}

const handleSubmit = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      emit('submit', { ...form })
      handleClose()
    } else {
      ElMessage.warning('请完善表单信息')
    }
  })
}
</script>

<style scoped>
.dialog-footer {
  text-align: right;
}
</style>
