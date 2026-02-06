import request from '@/utils/request'

// 查询留言板列表
export function listMessageBoard(query) {
  return request({
    url: '/system/messageBoard/list',
    method: 'post',
    data: query
  })
}

// 查询留言板详细
export function getMessageBoard(id) {
  return request({
    url: '/system/messageBoard/' + id,
    method: 'get'
  })
}

// 新增留言板
export function addMessageBoard(data) {
  return request({
    url: '/system/messageBoard',
    method: 'post',
    data: data
  })
}

// 修改留言板
export function updateMessageBoard(data) {
  return request({
    url: '/system/messageBoard',
    method: 'put',
    data: data
  })
}

// 删除留言板
export function delMessageBoard(ids) {
  return request({
    url: '/system/messageBoard/' + ids,
    method: 'delete'
  })
}

// 点赞/取消点赞
export function toggleLike(id) {
  return request({
    url: '/system/messageBoard/like/' + id,
    method: 'post'
  })
}
