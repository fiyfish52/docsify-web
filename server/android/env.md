#

## 生成签名证书

[生成证书](/server/language/java/java.md?id=keytool)

modelname VPN-Plugin-Qihoo
包名：com.android.UniQihooVpnPlugin

appkey 84045eb7343cfc51d0035485d9e4da10

keytool -genkey -alias test -keypass maywide368 -keyalg RSA -keysize 2048 -validity 36500 -keystore D:\test.keystore -storepass maywide368



.\keytool.exe -list -v -alias test  -storepass maywide368  -keystore D:\test.keystore


## 开发uni android 原生插件

[github](https://github.com/fiyfish52/UniPlugin-Qihoo-Sdk-android.git)
