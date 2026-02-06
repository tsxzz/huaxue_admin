import request from '@/utils/request'

// 查询雪道列表
export function listSlope(data) {
  return request({
    url: '/system/slope/list',
    method: 'post',
    data: data
  })
}

// 查询雪道详细
export function getSlope(id) {
  return request({
    url: '/system/slope/getInfo',
    method: 'post',
    data: { id: id }
  })
}

// 新增雪道
export function addSlope(data) {
  return request({
    url: '/system/slope/add',
    method: 'post',
    data: data
  })
}

// 修改雪道
export function updateSlope(data) {
  return request({
    url: '/system/slope/edit',
    method: 'post',
    data: data
  })
}

// 删除雪道
export function delSlope(id) {
  return request({
    url: '/system/slope/remove',
    method: 'post',
    data: [id]
  })
}

// 修改雪道状态
export function changeSlopeStatus(id, status) {
  return request({
    url: '/system/slope/changeStatus',
    method: 'post',
    data: {
      id: id,
      status: status
    }
  })
}

// 游客查询雪道列表（匿名访问）
export function publicListSlope(data) {
  return request({
    url: '/system/slope/public/list',
    method: 'post',
    data: data
  })
}

// 游客查询雪道详细信息（匿名访问）
export function publicGetSlope(id) {
  return request({
    url: '/system/slope/public/getInfo',
    method: 'post',
    data: { id: id }
  })
}
