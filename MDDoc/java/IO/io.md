# Java IO 流和文件操作

[1](https://www.runoob.com/java/java-files-io.html)[2](https://blog.csdn.net/qq_44715943/article/details/116501936)[3](https://javaguide.cn/java/io/io-basis.html)

[Java 流 (Stream)、文件 (File)和IO | 菜鸟教程https://www.runoob.com/java/java-files-io.html](https://www.runoob.com/java/java-files-io.html)

[Java IO流（超详细！）-CSDN博客https://blog.csdn.net/qq_44715943/article/details/116501936](https://blog.csdn.net/qq_44715943/article/details/116501936)

[Java IO 基础知识总结 | JavaGuidehttps://javaguide.cn/java/io/io-basis.html](https://javaguide.cn/java/io/io-basis.html)



在 Java 中，IO（输入/输出）是基于流（Stream）的概念构建的，用于读取和写入数据。流可以理解为数据的序列，输入流表示从源（如文件）读取数据，而输出流表示向目标（如文件）写入数据。Java 提供了丰富的 IO 类来支持文件操作和流的处理。

## Java IO 流的分类

Java IO 流根据数据处理的方式可以分为字节流和字符流：

- **字节流**：以字节为单位，读写数据，适用于任何类型的文件，包括文本、图片、音频等。
- **字符流**：以字符为单位，读写数据，主要用于处理文本文件。

## Java IO 流的四大家族

Java IO 流的核心由四个抽象类组成，它们是：

- *InputStream* / *OutputStream*：字节输入/输出流的基类。
- *Reader* / *Writer*：字符输入/输出流的基类。

## 常用的 Java IO 流类

- *FileInputStream* / *FileOutputStream*：用于读取和写入文件的字节流。
- *FileReader* / *FileWriter*：用于读取和写入文件的字符流。
- *BufferedReader* / *BufferedWriter*：带有缓冲区的字符流，提高读写效率。
- *DataInputStream* / *DataOutputStream*：用于读取和写入基本数据类型的数据流。
- *ObjectInputStream* / *ObjectOutputStream*：用于读取和写入序列化对象的流。

## Java 文件操作

Java 中的 *File* 类是文件和目录路径名的抽象表示形式，可以用来创建、删除、获取文件属性等操作，但不涉及文件内容的读写。



以下是使用 Java IO 流进行文件读写的示例代码：



```java
// 使用 FileInputStream 读取文件

try (InputStream is = new FileInputStream("example.txt")) {

int size = is.available();

for (int i = 0; i < size; i++) {

System.out.print((char) is.read());

}

} catch (IOException e) {

e.printStackTrace();

}

// 使用 FileOutputStream 写入文件

try (OutputStream os = new FileOutputStream("example.txt")) {

String data = "Java IO Stream Example";

os.write(data.getBytes());

} catch (IOException e) {

e.printStackTrace();

}
```

注意事项

- 在使用 IO 流进行文件操作时，应注意关闭流以释放系统资源。
- 对于文本文件的操作，建议使用字符流，以避免编码问题导致的乱码。
- 对于非文本文件（如图片、音频等），应使用字节流进行处理。

Java IO 流提供了强大而灵活的文件读写能力，广泛应用于文件传输和网络编程中。掌握 Java IO 流的使用对于进行文件操作和数据传输至关重要。