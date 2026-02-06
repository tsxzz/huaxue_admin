<template>
  <div ref="chartRef" style="width: 100%; height: 400px;"></div>
</template>

<script setup>
import { ref, onMounted, watch, onBeforeUnmount } from 'vue'
import * as echarts from 'echarts'

const props = defineProps({
  data: {
    type: Array,
    default: () => []
  },
  type: {
    type: String,
    default: 'daily' // daily 或 monthly
  }
})

const chartRef = ref(null)
let chartInstance = null

const initChart = () => {
  if (!chartRef.value) return
  
  chartInstance = echarts.init(chartRef.value)
  updateChart()
}

const updateChart = () => {
  if (!chartInstance || !props.data || props.data.length === 0) return
  
  const dates = props.data.map(item => props.type === 'daily' ? item.date : item.month)
  const ticketAmounts = props.data.map(item => item.ticketAmount ? parseFloat(item.ticketAmount) : 0)
  const rentalAmounts = props.data.map(item => item.rentalAmount ? parseFloat(item.rentalAmount) : 0)
  const totalAmounts = props.data.map(item => item.totalAmount ? parseFloat(item.totalAmount) : 0)
  
  const option = {
    title: {
      text: props.type === 'daily' ? '日收入趋势' : '月收入趋势',
      left: 'center',
      textStyle: {
        fontSize: 18,
        fontWeight: 'bold'
      }
    },
    tooltip: {
      trigger: 'axis',
      formatter: function(params) {
        let result = params[0].name + '<br/>'
        params.forEach(param => {
          result += param.seriesName + ': ¥' + param.value.toFixed(2) + '<br/>'
        })
        return result
      }
    },
    legend: {
      data: ['门票收入', '租赁收入', '总收入'],
      bottom: 10
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '15%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: dates
    },
    yAxis: {
      type: 'value',
      axisLabel: {
        formatter: '¥{value}'
      }
    },
    series: [
      {
        name: '门票收入',
        type: 'line',
        data: ticketAmounts,
        smooth: true,
        itemStyle: { color: '#409EFF' }
      },
      {
        name: '租赁收入',
        type: 'line',
        data: rentalAmounts,
        smooth: true,
        itemStyle: { color: '#67C23A' }
      },
      {
        name: '总收入',
        type: 'line',
        data: totalAmounts,
        smooth: true,
        itemStyle: { color: '#E6A23C' },
        lineStyle: {
          width: 3
        }
      }
    ]
  }
  
  chartInstance.setOption(option)
}

watch(() => props.data, () => {
  updateChart()
}, { deep: true })

onMounted(() => {
  initChart()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  if (chartInstance) {
    chartInstance.dispose()
  }
  window.removeEventListener('resize', handleResize)
})

const handleResize = () => {
  if (chartInstance) {
    chartInstance.resize()
  }
}
</script>

<style scoped>
</style>
