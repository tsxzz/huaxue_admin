<template>
  <div class="employee-list">
    <!-- 搜索栏 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="queryParams" :inline="true" ref="queryRef">
        <el-form-item label="员工姓名" prop="nickName">
          <el-input
            v-model="queryParams.nickName"
            placeholder="请输入员工姓名"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="手机号码" prop="phonenumber">
          <el-input
            v-model="queryParams.phonenumber"
            placeholder="请输入手机号码"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="部门" prop="deptId">
          <el-select
            v-model="queryParams.deptId"
            placeholder="请选择部门"
            clearable
            style="width: 150px"
          >
            <el-option
              v-for="dept in props.employeeDepts"
              :key="dept.deptId"
              :label="dept.deptName"
              :value="dept.deptId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select
            v-model="queryParams.status"
            placeholder="请选择状态"
            clearable
            style="width: 120px"
          >
            <el-option label="正常" value="0" />
            <el-option label="停用" value="1" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 操作栏 -->
    <el-card class="toolbar-card" shadow="never">
      <el-row :gutter="10">
        <el-col :span="1.5">
          <el-button type="primary" plain icon="Plus" @click="handleAdd">新增员工</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
          >
            修改
          </el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
          >
            删除
          </el-button>
        </el-col>
      </el-row>
    </el-card>

    <!-- 员工列表 -->
    <el-card class="table-card" shadow="never">
      <el-table v-loading="loading" :data="employeeList" @selection-change="handleSelectionChange" border>
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="员工编号" prop="userId" width="100" align="center" />
        <el-table-column label="员工姓名" prop="nickName" min-width="120" />
        <el-table-column label="登录账号" prop="userName" min-width="120" />
        <el-table-column label="手机号码" prop="phonenumber" width="120" align="center" />
        <el-table-column label="部门" prop="dept.deptName" width="120" align="center" />
        <el-table-column label="角色" width="150" align="center">
          <template #default="scope">
            <el-tag
              v-for="role in scope.row.roles"
              :key="role.roleId"
              :type="getRoleTagType(role.roleKey)"
              style="margin-right: 5px"
            >
              {{ role.roleName }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100" align="center">
          <template #default="scope">
            <el-switch
              v-model="scope.row.status"
              active-value="0"
              inactive-value="1"
              @change="handleStatusChange(scope.row)"
            />
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" align="center" />
        <el-table-column label="操作" width="250" align="center" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button link type="primary" icon="Key" @click="handleResetPwd(scope.row)">重置密码</el-button>
            <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <pagination
        v-show="total > 0"
        :total="total"
        :page="queryParams.pageNum"
        :limit="queryParams.pageSize"
        @pagination="handlePageChange"
      />
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listEmployee, delEmployee, changeEmployeeStatus, resetEmployeePwd } from '@/api/employee'
import Pagination from '@/components/Pagination/index.vue'

const emit = defineEmits(['add', 'update', 'resetPwd'])

const props = defineProps({
  employeeDepts: {
    type: Array,
    default: () => []
  }
})

const loading = ref(false)
const employeeList = ref([])
const total = ref(0)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  nickName: '',
  phonenumber: '',
  deptId: undefined,
  status: ''
})

// 获取角色标签类型
const getRoleTagType = (roleKey) => {
  if (roleKey === 'Coach') return 'success'
  if (roleKey === 'Frontdesk' || roleKey === 'Front desk') return 'warning'
  if (roleKey === 'houqing') return 'info'
  return ''
}

// 查询员工列表
const getList = async () => {
  loading.value = true
  try {
    const response = await listEmployee(queryParams)
    if (response.code === 200) {
      employeeList.value = response.rows || []
      total.value = response.total || 0
    }
  } catch (error) {
    console.error('查询员工列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 搜索
const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

// 重置
const resetQuery = () => {
  queryParams.nickName = ''
  queryParams.phonenumber = ''
  queryParams.deptId = undefined
  queryParams.status = ''
  handleQuery()
}

// 分页
const handlePageChange = (p) => {
  queryParams.pageNum = p.page
  queryParams.pageSize = p.limit
  getList()
}

// 多选框选中数据
const handleSelectionChange = (selection) => {
  ids.value = selection.map(item => item.userId)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}

// 新增
const handleAdd = () => {
  emit('add')
}

// 修改
const handleUpdate = (row) => {
  const userId = row ? row.userId : ids.value[0]
  emit('update', userId)
}

// 删除
const handleDelete = (row) => {
  const userIds = row ? [row.userId] : ids.value
  ElMessageBox.confirm('是否确认删除选中的员工？', '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      return delEmployee(userIds.join(','))
    })
    .then(() => {
      getList()
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

// 状态修改
const handleStatusChange = (row) => {
  const text = row.status === '0' ? '启用' : '停用'
  ElMessageBox.confirm('确认要"' + text + '""' + row.userName + '"员工吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      return changeEmployeeStatus(row.userId, row.status)
    })
    .then(() => {
      ElMessage.success(text + '成功')
    })
    .catch(() => {
      row.status = row.status === '0' ? '1' : '0'
    })
}

// 重置密码
const handleResetPwd = (row) => {
  emit('resetPwd', row.userId)
}

// 设置部门筛选
const setDeptFilter = (deptId) => {
  queryParams.deptId = deptId
  handleQuery()
}

defineExpose({
  getList,
  setDeptFilter
})
</script>

<style scoped lang="scss">
.employee-list {
  .search-card {
    margin-bottom: 20px;
  }

  .toolbar-card {
    margin-bottom: 20px;
  }

  .table-card {
    :deep(.el-table) {
      .el-table__cell {
        padding: 12px 0;
      }
    }
  }
}
</style>
