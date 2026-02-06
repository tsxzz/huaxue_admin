import request from '@/utils/request'

// 查询课程列表
export function listCourse(query) {
  return request({
    url: '/system/course/list',
    method: 'get',
    params: query
  })
}

// 查询课程详细
export function getCourse(id) {
  return request({
    url: '/system/course/' + id,
    method: 'get'
  })
}

// 新增课程
export function addCourse(data) {
  return request({
    url: '/system/course',
    method: 'post',
    data: data
  })
}

// 修改课程
export function updateCourse(data) {
  return request({
    url: '/system/course',
    method: 'put',
    data: data
  })
}

// 删除课程
export function delCourse(id) {
  return request({
    url: '/system/course/' + id,
    method: 'delete'
  })
}

// 公开查询课程列表（用于游客预约）
export function publicListCourse(query) {
  return request({
    url: '/system/course/public/list',
    method: 'get',
    params: query
  })
}

// 查询课程时间表列表
export function listCourseSchedule(query) {
  return request({
    url: '/system/courseSchedule/list',
    method: 'get',
    params: query
  })
}

// 根据课程ID查询时间表
export function getCourseScheduleByCourseId(courseId) {
  return request({
    url: '/system/courseSchedule/course/' + courseId,
    method: 'get'
  })
}

// 查询时间表详细
export function getCourseSchedule(id) {
  return request({
    url: '/system/courseSchedule/' + id,
    method: 'get'
  })
}

// 新增课程时间表
export function addCourseSchedule(data) {
  return request({
    url: '/system/courseSchedule',
    method: 'post',
    data: data
  })
}

// 修改课程时间表
export function updateCourseSchedule(data) {
  return request({
    url: '/system/courseSchedule',
    method: 'put',
    data: data
  })
}

// 删除课程时间表
export function delCourseSchedule(id) {
  return request({
    url: '/system/courseSchedule/' + id,
    method: 'delete'
  })
}

// 公开查询课程时间表（用于游客预约）
export function publicGetCourseScheduleByCourseId(courseId) {
  return request({
    url: '/system/courseSchedule/public/course/' + courseId,
    method: 'get'
  })
}
