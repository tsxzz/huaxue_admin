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
  
  const methods = props.data.map(item => item.methodName)
  const amounts = props.data.map(item => item.amount ? parseFloat(item.amount) : 0)
  const counts = props.data.map(item => item.count || 0)
  
  const option = {
    title: {
      text: '支付方式统计',
      left: 'center',
      textStyle: {
        fontSize: 18,
        fontWeight: 'bold'
      }
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      },
      formatter: function(params) {
        let result = params[0].name + '<br/>'
        params.forEach((param, index) => {
          if (index === 0) {
            result += '金额: ¥' + param.value.toFixed(2) + '<br/>'
          } else {
            result += '笔数: ' + param.value + '笔'
          }
        })
        return result
      }
    },
    legend: {
      data: ['金额', '笔数'],
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
      data: methods
    },
    yAxis: [
      {
        type: 'value',
        name: '金额',
        position: 'left',
        axisLabel: {
          formatter: '¥{value}'
        }
      },
      {
        type: 'value',
        name: '笔数',
        position: 'right',
        axisLabel: {
          formatter: '{value}笔'
        }
      }
    ],
    series: [
      {
        name: '金额',
        type: 'bar',
        data: amounts,
        itemStyle: {
          color: '#409EFF'
        }
      },
      {
        name: '笔数',
        type: 'line',
        yAxisIndex: 1,
        data: counts,
        itemStyle: {
          color: '#67C23A'
        },
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
