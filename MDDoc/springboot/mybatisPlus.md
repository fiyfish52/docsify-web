### 

### 开启字段驼峰命名

**`mybatis-plus.configuration.map-underscore-to-camel-case =true` , 实体类字段会转为驼峰，否则不会转为驼峰，导致返回值为空**

```java
    /**
     * 创建时间
     */
    @JsonFormat(shape= JsonFormat.Shape.STRING, timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @TableField("consumption_time")
    private LocalDateTime consumptionTime;
```

```yml
mybatis-plus:
  configuration:
#     开启驼峰下划线转换
    map-underscore-to-camel-case: true
```



### 分页插件

于 `v3.5.9` 起，`PaginationInnerInterceptor` 已分离出来。如需使用，则需单独引入 `mybatis-plus-jsqlparser` 依赖 

```xml
   <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-jsqlparser</artifactId>
            <version>3.5.10.1</version>
        </dependency>
```

```java

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MybatisPlusConfig {
    /**
     * 添加分页插件
     */
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL)); // 如果配置多个插件, 切记分页最后添加
        // 如果有多数据源可以不配具体类型, 否则都建议配上具体的 DbType
        return interceptor;
    }


}
```

