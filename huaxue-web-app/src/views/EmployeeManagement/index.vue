<template>
  <div class="employee-management-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-title">
          <el-icon class="title-icon"><UserFilled /></el-icon>
          <h1>员工管理</h1>
        </div>
        <p class="header-desc">管理教练、雪场前台、后勤人员三个部门的员工信息</p>
      </div>
    </div>

    <!-- 部门统计卡片 -->
    <div class="dept-statistics">
      <el-card class="stat-card coach" shadow="hover" @click="filterByDept('coach')">
        <div class="stat-content">
          <el-icon class="stat-icon"><User /></el-icon>
          <div class="stat-info">
            <div class="stat-label">教练</div>
            <div class="stat-value">{{ deptStats.coach }}</div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card frontdesk" shadow="hover" @click="filterByDept('frontdesk')">
        <div class="stat-content">
          <el-icon class="stat-icon"><Service /></el-icon>
          <div class="stat-info">
            <div class="stat-label">雪场前台</div>
            <div class="stat-value">{{ deptStats.frontdesk }}</div>
          </div>
        </div>
      </el-card>

      <el-card class="stat-card houqing" shadow="hover" @click="filterByDept('houqing')">
        <div class="stat-content">
          <el-icon class="stat-icon"><Tools /></el-icon>
          <div class="stat-info">
            <div class="stat-label">后勤人员</div>
            <div class="stat-value">{{ deptStats.houqing }}</div>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 员工列表 -->
    <EmployeeList
      ref="employeeListRef"
      :employee-depts="employeeDepts"
      @add="handleAdd"
      @update="handleUpdate"
      @reset-pwd="handleResetPwd"
    />

    <!-- 员工表单对话框 -->
    <EmployeeForm
      v-model="formVisible"
      :user-id="currentUserId"
      :role-options="roleOptions"
      :post-options="postOptions"
      :employee-depts="employeeDepts"
      @success="handleFormSuccess"
    />

    <!-- 重置密码对话框 -->
    <el-dialog title="重置密码" v-model="resetPwdVisible" width="400px" append-to-body>
      <el-form ref="resetPwdFormRef" :model="resetPwdForm" :rules="resetPwdRules" label-width="100px">
        <el-form-item label="新密码" prop="password">
          <el-input
            v-model="resetPwdForm.password"
            type="password"
            placeholder="请输入新密码"
            show-password
            maxlength="20"
          />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            v-model="resetPwdForm.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            show-password
            maxlength="20"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="resetPwdVisible = false">取 消</el-button>
          <el-button type="primary" @click="submitResetPwd" :loading="resetPwdSubmitting">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="EmployeeManagement">
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { UserFilled, User, Service, Tools } from '@element-plus/icons-vue'
import { listEmployee, resetEmployeePwd, getEmployeeDepts, getEmployeeStatistics } from '@/api/employee'
import { listRole } from '@/api/system/role'
import { listPost } from '@/api/system/post'
import EmployeeList from './components/EmployeeList.vue'
import EmployeeForm from './components/EmployeeForm.vue'

const employeeListRef = ref(null)
const formVisible = ref(false)
const resetPwdVisible = ref(false)
const resetPwdSubmitting = ref(false)
const resetPwdFormRef = ref(null)
const currentUserId = ref(null)

const roleOptions = ref([])
const postOptions = ref([])
const employeeDepts = ref([]) // 三个部门的列表

// 部门统计
const deptStats = reactive({
  coach: 0,
  frontdesk: 0,
  houqing: 0
})

// 重置密码表单
const resetPwdForm = reactive({
  password: '',
  confirmPassword: ''
})

const resetPwdRules = {
  password: [
    { required: true, message: '新密码不能为空', trigger: 'blur' },
    { min: 5, max: 20, message: '密码长度必须介于 5 和 20 之间', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '确认密码不能为空', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== resetPwdForm.password) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// 获取员工部门列表
const getEmployeeDeptList = async () => {
  try {
    const response = await getEmployeeDepts()
    if (response.code === 200) {
      employeeDepts.value = response.data || []
    }
  } catch (error) {
    console.error('获取员工部门列表失败:', error)
  }
}

// 获取角色列表
const getRoleList = async () => {
  try {
    const response = await listRole({})
    if (response.code === 200) {
      roleOptions.value = response.data || []
    }
  } catch (error) {
    console.error('获取角色列表失败:', error)
  }
}

// 获取岗位列表
const getPostList = async () => {
  try {
    const response = await listPost({})
    if (response.code === 200) {
      postOptions.value = response.data || []
    }
  } catch (error) {
    console.error('获取岗位列表失败:', error)
  }
}

// 统计各部门员工数（通过部门）
const getDeptStatistics = async () => {
  try {
    // 优先使用后端统计接口
    try {
      const response = await getEmployeeStatistics()
      if (response.code === 200 && response.data) {
        deptStats.coach = response.data.coach || 0
        deptStats.frontdesk = response.data.frontdesk || 0
        deptStats.houqing = response.data.houqing || 0
        return
      }
    } catch (err) {
      console.warn('使用后端统计接口失败，改用前端统计:', err)
    }
    
    // 备用方案：前端统计
    // 确保部门列表已加载
    if (!employeeDepts.value || employeeDepts.value.length === 0) {
      console.warn('部门列表未加载，无法统计')
      return
    }
    
    // 获取三个部门的ID（支持多种名称格式）
    const coachDept = employeeDepts.value.find(d => {
      const name = d.deptName || ''
      return name.includes('教练')
    })
    const frontdeskDept = employeeDepts.value.find(d => {
      const name = d.deptName || ''
      return name.includes('前台') || name.includes('雪场前台')
    })
    const houqingDept = employeeDepts.value.find(d => {
      const name = d.deptName || ''
      return name.includes('后勤')
    })
    
    // 一次性获取所有员工，然后在前端统计
    const response = await listEmployee({ pageNum: 1, pageSize: 10000 })
    if (response.code === 200 && response.rows) {
      const employees = response.rows
      
      // 按部门统计
      if (coachDept) {
        deptStats.coach = employees.filter(e => e.deptId === coachDept.deptId).length
      } else {
        deptStats.coach = 0
      }
      
      if (frontdeskDept) {
        deptStats.frontdesk = employees.filter(e => e.deptId === frontdeskDept.deptId).length
      } else {
        deptStats.frontdesk = 0
      }
      
      if (houqingDept) {
        deptStats.houqing = employees.filter(e => e.deptId === houqingDept.deptId).length
      } else {
        deptStats.houqing = 0
      }
    }
  } catch (error) {
    console.error('获取部门统计失败:', error)
  }
}

// 按部门筛选
const filterByDept = (deptType) => {
  if (!employeeListRef.value) return
  
  // 根据部门类型找到对应的部门ID
  let targetDept = null
  if (deptType === 'coach') {
    targetDept = employeeDepts.value.find(d => d.deptName && d.deptName.includes('教练'))
  } else if (deptType === 'frontdesk') {
    targetDept = employeeDepts.value.find(d => d.deptName && d.deptName.includes('前台'))
  } else if (deptType === 'houqing') {
    targetDept = employeeDepts.value.find(d => d.deptName && d.deptName.includes('后勤'))
  }
  
  if (targetDept) {
    // 设置筛选条件并刷新列表
    employeeListRef.value.setDeptFilter(targetDept.deptId)
  }
}

// 新增员工
const handleAdd = () => {
  currentUserId.value = null
  formVisible.value = true
}

// 修改员工
const handleUpdate = (userId) => {
  currentUserId.value = userId
  formVisible.value = true
}

// 表单提交成功
const handleFormSuccess = () => {
  if (employeeListRef.value) {
    employeeListRef.value.getList()
  }
  getDeptStatistics()
}

// 重置密码
const handleResetPwd = (userId) => {
  currentUserId.value = userId
  resetPwdForm.password = ''
  resetPwdForm.confirmPassword = ''
  resetPwdVisible.value = true
}

// 提交重置密码
const submitResetPwd = () => {
  resetPwdFormRef.value.validate((valid) => {
    if (valid) {
      resetPwdSubmitting.value = true
      resetEmployeePwd(currentUserId.value, resetPwdForm.password)
        .then(() => {
          ElMessage.success('密码重置成功')
          resetPwdVisible.value = false
        })
        .catch(() => {})
        .finally(() => {
          resetPwdSubmitting.value = false
        })
    }
  })
}

onMounted(async () => {
  // 先获取部门列表
  await getEmployeeDeptList()
  // 然后获取其他数据
  getRoleList()
  getPostList()
  // 最后统计（确保部门列表已加载）
  await getDeptStatistics()
  // 加载员工列表
  if (employeeListRef.value) {
    employeeListRef.value.getList()
  }
})
</script>

<style scoped lang="scss">
.employee-management-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);

  .page-header {
    margin-bottom: 20px;
    
    .header-content {
      .header-title {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 8px;
        
        .title-icon {
          font-size: 32px;
          color: #409eff;
        }
        
        h1 {
          font-size: 28px;
          font-weight: bold;
          color: #303133;
          margin: 0;
        }
      }
      
      .header-desc {
        color: #909399;
        font-size: 14px;
        margin: 0;
      }
    }
  }

  .dept-statistics {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 20px;

    .stat-card {
      cursor: pointer;
      transition: all 0.3s;

      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      }

      .stat-content {
        display: flex;
        align-items: center;
        gap: 20px;

        .stat-icon {
          font-size: 40px;
          padding: 15px;
          border-radius: 12px;
          color: white;
        }

        .stat-info {
          flex: 1;

          .stat-label {
            font-size: 14px;
            color: #909399;
            margin-bottom: 8px;
          }

          .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #303133;
          }
        }
      }

      &.coach {
        .stat-icon {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
      }

      &.frontdesk {
        .stat-icon {
          background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
      }

      &.houqing {
        .stat-icon {
          background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
      }
    }
  }
}

@media (max-width: 768px) {
  .employee-management-container {
    .dept-statistics {
      grid-template-columns: 1fr;
    }
  }
}
</style>
