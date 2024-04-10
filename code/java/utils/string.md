# string

## String <==> hexString

```java
public class StringToHex {
 
    /** 
     * 字符串转换为16进制字符串 
     *  
     * @param s 
     * @return 
     */  
    public static String stringToHexString(String s) {  
        String str = "";  
        for (int i = 0; i < s.length(); i++) {  
            int ch = s.charAt(i);  
            String s4 = Integer.toHexString(ch);  
            str = str + s4;  
        }  
        return str;  
    }  

    /** 
     * 16进制字符串转换为字符串 
     *  
     * @param s 
     * @return 
     */  
    public static String hexStringToString(String s) {  
        if (s == null || s.equals("")) {  
            return null;  
        }  
        s = s.replace(" ", "");  
        byte[] baKeyword = new byte[s.length() / 2];  
        for (int i = 0; i < baKeyword.length; i++) {  
            try {  
                baKeyword[i] = (byte) (0xff & Integer.parseInt(  
                        s.substring(i * 2, i * 2 + 2), 16));  
            } catch (Exception e) {  
                e.printStackTrace();  
            }  
        }  
        try {  
            // 这里可以指定编码，解决乱码
            s = new String(baKeyword, "gbk");  
            new String();  
        } catch (Exception e1) {  
            e1.printStackTrace();  
        }  
        return s;  
    }  

    /**
     * 16进制表示的字符串转换为字节数组
     *
     * @param s 16进制表示的字符串
     * @return byte[] 字节数组
     */
    public static byte[] hexStringToByteArray(String s) {
        int len = s.length();
        byte[] b = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            // 两位一组，表示一个字节,把这样表示的16进制字符串，还原成一个字节
            b[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character
                    .digit(s.charAt(i + 1), 16));
        }
        return b;
    }

    /**
     * byte数组转16进制字符串
     * @param bArray
     * @return
     */
        public static final String bytesToHexString(byte[] bArray) {
            StringBuffer sb = new StringBuffer(bArray.length);
            String sTemp;
            for (int i = 0; i < bArray.length; i++) {
            sTemp = Integer.toHexString(0xFF & bArray[i]);
            if (sTemp.length() < 2)
            sb.append(0);
            sb.append(sTemp.toUpperCase());
            }
            return sb.toString();
            }
}
```

## String <> inputstream

### InputStream转化为String

JDK原生提供

```java
byte[] bytes = new byte[0];
bytes = new byte[inputStream.available()];
inputStream.read(bytes);
String str = new String(bytes);
```

方法二

```java
String result = new BufferedReader(new InputStreamReader(inputStream))
        .lines().collect(Collectors.joining(System.lineSeparator()));
```

方法三：

```java
String result = new BufferedReader(new InputStreamReader(inputStream))
       .lines().parallel().collect(Collectors.joining(System.lineSeparator()));
```

方法四：

```java
Scanner s = new Scanner(inputStream).useDelimiter("\\A");
String str = s.hasNext() ? s.next() : "";
```

方法五：

```java
String resource = new Scanner(inputStream).useDelimiter("\\Z").next();
return resource;
```

方法六：

```java
StringBuilder sb = new StringBuilder();
String line;

BufferedReader br = new BufferedReader(new InputStreamReader(inputStream));
while ((line = br.readLine()) != null) {
    sb.append(line);
}
String str = sb.toString();
return str;
```

方法七：

```java
ByteArrayOutputStream result = new ByteArrayOutputStream();
byte[] buffer = new byte[1024];
int length;
while ((length = inputStream.read(buffer)) != -1) {
    result.write(buffer, 0, length);
}
String str = result.toString(StandardCharsets.UTF_8.name());
return str;
```

方法八：

```java
BufferedInputStream bis = new BufferedInputStream(inputStream);
ByteArrayOutputStream buf = new ByteArrayOutputStream();
int result = bis.read();
while(result != -1) {
    buf.write((byte) result);
    result = bis.read();
}
String str = buf.toString();
return str;
```

1.2 Apache Common提供

方法九：

```java
StringWriter writer = new StringWriter();
IOUtils.copy(inputStream, writer, StandardCharsets.UTF_8.name());
String str = writer.toString();
```

方法十：

```java
String str = IOUtils.toString(inputStream, "utf-8");
```

1.3 Google Guava提供

方法十一：

```java
String str = CharStreams.toString(new InputStreamReader(inputStream, StandardCharsets.UTF_8));
```

方法十二：

```java
String str = new String(ByteStreams.toByteArray(inputStream));
```

> 针对一个2MB的文件的输入流，多次执行测试如下(单位是毫秒)：

| 方法     | 执行毫秒数 |
| -------- | ---------- |
| 方法十   | 111        |
| 方法十一 | 236        |
| 方法十二 | 36         |
| 方法一   | 36         |
| 方法二   | 87         |
| 方法三   | 66         |
| 方法四   | 101        |
| 方法五   | 178        |
| 方法六   | 40         |
| 方法七   | 21         |
| 方法八   | 107        |
| 方法九   | 31         |

?> 从上述结果来看，`方法七`和`方法九`更好一些，而方法五和方法十一会更差一些。__

### String转化为InputStream

2.1 JDK原生提供

```java
InputStream is = new ByteArrayInputStream(str.getBytes());
```

2.2 Apache Common提供

```java
InputStream targetStream = IOUtils.toInputStream(str, StandardCharsets.UTF_8.name());
```

2.3 Google Guava提供

```java
InputStream targetStream =
        new ReaderInputStream(CharSource.wrap(str).openStream(), StandardCharsets.UTF_8.name());
```


## 文件转换为 字符串 再转为 文件

?> 系统间传递 需要使用 URLDecoder 编解码， 同时需要 指定编码集 编码：`java.net.URLEncoder.encode(str)` 解码：`URLDecoder.decode(res3,"utf-8")`

```java
  private byte[] test() throws IOException {
        //1、第一步：文件转为byte数组
        File file = new File("D:\\TOOL\\CSS3\\学习素材和工具\\工具集\\JavaScript工具集\\ECMAScript3.0规范英文版.pdf");
        FileInputStream fileInputStream = new FileInputStream(file);
        int size = fileInputStream.available();
        byte[] buffer = new byte[size];
        fileInputStream.read(buffer);

        //2、第二步：byte数组转换为char数组
        char[] byToChs = new char[size];
        for (int i = 0; i < size; i++) {
            byToChs[i] = (char) buffer[i];
        }

        //3、第三步：char数组转换为字符串
        StringBuilder sb = new StringBuilder();
        sb.append(byToChs);
        String str = sb.toString();

        //4、第四步：字符串转换为char数组
        char[] strTochs = str.toCharArray();

        //5、第五步:char数组转换为byte数组
        for (int i = 0; i < size; i++) {
            buffer[i] = (byte) strTochs[i];
        }
        String path = System.getProperty("user.dir");
        //6、第6步，把byte数组转化为文件
        File outputFile = new File(path + "/1.pdf");
        FileOutputStream fileOutputStream = new FileOutputStream(outputFile);
        fileOutputStream.write(buffer);

        fileOutputStream.close();
        fileInputStream.close();
        return null;
    }
```
