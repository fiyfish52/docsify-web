# 问题处理


> ## 生成 android lib aar 时需要特殊处理

### lib依赖第三方aar

打包时，无法将第三方aar 打包，需要依赖第三方插件

### lib 依赖第三方 aar中包含 其他jar包

打包时，该jar包无法使用； 需要单独依赖jar包，并将原有aar中的jar包删除，防止依赖重复 参考[手动处理aar](/web/uniapp/androidplugin/solveProblem?id=%e6%89%8b%e5%8a%a8%e5%a4%84%e7%90%86aar)

### lib 使用自定义字体

在uni project中配置android可用 资源文件

[官网说明](https://uniapp.dcloud.net.cn/tutorial/app-nativeresource-android.html)

### 解决方法

[参考android插件项目](https://github.com/fiyfish52/uniapp_plugin_dianju_android.git)

[参考uni项目](https://github.com/fiyfish52/uniapp_plugin_dianju_uni.git)

> ## 未配置appkey或配置错误

!> 导入的app与 appkey 必须是同属于一个应用

包名可自定义 ，对应的android项目 需要更改：
1, app/build.gradle:android.defaultConfig.applicationId
2, app/src/main/AndroidManifest.xml: package 内容

key 要填写报名对应的 appkey

配置app对应的证书

### 生成证书


> ## 手动处理aar

### 解压

unzip 或者 使用解压工具打开 解压即可 

### 重新压缩为aar

将tmpDir重新打包成一个新的aar

```sh
jar cvf ×××NewLib.aar -C tmpDir/ .
```

不要漏了末尾的 “.”，“tmpDir/” 与 “.” 之间用空格分隔。×××NewLib.aar表示新aar名称。
