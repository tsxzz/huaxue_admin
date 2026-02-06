import request from '@/utils/request'

// 查询租赁列表
export function listRental(data) {
  return request({
    url: '/system/equipmentRental/list',
    method: 'post',
    data: data || {}
  })
}

// 查询租赁详细
export function getRental(id) {
  return request({
    url: '/system/equipmentRental/getInfo',
    method: 'post',
    data: { id: id }
  })
}

// 新增租赁
export function addRental(data) {
  return request({
    url: '/system/equipmentRental/add',
    method: 'post',
    data: data
  })
}

// 修改租赁
export function updateRental(data) {
  return request({
    url: '/system/equipmentRental/edit',
    method: 'post',
    data: data
  })
}

// 删除租赁
export function delRental(ids) {
  return request({
    url: '/system/equipmentRental/remove',
    method: 'post',
    data: ids
  })
}

// 归还雪具
export function returnEquipment(id) {
  return request({
    url: '/system/equipmentRental/return',
    method: 'post',
    data: { id: id }
  })
}

// 取消租赁
export function cancelRental(id) {
  return request({
    url: '/system/equipmentRental/cancel',
    method: 'post',
    data: { id: id }
  })
}
