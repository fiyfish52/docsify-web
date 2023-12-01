# zip

```java
package com.maywide.oss.utils;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;


public class ZipUtils {
    private static final int BUFFER_SIZE = 2 * 1024;

    /**
     * 压缩成ZIP 方法1
     * 
     * @param srcDir
     *            压缩文件夹路径
     * @param zipFilePathName
     *            压缩文件输出地址与名字
     * @param KeepDirStructure
     *            是否保留原来的目录结构,true:保留目录结构;
     *            false:所有文件跑到压缩包根目录下(注意：不保留目录结构可能会出现同名文件,会压缩失败)
     * @throws RuntimeException
     *             压缩失败会抛出运行时异常
     */
    public static void toZip(String srcDir, String zipFilePathName,
            boolean KeepDirStructure) throws RuntimeException,
            FileNotFoundException {

        long start = System.currentTimeMillis();
        File file = new File(zipFilePathName);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
        }
        FileOutputStream out = new FileOutputStream(zipFilePathName);
        ZipOutputStream zos = null;
        try {
            zos = new ZipOutputStream(out);
            File sourceFile = new File(srcDir);
            compress(sourceFile, zos, sourceFile.getName(), KeepDirStructure);
            long end = System.currentTimeMillis();
            
        } catch (Exception e) {
            throw new RuntimeException("zip error from ZipUtils", e);
        } finally {
            if (zos != null) {
                try {
                    zos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 压缩成ZIP 方法2
     * 
     * @param srcFiles
     *            需要压缩的文件列表
     * @param zipFilePathName
     *            压缩文件输出地址与名字
     * @throws RuntimeException
     *             压缩失败会抛出运行时异常
     */
    public static void toZip(List<File> srcFiles, String zipFilePathName)
            throws RuntimeException, FileNotFoundException {
        long start = System.currentTimeMillis();
        ZipOutputStream zos = null;
        File file = new File(zipFilePathName);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
        }
        FileOutputStream out = new FileOutputStream(zipFilePathName);
        try {
            zos = new ZipOutputStream(out);
            for (File srcFile : srcFiles) {
                byte[] buf = new byte[BUFFER_SIZE];
                zos.putNextEntry(new ZipEntry(srcFile.getName()));
                int len;
                FileInputStream in = new FileInputStream(srcFile);
                while ((len = in.read(buf)) != -1) {
                    zos.write(buf, 0, len);
                }
                zos.closeEntry();
                in.close();
            }
            long end = System.currentTimeMillis();
            
        } catch (Exception e) {
            throw new RuntimeException("zip error from ZipUtils", e);
        } finally {
            if (zos != null) {
                try {
                    zos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 递归压缩方法
     * 
     * @param sourceFile
     *            源文件
     * @param zos
     *            zip输出流
     * @param name
     *            压缩后的名称
     * @param KeepDirStructure
     *            是否保留原来的目录结构,true:保留目录结构;
     *            false:所有文件跑到压缩包根目录下(注意：不保留目录结构可能会出现同名文件,会压缩失败)
     * @throws Exception
     */
    private static void compress(File sourceFile, ZipOutputStream zos,
            String name, boolean KeepDirStructure) throws Exception {
        byte[] buf = new byte[BUFFER_SIZE];
        if (sourceFile.isFile()) {
            // 向zip输出流中添加一个zip实体，构造器中name为zip实体的文件的名字
            zos.putNextEntry(new ZipEntry(name));
            // copy文件到zip输出流中
            int len;
            FileInputStream in = new FileInputStream(sourceFile);
            while ((len = in.read(buf)) != -1) {
                zos.write(buf, 0, len);

            }

            // Complete the entry
            zos.closeEntry();
            in.close();
        } else {
            File[] listFiles = sourceFile.listFiles();
            if (listFiles == null || listFiles.length == 0) {
                // 需要保留原来的文件结构时,需要对空文件夹进行处理
                if (KeepDirStructure) {

                    // 空文件夹的处理
                    zos.putNextEntry(new ZipEntry(name + "/"));

                    // 没有文件，不需要文件的copy
                    zos.closeEntry();
                }

            } else {
                for (File file : listFiles) {
                    // 判断是否需要保留原来的文件结构
                    if (KeepDirStructure) {
                        // 注意：file.getName()前面需要带上父文件夹的名字加一斜杠,
                        // 不然最后压缩包中就不能保留原来的文件结构,即：所有文件都跑到压缩包根目录下了
                        compress(file, zos, name + "/" + file.getName(),
                                KeepDirStructure);
                    } else {
                        compress(file, zos, file.getName(), KeepDirStructure);
                    }

                }
            }
        }
    }
    
    /**
     * 
     * @param targetPath 已路径分隔符结尾 "\" 获取方式  System.getProperty("file.separator");
     * @param fileFullPathName 文件绝对路径+文件名
     * @throws IOException
     */
    public static void unzip(String targetPath, String  fileFullPathName) throws IOException {
        InputStream is = new FileInputStream(fileFullPathName);

        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[16];
        while ((nRead = is.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }

        buffer.flush();

        byte[] byteArrays = buffer.toByteArray();
        is.close();
        // targetPath输出文件路径
        File targetFile = new File(targetPath);
        // 如果目录不存在，则创建
        if (!targetFile.exists()) {
            targetFile.mkdirs();
        }

        InputStream inputStream = new ByteArrayInputStream(byteArrays);
        ZipInputStream zip = new ZipInputStream(inputStream);
        ZipEntry zipEntry = null;
        while ((zipEntry = zip.getNextEntry()) != null) {
            String fileName_zip = zipEntry.getName();
            System.out.println(fileName_zip);
            File file = new File(targetPath+System.getProperty("file.separator") + fileName_zip);
            if (fileName_zip.endsWith("/")) {
                file.mkdir();
            } else {
                BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream(file));
                byte[] byte_s = new byte[1024];
                int num;
                while ((num = zip.read(byte_s, 0, byte_s.length)) > 0) {
                    outputStream.write(byte_s, 0, num);
                }
                outputStream.close();
            }
        }

    }
}

```
