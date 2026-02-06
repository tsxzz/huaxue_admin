<template>
  <el-dialog
    :model-value="modelValue"
    :title="operationType === '1' ? '物资入库' : '物资出库'"
    width="600px"
    @update:model-value="$emit('update:modelValue', $event)"
    @close="handleClose"
  >
    <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
      <el-form-item label="物资名称">
        <el-input :value="material?.materialName" disabled />
      </el-form-item>
      <el-form-item label="物资编码">
        <el-input :value="material?.materialCode" disabled />
      </el-form-item>
      <el-form-item label="当前库存">
        <el-input :value="material?.currentStock || 0" disabled />
      </el-form-item>
      <el-form-item label="数量" prop="quantity">
        <el-input-number v-model="form.quantity" :min="1" style="width: 100%" />
      </el-form-item>
      <el-form-item v-if="operationType === '1'" label="单价" prop="unitPrice">
        <el-input-number v-model="form.unitPrice" :precision="2" :min="0" style="width: 100%" />
      </el-form-item>
      <el-form-item v-if="operationType === '1'" label="供应商" prop="supplier">
        <el-input v-model="form.supplier" placeholder="请输入供应商" />
      </el-form-item>
      <el-form-item v-if="operationType === '2'" label="用途说明" prop="purpose">
        <el-input v-model="form.purpose" type="textarea" :rows="3" placeholder="请输入用途说明" />
      </el-form-item>
      <el-form-item v-if="operationType === '1'" label="批次号" prop="batchNumber">
        <el-input v-model="form.batchNumber" placeholder="请输入批次号" />
      </el-form-item>
      <el-form-item v-if="operationType === '1'" label="生产日期" prop="productionDate">
        <el-date-picker
          v-model="form.productionDate"
          type="date"
          placeholder="请选择生产日期"
          style="width: 100%"
          value-format="YYYY-MM-DD"
        />
      </el-form-item>
      <el-form-item v-if="operationType === '1'" label="有效期至" prop="expiryDate">
        <el-date-picker
          v-model="form.expiryDate"
          type="date"
          placeholder="请选择有效期至"
          style="width: 100%"
          value-format="YYYY-MM-DD"
        />
      </el-form-item>
      <el-form-item label="备注" prop="remark">
        <el-input v-model="form.remark" type="textarea" :rows="2" placeholder="请输入备注" />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button @click="handleClose">取消</el-button>
      <el-button type="primary" @click="handleSubmit" :loading="submitting">确定</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { addMaterialStock } from '@/api/material'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  material: {
    type: Object,
    default: null
  },
  operationType: {
    type: String,
    default: '1' // 1入库 2出库
  }
})

const emit = defineEmits(['update:modelValue', 'success'])

const formRef = ref(null)
const submitting = ref(false)

const form = reactive({
  materialId: null,
  materialCode: '',
  materialName: '',
  operationType: '1',
  quantity: 1,
  unitPrice: 0,
  supplier: '',
  purpose: '',
  batchNumber: '',
  productionDate: '',
  expiryDate: '',
  remark: ''
})

const rules = {
  quantity: [{ required: true, message: '请输入数量', trigger: 'blur' }],
  purpose: [{ required: true, message: '请输入用途说明', trigger: 'blur' }]
}

// 重置表单
const resetForm = () => {
  form.materialId = null
  form.materialCode = ''
  form.materialName = ''
  form.operationType = props.operationType
  form.quantity = 1
  form.unitPrice = 0
  form.supplier = ''
  form.purpose = ''
  form.batchNumber = ''
  form.productionDate = ''
  form.expiryDate = ''
  form.remark = ''
  formRef.value?.clearValidate()
}

// 提交
const handleSubmit = () => {
  formRef.value?.validate(valid => {
    if (valid) {
      if (props.operationType === '2' && form.quantity > (props.material?.currentStock || 0)) {
        ElMessage.warning('出库数量不能大于当前库存')
        return
      }
      
      submitting.value = true
      form.materialId = props.material?.id
      form.materialCode = props.material?.materialCode
      form.materialName = props.material?.materialName
      form.operationType = props.operationType
      
      addMaterialStock(form)
        .then(() => {
          ElMessage.success(props.operationType === '1' ? '入库成功' : '出库成功')
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
