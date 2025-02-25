# fastjsoin

## code


```java
<!-- https://mvnrepository.com/artifact/com.alibaba.fastjson2/fastjson2 -->
<dependency>
    <groupId>com.alibaba.fastjson2</groupId>
    <artifactId>fastjson2</artifactId>
    <version>2.0.33</version>
</dependency>
```

```javapackage org.knbs.core.utils;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.alibaba.fastjson2.TypeReference;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
public class FastJsonUtil {



    /**
     * 将Java对象转换为JSON字符串
     *
     * @param obj 要转换的Java对象
     * @return JSON字符串
     */
    public static String toJsonString(Object obj) {
        return JSON.toJSONString(obj);
    }

    /**
     * 将JSON字符串转换为Java对象
     *
     * @param json JSON字符串
     * @param clazz 目标Java类的Class对象
     * @param <T> 目标Java类的类型
     * @return 转换后的Java对象
     */
    public static <T> T fromJsonString(String json, Class<T> clazz) {
        return JSON.parseObject(json, clazz);
    }

    /**
     * 将JSON字符串转换为Java对象（支持复杂类型，如List、Map等）
     *
     * @param json JSON字符串
     * @param typeReference 目标Java类型的TypeReference对象
     * @param <T> 目标Java类的类型
     * @return 转换后的Java对象
     */
    public static <T> T fromJsonString(String json, TypeReference<T> typeReference) {
        return JSON.parseObject(json, typeReference);
    }

    /**
     * 将json转换为对象
     *
     * @param <T>   转换的类型
     * @param json  json数据
     * @param clazz 被转化对象的class
     * @return
     */
    @Deprecated
    public static <T> T json2obj(String json, Class<T> clazz) {
        try {
            return JSON.parseObject(json, clazz);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 将json转换为对象数组
     *
     * @param <T>   转换的类型
     * @param json  json数据
     * @param clazz 被转化对象的class
     * @return
     */
    @Deprecated
    public static <T> List<T> json2List(String json, Class<T> clazz) {
        try {
            return JSON.parseArray(json, clazz);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * jsonStr to Map
     *
     * @param jsonStr jsonStr
     * @return
     * @author tongys
     * @date 2013-4-2
     */
    @Deprecated
    public static Map<String, String> parseJSON2Map(String jsonStr) {

        // 参数di
        Map<String, String> map = new HashMap<String, String>();
        JSONObject json = null;

        // 最外层解析
        try {
            json = JSONObject.parseObject(jsonStr);
            for (String k : json.keySet()) {
                Object v = json.get(k);
                if (null != v) {
                    map.put(k.toString(), v.toString());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return map;
    }
}
```



## junit5 单元测试

```java
package org.knbs.core.utils;

import io.jsonwebtoken.lang.Assert;
import lombok.Data;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class FastJsonUtilTest {

    @Data
    class User{
        private String name;
        private String password;

    }
    @Test
    void toJsonString() {
        User user = new User();
        user.setName("test");
        user.setPassword("<PASSWORD>");
        String json = FastJsonUtil.toJsonString(user);
        System.out.println(json);
        Assert.notNull(json,"json is not null");
    }

    @Test
    void fromJsonString() {
        String json = "{\"name\":\"test\",\"password\":\"<PASSWORD>\"}";
        User user = FastJsonUtil.fromJsonString(json, User.class);
        System.out.println(user);
        Assert.notNull(user,"user is not null");

        String jsons = "[{\"name\":\"test\",\"password\":\"<PASSWORD>\"},{\"name\":\"test2\",\"password\":\"<PASSWORD2>\"}]";
        List<User> list = FastJsonUtil.fromJsonString(jsons, List.class);
        System.out.println(list);
        Assert.notNull(list,"list is not null");
    }

    @Test
    void testFromJsonString() {
    }

    @Test
    void json2obj() {
        String json = "{\"name\":\"test\",\"password\":\"<PASSWORD>\"}";
        User user = FastJsonUtil.json2obj(json, User.class);
        System.out.println(user);
        Assert.notNull(user,"user is not null");
    }

    @Test
    void json2List() {
        String json = "[{\"name\":\"test\",\"password\":\"<PASSWORD>\"},{\"name\":\"test2\",\"password\":\"<PASSWORD2>\"}]";
        List<User> list = FastJsonUtil.json2List(json, User.class);
        System.out.println(list);
        Assert.notNull(list,"list is not null");

    }

    @Test
    void parseJSON2Map() {
    }

    @Test
    void parseJSON2Map2() {
    }
}
```
