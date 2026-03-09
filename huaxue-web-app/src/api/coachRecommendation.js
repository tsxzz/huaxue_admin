import request from '@/utils/request'

// 获取教练推荐（混合推荐）
export function getCoachRecommendations(topN = 10, type = 'hybrid') {
  return request({
    url: '/system/coachRecommendation/recommend',
    method: 'get',
    params: {
      topN,
      type
    }
  })
}

// 基于用户的协同过滤推荐
export function getRecommendationsByUserCF(topN = 10) {
  return request({
    url: '/system/coachRecommendation/recommend/user',
    method: 'get',
    params: {
      topN
    }
  })
}

// 基于物品的协同过滤推荐
export function getRecommendationsByItemCF(topN = 10) {
  return request({
    url: '/system/coachRecommendation/recommend/item',
    method: 'get',
    params: {
      topN
    }
  })
}

// 计算用户相似度
export function calculateUserSimilarity(userId2) {
  return request({
    url: '/system/coachRecommendation/similarity/user',
    method: 'get',
    params: {
      userId2
    }
  })
}

// 计算教练相似度
export function calculateCoachSimilarity(coachId1, coachId2) {
  return request({
    url: '/system/coachRecommendation/similarity/coach',
    method: 'get',
    params: {
      coachId1,
      coachId2
    }
  })
}
