import request from '@/utils/request'

// 获取教练业绩统计
export function getCoachPerformance(query) {
  return request({
    url: '/system/coachPerformance/statistics',
    method: 'get',
    params: query
  })
}
