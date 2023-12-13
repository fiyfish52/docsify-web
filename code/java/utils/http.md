# http

```java
HttpURLConnection conn = null;
try {
    URL my_url = new URL(url);
    // 得到connection对象。
    conn = (HttpURLConnection) my_url.openConnection();
    // 允许写出
    conn.setDoOutput(true);
    // 允许读入
    conn.setDoInput(true);
    // 设置请求方式
    conn.setRequestMethod("POST");
    conn.setUseCaches(false);
    conn.setConnectTimeout(60 * 1000);
    conn.setReadTimeout(60 * 1000);
    // 设置请求头
    conn.setRequestProperty("Charsert", "UTF-8");
    conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");// 设置参数类型是json格式
    conn.setRequestProperty("Connection", "Keep-Alive");
    conn.setRequestProperty("logType", "base");
    
    // 连接网络。请求行，请求头的设置必须放在网络连接前
    conn.connect();
    
    // 增加request body
    JSONObject param = new JSONObject();
    param.put("srcStr", srcString);
    
    
    // 得到请求的输出流对象
    OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream(),"UTF-8");
    writer.write(param.toString());
    writer.flush();

    
    // 得到响应码
    int responseCode = conn.getResponseCode();
    if (responseCode == 200) {
        // 得到响应流
        InputStream inputStream = conn.getInputStream();

        byte[] bytes = new byte[0];
        bytes = new byte[inputStream.available()];
        inputStream.read(bytes);
        // 将响应流转换成字符串
        String returnLine = new String(bytes);
        String str = "Success" + conn.getResponseCode() + "---" + conn.getResponseMessage() + "---"
                + returnLine;
        System.out.print(str);
    } else {
        String str = "Error" + conn.getResponseCode() + "---" + conn.getResponseMessage();
        System.out.print(str);
    }

} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (conn != null) {
        conn.disconnect();
    }
}
```
