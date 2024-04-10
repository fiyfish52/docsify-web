# webclient 

## 配置文件

```java

import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;


@Configuration
public class WebClientConfig {

    @Bean
    public WebClient.Builder webClientBuilder() {
        return WebClient.builder();
    }

    @Bean("loadBalancedWebClientBuilder")
    @LoadBalanced
    public WebClient.Builder loadBalancedWebClientBuilder() {
        return WebClient.builder();
    }
}

```


## 工具类

```java
import com.knbs.common.constants.base.BaseConstant;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

@Slf4j
@Service
public class BaseServerService {

    private final WebClient webClient;

    @Autowired
    public BaseServerService(WebClient.Builder loadBalancedWebClientBuilder) {
//        this.webClient = loadBalancedWebClientBuilder.baseUrl("lb://localhost:8785").build();
        this.webClient = loadBalancedWebClientBuilder.baseUrl("lb://base-server").build();
    }

    public Map findSysParams() throws ExecutionException, InterruptedException, TimeoutException {
        Map retmap = new HashMap();
        Map map = new HashMap();
        map.put("gcode", BaseConstant.PRV_PARAMS.BOSS_SERVER_PARAM);
        Mono<Map> mono = webClient.post()
                .uri("/base/sys_params/findSysParams")
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(map)
                .retrieve()
                .bodyToMono(Map.class);
        Future future = Executors.newCachedThreadPool().submit((Callable<Map>) () -> mono.block());
        Map datas = ((Map) future.get(5, TimeUnit.SECONDS));
        if (datas != null) {
            for (Object obj : (List) datas.get("data")) {
                Map m = (Map) obj;
                String mcode = m.get("mcode") + "";
                String data = m.get("data") + "";
                if (BaseConstant.BOSS_SERVER_PARAM.URL.equals(mcode)) {
                    retmap.put(BaseConstant.BOSS_SERVER_PARAM.URL, data);
                }
                if (BaseConstant.BOSS_SERVER_PARAM.CLIENT_PWD.equals(mcode)) {
                    retmap.put(BaseConstant.BOSS_SERVER_PARAM.CLIENT_PWD, data);
                }
                if (BaseConstant.BOSS_SERVER_PARAM.CHANNEL_CODE.equals(mcode)) {
                    retmap.put(BaseConstant.BOSS_SERVER_PARAM.CHANNEL_CODE, data);
                }
                if (BaseConstant.BOSS_SERVER_PARAM.SERVICE_CODE.equals(mcode)) {
                    retmap.put(BaseConstant.BOSS_SERVER_PARAM.SERVICE_CODE, data);
                }
                if (BaseConstant.BOSS_SERVER_PARAM.CLIENT_CODE.equals(mcode)) {
                    retmap.put(BaseConstant.BOSS_SERVER_PARAM.CLIENT_CODE, data);
                }
            }
            log.info("获取参数{}:{}", BaseConstant.PRV_PARAMS.BOSS_SERVER_PARAM, retmap.toString());
        }

        return retmap;
    }
}
```

## 调用

```java
@Autowired
 private BaseServerService baseServerService;
 ....
 baseServerService.findSysParams();
```
