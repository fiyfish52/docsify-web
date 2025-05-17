# Junit 5

## 注解

JUnit 5 是 Java 中广泛使用的单元测试框架，提供了丰富的注解来简化测试的编写和管理。以下是一些常用的 JUnit 5 注解及其含义：

| 注解                                                     | 含义                                                         |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| @Test                                                    | 标记一个方法是测试方法。这是最基本的注解，用于标识测试方法。 |
| @DisplayName                                             | 为测试类或测试方法设置一个显示名称，便于在 IDE 中识别和描述测试。 |
| @BeforeEach                                              | 标记一个方法，该方法将在每个测试方法运行之前执行一次。       |
| @AfterEach                                               | 标记一个方法，该方法将在每个测试方法运行之后执行一次。       |
| @BeforeAll                                               | 标记一个静态方法，该方法将在所有测试方法运行之前执行一次。   |
| @AfterAll                                                | 标记一个静态方法，该方法将在所有测试方法运行之后执行一次。   |
| @Disabled                                                | 禁用测试类或方法，使其不会执行。类似于 JUnit 4 中的 @Ignore。 |
| @Tag                                                     | 为测试类或方法添加标签，可用于过滤测试用例。                 |
| @RepeatedTest                                            | 标记一个方法，使其在同一个测试类中重复执行。                 |
| @ParameterizedTest                                       | 标记一个方法是参数化测试，该方法将使用不同的参数多次运行。   |
| @ValueSource、@EnumSource、@CsvFileSource、@MethodSource | 用于提供参数化测试的输入数据。                               |
| @Timeout                                                 | 标记一个方法，如果该方法运行时间超过指定时间，则会返回错误。 |
| @ExtendWith                                              | 为测试类或方法提供扩展类引用，用于定制测试行为。             |
| @Assumptions                                             | 类似于断言，不满足的假设会使得测试方法失败。                 |
| @Nested                                                  | 用于创建嵌套测试类，嵌套类中可以包含其他测试方法。           |
| @TestTemplate                                            | 用于定义测试模板，这些模板可以在多个测试用例中重复使用。     |


通过这些注解，JUnit 5 提供了灵活的测试配置和扩展能力，使得单元测试更加高效和易于管理。

## junit5 如何定义测试方法顺序

在JUnit 5中，可以通过多种方式来定义测试方法的执行顺序。以下是几种常见的方法：
使用@TestMethodOrder注解：
MethodOrderer.MethodName：根据方法名称的字母顺序对测试进行排序。
MethodOrderer.DisplayName：根据方法的显示名称进行排序。
MethodOrderer.OrderAnnotation：根据@Order注解指定的值对测试进行排序。
MethodOrderer.Random：以伪随机顺序对测试进行排序。
MethodOrderer.Custom：使用自定义的排序逻辑对测试进行排序。
示例代码：

```java
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class OrderAnnotationTests {
    @Test
    @Order(1)
    public void testE() {
        System.out.println("Test E");
    }

    @Test
    @Order(2)
    public void testA() {
        System.out.println("Test A");
    }

    @Test
    @Order(3)
    public void testD() {
        System.out.println("Test D");
    }

    @Test
    @Order(4)
    public void testC() {
        System.out.println("Test C");
    }

    @Test
    @Order(5)
    public void testB() {
        System.out.println("Test B");
    }
}
```

自定义排序： 可以通过实现MethodOrderer接口来定义自定义的排序逻辑。

```java
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

@TestMethodOrder(MethodOrderer.Custom.class)
public class CustomOrderTests {
    @Test
    @Order(1)
    public void testA() {
        System.out.println("Test A");
    }

    @Test
    @Order(2)
    public void testB() {
        System.out.println("Test B");
    }

    @Test
    @Order(3)
    public void testC() {
        System.out.println("Test C");
    }
}
```

通过以上方法，可以灵活地控制JUnit 5中测试方法的执行顺序，以满足不同的测试需求。