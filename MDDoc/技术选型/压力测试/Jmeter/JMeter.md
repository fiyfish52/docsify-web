# JMeter

## 下载地址

[Apache JMeter - Download Apache JMeter](https://jmeter.apache.org/download_jmeter.cgi?Preferred=https%3A%2F%2Fdlcdn.apache.org%2F)



## 参数指标



| 参数       | 说明                                                         |
| ---------- | ------------------------------------------------------------ |
| Label      | 每个 JMeter 的 element（例如 HTTP Request）都有一个 Name 属性，这里显示的就是 Name 属性的值 |
| #Samples   | 表示你这次测试中一共发出了多少个请求，如果模拟10个用户，每个用户迭代10次，那么这里显示100 |
| Average    | 平均响应时间——默认情况下是单个 Request 的平均响应时间，单位为毫秒。当使用了 Transaction Controller 时，也可以以 |
| Average    | Transaction 为单位显示平均响应时间                           |
| Median     | 中位数，也就是 50％ 用户的响应时间                           |
| 90% Line   | 90％ 用户的响应时间                                          |
| Min        | 最小响应时间                                                 |
| Max        | 最大响应时间                                                 |
| Error%     | 本次测试中出现错误的请求的数量/请求的总数                    |
| Throughput | 吞吐量——默认情况下表示每秒完成的请求数（Request per Second），当使用了 Transaction Controller 时，也可以表示类似 LoadRunner 的 Transaction per Second 数 |
| KB/Sec     | 每秒从服务器端接收到的数据量，相当于LoadRunner中的Throughput/Sec |



## 使用手册





