<template>
  <div class="course-list">
    <el-table v-loading="loading" :data="courseList" border>
      <el-table-column label="课程名称" prop="courseName" width="150" />
      <el-table-column label="课程类型" prop="courseType" width="120" />
      <el-table-column label="课程描述" prop="description" show-overflow-tooltip />
      <el-table-column label="时长(分钟)" prop="duration" width="100" align="center" />
      <el-table-column label="价格(元)" prop="price" width="100" align="center">
        <template #default="scope">
          ¥{{ scope.row.price }}
        </template>
      </el-table-column>
      <el-table-column label="最大学员数" prop="maxStudents" width="100" align="center" />
      <el-table-column label="状态" prop="status" width="80" align="center">
        <template #default="scope">
          <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'">
            {{ scope.row.status === '0' ? '正常' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" align="center" fixed="right">
        <template #default="scope">
          <el-button link type="primary" size="small" @click="handleSchedule(scope.row)">
            时间安排
          </el-button>
          <el-button link type="primary" size="small" @click="handleUpdate(scope.row)">
            修改
          </el-button>
          <el-button link type="danger" size="small" @click="handleDelete(scope.row)">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  courseList: {
    type: Array,
    default: () => []
  },
  loading: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['schedule', 'update', 'delete'])

const handleSchedule = (row) => {
  emit('schedule', row)
}

const handleUpdate = (row) => {
  emit('update', row)
}

const handleDelete = (row) => {
  emit('delete', row)
}
</script>

<style scoped>
.course-list {
  margin-top: 20px;
}
</style>
