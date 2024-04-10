# VPN easyConnect

```sh
docker run --name MyEasyconnect --rm --device /dev/net/tun --cap-add NET_ADMIN -ti -p 127.0.0.1:1080:1080 -p 127.0.0.1:8888:8888 -e EC_VER=7.6.3 -e CLI_OPTS="-d https://ip:port -u username -p password" hagb/docker-easyconnect:cli
```
