<template>
  <el-drawer
    v-model="innerVisible"
    title="协同过滤推荐 · 怎么算出来的？"
    direction="rtl"
    size="560px"
    append-to-body
    class="cf-explain-drawer"
    @opened="onDrawerOpened"
    @closed="onDrawerClosed"
  >
    <div class="cf-scroll">
      <!-- 与「全部列表」的区分（保留用户需要的对比说明） -->
      <el-alert type="info" :closable="false" show-icon class="cf-alert-top">
        <template #title>
          <span>上方蓝色推荐区里的教练顺序，由<strong>协同过滤模型打分后排序</strong>；下方「全部教练」是查询列表，<strong>不是同一套排序</strong>。</span>
        </template>
      </el-alert>

      <!-- 流程：普通人可顺着读 -->
      <section class="cf-block">
        <h4 class="cf-h4">
          <el-icon><Connection /></el-icon>
          算分流程（您在系统里的行为 → 分数 → 排名）
        </h4>
        <p class="cf-lead">
          可以把协同过滤理解成：先根据别人的「选课/预约习惯」帮您找线索，再把线索折合成一个<strong>0～1 的推荐分</strong>，分高的排在更前面。
        </p>
        <div class="cf-pipeline">
          <div class="cf-step">
            <div class="cf-step-num">1</div>
            <div class="cf-step-body">
              <strong>收集信号</strong>
              <span>例如您浏览、预约过哪些教练/课程（脱敏后参与计算）。</span>
            </div>
          </div>
          <div class="cf-arrow" aria-hidden="true">→</div>
          <div class="cf-step">
            <div class="cf-step-num">2</div>
            <div class="cf-step-body">
              <strong>找「臭味相投」</strong>
              <span>用户协同：找和您选课习惯相近的其他用户；物品协同：找和您关注过的教练相似的教练。</span>
            </div>
          </div>
          <div class="cf-arrow" aria-hidden="true">→</div>
          <div class="cf-step">
            <div class="cf-step-num">3</div>
            <div class="cf-step-body">
              <strong>加权算分</strong>
              <span>混合策略把多路信号合成<strong>推荐分</strong>（见下图柱形长度）。</span>
            </div>
          </div>
          <div class="cf-arrow" aria-hidden="true">→</div>
          <div class="cf-step">
            <div class="cf-step-num">4</div>
            <div class="cf-step-body">
              <strong>排序展示</strong>
              <span>分数高的教练在推荐区更靠前；表格中同时列出「第几名」。</span>
            </div>
          </div>
        </div>
      </section>

      <!-- 混合策略示意（静态教育图） -->
      <section class="cf-block">
        <h4 class="cf-h4">
          <el-icon><DataAnalysis /></el-icon>
          混合协同过滤在做什么？（示意）
        </h4>
        <div class="cf-hybrid-legend">
          <div class="cf-chip cf-chip-user">
            <span class="cf-chip-title">用户协同（User-CF）</span>
            <span class="cf-chip-desc">「和您像的用户」偏好的教练，更容易得高分。</span>
          </div>
          <div class="cf-chip cf-chip-item">
            <span class="cf-chip-title">物品协同（Item-CF）</span>
            <span class="cf-chip-desc">与您曾关注教练「相似」的教练，更容易得高分。</span>
          </div>
        </div>
        <p class="cf-note">实际系统按接口参数采用混合推荐；下表「相似用户数 / 相似教练数」来自后端本次计算结果（可能某一列为空）。</p>
      </section>

      <!-- ECharts：推荐分柱状图 -->
      <section class="cf-block" v-if="sortedCoaches.length">
        <h4 class="cf-h4">
          <el-icon><TrendCharts /></el-icon>
          推荐分一览（柱越长 = 综合推荐越强）
        </h4>
        <div ref="chartRef" class="cf-chart" />
        <p class="cf-hint">横轴为推荐分（0～1）。与您卡片从左到右顺序一致：左侧教练通常分数更高。</p>
      </section>

      <!-- 排名表：比纯文字更直观 -->
      <section class="cf-block" v-if="sortedCoaches.length">
        <h4 class="cf-h4">
          <el-icon><List /></el-icon>
          推荐排名明细
        </h4>
        <el-table :data="tableRows" border size="small" stripe max-height="280">
          <el-table-column prop="rank" label="名次" width="58" align="center" />
          <el-table-column prop="name" label="教练" min-width="88" show-overflow-tooltip />
          <el-table-column label="推荐分" width="120" align="center">
            <template #default="scope">
              <el-progress
                :percentage="scoreToPercent(scope.row.score)"
                :color="progressColors"
                :stroke-width="10"
                :show-text="true"
              />
            </template>
          </el-table-column>
          <el-table-column prop="similarUsers" label="相似用户量" width="96" align="center">
            <template #default="scope">
              {{ scope.row.similarUsers != null ? scope.row.similarUsers : '—' }}
            </template>
          </el-table-column>
          <el-table-column prop="similarCoaches" label="相似教练量" width="96" align="center">
            <template #default="scope">
              {{ scope.row.similarCoaches != null ? scope.row.similarCoaches : '—' }}
            </template>
          </el-table-column>
        </el-table>
        <p class="cf-note">「相似用户量 / 相似教练量」表示本次为该教练算分时，背后参考了多少条近邻信号（越大通常说明参考面越宽，但不等于一定更准）。</p>
      </section>

      <section class="cf-block cf-block-muted">
        <h4 class="cf-h4">补充说明</h4>
        <ul class="cf-bullets">
          <li>推荐分由算法自动估计，会随全站用户行为变化而波动。</li>
          <li>新用户行为较少时，系统可能更多参考热门或默认策略（以后端实现为准）。</li>
          <li>您仍可自行在「全部教练列表」里按等级、姓名等筛选，与推荐区互不替代。</li>
        </ul>
      </section>
    </div>
  </el-drawer>
</template>

<script setup>
import { ref, computed, watch, nextTick, onBeforeUnmount } from 'vue'
import * as echarts from 'echarts'
import { Connection, DataAnalysis, TrendCharts, List } from '@element-plus/icons-vue'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  /** 与接口一致：CoachRecommendationDTO 列表 */
  coaches: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['update:modelValue'])

const innerVisible = computed({
  get: () => props.modelValue,
  set: (v) => emit('update:modelValue', v)
})

const chartRef = ref(null)
let chartInstance = null

const sortedCoaches = computed(() => {
  const list = [...(props.coaches || [])]
  list.sort((a, b) => {
    const sa = a.recommendationScore != null ? Number(a.recommendationScore) : 0
    const sb = b.recommendationScore != null ? Number(b.recommendationScore) : 0
    return sb - sa
  })
  return list
})

const tableRows = computed(() =>
  sortedCoaches.value.map((c, i) => ({
    rank: i + 1,
    name: c.coachName || '未知教练',
    score: c.recommendationScore != null ? Number(c.recommendationScore) : 0,
    similarUsers: c.similarUserCount,
    similarCoaches: c.similarCoachCount
  }))
)

const progressColors = [
  { color: '#909399', percentage: 40 },
  { color: '#e6a23c', percentage: 70 },
  { color: '#67c23a', percentage: 100 }
]

const scoreToPercent = (score) => {
  const s = Math.max(0, Math.min(1, Number(score) || 0))
  return Math.round(s * 100)
}

const renderChart = () => {
  if (!chartRef.value || sortedCoaches.value.length === 0) return

  const rows = [...sortedCoaches.value].reverse()
  const names = rows.map((c) => {
    const n = c.coachName || '教练'
    return n.length > 8 ? `${n.slice(0, 8)}…` : n
  })
  const scores = rows.map((c) =>
    c.recommendationScore != null ? Number(c.recommendationScore) : 0
  )

  if (!chartInstance) {
    chartInstance = echarts.init(chartRef.value)
  }

  chartInstance.setOption({
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' },
      formatter(params) {
        const p = params[0]
        const idx = p.dataIndex
        const raw = rows[idx]
        const fullName = raw?.coachName || '—'
        const reason = raw?.recommendationReason || '—'
        return `${fullName}<br/>推荐分：<b>${p.value}</b><br/><span style="font-size:12px;color:#909399">${reason}</span>`
      }
    },
    grid: { left: 12, right: 24, top: 16, bottom: 8, containLabel: true },
    xAxis: {
      type: 'value',
      min: 0,
      max: 1,
      splitNumber: 5,
      axisLabel: { formatter: (v) => v.toFixed(1) }
    },
    yAxis: {
      type: 'category',
      data: names,
      axisLabel: { fontSize: 11 }
    },
    series: [
      {
        name: '推荐分',
        type: 'bar',
        data: scores,
        barMaxWidth: 22,
        itemStyle: {
          borderRadius: [0, 6, 6, 0],
          color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
            { offset: 0, color: '#79bbff' },
            { offset: 1, color: '#409eff' }
          ])
        },
        label: {
          show: true,
          position: 'right',
          formatter: (p) => Number(p.value).toFixed(3)
        }
      }
    ]
  })
}

const disposeChart = () => {
  if (chartInstance) {
    chartInstance.dispose()
    chartInstance = null
  }
}

const onDrawerOpened = () => {
  nextTick(() => {
    renderChart()
    setTimeout(() => chartInstance?.resize(), 320)
  })
}

const onDrawerClosed = () => {
  disposeChart()
}

watch(
  () => props.coaches,
  () => {
    if (props.modelValue) {
      nextTick(() => {
        renderChart()
        chartInstance?.resize()
      })
    }
  },
  { deep: true }
)

watch(
  () => props.modelValue,
  (v) => {
    if (!v) disposeChart()
  }
)

onBeforeUnmount(() => {
  disposeChart()
})
</script>

<style scoped>
.cf-scroll {
  padding-bottom: 24px;
}

.cf-alert-top {
  margin-bottom: 18px;
}

.cf-block {
  margin-bottom: 22px;
}

.cf-block-muted {
  padding: 12px 14px;
  background: #f5f7fa;
  border-radius: 8px;
  border: 1px solid #ebeef5;
}

.cf-h4 {
  margin: 0 0 10px;
  font-size: 15px;
  font-weight: 600;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
}

.cf-lead {
  margin: 0 0 14px;
  font-size: 13px;
  color: #606266;
  line-height: 1.65;
}

.cf-pipeline {
  display: flex;
  flex-wrap: wrap;
  align-items: stretch;
  gap: 8px;
}

.cf-step {
  flex: 1 1 140px;
  min-width: 120px;
  display: flex;
  gap: 10px;
  padding: 12px;
  background: #ecf5ff;
  border: 1px solid #d9ecff;
  border-radius: 10px;
}

.cf-step-num {
  width: 26px;
  height: 26px;
  border-radius: 50%;
  background: #409eff;
  color: #fff;
  font-size: 13px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.cf-step-body {
  display: flex;
  flex-direction: column;
  gap: 4px;
  font-size: 12px;
  color: #606266;
  line-height: 1.5;
}

.cf-step-body strong {
  color: #303133;
  font-size: 13px;
}

.cf-arrow {
  align-self: center;
  color: #409eff;
  font-weight: 700;
  font-size: 18px;
  padding: 0 2px;
}

.cf-hybrid-legend {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.cf-chip {
  padding: 12px 14px;
  border-radius: 10px;
  border: 1px solid #ebeef5;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.cf-chip-user {
  background: linear-gradient(135deg, #fdf6ec 0%, #fff 100%);
  border-color: #f5dab1;
}

.cf-chip-item {
  background: linear-gradient(135deg, #f0f9ff 0%, #fff 100%);
  border-color: #b3d8ff;
}

.cf-chip-title {
  font-weight: 600;
  font-size: 13px;
  color: #303133;
}

.cf-chip-desc {
  font-size: 12px;
  color: #606266;
  line-height: 1.55;
}

.cf-note,
.cf-hint {
  margin: 10px 0 0;
  font-size: 12px;
  color: #909399;
  line-height: 1.55;
}

.cf-chart {
  width: 100%;
  height: 260px;
}

.cf-bullets {
  margin: 0;
  padding-left: 18px;
  font-size: 13px;
  color: #606266;
  line-height: 1.7;
}

.cf-bullets li {
  margin-bottom: 6px;
}
</style>
