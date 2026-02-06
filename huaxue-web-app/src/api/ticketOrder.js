import request from '@/utils/request'

// 查询门票订单列表
export function listTicketOrder(data) {
  return request({
    url: '/system/ticketOrder/list',
    method: 'post',
    data: data
  })
}

// 查询门票订单详细
export function getTicketOrder(id) {
  return request({
    url: '/system/ticketOrder/' + id,
    method: 'get'
  })
}

// 新增门票订单
export function addTicketOrder(data) {
  return request({
    url: '/system/ticketOrder',
    method: 'post',
    data: data
  })
}

// 修改门票订单
export function updateTicketOrder(data) {
  return request({
    url: '/system/ticketOrder',
    method: 'put',
    data: data
  })
}

// 删除门票订单
export function delTicketOrder(ids) {
  return request({
    url: '/system/ticketOrder/' + ids,
    method: 'delete'
  })
}

// 处理退票
export function refundTicket(id, refundReason) {
  return request({
    url: '/system/ticketOrder/refund/' + id,
    method: 'post',
    data: { refundReason: refundReason }
  })
}

// 支付订单
export function payTicketOrder(id, paymentMethod) {
  return request({
    url: '/system/ticketOrder/pay/' + id,
    method: 'post',
    data: { paymentMethod: paymentMethod }
  })
}

// 取消订单
export function cancelTicketOrder(id) {
  return request({
    url: '/system/ticketOrder/cancel/' + id,
    method: 'post'
  })
}