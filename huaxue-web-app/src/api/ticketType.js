import request from '@/utils/request'

// 查询门票类型列表
export function listTicketType(data) {
  return request({
    url: '/system/ticketType/list',
    method: 'post',
    data: data
  })
}

// 查询门票类型详细
export function getTicketType(id) {
  return request({
    url: '/system/ticketType/' + id,
    method: 'get'
  })
}

// 新增门票类型
export function addTicketType(data) {
  return request({
    url: '/system/ticketType',
    method: 'post',
    data: data
  })
}

// 修改门票类型
export function updateTicketType(data) {
  return request({
    url: '/system/ticketType',
    method: 'put',
    data: data
  })
}

// 删除门票类型
export function delTicketType(ids) {
  return request({
    url: '/system/ticketType/' + ids,
    method: 'delete'
  })
}

// 公开查询可用门票类型列表（游客预订时使用，无需登录）
export function publicListTicketType(data) {
  return request({
    url: '/system/ticketType/public/list',
    method: 'post',
    data: data
  })
}