<template>
  <el-dialog
    :model-value="modelValue"
    title="新增领用"
    width="600px"
    @update:model-value="$emit('update:modelValue', $event)"
    @close="handleClose"
  >
    <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
      <el-form-item label="物资" prop="materialId">
        <el-select
          v-model="form.materialId"
          placeholder="请选择物资"
          filterable
          style="width: 100%"
          @change="handleMaterialChange"
        >
          <el-option
            v-for="item in materialOptions"
            :key="item.id"
            :label="`${item.materialName} (库存: ${item.currentStock || 0})`"
            :value="item.id"
            :disabled="(item.currentStock || 0) === 0"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="领用数量" prop="quantity">
        <el-input-number v-model="form.quantity" :min="1" style="width: 100%" />
      </el-form-item>
      <el-form-item label="所属部门" prop="department">
        <el-input v-model="form.department" placeholder="请输入所属部门" />
      </el-form-item>
      <el-form-item label="用途说明" prop="usagePurpose">
        <el-input v-model="form.usagePurpose" type="textarea" :rows="3" placeholder="请输入用途说明" />
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
import { addMaterialUsage, listMaterial } from '@/api/material'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue', 'success'])

const formRef = ref(null)
const submitting = ref(false)
const materialOptions = ref([])

const form = reactive({
  materialId: null,
  quantity: 1,
  department: '',
  usagePurpose: '',
  remark: ''
})

const rules = {
  materialId: [{ required: true, message: '请选择物资', trigger: 'change' }],
  quantity: [{ required: true, message: '请输入领用数量', trigger: 'blur' }],
  usagePurpose: [{ required: true, message: '请输入用途说明', trigger: 'blur' }]
}

// 加载物资列表
const loadMaterials = () => {
  listMaterial({ status: '0', params: { pageNum: 1, pageSize: 1000 } })
    .then(response => {
      materialOptions.value = response.rows || []
    })
}

// 物资选择变化
const handleMaterialChange = (materialId) => {
  const material = materialOptions.value.find(item => item.id === materialId)
  if (material && form.quantity > (material.currentStock || 0)) {
    ElMessage.warning('领用数量不能大于当前库存')
    form.quantity = material.currentStock || 1
  }
}

// 重置表单
const resetForm = () => {
  form.materialId = null
  form.quantity = 1
  form.department = ''
  form.usagePurpose = ''
  form.remark = ''
  formRef.value?.clearValidate()
}

// 提交
const handleSubmit = () => {
  formRef.value?.validate(valid => {
    if (valid) {
      const material = materialOptions.value.find(item => item.id === form.materialId)
      if (form.quantity > (material?.currentStock || 0)) {
        ElMessage.warning('领用数量不能大于当前库存')
        return
      }
      
      submitting.value = true
      addMaterialUsage(form)
        .then(() => {
          ElMessage.success('领用申请提交成功')
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
    loadMaterials()
    resetForm()
  }
})
</script>
