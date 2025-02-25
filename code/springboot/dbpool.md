# 数据库连接池

## druid

com.alibaba.druid.pool.DruidDataSource 基本配置参数

name ：数据源名称
如果存在多个数据源，监控的时候可以通过名字来区分开来

如果没有配置，将会生成一个名字，格式是"DataSource-"+System.identityHashCode(this)

jdbcUrl ：连接数据库的 url，不同数据库不一样
username ：连接数据库的用户名
password ：连接数据库的密码
driverClassName ：数据库驱动类
可配可不配，如果不配置 druid 会根据 url 自动识别 dbType，然后选择相应的 driverClassName（建议配置下）

initialSize ：初始化时建立物理连接的个数，初始化发生在显示调用 init 方法，或者第一次 getConnection 时
maxActive ：最大连接池数量
maxIdle ：已经不再使用，配置了也没效果
minIdle ：最小连接池数量
maxWait ：获取连接时最大等待时间，单位毫秒
配置了 maxWait 之后，缺省启用公平锁，并发效率会有所下降（可以通过配置 useUnfairLock=true 使用非公平锁）

poolPreparedStatements ：是否缓存 preparedStatement，即 PsCache
PSCache 对支持游标的数据库性能提升巨大，比如说 oracle，而 mysql 则建议关闭

maxOpenPreparedStatements ：要启用 PSCache，必须配置大于0
当大于 0 时，poolPreparedStatements 自动触发修改为 true

在 Druid 中，不会存在 Oracle 下 PSCache 占用内存过多的问题，可以把这个数值配置大一点，比如 100

validationQuery ：用来检测连接是否有效的 sql，要求是一个查询语句
如果 validationQuery 为null，testOnBorrow、testOnReturn 、testWhileIdle 都不会起作用

testOnBorrow ：申请连接时执行 validationQuery 检测连接是否有效，做了这个配置会降低性能
testOnReturn ：归还连接时执行 validationQuery 检测连接是否有效，做了这个配置会降低性能
testWhileIdle ：建议配置为 true，不影响性能，并且保证安全性
申请连接的时候检测，如果空闲时间大于 timeBetweenEvictionRunMills，执行 validationQuery 检测连接是否有效

timeBetweenEvictionRunMillis ：间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒

Destory 线程会检测连接的间隔时间
testWhileIdle 的判断依据（详见 testWhileIdele 属性的说明）
numTestsPerEvictionRun ：废弃，一个 DruidDataSource 只支持一个 EvicationRun
minEvictableIdleTimeMillis ：一个连接在池中最小生存的时间，单位是毫秒
connectionInitSqls ：物理连接初始化的时候执行 sql
exceptionSorter ：当数据库抛出一些不可恢复的异常时，抛弃连接
filters ：通过别名的方式配置扩展插件，属性类型是字符串
常用的插件有：监控统计用的 filter（stat：监控统计，log：4:日志记录，wall：防御sql注入）

proxyFilters ：类型是 List<com.alibaba.druid,filter.Filter>，如果同时配置 filter 和 proxyFilters，是组合关系（并非）