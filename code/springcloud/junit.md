# 使用junit进行单元测试



> 引入jar

1. 单独引入控制junit版本

```pom
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
    <exclusions>
        <exclusion>
            <groupId>org.junit.vintage</groupId>
            <artifactId>junit-vintage-engine</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>${junit.version}</version>
    <scope>test</scope>
</dependency>
```

2. 一起引入

```pom
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

> 编写

junit 4 与junit5 写法区别较大;

**在JUnit 5中，@ RunWith注释已由功能更强大的@ExtendWith注释替换。**

1. junit 4

```java
import com.knbs.auth.openfeign.ClientServerFeign;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@Slf4j
@SpringBootTest
@RunWith(SpringRunner.class)
class ClientOpenfignControllerTest {

    @Autowired
    private ClientServerFeign clientServerFeign;
    @Test
    void aaa() {
      String ret =   clientServerFeign.doQueryClientInfos();
      log.info(ret);
    }

}
```

2. junit 5

```java
import com.knbs.auth.openfeign.ClientServerFeign;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@Slf4j
@SpringBootTest
@ExtendWith(SpringExtension.class)
class ClientOpenfignControllerTest {

    @Autowired
    private ClientServerFeign clientServerFeign;
    @Test
    void aaa() {
      String ret =   clientServerFeign.doQueryClientInfos();
      log.info(ret);
    }

}
```
