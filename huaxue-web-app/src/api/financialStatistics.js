import request from '@/utils/request'

// 获取财务统计数据
export function getFinancialStatistics(startDate, endDate) {
  return request({
    url: '/system/financialStatistics/statistics',
    method: 'get',
    params: {
      startDate: startDate,
      endDate: endDate
    }
  })
}
