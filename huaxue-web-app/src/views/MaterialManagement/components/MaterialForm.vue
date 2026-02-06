<template>
  <el-dialog
    :model-value="modelValue"
    :title="materialId ? '修改物资' : '新增物资'"
    width="800px"
    @update:model-value="$emit('update:modelValue', $event)"
    @close="handleClose"
  >
    <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="物资编码" prop="materialCode">
            <el-input v-model="form.materialCode" placeholder="请输入物资编码" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="物资名称" prop="materialName">
            <el-input v-model="form.materialName" placeholder="请输入物资名称" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="物资类型" prop="materialType">
            <el-select v-model="form.materialType" placeholder="请选择物资类型" style="width: 100%">
              <el-option label="急救药品" value="1" />
              <el-option label="医疗用品" value="2" />
              <el-option label="其他" value="3" />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="单位" prop="unit">
            <el-input v-model="form.unit" placeholder="如：盒、瓶、支" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="规格型号" prop="specification">
            <el-input v-model="form.specification" placeholder="请输入规格型号" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="生产厂家" prop="manufacturer">
            <el-input v-model="form.manufacturer" placeholder="请输入生产厂家" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="批次号" prop="batchNumber">
            <el-input v-model="form.batchNumber" placeholder="请输入批次号" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="单价" prop="unitPrice">
            <el-input-number v-model="form.unitPrice" :precision="2" :min="0" style="width: 100%" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="生产日期" prop="productionDate">
            <el-date-picker
              v-model="form.productionDate"
              type="date"
              placeholder="请选择生产日期"
              style="width: 100%"
              value-format="YYYY-MM-DD"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="有效期至" prop="expiryDate">
            <el-date-picker
              v-model="form.expiryDate"
              type="date"
              placeholder="请选择有效期至"
              style="width: 100%"
              value-format="YYYY-MM-DD"
            />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="安全库存" prop="safetyStock">
            <el-input-number v-model="form.safetyStock" :min="0" style="width: 100%" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="当前库存" prop="currentStock">
            <el-input-number v-model="form.currentStock" :min="0" style="width: 100%" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-form-item label="存放位置" prop="storageLocation">
        <el-input v-model="form.storageLocation" placeholder="请输入存放位置" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-radio-group v-model="form.status">
          <el-radio label="0">正常</el-radio>
          <el-radio label="1">停用</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="备注" prop="remark">
        <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" />
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
import { getMaterial, addMaterial, updateMaterial } from '@/api/material'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  materialId: {
    type: Number,
    default: null
  }
})

const emit = defineEmits(['update:modelValue', 'success'])

const formRef = ref(null)
const submitting = ref(false)

const form = reactive({
  materialCode: '',
  materialName: '',
  materialType: '',
  specification: '',
  unit: '',
  manufacturer: '',
  batchNumber: '',
  productionDate: '',
  expiryDate: '',
  safetyStock: 0,
  currentStock: 0,
  unitPrice: 0,
  storageLocation: '',
  status: '0',
  remark: ''
})

const rules = {
  materialCode: [{ required: true, message: '请输入物资编码', trigger: 'blur' }],
  materialName: [{ required: true, message: '请输入物资名称', trigger: 'blur' }],
  materialType: [{ required: true, message: '请选择物资类型', trigger: 'change' }]
}

// 加载物资信息
const loadMaterial = () => {
  if (props.materialId) {
    getMaterial(props.materialId).then(response => {
      Object.assign(form, response.data)
    })
  } else {
    resetForm()
  }
}

// 重置表单
const resetForm = () => {
  form.materialCode = ''
  form.materialName = ''
  form.materialType = ''
  form.specification = ''
  form.unit = ''
  form.manufacturer = ''
  form.batchNumber = ''
  form.productionDate = ''
  form.expiryDate = ''
  form.safetyStock = 0
  form.currentStock = 0
  form.unitPrice = 0
  form.storageLocation = ''
  form.status = '0'
  form.remark = ''
  formRef.value?.clearValidate()
}

// 提交
const handleSubmit = () => {
  formRef.value?.validate(valid => {
    if (valid) {
      submitting.value = true
      const api = props.materialId ? updateMaterial : addMaterial
      api(form)
        .then(() => {
          ElMessage.success(props.materialId ? '修改成功' : '新增成功')
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
    loadMaterial()
  }
})
</script>
