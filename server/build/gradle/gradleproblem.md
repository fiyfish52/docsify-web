# gradle problem

## 中文乱码

`build.gradle` 文件增加

```pom
tasks.withType(JavaCompile) {  
    options.encoding = "UTF-8"  
} 
```

## 设定中心仓库

```pom
repositories {
    mavenLocal()
    maven { url 'https://maven.aliyun.com/nexus/content/repositories/google' }
    maven { url 'https://maven.aliyun.com/nexus/content/groups/public' }
    maven { url 'https://maven.aliyun.com/nexus/content/repositories/jcenter'}
    mavenCentral()
}
```
