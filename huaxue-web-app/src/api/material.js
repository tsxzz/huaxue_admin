import request from '@/utils/request'

// 查询物资管理列表
export function listMaterial(query) {
  return request({
    url: '/system/material/list',
    method: 'post',
    data: query
  })
}

// 查询物资管理详细
export function getMaterial(id) {
  return request({
    url: '/system/material/' + id,
    method: 'get'
  })
}

// 新增物资管理
export function addMaterial(data) {
  return request({
    url: '/system/material',
    method: 'post',
    data: data
  })
}

// 修改物资管理
export function updateMaterial(data) {
  return request({
    url: '/system/material',
    method: 'put',
    data: data
  })
}

// 删除物资管理
export function delMaterial(ids) {
  return request({
    url: '/system/material/' + ids,
    method: 'delete'
  })
}

// 获取即将过期的物资
export function getExpiringSoonMaterials() {
  return request({
    url: '/system/material/expiringSoon',
    method: 'get'
  })
}

// 获取库存不足的物资
export function getLowStockMaterials() {
  return request({
    url: '/system/material/lowStock',
    method: 'get'
  })
}

// 查询出入库记录列表
export function listMaterialStock(query) {
  return request({
    url: '/system/materialStock/list',
    method: 'post',
    data: query
  })
}

// 查询出入库记录详细
export function getMaterialStock(id) {
  return request({
    url: '/system/materialStock/' + id,
    method: 'get'
  })
}

// 新增出入库记录
export function addMaterialStock(data) {
  return request({
    url: '/system/materialStock',
    method: 'post',
    data: data
  })
}

// 修改出入库记录
export function updateMaterialStock(data) {
  return request({
    url: '/system/materialStock',
    method: 'put',
    data: data
  })
}

// 删除出入库记录
export function delMaterialStock(ids) {
  return request({
    url: '/system/materialStock/' + ids,
    method: 'delete'
  })
}

// 查询领用记录列表
export function listMaterialUsage(query) {
  return request({
    url: '/system/materialUsage/list',
    method: 'post',
    data: query
  })
}

// 查询领用记录详细
export function getMaterialUsage(id) {
  return request({
    url: '/system/materialUsage/' + id,
    method: 'get'
  })
}

// 新增领用记录
export function addMaterialUsage(data) {
  return request({
    url: '/system/materialUsage',
    method: 'post',
    data: data
  })
}

// 修改领用记录
export function updateMaterialUsage(data) {
  return request({
    url: '/system/materialUsage',
    method: 'put',
    data: data
  })
}

// 删除领用记录
export function delMaterialUsage(ids) {
  return request({
    url: '/system/materialUsage/' + ids,
    method: 'delete'
  })
}

// 审批领用申请
export function approveUsage(id, data) {
  return request({
    url: '/system/materialUsage/approve/' + id,
    method: 'post',
    data: data
  })
}

// 归还物资
export function returnMaterial(id) {
  return request({
    url: '/system/materialUsage/return/' + id,
    method: 'post'
  })
}
