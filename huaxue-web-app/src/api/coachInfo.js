import request from '@/utils/request'

// 查询教练信息列表
export function listCoachInfo(query) {
  return request({
    url: '/system/coachInfo/list',
    method: 'get',
    params: query
  })
}

// 获取当前登录教练的信息
export function getCurrentCoachInfo() {
  return request({
    url: '/system/coachInfo/current',
    method: 'get'
  })
}

// 查询教练信息详细
export function getCoachInfo(id) {
  return request({
    url: '/system/coachInfo/' + id,
    method: 'get'
  })
}

// 新增教练信息
export function addCoachInfo(data) {
  return request({
    url: '/system/coachInfo',
    method: 'post',
    data: data
  })
}

// 修改教练信息
export function updateCoachInfo(data) {
  return request({
    url: '/system/coachInfo',
    method: 'put',
    data: data
  })
}

// 删除教练信息
export function delCoachInfo(id) {
  return request({
    url: '/system/coachInfo/' + id,
    method: 'delete'
  })
}
