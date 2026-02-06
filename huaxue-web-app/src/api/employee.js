import request from '@/utils/request'
import { parseStrEmpty } from '@/utils/ruoyi'

// 查询员工列表
export function listEmployee(query) {
  return request({
    url: '/system/employee/list',
    method: 'get',
    params: query
  })
}

// 查询员工详细
export function getEmployee(userId) {
  return request({
    url: '/system/employee/' + parseStrEmpty(userId),
    method: 'get'
  })
}

// 新增员工
export function addEmployee(data) {
  return request({
    url: '/system/employee',
    method: 'post',
    data: data
  })
}

// 修改员工
export function updateEmployee(data) {
  return request({
    url: '/system/employee',
    method: 'put',
    data: data
  })
}

// 删除员工
export function delEmployee(userId) {
  return request({
    url: '/system/employee/' + userId,
    method: 'delete'
  })
}

// 用户密码重置
export function resetEmployeePwd(userId, password) {
  const data = {
    userId,
    password
  }
  return request({
    url: '/system/employee/resetPwd',
    method: 'put',
    data: data
  })
}

// 用户状态修改
export function changeEmployeeStatus(userId, status) {
  const data = {
    userId,
    status
  }
  return request({
    url: '/system/employee/changeStatus',
    method: 'put',
    data: data
  })
}

// 获取员工部门列表
export function getEmployeeDepts() {
  return request({
    url: '/system/employee/depts',
    method: 'get'
  })
}

// 获取员工统计
export function getEmployeeStatistics() {
  return request({
    url: '/system/employee/statistics',
    method: 'get'
  })
}
