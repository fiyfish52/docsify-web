# dateTime

## java.util.Date 下的格式化

```java
    //获取日期
    //导 import java.util.Date; 下的包
    Date date = new Date();
    System.out.println(date);
    //Fri Nov 29 10:05:00 CST 2019
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String datef = sdf.format(date);
    System.out.println("格式化后的日期：" + datef);
    //格式化后的日期：2019-11-29
```

字符串类型的时间转换为sql类型的时间

```java
try {
    //需要导 import java.sql.Date; 下的包
    //把字符串类型的时间转换为sql类型的时间 parse(需要转换的字符串) 
    //因为parse(可能值为空所以需要 try catch 块)
    Date datef= new Date(new SimpleDateFormat("yyyy-MM-dd").parse("2019-11-29").getTime());
    System.out.println(datef);
    } catch (ParseException e) {
        e.printStackTrace();
}
```

## java.time

```java
String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
Date date = new Date(new SimpleDateFormat("yyyy-MM-dd").parse(dateStr).getTime());
```
