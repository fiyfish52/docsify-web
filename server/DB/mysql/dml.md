# DML


## select

### json 转table

_$[*] 表示所有index; $[0] 表示取json中第一组_

```sql
SELECT *
   FROM
     JSON_TABLE(
       '[{"x":2,"y":"8"},{"x":"3","y":"7"},{"x":"4","y":6}]',
       "$[*]" COLUMNS(
         xval VARCHAR(100) PATH "$.x",
         yval VARCHAR(100) PATH "$.y"
       )
     ) AS  jt1;
```

### 日期

> #### 今天

```sql
select * from 表名 where to_days(时间字段名) = to_days(now());  
```

> #### 昨天  
SELECT * FROM 表名 WHERE TO_DAYS( NOW( ) ) - TO_DAYS( 时间字段名) <= 1  

> #### 7天  
SELECT * FROM 表名 where DATE_SUB(CURDATE(), INTERVAL 7 DAY) <= date(时间字段名)  

> #### 近30天  
SELECT * FROM 表名 where DATE_SUB(CURDATE(), INTERVAL 30 DAY) <= date(时间字段名)  

> #### 本月  
SELECT * FROM 表名 WHERE DATE_FORMAT( 时间字段名, '%Y%m' ) = DATE_FORMAT( CURDATE( ) , '%Y%m' )  

> #### 上一月  
SELECT * FROM 表名 WHERE PERIOD_DIFF( date_format( now( ) , '%Y%m' ) , date_format( 时间字段名, '%Y%m' ) ) =1  

> #### 查询本季度数据  
select * from `ht_invoice_information` where QUARTER(create_date)=QUARTER(now());  

> #### 查询上季度数据  
select * from `ht_invoice_information` where QUARTER(create_date)=QUARTER(DATE_SUB(now(),interval 1 QUARTER));  

> #### 查询本年数据  
select * from `ht_invoice_information` where YEAR(create_date)=YEAR(NOW());  

> #### 查询上年数据  
select * from `ht_invoice_information` where year(create_date)=year(date_sub(now(),interval 1 year));  
查询当前这周的数据   
SELECT name,submittime FROM enterprise WHERE YEARWEEK(date_format(submittime,'%Y-%m-%d')) = YEARWEEK(now());  

> #### 查询上周的数据  
SELECT name,submittime FROM enterprise WHERE YEARWEEK(date_format(submittime,'%Y-%m-%d')) = YEARWEEK(now())-1;  

> #### 查询当前月份的数据  
select name,submittime from enterprise   where date_format(submittime,'%Y-%m')=date_format(now(),'%Y-%m')  

> #### 查询距离当前现在6个月的数据  
select name,submittime from enterprise where submittime between date_sub(now(),interval 6 month) and now();  

> #### 查询上个月的数据  
select name,submittime from enterprise   where date_format(submittime,'%Y-%m')=date_format(DATE_SUB(curdate(), INTERVAL 1 MONTH),'%Y-%m')  

select * from ` user ` where DATE_FORMAT(pudate, ' %Y%m ' ) = DATE_FORMAT(CURDATE(), ' %Y%m ' ) ;  

select * from user where WEEKOFYEAR(FROM_UNIXTIME(pudate,'%y-%m-%d')) = WEEKOFYEAR(now())  

select *
from user
where MONTH (FROM_UNIXTIME(pudate, ' %y-%m-%d ' )) = MONTH (now())  


select *
from [ user ]   
where YEAR (FROM_UNIXTIME(pudate, ' %y-%m-%d ' )) = YEAR (now())  
and MONTH (FROM_UNIXTIME(pudate, ' %y-%m-%d ' )) = MONTH (now())  

select *
from [ user ]   
where pudate between 上月最后一天  
and 下月第一天  
where date(regdate)   =   curdate();  

select   *   from   test   where year(regdate)=year(now())   and month(regdate)=month(now())   and day(regdate)=day(now())  

SELECT date( c_instime ) ,curdate( )  
FROM `t_score`  
WHERE 1  
LIMIT 0 , 30





```sql
to_char to_date
date_format(date,'%Y-%m-%d') -------------->oracle中的to_char();
str_to_date(date,'%Y-%m-%d') -------------->oracle中的to_date();
%Y：代表4位的年份
%y：代表2为的年份
%m：代表月, 格式为(01……12)
%c：代表月, 格式为(1……12)
%d：代表月份中的天数,格式为(00……31)
%e：代表月份中的天数, 格式为(0……31)
%H：代表小时,格式为(00……23)
%k：代表 小时,格式为(0……23)
%h： 代表小时,格式为(01……12)
%I： 代表小时,格式为(01……12)
%l ：代表小时,格式为(1……12)
%i： 代表分钟, 格式为(00……59)
%r：代表 时间,格式为12 小时(hh:mm:ss [AP]M)
%T：代表 时间,格式为24 小时(hh:mm:ss)
%S：代表 秒,格式为(00……59)
%s：代表 秒,格式为(00……59)
SELECT DATE_FORMAT(20130111191640,'%Y-%m-%d %H:%i:%s')
DATE_FORMAT(20130111191640,'%Y-%m-%d %H:%i:%s')
```

