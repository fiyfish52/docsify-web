# RSAUtil


```java
package com.maywide.oss.component.biz.es.impl;

import java.io.ByteArrayOutputStream;
import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;

import com.maywide.oss.component.log.LogCommonFile;

    
public class RSAUtils {
     
    /** */
    /**
     * 加密算法RSA
     */
    public static final String KEY_ALGORITHM = "RSA";
 
    /** */
    /**
     * 签名算法
     */
    public static final String SIGNATURE_ALGORITHM = "MD5withRSA";
    
    /***
     * 签名算法
     */
    public static final String SIGNATURE_ONLINE_ALGORITHM = "SHA1withRSA";
 
    /** */
    /**
     * 获取公钥的key
     */
    private static final String PUBLIC_KEY = "RSAPublicKey";
 
    /** */
    /**
     * 获取私钥的key
     */
    private static final String PRIVATE_KEY = "RSAPrivateKey";
 
    /** */
    /**
     * RSA最大加密明文大小
     */
    private static final int MAX_ENCRYPT_BLOCK = 117;
 
    /** */
    /**
     * RSA最大解密密文大小
     */
    private static final int MAX_DECRYPT_BLOCK = 128;
 
    /** */
    /**
     * RSA 位数 如果采用2048 上面最大加密和最大解密则须填写:  245 256
     */
    private static final int INITIALIZE_LENGTH = 1024;
    
    public static final String CHARSET = "UTF-8";
    
    public static final String LOGIN_PRIVATE_KEY ="MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAIlvspYGGwfKIgo2t2MZeZVYjQkStol6aSu9ve+KOIqnQ/X2bueYBBP8wQrMVaCBZDGo2FlickWgFgCY/RAK+Zeq6I9JrZlEMYDy0XPO/3+VJc/EnKO8MfGNDVXFfvHXXJlD0bG2S0I4sFvkQhP8TvcXUhLSfZHKhQ3pi0XDN1SHAgMBAAECgYBrgKqBfS8hjbPIp3oVEzUuY8CWC0QrD0w6wcVTHJwToLihKW0gzKDL/ZYGW0TTMsLrsTXh3QajfZAYUZMJPHx0PiCxVLcxjKZvIwNETDolNfNuPpqAqJ3Olws7cA9sjX1fT8p2fCsIlV9krAOtFYgR2Z/5mJMIt0zZ0q3Me4RxCQJBAPLI5iN2D5Hqnb3MpfsSpaRPCWKg+kE46z4u/N4XEh9H3xvf0l3uL16J+CELfsIN1RngVX77ff+r3SjEaWsyFLMCQQCQ6tA/xyKGLR7L6oPKnUwKNuuvyeCBzpiHZl4UwrlbUMOolSj/E2pfV1gf9RVBBTRhAK68hU/XgUcq9UIAjbLdAkBkg/JsCgwGMGlgVCL/4Md9UE+latpROHyEgTWlyU1yb/IZ+z+ALgWkkWCOZdD0DIAGt48OBJc0y/XDVBYFEHXrAkAvIU7tDxR5Ur9LTk/iW1nZkJcCKsOrM8eDcZVzZwjlW9TmROx6WJQlwcBVVF2/MbQhQBmUEj8vNUox/GWkzHC5AkBBu0ej6W5pLfGzMAjYcb05A/zdSM2FQOsvHbWmF2k5EKfEpdIHB6FIWXFErk49nZv01wwwA6jJg4ShMTNjwGkc";
 
    /** */
    /**
     * <p>
     * 生成密钥对(公钥和私钥)
     * </p>
     * 
     * @return
     * @throws Exception
     */
    public static Map<String, Object> genKeyPair() throws Exception {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance(KEY_ALGORITHM);
        keyPairGen.initialize(INITIALIZE_LENGTH);
        KeyPair keyPair = keyPairGen.generateKeyPair();
        RSAPublicKey publicKey = (RSAPublicKey) keyPair.getPublic();
        RSAPrivateKey privateKey = (RSAPrivateKey) keyPair.getPrivate();
        Map<String, Object> keyMap = new HashMap<String, Object>(2);
        keyMap.put(PUBLIC_KEY, publicKey);
        keyMap.put(PRIVATE_KEY, privateKey);
        return keyMap;
    }
 
    /** */
    /**
     * <p>
     * 用私钥对信息生成数字签名
     * </p>
     * 
     * @param data
     *            已加密数据
     * @param privateKey
     *            私钥(BASE64编码)
     * 
     * @return
     * @throws Exception
     */
    public static String sign(byte[] data, String privateKey) throws Exception {
        byte[] keyBytes = Base64.decodeBase64(privateKey.getBytes());
        PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        PrivateKey privateK = keyFactory.generatePrivate(pkcs8KeySpec);
        Signature signature = Signature.getInstance(SIGNATURE_ALGORITHM);
        signature.initSign(privateK);
        signature.update(data);
        return new String(Base64.encodeBase64(signature.sign()),CHARSET);
    }
    
    
    public static String onlineSign(byte[] data, String privateKey) throws Exception {
        byte[] keyBytes = Base64.decodeBase64(privateKey.getBytes());
        PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        PrivateKey privateK = keyFactory.generatePrivate(pkcs8KeySpec);
        Signature signature = Signature.getInstance(SIGNATURE_ONLINE_ALGORITHM);
        signature.initSign(privateK);
        signature.update(data);
        return new String(Base64.encodeBase64(signature.sign()),CHARSET);
    }
 
    /** */
    /**
     * <p>
     * 校验数字签名
     * </p>
     * 
     * @param data
     *            已加密数据
     * @param publicKey
     *            公钥(BASE64编码)
     * @param sign
     *            数字签名
     * 
     * @return
     * @throws Exception
     * 
     */
    public static boolean verify(byte[] data, String publicKey, String sign) throws Exception {
        byte[] keyBytes = Base64.decodeBase64(publicKey.getBytes());
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        PublicKey publicK = keyFactory.generatePublic(keySpec);
        Signature signature = Signature.getInstance(SIGNATURE_ALGORITHM);
        signature.initVerify(publicK);
        signature.update(data);
        return signature.verify(Base64.decodeBase64(sign.getBytes()));
    }
 
    /** */
    /**
     * <P>
     * 私钥解密
     * </p>
     * 
     * @param encryptedData
     *            已加密数据
     * @param privateKey
     *            私钥(BASE64编码)
     * @return
     * @throws Exception
     */
    public static byte[] decryptByPrivateKey(byte[] encryptedData, String privateKey) throws Exception {
        byte[] keyBytes = Base64.decodeBase64(privateKey);
        PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        Key privateK = keyFactory.generatePrivate(pkcs8KeySpec);
        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
        cipher.init(Cipher.DECRYPT_MODE, privateK);
        int inputLen = encryptedData.length;
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        int offSet = 0;
        byte[] cache;
        int i = 0;
        // 对数据分段解密
        while (inputLen - offSet > 0) {
            if (inputLen - offSet > MAX_DECRYPT_BLOCK) {
                cache = cipher.doFinal(encryptedData, offSet, MAX_DECRYPT_BLOCK);
            } else {
                cache = cipher.doFinal(encryptedData, offSet, inputLen - offSet);
            }
            out.write(cache, 0, cache.length);
            i++;
            offSet = i * MAX_DECRYPT_BLOCK;
        }
        byte[] decryptedData = out.toByteArray();
        out.close();
        return decryptedData;
    }
 
    /** */
    /**
     * <p>
     * 公钥解密
     * </p>
     * 
     * @param encryptedData
     *            已加密数据
     * @param publicKey
     *            公钥(BASE64编码)
     * @return
     * @throws Exception
     */
    public static byte[] decryptByPublicKey(byte[] encryptedData, String publicKey) throws Exception {
        byte[] keyBytes = Base64.decodeBase64(publicKey.getBytes());
        X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        Key publicK = keyFactory.generatePublic(x509KeySpec);
        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
        cipher.init(Cipher.DECRYPT_MODE, publicK);
        int inputLen = encryptedData.length;
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        int offSet = 0;
        byte[] cache;
        int i = 0;
        // 对数据分段解密
        while (inputLen - offSet > 0) {
            if (inputLen - offSet > MAX_DECRYPT_BLOCK) {
                cache = cipher.doFinal(encryptedData, offSet, MAX_DECRYPT_BLOCK);
            } else {
                cache = cipher.doFinal(encryptedData, offSet, inputLen - offSet);
            }
            out.write(cache, 0, cache.length);
            i++;
            offSet = i * MAX_DECRYPT_BLOCK;
        }
        byte[] decryptedData = out.toByteArray();
        out.close();
        return decryptedData;
    }
 
    /** */
    /**
     * <p>
     * 公钥加密
     * </p>
     * 
     * @param data
     *            源数据
     * @param publicKey
     *            公钥(BASE64编码)
     * @return
     * @throws Exception
     */
    public static byte[] encryptByPublicKey(byte[] data, String publicKey) throws Exception {
        byte[] keyBytes = Base64.decodeBase64(publicKey.getBytes());
        X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        Key publicK = keyFactory.generatePublic(x509KeySpec);
        // 对数据加密
        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
        cipher.init(Cipher.ENCRYPT_MODE, publicK);
        int inputLen = data.length;
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        int offSet = 0;
        byte[] cache;
        int i = 0;
        // 对数据分段加密
        while (inputLen - offSet > 0) {
            if (inputLen - offSet > MAX_ENCRYPT_BLOCK) {
                cache = cipher.doFinal(data, offSet, MAX_ENCRYPT_BLOCK);
            } else {
                cache = cipher.doFinal(data, offSet, inputLen - offSet);
            }
            out.write(cache, 0, cache.length);
            i++;
            offSet = i * MAX_ENCRYPT_BLOCK;
        }
        byte[] encryptedData = out.toByteArray();
        out.close();
        return encryptedData;
    }
 
    /** */
    /**
     * <p>
     * 私钥加密
     * </p>
     * 
     * @param data
     *            源数据
     * @param privateKey
     *            私钥(BASE64编码)
     * @return
     * @throws Exception
     */
    public static byte[] encryptByPrivateKey(byte[] data, String privateKey) throws Exception {
        byte[] keyBytes = Base64.decodeBase64(privateKey.getBytes());
        PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        Key privateK = keyFactory.generatePrivate(pkcs8KeySpec);
        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
        cipher.init(Cipher.ENCRYPT_MODE, privateK);
        int inputLen = data.length;
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        int offSet = 0;
        byte[] cache;
        int i = 0;
        // 对数据分段加密
        while (inputLen - offSet > 0) {
            if (inputLen - offSet > MAX_ENCRYPT_BLOCK) {
                cache = cipher.doFinal(data, offSet, MAX_ENCRYPT_BLOCK);
            } else {
                cache = cipher.doFinal(data, offSet, inputLen - offSet);
            }
            out.write(cache, 0, cache.length);
            i++;
            offSet = i * MAX_ENCRYPT_BLOCK;
        }
        byte[] encryptedData = out.toByteArray();
        out.close();
        return encryptedData;
    }
 
    /** */
    /**
     * <p>
     * 获取私钥
     * </p>
     * 
     * @param keyMap
     *            密钥对
     * @return
     * @throws Exception
     */
    public static String getPrivateKey(Map<String, Object> keyMap) throws Exception {
        Key key = (Key) keyMap.get(PRIVATE_KEY);
        return new String(Base64.encodeBase64(key.getEncoded()),CHARSET);
    }
 
    /** */
    /**
     * <p>
     * 获取公钥
     * </p>
     * 
     * @param keyMap
     *            密钥对
     * @return
     * @throws Exception
     */
    public static String getPublicKey(Map<String, Object> keyMap) throws Exception {
        Key key = (Key) keyMap.get(PUBLIC_KEY);
        return new String(Base64.encodeBase64(key.getEncoded()),CHARSET);
    }
 
    /**
     * java端公钥加密
     */
    public static String encryptedDataOnJava(String data, String PUBLICKEY) {
        try {
            data = new String(Base64.encodeBase64(encryptByPublicKey(data.getBytes(),
                    PUBLICKEY)),CHARSET);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            //e.printStackTrace();
            LogCommonFile.error(e);
        }
        return data;
    }
 
    /**
     * java端私钥解密
     */
    public static String decryptDataOnJava(String data, String PRIVATEKEY,String  charset) {
        String temp = "";
        try {
            byte[] rs = Base64.decodeBase64(data.getBytes());
            temp = new String(RSAUtils.decryptByPrivateKey(rs, PRIVATEKEY),charset);
 
        } catch (Exception e) {
            //e.printStackTrace();
            LogCommonFile.error(e);
        }
        return temp;
    }
 
    public static void main(String[] args) throws  Exception{
        Map<String, Object> map = genKeyPair();
        String privatekey = getPrivateKey(map);
        String publickey = getPublicKey(map);
        LogCommonFile.info("private1:"+privatekey);
        LogCommonFile.info("public1:"+publickey);
        String str = "123";
        byte[] data1 = encryptByPublicKey(str.getBytes(),publickey);
        
        
        String s = new String(Base64.encodeBase64(data1),CHARSET);
        
        Map<String, Object> map1 = genKeyPair();
        String privatekey1 = getPrivateKey(map1);
        String publickey1 = getPublicKey(map1);
        LogCommonFile.info("private2:"+privatekey1);
        LogCommonFile.info("public2:"+publickey1);
        
        String ss = sign(data1,privatekey1);
        
        LogCommonFile.info(s);
        s = decryptDataOnJava(s,privatekey,CHARSET);
        boolean issgin = verify(data1,publickey1,ss);
        //LogCommonFile.info(issgi);
        LogCommonFile.info(s);
        
        String requestData = "{requestData:}";
    }
    
    public static String easpString(String requestData){
        if(requestData != null && !requestData.equals("")){
            String s = "{\"requestData\":";
            if(!requestData.startsWith(s)){
                throw new RuntimeException("参数【requestData】缺失异常！");
            }else{
                int closeLen = requestData.length()-1;
                int openLen = "{\"requestData\":".length();
                String substring = StringUtils.substring(requestData, openLen, closeLen);
                return substring;
            }
        }
        return "";
    }

}

```
