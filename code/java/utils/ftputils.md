# FtpUtil

> java code

```java
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.maywide.digit.agent.ftp.entity.FtpFile;
import com.maywide.digit.common.exception.BusinessException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import sun.misc.BASE64Encoder;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.List;

@Slf4j
@Component
public class FtpUtil {

    static String LOCAL_CHARSET = "UTF-8";
    static String SERVER_CHARSET = "ISO-8859-1";

    @Value("${ftp.config.ip}")
    String ip;

    @Value("${ftp.config.port}")
    Integer port;

    @Value("${ftp.config.ftp-user}")
    String username;

    @Value("${ftp.config.ftp-password}")
    String password;
    //图片路径
    @Value("${ftp.config.base-path}")
    String basePath;


    private FTPClient connectFtpServer(){
        FTPClient ftpClient = new FTPClient();
        try {
            ftpClient.connect(ip,port);
            ftpClient.login(username,password);
            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);//设置文件传输模式为二进制，可以保证传输的内容不会被改变
            ftpClient.setConnectTimeout(1000*30);//设置连接超时时间
            ftpClient.setControlEncoding("utf-8");//设置ftp字符集
            ftpClient.enterLocalPassiveMode();//设置被动模式，文件传输端口设置
            int replyCode = ftpClient.getReplyCode();
            if (!FTPReply.isPositiveCompletion(replyCode)){
                log.error("connect ftp {} failed",ip);
                ftpClient.disconnect();
                return null;
            }
            log.info("replyCode==========={}",replyCode);
        } catch (IOException e) {
            log.error("connect fail ------->>>{}",e.getCause());
            return null;
        }


        return ftpClient;
    }


    /**
     *
     * @param inputStream 待上传文件的输入流
     * @param originName 文件保存时的名字
     */
    public String uploadFile(InputStream inputStream, String originName) {
        FTPClient ftpClient = connectFtpServer();
        if (ftpClient == null) {
            return null;
        }
        try {
            String path  = basePath + "/" + DateUtil.format(new Date(),"yyyyMMdd");
            this.createDir(ftpClient,path);//进入到文件保存的目录
            if (FTPReply.isPositiveCompletion(ftpClient.sendCommand("OPTS UTF8", "ON"))) {
                LOCAL_CHARSET = "UTF-8";
            }
            ftpClient.setControlEncoding(LOCAL_CHARSET);
            Boolean isSuccess = ftpClient.storeFile(new String(originName.getBytes(LOCAL_CHARSET), SERVER_CHARSET), inputStream);
            if (!isSuccess) {
                throw new BusinessException(originName + "---》上传失败！");
            }
            log.info("{}---》上传成功！", originName);
            ftpClient.logout();
            return path ;
        } catch (IOException e) {
            log.error("{}---》上传失败！", originName);
            return null;
        } finally {
            if (ftpClient.isConnected()) {
                try {
                    ftpClient.disconnect();
                } catch (IOException e) {
                    log.error("disconnect fail ------->>>{}", e.getCause());
                }
            }
        }
    }


    /**
     *  读ftp上的文件，并将其转换成base64
     * @param remoteFileName ftp服务器上的文件名
     * @return
     */
    public String readFileToBase64(String remoteFileName){
        FTPClient ftpClient = connectFtpServer();
        if (ftpClient == null){
            return null;
        }
        String base64 = "";
        InputStream inputStream = null;

        try {
            ftpClient.changeWorkingDirectory(basePath);
            FTPFile[] ftpFiles = ftpClient.listFiles(basePath);
            Boolean flag = false;
            //遍历当前目录下的文件，判断要读取的文件是否在当前目录下
            for (FTPFile ftpFile:ftpFiles){
                if (ftpFile.getName().equals(remoteFileName)){
                    flag = true;
                }
            }

            if (!flag){
                log.error("directory：{}下没有 {}",basePath,remoteFileName);
                return null;
            }
            //获取待读文件输入流
            inputStream = ftpClient.retrieveFileStream(basePath+remoteFileName);

            //inputStream.available() 获取返回在不阻塞的情况下能读取的字节数，正常情况是文件的大小
            byte[] bytes = new byte[inputStream.available()];

            inputStream.read(bytes);//将文件数据读到字节数组中
            BASE64Encoder base64Encoder = new BASE64Encoder();
            base64 = base64Encoder.encode(bytes);//将字节数组转成base64字符串
            log.info("read file {} success",remoteFileName);
            ftpClient.logout();
        } catch (IOException e) {
            log.error("read file fail ----->>>{}",e.getCause());
            return null;
        }finally {
            if (ftpClient.isConnected()){
                try {
                    ftpClient.disconnect();
                } catch (IOException e) {
                    log.error("disconnect fail ------->>>{}",e.getCause());
                }
            }
            if (inputStream != null){
                try {
                    inputStream.close();
                } catch (IOException e) {
                    log.error("inputStream close fail -------- {}",e.getCause());
                }
            }

        }
        return base64;
    }




    // 下载文件
    public void download(OutputStream outputStream , FtpFile ftpFile){
        String path = ftpFile.getFilePath() ;
        String fileStoreName = ftpFile.getFileStoreName(); ;

        FTPClient ftpClient = connectFtpServer();
        if (ftpClient == null){
            return ;
        }
        try {
            if (FTPReply.isPositiveCompletion(ftpClient.sendCommand("OPTS UTF8", "ON"))) {
                LOCAL_CHARSET = "UTF-8";
            }
            ftpClient.setControlEncoding(LOCAL_CHARSET);
            ftpClient.changeWorkingDirectory(path);
            FTPFile[] ftpFiles = ftpClient.listFiles(path);
            Boolean flag = false;
            //遍历当前目录下的文件，判断是否存在待下载的文件
            for (FTPFile file:ftpFiles){
                if (file.getName().equals(fileStoreName)){
                    flag = true;
                    break;
                }
            }
            if (!flag){
                throw new BusinessException("文件不存在...") ;
            }

            String s = new String(fileStoreName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1);
            Boolean isSuccess = ftpClient.retrieveFile(s,outputStream); //下载文件
            if (!isSuccess){
                log.error("download file 【{}】 fail",fileStoreName);
            }

            log.info("download file success");
            ftpClient.logout();
        } catch (IOException e) {
            log.error("download file 【{}】 fail ------->>>{}",fileStoreName,e.getCause());
        }finally {
            if (ftpClient.isConnected()){
                try {
                    ftpClient.disconnect();
                } catch (IOException e) {
                    log.error("disconnect fail ------->>>{}",e.getCause());
                }
            }
            if (outputStream != null){
                try {
                    outputStream.close();
                } catch (IOException e) {
                    log.error("outputStream close fail ------->>>{}",e.getCause());
                }
            }
        }
    }

    public boolean createDir(FTPClient ftpClient, String dir){
        if(StringUtils.isEmpty(dir)){
            return true;
        }
        String d;
        try {
            //目录编码，解决中文路径问题
            d = new String(dir.getBytes("UTF-8"),"iso-8859-1");
            if(ftpClient.changeWorkingDirectory(d)){
                return true;
            }
            List<String> list = StrUtil.split(d, "/");
            StringBuffer sbfDir=new StringBuffer();
            //循环生成子目录
            for(String s : list){
                if (StringUtils.isEmpty(s)){
                    continue;
                }
                sbfDir.append("/").append(s) ;
                //目录编码，解决中文路径问题
                d = new String(sbfDir.toString().getBytes("UTF-8"),"iso-8859-1");
                //尝试切入目录
                if(ftpClient.changeWorkingDirectory(d)){
                    continue;
                }
                if(!ftpClient.makeDirectory(d)){
                    log.error("[失败]ftp创建目录："+sbfDir.toString());
                    return false;
                }
                log.info("[成功]创建ftp目录："+sbfDir.toString());
            }
            //将目录切换至指定路径
            return ftpClient.changeWorkingDirectory(d);
        } catch (Exception e) {
            log.error(e.getMessage(),e);
            return false;
        }
    }
}
```
