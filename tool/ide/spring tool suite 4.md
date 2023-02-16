# Spring Tool Suites 4

## 一直报错: build

---

报错如下：

```sh
Errors occurred during the build.
Errors running builder 'Java Builder' on project 'springboot3-parent'.
Unable to make protected final java.lang.Class java.lang.ClassLoader.defineClass(java.lang.String,byte[],int,int) throws java.lang.ClassFormatError accessible: module java.base does not "opens java.lang" to unnamed module @163042ea
```

> 原因

引用lombook.jar 的问题

> 解决

更改 SpringToolSuite4.ini 文件，添加如下配置：

路径更改为自己的路径

```sh
-vm
C:\Program Files\JAVA\jdk-17.0.5\bin\javaw.exe
```

```sh
--add-opens=java.base/java.lang=ALL-UNNAMED
```

```sh
--illegal-access=warn
-javaagent:D:\software\sts-4.17.2.RELEASE\lombok.jar
```

完整版：

```bash
-vm
C:\Program Files\JAVA\jdk-17.0.5\bin\javaw.exe
-startup
plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar
--launcher.library
plugins/org.eclipse.equinox.launcher.win32.win32.x86_64_1.2.700.v20221108-1024
-product
org.springframework.boot.ide.branding.sts4
--launcher.defaultAction
openFile
-vm
plugins/org.eclipse.justj.openjdk.hotspot.jre.full.win32.x86_64_17.0.6.v20230125-1136/jre/bin
-vmargs
--add-opens=java.base/java.io=ALL-UNNAMED
--add-opens=java.base/sun.nio.ch=ALL-UNNAMED
--add-opens=java.base/java.net=ALL-UNNAMED
--add-opens=java.base/sun.security.ssl=ALL-UNNAMED
--add-opens=java.base/java.lang=ALL-UNNAMED
-Dosgi.requiredJavaVersion=17
-Dosgi.dataAreaRequiresExplicitInit=true
-Dsun.java.command=SpringToolSuite4
-Xms256m
-Xmx2048m
--illegal-access=permit
--add-modules=ALL-SYSTEM
--illegal-access=warn
-javaagent:D:\software\sts-4.17.2.RELEASE\lombok.jar
```
