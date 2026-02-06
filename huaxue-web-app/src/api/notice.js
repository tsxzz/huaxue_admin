import request from '@/utils/request'

// 查询通知管理列表（公开接口，无需登录）
export function publicListNotice(data) {
  return request({
    url: '/system/skiNotice/public/list',
    method: 'post',
    data: data
  })
}

// 查询通知管理列表
export function listNotice(data) {
  return request({
    url: '/system/skiNotice/list',
    method: 'post',
    data: data
  })
}

// 查询通知管理详细
export function getNotice(id) {
  return request({
    url: '/system/skiNotice/' + id,
    method: 'get'
  })
}

// 新增通知管理
export function addNotice(data) {
  return request({
    url: '/system/skiNotice',
    method: 'post',
    data: data
  })
}

// 修改通知管理
export function updateNotice(data) {
  return request({
    url: '/system/skiNotice',
    method: 'put',
    data: data
  })
}

// 删除通知管理
export function delNotice(ids) {
  return request({
    url: '/system/skiNotice/' + ids,
    method: 'delete'
  })
}

// 发布通知
export function publishNotice(id) {
  return request({
    url: '/system/skiNotice/publish/' + id,
    method: 'post'
  })
}

// 关闭通知
export function closeNotice(id) {
  return request({
    url: '/system/skiNotice/close/' + id,
    method: 'post'
  })
}
