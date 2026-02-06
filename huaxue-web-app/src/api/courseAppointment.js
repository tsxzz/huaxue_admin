import request from '@/utils/request'

// 查询课程预约列表
export function listCourseAppointment(query) {
  return request({
    url: '/system/courseAppointment/list',
    method: 'get',
    params: query
  })
}

// 查询当前教练的预约列表
export function listCoachAppointment(query) {
  return request({
    url: '/system/courseAppointment/coach/list',
    method: 'get',
    params: query
  })
}

// 查询当前学员的预约列表
export function listStudentAppointment(query) {
  return request({
    url: '/system/courseAppointment/student/list',
    method: 'get',
    params: query
  })
}

// 查询预约详细
export function getCourseAppointment(id) {
  return request({
    url: '/system/courseAppointment/' + id,
    method: 'get'
  })
}

// 新增课程预约
export function addCourseAppointment(data) {
  return request({
    url: '/system/courseAppointment',
    method: 'post',
    data: data
  })
}

// 修改课程预约
export function updateCourseAppointment(data) {
  return request({
    url: '/system/courseAppointment',
    method: 'put',
    data: data
  })
}

// 删除课程预约
export function delCourseAppointment(id) {
  return request({
    url: '/system/courseAppointment/' + id,
    method: 'delete'
  })
}

// 支付预约
export function payCourseAppointment(id, paymentMethod) {
  return request({
    url: '/system/courseAppointment/pay/' + id,
    method: 'put',
    params: { paymentMethod }
  })
}

// 确认预约
export function confirmCourseAppointment(id) {
  return request({
    url: '/system/courseAppointment/confirm/' + id,
    method: 'put'
  })
}

// 完成预约
export function completeCourseAppointment(id) {
  return request({
    url: '/system/courseAppointment/complete/' + id,
    method: 'put'
  })
}

// 取消预约（退课）
export function cancelCourseAppointment(id, cancelReason) {
  return request({
    url: '/system/courseAppointment/cancel/' + id,
    method: 'put',
    params: { cancelReason }
  })
}
