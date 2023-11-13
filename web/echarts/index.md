# echarts 配置项说明

## 公共配置

### xAxis x坐标轴

```txt
直角坐标系 grid 中的 x 轴，一般情况下单个 grid 组件最多只能放上下两个 x 轴，多于两个 x 轴需要通过配置 offset 属性防止同个位置多个 x 轴的重叠。
```

[官网说明](https://echarts.apache.org/zh/option.html#xAxis)

| 配置                     | 默认   | 值            | 说明                 | 官网解释                                                                                   |
| ------------------------ | ------ | ------------- | -------------------- | ------------------------------------------------------------------------------------------ |
| `xAxis.axisLabel.rotate` | `none` | `-90` 到 `90` | 刻度标签旋转的角度， | [xAxis.axisLabel.rotate](https://echarts.apache.org/zh/option.html#xAxis.axisLabel.rotate) |

### grid

```txt
直角坐标系内绘图网格，单个 grid 内最多可以放置上下两个 X 轴，左右两个 Y 轴。可以在网格上绘制折线图，柱状图，散点图（气泡图）。

在 ECharts 2.x 里单个 echarts 实例中最多只能存在一个 grid 组件，在 ECharts 3 中可以存在任意个 grid 组件。
```

[官网说明](https://echarts.apache.org/zh/option.html#grid)

| 配置        | 默认     | 值                                 | 说明                        | 官网解释                                                         |
| ----------- | -------- | ---------------------------------- | --------------------------- | ---------------------------------------------------------------- |
| `grid.show` | `自适应` | `20px` `20%`                       | 是否显示直角坐标系网格。    | [grid.show](https://echarts.apache.org/zh/option.html#grid.show) |
| `grid.left` | `plain`  | `20` `20%` `left` `center` `right` | grid 组件离容器左侧的距离。 | [grid.left](https://echarts.apache.org/zh/option.html#grid.left) |


### legend 图例

```vim
图例组件。

图例组件展现了不同系列的标记(symbol)，颜色和名字。可以通过点击图例控制哪些系列不显示。

ECharts 3 中单个 echarts 实例中可以存在多个图例组件，会方便多个图例的布局。

当图例数量过多时，可以使用 滚动图例（垂直） 或 滚动图例（水平），参见：legend.type
```

[官网说明](https://echarts.apache.org/zh/option.html#legend)

| 配置     | 默认     | 值               | 说明                          | 官网解释                                                          |
| -------- | -------- | ---------------- | ----------------------------- | ----------------------------------------------------------------- |
| `bottom` | `自适应` | `20px` `20%`     | 图例组件离容器下侧的距离。    | [bottom](https://echarts.apache.org/zh/option.html#legend.bottom) |
| `type`   | `plain`  | `plain` `scroll` | 图例展示格式 可滚动翻页的图例 | [type](https://echarts.apache.org/zh/option.html#legend)          |

## bar 柱状图

### data

```sh
  const myChart = echarts.init(document.getElementById(id));
  myChart.showLoading();
  myChart.setOption({
   title: {
      text: title
    },
    grid: {
      left: '40'
    },
    legend: {
      type: 'scroll',
      bottom: '5%',
      left: 'center'
    },
    tooltip: {
      confine: true
    },
    xAxis: {
      axisLabel:{
        rotate:-10,
      },
      data: xAxisDatas
      // data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
    },
    yAxis: {},
    series: [
      {
        label: {
          show: true,
          position: 'top'
        },
        name: seriesName,
        type: 'bar',
        barWidth: '20px',
        data: seriesDatas
        // data: [5, 20, 36, 10, 10, 20]
      }
    ]
  });
  myChart.resize({width: 'auto', height:'auto' })
  myChart.hideLoading()
```

### bar config

| 配置                    | 默认     | 值                     | 说明               | 官网解释                                                                              |
| ----------------------- | -------- | ---------------------- | ------------------ | ------------------------------------------------------------------------------------- |
| `series.barWidth`       | `自适应` | `px` `20%`             | 柱状图宽度         | [barWidth](https://echarts.apache.org/zh/option.html#series-bar.barWidths)            |
| `tooltip.confine:true`  | `false`  | `boolean`              | tootip被遮挡       | [confine](https://echarts.apache.org/zh/option.html#tooltip.confine)                  |
| `series.label.show`     | `false`  | `boolean`              | 图中是否显示标签。 | [label.show](https://echarts.apache.org/zh/option.html#series-bar.label.show)         |
| `series.label.position` | `false`  | `top``left``inside` 等 | 图中是否显示标签。 | [label.position](https://echarts.apache.org/zh/option.html#series-bar.label.position) |

## pie 扇形图

### pie data

```sh
  const myChart = echarts.init(document.getElementById(id));
  myChart.showLoading();

  // 绘制图表
  myChart.setOption({
      title: {
        text: title
      },
      tooltip: {
        trigger: 'item'
      },
      legend: {
        type: 'scroll',
        bottom: '5%',
        left: 'center'
      },
      series: [
        {
          name: seriesName,
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          label: {
            show: false,
            position: 'center'
          },
          emphasis: {
            label: {
              show: false,
              fontSize: 40,
              fontWeight: 'bold'
            }
          },
          labelLine: {
            show: false
          },
          data: [
             { value: 1048, name: 'Search Engine' },
             { value: 735, name: 'Direct' },
             { value: 580, name: 'Email' },
             { value: 484, name: 'Union Ads' },
             { value: 300, name: 'Video Ads' }
           ]
        }
      ]
    }
  )
  myChart.resize({width: 'auto', height:'auto' })
  myChart.hideLoading()
```

### pie config

| 配置                   | 默认     | 值         | 说明         | 官网解释                                                                   |
| ---------------------- | -------- | ---------- | ------------ | -------------------------------------------------------------------------- |
| series[index].barWidth | `自适应` | `px` `20%` | 柱状图宽度   | [barWidth](https://echarts.apache.org/zh/option.html#series-bar.barWidths) |
| tooltip.confine:true   | `false`  | `boolean`  | tootip被遮挡 | [confine](https://echarts.apache.org/zh/option.html#tooltip.confine)       |

