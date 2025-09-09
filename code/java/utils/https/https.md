# HTTPS 请求

协议：TLSv1 

## 依赖jar包

```
commons-httpclient.jar
commons-logging-1.1.0.jboss.jar
httpclient-4.5.1.jar
httpcore-4.4.3.jar
httpmime-4.1.2.jar
jettison-1.0.1.jar
jsonplugin-0.33-SNAPSHOT.jar
servlet-api.jar
```



## jdk 版本

### jdk 1.6, 1.7



使用 TLSv1 协议访问https
jdk 可选用 1.6 1.7



```java
package org.flyfish.test;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.KeyStore;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.googlecode.jsonplugin.JSONUtil;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.codehaus.jettison.json.JSONObject;

/**
 * 使用 TLSv1 协议访问https
 * jdk 可选用 1.6 1.7
 *
 */

public class httpclien {

	private static final String RESPONSE_KEY_STATUS = "status";
	private static final String RESPONSE_KEY_MESSAGE = "message";
	private static final String RESPONSE_KEY_OUTPUT = "output";
	private static final String STATUS_OK = "0";
	private static String[] url = {
			"https://172.28.28.136:7021/boss2_task/integrate/integate!bossRequest"};
	static Logger LOG = Logger.getAnonymousLogger();

	public static void main(String[] arg) {
		try {
			 https();
//			https();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@SuppressWarnings({ "unused", "deprecation", "resource" })
	public static void https() throws Exception {
		String[] bossHttpInfo = { url[0], "1" };
		String bossurl = bossHttpInfo[0];
		String version = bossHttpInfo[1];
		String clientCode = "QD11202l00";
		String deptId = "7715";
		String clientPwd = "1b445c0445a364c9bb17b2d1325ba492";
		String channelcode = "11202l00";

		DefaultHttpClient httpclient = new DefaultHttpClient();
		KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
		/* 1.证书文件 */
//		FileInputStream instream = new FileInputStream(new File(
//				"D:\\maywide\\svn\\14陕西省网BOSS2项目\\04接口管理\\统一接口服务（UIP）\\证书\\联调测试机172.28.28.133证书\\server_133.jks"));
		FileInputStream instream = new FileInputStream(new File(
				"D:\\maywide\\svn\\14陕西省网BOSS2项目\\04接口管理\\统一接口服务（UIP）\\证书\\136证书\\server.jks"));
		try {
			/* 2.校验密码 */
			trustStore.load(instream, "password".toCharArray());
		} finally {
			instream.close();
		}

		SSLSocketFactory socketFactory = new SSLSocketFactory(trustStore,
				"password", trustStore);
		Scheme sch = new Scheme("https", socketFactory, 443);
		httpclient.getConnectionManager().getSchemeRegistry().register(sch);

		/* 3.如果采用get方式 */
		// HttpGet httpget = new HttpGet(BOSS_URL);
		// System.out.println("executing request" + httpget.getRequestLine());
		// HttpResponse response = httpclient.execute(httpget);
		// HttpEntity entity = response.getEntity();
		// System.out.println("----------------------------------------");
		// System.out.println(response.getStatusLine());
		// if (entity != null) {
		// System.out.println("Response content length: "+
		// entity.getContentLength());
		// }
		// if (entity != null) {
		// entity.consumeContent();
		// }
		// httpclient.getConnectionManager().shutdown();

		/* 4.如果采用post方式 */
		HttpPost httpPost = new HttpPost(bossurl);
		/* 将request对象转换成JSON形式字符串requestStr */
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("querytype", "9");
		map.put("queryvalue", "1210700963924");
		map.put("citycode", "XY");
		String requestStr = JSONUtil.serialize(map, null, null, false, true);
		String requestid = createRequestid(clientCode);
		LOG.info("requestid=" + requestid);
		List<NameValuePair> nvps = new ArrayList<NameValuePair>();
		nvps.add(new BasicNameValuePair("version", version));
		nvps.add(new BasicNameValuePair("servicecode", "QUE_USERINFOLIST"));
		nvps.add(new BasicNameValuePair("requestid", requestid));
		nvps.add(new BasicNameValuePair("requestContent", requestStr));

		nvps.add(new BasicNameValuePair("citycode", "1"));
//		nvps.add(new BasicNameValuePair("deptid", deptId));
		nvps.add(new BasicNameValuePair("channelcode", channelcode));
		nvps.add(new BasicNameValuePair("clientcode", clientCode));
		nvps.add(new BasicNameValuePair("clientpwd", clientPwd));

		httpPost.setEntity(new UrlEncodedFormEntity(nvps));

		/* clientcode+YYYYMMDDHHMMSS */

		// String responseStr = postMethod.getResponseBodyAsString().trim();
		// LOG.info("=========>responseStr=" + responseStr);
		HttpResponse response = httpclient.execute(httpPost);
		HttpEntity entity = response.getEntity();
		// EntityUtils中的toString()方法转换服务器的响应数据
		String str = EntityUtils.toString(entity, "utf-8");
		System.out.println("服务器的响应是:" + str);

		// //6.从消息载体对象中获取操作的读取流对象
		// InputStream input=entity.getContent();
		// BufferedReader br=new BufferedReader(new InputStreamReader(input));
		// String str=br.readLine();
		// String result=new String(str.getBytes("gbk"), "utf-8");
		// System.out.println("服务器的响应是:"+result);
		// br.close();
		// input.close();
		httpclient.getConnectionManager().shutdown();
		LOG.info("=========>responseStr=" + response.getEntity());

	}

	public static void http() throws Exception {

		String[] bossHttpInfo = { url[3], "1" };
		String bossurl = bossHttpInfo[0];
		String version = bossHttpInfo[1];
		String clientCode = "QD11202l00";
//		String deptId = "7715";
		String clientPwd = "1b445c0445a364c9bb17b2d1325ba492";
		String channelcode = "11202l00";
		// 1.构造HttpClient的实例
		HttpClient httpClient = new HttpClient();
		httpClient.getParams().setContentCharset("UTF-8");
		PostMethod postMethod = new PostMethod(bossurl);

		/* 将request对象转换成JSON形式字符串requestStr */
		// Object request = new Object();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("querytype", "9");
		map.put("queryvalue", "1001800006747");
//		map.put("citycode", "XY");
		String requestStr = JSONUtil.serialize(map, null, null, false, true);
		// 3.把参数值放入到PostMethod对象中
		/*
		 * ?version=1 &clientcode=10001 &servicecode=xxx
		 * &requestid=100012012080100000001 &requestContent={}}
		 */
		postMethod.addParameter("version", version);
		postMethod.addParameter("clientcode", clientCode);
//		postMethod.addParameter("deptid", deptId);
		postMethod.addParameter("channelcode", channelcode);
		postMethod.addParameter("clientpwd", clientPwd);
		/* clientcode+YYYYMMDDHHMMSS */
		String requestid = createRequestid(clientCode);
		LOG.info("requestid=" + requestid);
		// bo.setCitycode("1");
		// bo.setServicecode("BIZ_PAY_INTERF");
		// 请求方法名
		postMethod.addParameter("servicecode", "QUE_USERINFO");
		postMethod.addParameter("requestid", requestid);// 交易流水号
		postMethod.addParameter("requestContent", requestStr);
		postMethod.addParameter("citycode", "1");

		JSONObject jsonobj = null;
		String status = null;
		String message = null;
		try {
			// 4.执行postMethod,调用http接口
			httpClient.executeMethod(postMethod);// 200
			// 5.读取内容
			String responseStr = postMethod.getResponseBodyAsString().trim();
			LOG.info("=========>responseStr=" + responseStr);
			// 6.处理返回的内容
			jsonobj = new JSONObject(responseStr);
			status = jsonobj.getString(RESPONSE_KEY_STATUS);
			LOG.info("status=" + status);
			message = jsonobj.getString(RESPONSE_KEY_MESSAGE);
			LOG.info("message=" + message);
			String output = jsonobj.getString(RESPONSE_KEY_OUTPUT);
			LOG.info(output);
			LOG.info(status);

		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			// 7.释放连接
			postMethod.releaseConnection();
			if (jsonobj == null) {

				throw new Exception("系统繁忙，请稍后再试...");
			}

			if (!STATUS_OK.equals(status)) { // 400错误也要抛异常的

				throw new Exception(status);
			}
		}
	}

	protected static String createRequestid(String clientCode) throws Exception {
		/* clientcode+YYYYMMDDHHMMSS */
		StringBuffer seril = new StringBuffer(clientCode);
		SimpleDateFormat formatterYMD = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat formatterHMS = new SimpleDateFormat("00HHmmss");
		// 时间请获取数据库时间
		String dateYMD = formatterYMD.format(new Date());
		String dateHMS = formatterHMS.format(new Date());
		seril.append(dateYMD);
		seril.append(dateHMS);
		LOG.info("requestid=" + seril.toString());
		return seril.toString();
	}
}

```

### jdk >= 1.8.0_291

```java
package org.flyfish.test;

/**
 * @author zhanglipengLZ
 * @version 1.0
 * @description: TODO
 * @date 2025/6/11 14:34
 */

import java.io.*;
import java.security.*;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Logger;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLException;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;

import com.googlecode.jsonplugin.JSONUtil;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpHead;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.config.Registry;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.socket.ConnectionSocketFactory;
import org.apache.http.conn.socket.LayeredConnectionSocketFactory;
import org.apache.http.conn.socket.PlainConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLContexts;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.conn.ssl.X509HostnameVerifier;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

/**
 * 适用1.6 1.7  <1.8.0_291
 * 若要适用 >= 1.8.0_291 需要更改java。security 配置  jdk.tls.disabledAlgorithms 去掉 TLSv1 TLSv1.1
 *      openjdk 文件路径：C:\Program Files\JAVA\jdk-17.0.5\conf\security 文件名： java.security
 *          jdk 文件路径：Java安装目录下的jre/lib/security/java.security 文件名： java.security
 */
public class HttpTest3 {

    static Logger LOG = Logger.getAnonymousLogger();


    public static void main(String[] args) throws Exception {
        CloseableHttpClient closeableHttpClient = null;
        CloseableHttpResponse closeableHttpResponse = null;
        try {
            HttpHead httpHead = null;
            TrustStrategy trustStrategy = null;
            SSLContext sslContext = null;
            X509HostnameVerifier x509HostnameVerifier = null;
            LayeredConnectionSocketFactory sslConnectionSocketFactory = null;
            Registry<ConnectionSocketFactory> registry = null;
            PoolingHttpClientConnectionManager poolingHttpClientConnectionManager = null;
            RequestConfig requestConfig = null;
            String audioURL = "https://172.28.28.136:7021/boss2_task/integrate/integate!bossRequest";

            httpHead = new HttpHead(audioURL);

            trustStrategy = new TrustStrategy() {
                @Override
                public boolean isTrusted(X509Certificate[] xcs, String authType) throws CertificateException {
                    return true;
                }
            };
            KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
            /* 1.证书文件 */
//		FileInputStream instream = new FileInputStream(new File(
//				"D:\\maywide\\svn\\14陕西省网BOSS2项目\\04接口管理\\统一接口服务（UIP）\\证书\\联调测试机172.28.28.133证书\\server_133.jks"));
            FileInputStream instream = new FileInputStream(new File(
                    "D:\\maywide\\svn\\14陕西省网BOSS2项目\\04接口管理\\统一接口服务（UIP）\\证书\\136证书\\server.jks"));
            try {
                /* 2.校验密码 */
                trustStore.load(instream, "password".toCharArray());
            } catch (CertificateException e) {
                throw new RuntimeException(e);
            } finally {
                instream.close();
            }
            sslContext = SSLContexts
                    .custom()
                    .useSSL()
                    .loadTrustMaterial(trustStore, trustStrategy)
                    .setSecureRandom(new SecureRandom())
                    .build();

            x509HostnameVerifier = new X509HostnameVerifier() {
                @Override
                public void verify(String host, SSLSocket ssl) throws IOException {
                    //do nothing
                }

                @Override
                public void verify(String host, X509Certificate cert) throws SSLException {
                    //do nothing                                                            //do nothing
                }

                @Override
                public void verify(String host, String[] cns, String[] subjectAlts) throws SSLException {
                    //do nothing
                }

                @Override
                public boolean verify(String string, SSLSession ssls) {
                    return true;
                }
            };

            //either one works
            //LayeredConnectionSocketFactory sslConnectionSocketFactory = new SSLConnectionSocketFactory(sslContext, new String[]{"TLSv1"}, null, SSLConnectionSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);
            sslConnectionSocketFactory = new SSLConnectionSocketFactory(sslContext, new String[]{"TLSv1"}, null, x509HostnameVerifier);

            registry = RegistryBuilder.<ConnectionSocketFactory>create()
                    .register("http", PlainConnectionSocketFactory.getSocketFactory())
                    .register("https", sslConnectionSocketFactory)
                    .build();

            poolingHttpClientConnectionManager = new PoolingHttpClientConnectionManager(registry);

            requestConfig = RequestConfig
                    .custom()
                    .setConnectTimeout(5000)            //5 seconds
                    .setConnectionRequestTimeout(5000)
                    .setSocketTimeout(5000)
                    .build();

            closeableHttpClient = HttpClientBuilder
                    .create()
                    .setDefaultRequestConfig(requestConfig)
                    .setSslcontext(sslContext)
                    .setHostnameVerifier(x509HostnameVerifier)
                    .setSSLSocketFactory(sslConnectionSocketFactory)
                    .setConnectionManager(poolingHttpClientConnectionManager)
                    .build();

            if (closeableHttpClient != null) {
//                closeableHttpResponse = closeableHttpClient.execute(httpHead);


                 String[] url = {
                        "https://172.28.28.136:7021/boss2_task/integrate/integate!bossRequest"};
                String[] bossHttpInfo = { url[0], "1" };
                String bossurl = bossHttpInfo[0];
                String version = bossHttpInfo[1];
                String clientCode = "QD11202l00";
                String deptId = "7715";
                String clientPwd = "1b445c0445a364c9bb17b2d1325ba492";
                String channelcode = "11202l00";
                HttpPost httpPost = new HttpPost(bossurl);
                /* 将request对象转换成JSON形式字符串requestStr */
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("querytype", "9");
                map.put("queryvalue", "1210700963924");
                map.put("citycode", "XY");
                String requestStr = JSONUtil.serialize(map, null, null, false, true);
                String requestid = createRequestid(clientCode);
                LOG.info("requestid=" + requestid);
                List<NameValuePair> nvps = new ArrayList<NameValuePair>();
                nvps.add(new BasicNameValuePair("version", version));
                nvps.add(new BasicNameValuePair("servicecode", "QUE_USERINFOLIST"));
                nvps.add(new BasicNameValuePair("requestid", requestid));
                nvps.add(new BasicNameValuePair("requestContent", requestStr));

                nvps.add(new BasicNameValuePair("citycode", "1"));
//		nvps.add(new BasicNameValuePair("deptid", deptId));
                nvps.add(new BasicNameValuePair("channelcode", channelcode));
                nvps.add(new BasicNameValuePair("clientcode", clientCode));
                nvps.add(new BasicNameValuePair("clientpwd", clientPwd));

                httpPost.setEntity(new UrlEncodedFormEntity(nvps));
                closeableHttpResponse = closeableHttpClient.execute(httpPost);


                if (closeableHttpResponse != null) {
                    int statusCode = closeableHttpResponse.getStatusLine().getStatusCode();
                    InputStream inputStream = closeableHttpResponse.getEntity().getContent();
                    String res = "";
                    try (Scanner scanner = new Scanner(inputStream, "UTF-8").useDelimiter("\\A")) {
                        res =  scanner.hasNext() ? scanner.next() : "";
                    }
                    LOG.info(res);
                    System.out.println(String.valueOf(statusCode));
                    System.out.println(closeableHttpResponse.getFirstHeader("Content-Type"));
                }
            }
        } catch (NoSuchAlgorithmException noSuchAlgorithmException) {
            System.out.println(noSuchAlgorithmException.getMessage());
        } catch (KeyStoreException keyStoreException) {
            System.out.println(keyStoreException.getMessage());
        } catch (KeyManagementException keyManagementException) {
            System.out.println(keyManagementException.getMessage());
        } catch (IOException iOException) {
            System.out.println(iOException.getMessage());
        } finally {
            if (closeableHttpResponse != null) {
                try {
                    closeableHttpResponse.close();
                } catch (IOException iOException) {
                    System.out.println(iOException.getMessage());
                }
            }
            if (closeableHttpClient != null) {
                try {
                    closeableHttpClient.close();
                } catch (IOException iOException) {
                    System.out.println(iOException.getMessage());
                }
            }
        }
    }
    protected static String createRequestid(String clientCode) throws Exception {
        /* clientcode+YYYYMMDDHHMMSS */
        StringBuffer seril = new StringBuffer(clientCode);
        SimpleDateFormat formatterYMD = new SimpleDateFormat("yyyyMMdd");
        SimpleDateFormat formatterHMS = new SimpleDateFormat("00HHmmss");
        // 时间请获取数据库时间
        String dateYMD = formatterYMD.format(new Date());
        String dateHMS = formatterHMS.format(new Date());
        seril.append(dateYMD);
        seril.append(dateHMS);
        LOG.info("requestid=" + seril.toString());
        return seril.toString();
    }
}
```

