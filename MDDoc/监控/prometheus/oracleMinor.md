



docker 部署oracle-exporter

```
docker run -it --rm     -e DB_USERNAME=boss_crm     -e DB_PASSWORD=boss_crm     -e DB_CONNECT_STRING=10.253.100.153:1521/boss     -p 9161:9161     container-registry.oracle.com/database/observability-exporter:2.0.2 --name ora153
```

oracle export --github

```
https://github.com/oracle/oracle-db-appdev-monitoring.git
```



```
docker run -it --rm -e DB_USERNAME=opu71fpi -e DB_PASSWORD=9MY4MP0D -e DB_CONNECT_STRING=172.28.25.88:9017/sxboss -p 9162:9161     container-registry.oracle.com/database/observability-exporter:2.0.2 --name ora24
```

prometheus

oracle 配置

```
#oralce

  - job_name: oracle

    scrape_interval: 30s 

    static_configs:

    - targets: ['localhost:9161']
```





grafana

```
https://grafana.com/grafana/dashboards
```

配置

conf 下，将 defaults.ini 复制一份 custom.ini 再更改，否则不生效；
