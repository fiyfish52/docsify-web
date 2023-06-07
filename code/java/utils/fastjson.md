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

```java
package com.knbs.common.utils.json;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import lombok.NoArgsConstructor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Mr.zhang
 * @version 1.0
 * @description: Fastjson 工具类
 * @date 2023/2/26 12:21:44
 */
@NoArgsConstructor
public final class FastJsonUtil {

    /**
     * 将对象转换为json
     * null ->list =[]
     * 输出null 值
     * @param value 对象
     * @return
     */
    public static String obj2json(Object value) {
        try {
            return JSON.toJSONString(value, SerializerFeature.WriteMapNullValue,SerializerFeature.WriteNullListAsEmpty);
        } catch (Exception e) {
            try {
                return obj2json3(value);
            } catch (Exception e1) {
                e.printStackTrace();
                return null;
            }
        }
    }

    public static String obj2jsonPretty(Object value) {
        try {
            return JSON.toJSONString(value, SerializerFeature.PrettyFormat);
        } catch (Exception e) {
            try {
                return obj2json2(value);
            } catch (Exception e1) {
                e.printStackTrace();
                return null;
            }
        }
    }

    public static String obj2jsonDateFormat(Object value) {
        try {
            return JSON.toJSONStringWithDateFormat(value, "yyyy-MM-dd HH:mm:ss",
                    SerializerFeature.WriteDateUseDateFormat,SerializerFeature.DisableCircularReferenceDetect);
        } catch (Exception e) {
            try {
                return obj2json2(value);
            } catch (Exception e1) {
                e.printStackTrace();
                return null;
            }
        }
    }

    public static String obj2jsonDateFormat(Object value, String format) {
        try {
//			return JSON.toJSONString(value, SerializerFeature.PrettyFormat);
            return JSON.toJSONStringWithDateFormat(value, format,
                    SerializerFeature.WriteDateUseDateFormat);
        } catch (Exception e) {
            try {
                return obj2json2(value);
            } catch (Exception e1) {
                e.printStackTrace();
                return null;
            }
        }
    }

    @SuppressWarnings("deprecation")
    public static String obj2json2(Object value) {
        try {
            return JSON.toJSONString(value, SerializerFeature.WriteTabAsSpecial, SerializerFeature.WriteSlashAsSpecial);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @SuppressWarnings("deprecation")
    public static String obj2json3(Object value) {
        try {
            return JSON.toJSONString(value, SerializerFeature.WriteTabAsSpecial, SerializerFeature.WriteSlashAsSpecial,
                    SerializerFeature.BrowserCompatible);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 将json转换为对象
     *
     * @param <T>   转换的类型
     * @param json  json数据
     * @param clazz 被转化对象的class
     * @return
     */
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

    /**
     * jsonStr to Map
     *
     * @param jsonStr jsonStr
     * @return
     */
    public static Map<String, Object> parseJSON2Map2(String jsonStr) {

        // 参数di
        Map<String, Object> map = new HashMap<String, Object>();
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
import com.knbs.client.model.ClientInfos;
import com.knbs.common.utils.json.FastJsonUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.util.Assert;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

/**
 * @author Mr.zhang
 * @version 1.0
 * @description: TODO
 * @date 2023/2/26 9:57:12
 */
@Slf4j
public class CustmerTest {

    @Test
    void ddd(){
        String jsonStr = "{\n" +
                "  \"knbsResultCode\": \"SUCESS\",\n" +
                "  \"data\": [\n" +
                "    {\n" +
                "      \"scope\": [\n" +
                "        \"all\"\n" +
                "      ],\n" +
                "      \"client_id\": \"test1\",\n" +
                "      \"client_secret\": \"secret\",\n" +
                "      \"resource_ids\": [\n" +
                "        \"mobile\",\n" +
                "        \"salary\"\n" +
                "      ],\n" +
                "      \"authorized_grant_types\": [\n" +
                "        \"implicit\",\n" +
                "        \"refresh_token\",\n" +
                "        \"password\",\n" +
                "        \"authorization_code\"\n" +
                "      ],\n" +
                "      \"redirect_uri\": [\n" +
                "        \"www.baidu.com\"\n" +
                "      ],\n" +
                "      \"autoapprove\": null,\n" +
                "      \"access_token_validity\": null,\n" +
                "      \"refresh_token_validity\": null\n" +
                "    }\n" +
                "  ],\n" +
                "  \"code\": 200,\n" +
                "  \"msg\": \"SUCCESS\"\n" +
                "}";


        Map<String,String> map = FastJsonUtil.parseJSON2Map(jsonStr);
        List<ClientInfos> clientInfosList = FastJsonUtil.json2List(map.get("data"),ClientInfos.class);

        Assert.notEmpty(clientInfosList);
    }
}
```
