<template>
  <el-dialog
    v-model="visible"
    :title="dialogTitle"
    width="700px"
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="form"
      :rules="rules"
      label-width="100px"
    >
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="雪具编号" prop="equipmentCode">
            <el-input v-model="form.equipmentCode" placeholder="请输入雪具编号" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="雪具名称" prop="name">
            <el-input v-model="form.name" placeholder="请输入雪具名称" />
          </el-form-item>
        </el-col>
      </el-row>
      
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="雪具类型" prop="category">
            <el-select v-model="form.category" placeholder="请选择雪具类型" style="width: 100%">
              <el-option label="双板滑雪板" value="1" />
              <el-option label="单板滑雪板" value="2" />
              <el-option label="滑雪杖" value="3" />
              <el-option label="头盔" value="4" />
              <el-option label="护目镜" value="5" />
              <el-option label="滑雪服" value="6" />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="品牌" prop="brand">
            <el-input v-model="form.brand" placeholder="请输入品牌" />
          </el-form-item>
        </el-col>
      </el-row>
      
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="型号" prop="model">
            <el-input v-model="form.model" placeholder="请输入型号" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="尺寸/规格" prop="size">
            <el-input v-model="form.size" placeholder="请输入尺寸/规格" />
          </el-form-item>
        </el-col>
      </el-row>
      
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="颜色" prop="color">
            <el-input v-model="form.color" placeholder="请输入颜色" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="总库存" prop="totalQuantity">
            <el-input-number v-model="form.totalQuantity" :min="0" :precision="0" style="width: 100%" />
          </el-form-item>
        </el-col>
      </el-row>
      
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="购买价格" prop="purchasePrice">
            <el-input-number v-model="form.purchasePrice" :min="0" :precision="2" style="width: 100%">
              <template #prefix>¥</template>
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="租赁价格" prop="rentalPrice">
            <el-input-number v-model="form.rentalPrice" :min="0" :precision="2" style="width: 100%">
              <template #prefix>¥</template>
            </el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
      
      <el-form-item label="雪具图片" prop="imageUrl">
        <ImageUpload v-model="form.imageUrl" :limit="1" :fileSize="5" :fileType="['png', 'jpg', 'jpeg', 'gif']" />
      </el-form-item>
      
      <el-form-item label="描述" prop="description">
        <el-input
          v-model="form.description"
          type="textarea"
          :rows="3"
          placeholder="请输入描述信息"
        />
      </el-form-item>
    </el-form>
    
    <template #footer>
      <el-button @click="handleClose">取消</el-button>
      <el-button type="primary" @click="handleSubmit" :loading="loading">确定</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, watch, computed, nextTick, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import ImageUpload from '@/components/ImageUpload/index.vue'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  equipment: {
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
  return props.equipment ? '编辑雪具' : '新增雪具'
})

const form = reactive({
  id: null,
  equipmentCode: '',
  name: '',
  category: '',
  brand: '',
  model: '',
  size: '',
  color: '',
  purchasePrice: null,
  rentalPrice: null,
  imageUrl: '',
  totalQuantity: 0,
  availableQuantity: 0,
  maintenanceQuantity: 0,
  scrapQuantity: 0,
  status: 1,
  description: ''
})

const rules = {
  equipmentCode: [
    { required: true, message: '请输入雪具编号', trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入雪具名称', trigger: 'blur' }
  ],
  category: [
    { required: true, message: '请选择雪具类型', trigger: 'change' }
  ],
  totalQuantity: [
    { required: true, message: '请输入总库存', trigger: 'blur' },
    { type: 'number', min: 0, message: '总库存必须大于等于0', trigger: 'blur' }
  ]
}

// 重置表单
const resetForm = () => {
  Object.assign(form, {
    id: null,
    equipmentCode: '',
    name: '',
    category: '',
    brand: '',
    model: '',
    size: '',
    color: '',
    purchasePrice: null,
    rentalPrice: null,
    imageUrl: '',
    totalQuantity: 0,
    availableQuantity: 0,
    maintenanceQuantity: 0,
    scrapQuantity: 0,
    status: 1,
    description: ''
  })
  if (formRef.value) {
    formRef.value.resetFields()
  }
}

// 填充表单数据
const fillForm = (equipmentData) => {
  if (equipmentData) {
    Object.assign(form, {
      id: equipmentData.id,
      equipmentCode: equipmentData.equipmentCode || '',
      name: equipmentData.name || '',
      category: equipmentData.category || '',
      brand: equipmentData.brand || '',
      model: equipmentData.model || '',
      size: equipmentData.size || '',
      color: equipmentData.color || '',
      purchasePrice: equipmentData.purchasePrice || null,
      rentalPrice: equipmentData.rentalPrice || null,
      imageUrl: equipmentData.imageUrl || '',
      totalQuantity: equipmentData.totalQuantity || 0,
      availableQuantity: equipmentData.availableQuantity || 0,
      maintenanceQuantity: equipmentData.maintenanceQuantity || 0,
      scrapQuantity: equipmentData.scrapQuantity || 0,
      status: equipmentData.status !== undefined ? equipmentData.status : 1,
      description: equipmentData.description || ''
    })
  } else {
    resetForm()
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
      // 如果是新增，可用数量等于总库存
      if (!form.id && form.availableQuantity === 0) {
        form.availableQuantity = form.totalQuantity
      }
      emit('submit', { ...form })
    } else {
      ElMessage.warning('请完善表单信息')
    }
  })
}

// 监听equipment变化，填充表单
watch(() => props.equipment, (newVal) => {
  fillForm(newVal)
})

// 监听对话框显示状态
watch(visible, (val) => {
  if (!val) {
    resetForm()
  } else {
    nextTick(() => {
      fillForm(props.equipment)
    })
  }
})

// 组件挂载时初始化
onMounted(() => {
  if (props.equipment) {
    fillForm(props.equipment)
  }
})
</script>

<style scoped lang="scss">
:deep(.el-dialog__body) {
  padding: 20px;
}
</style>
