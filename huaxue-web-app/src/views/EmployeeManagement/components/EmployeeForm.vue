<template>
  <el-dialog :title="title" v-model="visible" width="600px" append-to-body @close="handleClose">
    <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
      <el-row>
        <el-col :span="12">
          <el-form-item label="员工姓名" prop="nickName">
            <el-input v-model="form.nickName" placeholder="请输入员工姓名" maxlength="30" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="归属部门" prop="deptId">
            <el-select v-model="form.deptId" placeholder="请选择归属部门" style="width: 100%">
              <el-option
                v-for="dept in deptOptions"
                :key="dept.deptId"
                :label="dept.deptName"
                :value="dept.deptId"
              />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="手机号码" prop="phonenumber">
            <el-input v-model="form.phonenumber" placeholder="请输入手机号码" maxlength="11" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="form.email" placeholder="请输入邮箱" maxlength="50" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item v-if="!form.userId" label="登录账号" prop="userName">
            <el-input v-model="form.userName" placeholder="请输入登录账号" maxlength="30" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item v-if="!form.userId" label="登录密码" prop="password">
            <el-input
              v-model="form.password"
              placeholder="请输入登录密码"
              type="password"
              maxlength="20"
              show-password
            />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="性别">
            <el-select v-model="form.sex" placeholder="请选择" style="width: 100%">
              <el-option label="男" value="0" />
              <el-option label="女" value="1" />
              <el-option label="未知" value="2" />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="状态">
            <el-radio-group v-model="form.status">
              <el-radio label="0">正常</el-radio>
              <el-radio label="1">停用</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="岗位">
            <el-select v-model="form.postIds" multiple placeholder="请选择岗位" style="width: 100%">
              <el-option
                v-for="item in postOptions"
                :key="item.postId"
                :label="item.postName"
                :value="item.postId"
                :disabled="item.status == 1"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="角色" prop="roleIds">
            <el-select v-model="form.roleIds" multiple placeholder="请选择角色" style="width: 100%">
              <el-option
                v-for="item in roleOptions"
                :key="item.roleId"
                :label="item.roleName"
                :value="item.roleId"
                :disabled="item.status == 1"
              />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="24">
          <el-form-item label="备注">
            <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" :rows="3" />
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="submitForm" :loading="submitting">确 定</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { getEmployee, addEmployee, updateEmployee } from '@/api/employee'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  userId: {
    type: Number,
    default: null
  },
  roleOptions: {
    type: Array,
    default: () => []
  },
  postOptions: {
    type: Array,
    default: () => []
  },
  employeeDepts: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['update:modelValue', 'success'])

const visible = ref(false)
const title = ref('')
const submitting = ref(false)
const formRef = ref(null)
const deptOptions = ref([])

const form = reactive({
  userId: undefined,
  nickName: '',
  userName: '',
  password: '',
  deptId: null,
  phonenumber: '',
  email: '',
  sex: '0',
  status: '0',
  postIds: [],
  roleIds: [],
  remark: ''
})

const rules = {
  nickName: [{ required: true, message: '员工姓名不能为空', trigger: 'blur' }],
  userName: [
    { required: true, message: '登录账号不能为空', trigger: 'blur' },
    { min: 2, max: 20, message: '登录账号长度必须介于 2 和 20 之间', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '登录密码不能为空', trigger: 'blur' },
    { min: 5, max: 20, message: '登录密码长度必须介于 5 和 20 之间', trigger: 'blur' }
  ],
  phonenumber: [
    { pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ],
  email: [{ type: 'email', message: '请输入正确的邮箱地址', trigger: ['blur', 'change'] }],
  roleIds: [{ required: true, message: '请选择角色', trigger: 'change' }]
}

// 监听 visible 变化
watch(() => props.modelValue, (val) => {
  visible.value = val
  if (val) {
    if (props.userId) {
      title.value = '修改员工'
      getEmployeeInfo()
    } else {
      title.value = '新增员工'
      resetForm()
    }
    getDeptList()
  }
})

watch(visible, (val) => {
  emit('update:modelValue', val)
})

// 获取部门列表（只显示三个员工部门）
const getDeptList = async () => {
  // 直接使用传入的员工部门列表
  deptOptions.value = props.employeeDepts || []
}

// 获取员工信息
const getEmployeeInfo = async () => {
  try {
    const response = await getEmployee(props.userId)
    if (response.code === 200) {
      const data = response.data
      form.userId = data.userId
      form.nickName = data.nickName || ''
      form.userName = data.userName || ''
      form.deptId = data.deptId
      form.phonenumber = data.phonenumber || ''
      form.email = data.email || ''
      form.sex = data.sex || '0'
      form.status = data.status || '0'
      form.postIds = response.postIds || []
      form.roleIds = response.roleIds || []
      form.remark = data.remark || ''
    }
  } catch (error) {
    console.error('获取员工信息失败:', error)
  }
}

// 重置表单
const resetForm = () => {
  form.userId = undefined
  form.nickName = ''
  form.userName = ''
  form.password = ''
  form.deptId = null
  form.phonenumber = ''
  form.email = ''
  form.sex = '0'
  form.status = '0'
  form.postIds = []
  form.roleIds = []
  form.remark = ''
  formRef.value?.resetFields()
}

// 提交表单
const submitForm = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      submitting.value = true
      const submitData = { ...form }
      
      if (form.userId) {
        // 修改
        updateEmployee(submitData)
          .then(() => {
            ElMessage.success('修改成功')
            handleClose()
            emit('success')
          })
          .catch(() => {})
          .finally(() => {
            submitting.value = false
          })
      } else {
        // 新增
        addEmployee(submitData)
          .then(() => {
            ElMessage.success('新增成功')
            handleClose()
            emit('success')
          })
          .catch(() => {})
          .finally(() => {
            submitting.value = false
          })
      }
    }
  })
}

// 关闭对话框
const handleClose = () => {
  visible.value = false
  resetForm()
}
</script>

<style scoped>
</style>
