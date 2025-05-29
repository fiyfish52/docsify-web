# sql

## 日期时间

### 上月第一天

```sql
select to_char(last_day(add_months(trunc(sysdate),-2))+1,'yyyy-mm-dd') from dual;
```

### 上月最后一天

```sql
select to_char(last_day(add_months(trunc(sysdate),-1)),'yyyy-mm-dd') from dual;
```

### 本月第一天

```sql
select  to_char(trunc(sysdate, 'mm'),'yyyy-mm-dd') from dual;
```

### 本月最后一天

```sql
select to_char(last_day(trunc(sysdate)),'yyyy-mm-dd') from dual;
```

### 下月第一天

```sql
SELECT to_char(last_day(SYSDATE) + 1,'yyyy-mm-dd')  FROM dual;
```

### 下月最后一天

```sql
select to_char(last_day(add_months(trunc(sysdate),1)),'yyyy-mm-dd') from dual;
```

### 今年第一天

```sql
select trunc(sysdate,'yyyy') FROM DUAL;
```

### 今年最后一天

```sql
select last_day(add_months(trunc(SYSDATE,'y'),11)) from dual
```





### 判断日期在这个月

```sql
PLAN_DATE between to_char(trunc(sysdate, 'mm'),'yyyy-mm-dd') and to_char(last_day(trunc(sysdate)),'yyyy-mm-dd')
```

### 判断日期在下月

```sql
PLAN_DATE between  to_char(last_day(SYSDATE) + 1,'yyyy-mm-dd')  and to_char(last_day(add_months(trunc(sysdate),1)),'yyyy-mm-dd')
```
