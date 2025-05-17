# JdbcTemplate

在Spring Boot中使用JdbcTemplate可以简化JDBC操作。以下是如何在Spring Boot项目中使用JdbcTemplate的基本步骤：

## 添加依赖

确保你的pom.xml文件中包含了Spring Boot的JDBC和数据库驱动依赖。例如，如果你使用的是MySQL数据库：

```xml
<dependencies>
    <!-- Spring Boot JDBC 依赖 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jdbc</artifactId>
    </dependency>

    <!-- MySQL 驱动依赖 -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>

```

## 配置数据库连接

在application.properties或application.yml文件中配置数据库连接信息：

```properties
# application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/your_database?useSSL=false&serverTimezone=UTC
spring.datasource.username=your_username
spring.datasource.password=your_password

```

## 注入JdbcTemplate

在你的服务类中注入JdbcTemplate：

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public UserService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // 其他方法...
}

```

## 创建实体类

确保你有一个与数据库表对应的实体类：

```java
public class User {
    private int id;
    private String name;
    private String email;

    // getters and setters...
}

```



## 使用JdbcTemplate执行SQL

使用JdbcTemplate执行SQL查询和更新操作：

```java
public List<User> findAllUsers() {
    String sql = "SELECT * FROM users";
    return jdbcTemplate.query(sql, new UserRowMapper());
}

public int createUser(User user) {
    String sql = "INSERT INTO users(name, email) VALUES(?, ?)";
    return jdbcTemplate.update(sql, user.getName(), user.getEmail());
}

// UserRowMapper.java
import org.springframework.jdbc.core.RowMapper;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserRowMapper implements RowMapper<User> {
    @Override
    public User mapRow(ResultSet rs, int rowNum) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        return user;
    }
}

```

以上就是在Spring Boot中使用JdbcTemplate的基本步骤。记得处理好异常，并根据实际情况调整代码。