import request from '@/utils/request'

// 获取运营统计数据
export function getOperationalStatistics(startDate, endDate, type) {
  return request({
    url: '/system/operationalStatistics/statistics',
    method: 'get',
    params: {
      startDate: startDate,
      endDate: endDate,
      type: type || 'daily'
    }
  })
}
