import request from '@/utils/request'

// 查询雪具列表
export function listEquipment(data) {
  return request({
    url: '/system/equipment/list',
    method: 'post',
    data: data
  })
}

// 查询雪具详细
export function getEquipment(id) {
  return request({
    url: '/system/equipment/getInfo',
    method: 'post',
    data: { id: id }
  })
}

// 新增雪具
export function addEquipment(data) {
  return request({
    url: '/system/equipment/add',
    method: 'post',
    data: data
  })
}

// 修改雪具
export function updateEquipment(data) {
  return request({
    url: '/system/equipment/edit',
    method: 'post',
    data: data
  })
}

// 删除雪具
export function delEquipment(ids) {
  return request({
    url: '/system/equipment/remove',
    method: 'post',
    data: ids
  })
}

// 报修雪具
export function reportMaintenance(id, quantity) {
  return request({
    url: '/system/equipment/reportMaintenance',
    method: 'post',
    data: {
      id: id,
      maintenanceQuantity: quantity
    }
  })
}

// 完成维修
export function completeMaintenance(id, quantity) {
  return request({
    url: '/system/equipment/completeMaintenance',
    method: 'post',
    data: {
      id: id,
      maintenanceQuantity: quantity
    }
  })
}

// 报废雪具
export function scrapEquipment(id, quantity) {
  return request({
    url: '/system/equipment/scrap',
    method: 'post',
    data: {
      id: id,
      scrapQuantity: quantity
    }
  })
}
