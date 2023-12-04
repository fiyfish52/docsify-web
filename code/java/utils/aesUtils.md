# AES

## jdk1.6

```java

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.nio.charset.Charset;
import java.security.Permission;
import java.security.SecureRandom;

public class GWAesUtils {
    private static final Log log = LogFactory.getLog(GWAesUtils.class);
    public static final String VI_16 = "0123456789ABEDEF";
    public static final int NUM_16 = 16;
    public static final int NUM_32 = 32;

    static {
        try {
            addCryptoPermission();
        } catch (Exception ex) {
            log.error("初始化Crypto-AES权限失败", ex);
        }
    }

    public GWAesUtils() {
    }

    public static class Base64Utils {
        private static final Charset DEFAULT_CHARSET;

        public Base64Utils() {
        }

        public static byte[] encode(byte[] src) {
            return src.length == 0 ? src : Base64.getEncoder().encode(src);
        }

        public static byte[] decode(byte[] src) {
            return src.length == 0 ? src : Base64.getDecoder().decode(src);
        }

        public static byte[] encodeUrlSafe(byte[] src) {
            return src.length == 0 ? src : Base64.getUrlEncoder().encode(src);
        }

        public static byte[] decodeUrlSafe(byte[] src) {
            return src.length == 0 ? src : Base64.getUrlDecoder().decode(src);
        }

        public static String encodeToString(byte[] src) {
            return src.length == 0 ? "" : new String(encode(src), DEFAULT_CHARSET);
        }

        public static byte[] decodeFromString(String src) {
            return src.isEmpty() ? new byte[0] : decode(src.getBytes(DEFAULT_CHARSET));
        }

        public static String encodeToUrlSafeString(byte[] src) {
            return new String(encodeUrlSafe(src), DEFAULT_CHARSET);
        }

        public static byte[] decodeFromUrlSafeString(String src) {
            return decodeUrlSafe(src.getBytes(DEFAULT_CHARSET));
        }

        static {
            DEFAULT_CHARSET = Charset.forName("UTF-8");
        }
    }

    public static String encryptEcbToStr(String key, String text) {
        byte[] keyRaw = initKeyWithPadding(key);
        byte[] textRaw = getBytes(text);
        byte[] result = encryptEcb(keyRaw, textRaw);
        return Base64Utils.encodeToString(result);
    }

    public static String encryptEcbToStr(String key, byte[] text) {
        byte[] keyRaw = initKeyWithPadding(key);
        byte[] result = encryptEcb(keyRaw, text);
        return Base64Utils.encodeToString(result);
    }

    public static byte[] encryptEcb(String key, String text) {
        byte[] keyRaw = initKeyWithPadding(key);
        byte[] textRaw = getBytes(text);
        return encryptEcb(keyRaw, textRaw);
    }

    public static byte[] encryptEcb(String key, byte[] text) {
        byte[] keyRaw = initKeyWithPadding(key);
        return encryptEcb(keyRaw, text);
    }

    public static byte[] encryptEcb(byte[] key, byte[] text) {
        try {
            SecretKeySpec skeySpec = new SecretKeySpec(key, "AES");
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(1, skeySpec);
            return cipher.doFinal(text);
        } catch (Exception var4) {
            return null;
        }
    }

    public static String decryptEcbToStr(String key, String text) {
        try {
            byte[] keyRaw = initKeyWithPadding(key);
            byte[] textRaw = Base64Utils.decodeFromString(text);
            byte[] result = decryptEcb(keyRaw, textRaw);
            return toString(result);
        } catch (Exception var5) {
            return null;
        }
    }

    public static String decryptEcbToStr(String key, byte[] text) {
        byte[] keyRaw = initKeyWithPadding(key);
        byte[] result = decryptEcb(keyRaw, text);
        return toString(result);
    }

    public static byte[] decryptEcb(String key, String text) {
        try {
            byte[] keyRaw = initKeyWithPadding(key);
            byte[] textRaw = Base64Utils.decodeFromString(text);
            return decryptEcb(keyRaw, textRaw);
        } catch (Exception var4) {
            return null;
        }
    }

    public static byte[] decryptEcb(String key, byte[] text) {
        byte[] keyRaw = initKeyWithPadding(key);
        return decryptEcb(keyRaw, text);
    }

    public static byte[] decryptEcb(byte[] key, byte[] text) {
        try {
            SecretKeySpec skeySpec = new SecretKeySpec(key, "AES");
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(2, skeySpec);
            return cipher.doFinal(text);
        } catch (Exception var4) {
            return null;
        }
    }

    public static String encryptCbcToStr(String key, String text) {
        byte[] keyRaw = initKeyWithPadding(key);
        byte[] textRaw = getBytes(text);
        byte[] result = encryptCbc(keyRaw, textRaw);
        return Base64Utils.encodeToString(result);
    }

    public static String encryptCbcToStr(String key, byte[] text) {
        byte[] keyRaw = initKeyWithPadding(key);
        byte[] result = encryptCbc(keyRaw, text);
        return Base64Utils.encodeToString(result);
    }

    public static byte[] encryptCbc(String key, String text) {
        byte[] keyRaw = initKeyWithPadding(key);
        byte[] textRaw = getBytes(text);
        return encryptCbc(keyRaw, textRaw);
    }

    public static byte[] encryptCbc(String key, byte[] text) {
        byte[] keyRaw = initKeyWithPadding(key);
        return encryptCbc(keyRaw, text);
    }

    public static byte[] encryptCbc(byte[] key, byte[] text) {
        return encryptCbc(key, text, "0123456789ABEDEF".getBytes(Base64Utils.DEFAULT_CHARSET));
    }

    public static byte[] encryptCbc(byte[] key, byte[] text, byte[] vi) {
        try {
            SecretKeySpec skeySpec = new SecretKeySpec(key, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            IvParameterSpec ips = new IvParameterSpec(vi);
            cipher.init(1, skeySpec, ips);
            return cipher.doFinal(text);
        } catch (Exception var6) {
           System.out.println(var6);
           return null;
        }
    }

    public static String decryptCbcToStr(String key, String text) {
        try {
            byte[] keyRaw = initKeyWithPadding(key);
            byte[] textRaw = Base64Utils.decodeFromString(text);
            byte[] result = decryptCbc(keyRaw, textRaw);
            return toString(result);
        } catch (Exception var5) {
            return null;
        }
    }

    public static String decryptCbcToStr(String key, byte[] text) {
        byte[] keyRaw = initKeyWithPadding(key);
        byte[] result = decryptCbc(keyRaw, text);
        return toString(result);
    }

    public static byte[] decryptCbc(String key, String text) {
        try {
            byte[] keyRaw = initKeyWithPadding(key);
            byte[] textRaw = Base64Utils.decodeFromString(text);
            return decryptCbc(keyRaw, textRaw);
        } catch (Exception var4) {
            return null;
        }
    }

    public static byte[] decryptCbc(String key, byte[] text) {
        byte[] keyRaw = initKeyWithPadding(key);
        return decryptCbc(keyRaw, text);
    }

    public static byte[] decryptCbc(byte[] key, byte[] text) {
        return decryptCbc(key, text, "0123456789ABEDEF".getBytes(Base64Utils.DEFAULT_CHARSET));
    }

    public static byte[] decryptCbc(byte[] key, byte[] text, byte[] vi) {
        try {
            SecretKeySpec skeySpec = new SecretKeySpec(key, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            IvParameterSpec ips = new IvParameterSpec(vi);
            cipher.init(2, skeySpec, ips);
            return cipher.doFinal(text);
        } catch (Exception var6) {
            return null;
        }
    }

    private static SecretKeySpec getSecretKey(byte[] password) throws Exception {
        KeyGenerator kg = null;
        kg = KeyGenerator.getInstance("AES");
        SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG");
        secureRandom.setSeed(password);
        kg.init(256, secureRandom);
        SecretKey secretKey = kg.generateKey();
        return new SecretKeySpec(secretKey.getEncoded(), "AES");
    }

    public static byte[] initKeyWithPadding(String password) {
        byte[] bytes = password.getBytes();
        byte[] result = null;
        if (password.length() < 16) {
            result = new byte[16];
            System.arraycopy(bytes, 0, result, 0, bytes.length);
        } else if (password.length() == 16) {
            result = password.getBytes(Base64Utils.DEFAULT_CHARSET);
        } else if (password.length() < 32) {
            result = new byte[32];
            System.arraycopy(bytes, 0, result, 0, bytes.length);
        } else {
            result = password.substring(0, 32).getBytes(Base64Utils.DEFAULT_CHARSET);
        }

        return result;
    }

    public static String toString(byte[] bytes) {
        try {
            return new String(bytes, "UTF-8");
        } catch (UnsupportedEncodingException var2) {
            return "";
        }
    }

    public static byte[] getBytes(String str) {
        if (str != null) {
            try {
                return str.getBytes("UTF-8");
            } catch (UnsupportedEncodingException var2) {
                return null;
            }
        } else {
            return null;
        }
    }

    /*    
        private static void ensureAESMaxAllowedKeyLength(Cipher cipher, int keyLength) throws Exception {
            if (Cipher.getMaxAllowedKeyLength("AES") < keyLength * 8) {
                changeAESMaxAllowedKeyLength(cipher);
            }
        }
    
        private static void changeAESMaxAllowedKeyLength(Cipher cipher) {
            try {
                String fieldName;
                String permissionClassName;
                // jdk1.5
                Method getConfiguredPermissionM = ReflectionUtils.findMethod(Cipher.class, "c", new Class[]{String.class});
                if (null != getConfiguredPermissionM) {
                    fieldName = "b";
                    permissionClassName = "javax.crypto.SunJCE_f";
                } else {
                    // jdk1.7及之后版本
                    fieldName = "maxKeySize";
                    permissionClassName = "javax.crypto.CryptoPermission";
                    getConfiguredPermissionM = ReflectionUtils.findMethod(Cipher.class, "getConfiguredPermission", new Class[]{String.class});
                }
                getConfiguredPermissionM.setAccessible(true);
                Object configurePermission = getConfiguredPermissionM.invoke(cipher, "AES");
                Class<?> CryptoPermissionClass = Class.forName(permissionClassName);
                Field maxKeySizeField = ReflectionUtils.findField(CryptoPermissionClass, fieldName);
                maxKeySizeField.setAccessible(true);
                ReflectionUtils.setField(maxKeySizeField, configurePermission, 2147483647);
                getConfiguredPermissionM.setAccessible(false);
                maxKeySizeField.setAccessible(false);
            } catch (Exception ex) {
            }
        }
    */

    private static void addCryptoPermission() throws Exception {
        final String version = System.getProperty("java.version");
        if (StringUtils.isNotBlank(version) && (version.startsWith("1.6") || version.startsWith("1.7"))) {
            String managerClassName;
            String policyFieldName;
            String permissionClassName;
            String methodName;
            if (version.startsWith("1.6")) {
                managerClassName = "javax.crypto.SunJCE_h";
                policyFieldName = "a";
                permissionClassName = "javax.crypto.SunJCE_f";
                methodName = "add";
            } else {
                managerClassName = "javax.crypto.JceSecurityManager";
                policyFieldName = "defaultPolicy";
                permissionClassName = "javax.crypto.CryptoPermission";
                methodName = "add";
            }
            Class<?> securityManagerClass = Class.forName(managerClassName);
            Field defaultPolicy = securityManagerClass.getDeclaredField(policyFieldName);
            defaultPolicy.setAccessible(true);
            Object defaultPolicyInstance = defaultPolicy.get(null);
            Class<?> permissionClass = Class.forName(permissionClassName);
            Constructor<?> permissionConstructor = permissionClass.getDeclaredConstructor(String.class, int.class);
            permissionConstructor.setAccessible(true);
            Object aesPermission = permissionConstructor.newInstance("AES", 2147483647);
            Method addMethod = defaultPolicyInstance.getClass().getMethod(methodName, Permission.class);
            addMethod.setAccessible(true);
            addMethod.invoke(defaultPolicyInstance, aesPermission);

            defaultPolicy.setAccessible(false);
            permissionConstructor.setAccessible(false);
            addMethod.setAccessible(false);
        }
    }
    
    /**
     * Convert hex string to byte[]
     *
     * @param hexString the hex string
     * @return byte[]
     */
    public static byte[] hexStringToBytes(String hexString) {
        if (hexString == null || hexString.equals("")) {
            return null;
        }
        hexString = hexString.toUpperCase();
        int length = hexString.length() / 2;
        char[] hexChars = hexString.toCharArray();
        byte[] d = new byte[length];
        for (int i = 0; i < length; i++) {
            int pos = i * 2;
            d[i] = (byte) (charToByte(hexChars[pos]) << 4 | charToByte(hexChars[pos + 1]));
        }
        return d;
    }
    /**
     * Convert char to byte
     *
     * @param c char
     * @return byte
     */
    private static byte charToByte(char c) {
        return (byte) "0123456789ABCDEF".indexOf(c);
    }

    public static void main(String[] args) throws Exception {

//        long length = Cipher.getMaxAllowedKeyLength("AES");
//        System.out.println("maxKeyLengthOfCrypto:" + length);

        String s1 = "hello";
        String password = "12345678901234567890123456789000";
        System.out.println(encryptEcbToStr(password, s1));
        System.out.println(decryptEcbToStr(password, "53EH50UdzUWEPaREAYnmZw=="));
        System.out.println(decryptEcbToStr(password, "HBi4SUIR6eUyn7YClJt116A2MrGFkqFNluiCT9w+0lo="));

        //  String s2 = "hello";
        //  String password2 = "1234567890123456";
        //  System.out.println(encryptCbcToStr(password2, s2));
        //  System.out.println(decryptCbcToStr(password2, encryptCbcToStr(password2, s2)));
    }
}

```

## other latest

### AESUtils

```java
package com.maywide.oss.utils.aes;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.Security;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

/** 
* @author : Mr.zhang
* @date ：2023年11月30日 下午5:29:52 
* 
*/
public class AESUtils {
    public static final String CHARSET = "UTF-8";
    private static byte[] encryptOrDecrypt(int mode,byte[] byteContent, String key,byte[] iv, AESType type, String modeAndPadding) throws InvalidKeyException, NoSuchAlgorithmException, InvalidAlgorithmParameterException, NoSuchPaddingException, BadPaddingException, IllegalBlockSizeException {
        
//        Security.addProvider(new BouncyCastleProvider());
        KeyGenerator kgen = KeyGenerator.getInstance("AES");
        //此处解决mac，linux报错
        SecureRandom random = SecureRandom.getInstance("SHA1PRNG");
        random.setSeed(key.getBytes());
        kgen.init(type.value, random);
        SecretKey secretKey = kgen.generateKey();
        byte[] enCodeFormat = secretKey.getEncoded();
        SecretKeySpec keySpec = new SecretKeySpec(enCodeFormat, "AES");
        Cipher cipher = Cipher.getInstance(modeAndPadding);// 创建密码器
        if ( null !=iv ) {
            //指定一个初始化向量 (Initialization vector，IV)， IV 必须是16位
            cipher.init(mode, keySpec, new IvParameterSpec(iv));
        } else {
            cipher.init(mode, keySpec);
        }
        byte[] result = cipher.doFinal(byteContent);
        return result;
    }
    public static void main(String[] args) throws Exception {
//        System.out.println("【1】AES不指定模式和填充，默认为 ECB/PKCS5Padding，输入可以不是16字节，也不需要填充向量\n");
//        // 需要加密的内容
//        String content = "在线助手";
//        // 生成密钥需要的密码值
//        String key = "www.it399.com111";
//        System.out.println("content： " + content + "\nkey： " + key);
//        byte[] encodeByte;
//        byte[] decodeByte;
//        //默认方式  每次加密都不一样，但是秘钥是一样的，所以解密还是一样的
//        // 内容加密后的值
//        encodeByte = encrypt(content.getBytes(CHARSET), key, AESType.AES_128, EncodeType.AES_DEFAULT);
//        String encodeStr = TypeConvert.bytesToHexString(encodeByte);
//        // 被加密的内容解密后的值
//        decodeByte = decrypt(encodeByte, key, AESType.AES_128, EncodeType.AES_DEFAULT);
//        String decodeStr = new String(decodeByte,CHARSET);
//        System.out.println("encode： " + encodeStr + "\ndecode： " + decodeStr);
//
//
//        System.out.println("【2】AES_CBC_NoPadding模式，输入必须是16*n字节，需要填充向量\n");
//        // 内容加密后的值
//        //待加密内容不足16*n位 报错javax.crypto.IllegalBlockSizeException: Input length not multiple of 16 bytes
//        //需要填充向量，不然报错java.security.InvalidKeyException: Parameters missing
//        //得到加密后的内容先base64编码再解码再传给解码，不然直接转回乱码
//        content = "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
//        encodeByte = encrypt(content.getBytes(CHARSET), key, AESType.AES_256, EncodeType.AES_CBC_NoPadding);
//        encodeStr = TypeConvert.bytesToHexString(encodeByte);
//        decodeByte = decrypt(TypeConvert.hexStringToBytes(encodeStr), key, AESType.AES_256, EncodeType.AES_CBC_NoPadding);
//        decodeStr = new String(decodeByte,CHARSET);
//        System.out.println("encode： " + encodeStr + "\ndecode： " + decodeStr);
        String content = "在线助手";
        // 生成密钥需要的密码值
        String key = "9109748D8AAB2D4C90FB86984C52A84CFED94F72DFF491FC290E5C09690DAB9E";
        byte[] encrypt;
        /**
         * AES加密方式一:AES不指定模式和填充，默认为 ECB/PKCS5Padding
         */
//        System.out.println("【0】AES不指定模式和填充，默认为 ECB/PKCS5Padding，输入可以不是16字节，也不需要填充向量\n");
//        //128
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_128,EncodeType.AES_DEFAULT);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_128,EncodeType.AES_DEFAULT);
//        //192
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_192,EncodeType.AES_DEFAULT);
//        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_192,EncodeType.AES_DEFAULT);
//        //256
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_256,EncodeType.AES_DEFAULT);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_256,EncodeType.AES_DEFAULT);
//        /**
//         * 1.1 AES/CBC （需要填充向量16*n）
//         * AES/CBC/NoPadding
//         * AES/CBC/PKCS5Padding
//         * AES/CBC/ISO10126Padding
//         */
//        System.out.println("【1.1】AES_CBC_NoPadding模式，需要填充向量,待加密必须是16*n");
//        content = "在线助手在线助手在线助手在线助手";
//        key = "www.it399.com";
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_128,EncodeType.AES_CBC_NoPadding);
//        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_128,EncodeType.AES_CBC_NoPadding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_192,EncodeType.AES_CBC_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_192,EncodeType.AES_CBC_PKCS5Padding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_256,EncodeType.AES_CBC_ISO10126Padding);
//        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_256,EncodeType.AES_CBC_ISO10126Padding);
//        /**
//         * 1.2 AES/CFB
//         * AES/CBC/NoPadding
//         * AES/CBC/PKCS5Padding
//         * AES/CBC/ISO10126Padding
//         */
//        System.out.println("【1.2】AES_CFB_NoPadding模式\n");
//        content = "在线助手";
//        // 生成密钥需要的密码值
//        key = "https://www.it399.com";
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_128,EncodeType.AES_CFB_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_128,EncodeType.AES_CFB_PKCS5Padding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_192,EncodeType.AES_CFB_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_192,EncodeType.AES_CFB_PKCS5Padding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_256,EncodeType.AES_CFB_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_256,EncodeType.AES_CFB_PKCS5Padding);
//        /**
//         * 1.2 AES/ECB
//         * AES/ECB/NoPadding
//         * AES/ECB/PKCS5Padding
//         * AES/ECB/ISO10126Padding
//         */
//        System.out.println("【1.3】AES_ECB模式");
//        content = "在线助手";
//        // 生成密钥需要的密码值
//        key = "https://www.it399.com";
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_128,EncodeType.AES_ECB_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_128,EncodeType.AES_ECB_PKCS5Padding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_192,EncodeType.AES_ECB_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_192,EncodeType.AES_ECB_PKCS5Padding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_256,EncodeType.AES_ECB_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_256,EncodeType.AES_ECB_PKCS5Padding);
        /**
         * 1.4 AES/OFB
         * AES/OFB/NoPadding
         * AES/OFB/PKCS5Padding
         * AES/OFB/ISO10126Padding
         */
        System.out.println("【1.4】AES_OFB模式");
        content = "在线助手";
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_128,EncodeType.AES_OFB_PKCS5Padding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_128,EncodeType.AES_OFB_PKCS5Padding);
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_192,EncodeType.AES_OFB_PKCS5Padding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_192,EncodeType.AES_OFB_PKCS5Padding);
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_256,EncodeType.AES_OFB_PKCS5Padding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_256,EncodeType.AES_OFB_PKCS5Padding);
        /**
         * 1.5 AES/PCBC
         * AES/PCBC/NoPadding
         * AES/PCBC/PKCS5Padding
         * AES/PCBC/ISO10126Padding
         */
        System.out.println("【1.5】AES_PCBC模式");
        content = "在线助手";
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_128,EncodeType.AES_PCBC_PKCS5Padding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_128,EncodeType.AES_PCBC_PKCS5Padding);
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_192,EncodeType.AES_PCBC_PKCS5Padding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_192,EncodeType.AES_PCBC_PKCS5Padding);
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_256,EncodeType.AES_PCBC_PKCS5Padding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_256,EncodeType.AES_PCBC_PKCS5Padding);
        //
//        /**1.3 AES/CBC
//         * AES_CBC_NoPadding模式（填充向量可选）
//         */
        System.out.println("【1.3】AES_CBC_NoPadding模式");
        content = "在线助手在线助手在线助手在线助手";
        // 生成密钥需要的密码值
//        key = "www.it399.com";
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_128,EncodeType.AES_CBC_NoPadding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_128,EncodeType.AES_CBC_NoPadding);
        content = "你好你好";
        // 生成密钥需要的密码值
//        key = "www.it399.com";
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_192,EncodeType.AES_CBC_PKCS5Padding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_192,EncodeType.AES_CBC_PKCS5Padding);
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_256,EncodeType.AES_CBC_ISO10126Padding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_256,EncodeType.AES_CBC_ISO10126Padding);
        
        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,getIV(),AESType.AES_256,EncodeType.AES_CBC_PKCS5Padding);
        encryptOrdecrypt(false,encrypt,key,getIV(),AESType.AES_256,EncodeType.AES_CBC_PKCS5Padding);
//
//
//
//        /**
//         * 2.1 AES/CFB 128/192/256位加解密
//         * AES_CFB_NoPadding模式（填充向量可选）
//         */
//        System.out.println("【2.1】AES_CFB_NoPadding模式，需要填充向量\n");
//        content = "在线助手";
//        // 生成密钥需要的密码值
//        key = "www.it399.com";
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_128,EncodeType.AES_CFB_NoPadding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_128,EncodeType.AES_CFB_NoPadding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_192,EncodeType.AES_CFB_NoPadding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_192,EncodeType.AES_CFB_NoPadding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_256,EncodeType.AES_CFB_NoPadding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_256,EncodeType.AES_CFB_NoPadding);
//
//        /**
//         * 2.2 AES/CFB
//         * AES_CFB_NoPadding模式（填充向量可选）
//         */
//        System.out.println("【2.2】AES_CFB_NoPadding模式\n");
//        content = "在线助手";
//        // 生成密钥需要的密码值
//        key = "www.it399.com";
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_128,EncodeType.AES_CFB_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_128,EncodeType.AES_CFB_PKCS5Padding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_192,EncodeType.AES_CFB_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_192,EncodeType.AES_CFB_PKCS5Padding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_256,EncodeType.AES_CFB_PKCS5Padding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_256,EncodeType.AES_CFB_PKCS5Padding);
//
//        /**2.3 AES/CFB
//         * AES_CFB_NoPadding模式（填充向量可选）
//         */
//        System.out.println("【2.3】AES_CFB_NoPadding模式\n");
//        content = "在线助手";
//        // 生成密钥需要的密码值
//        key = "www.it399.com";
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_128,EncodeType.AES_CFB_ISO10126Padding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_128,EncodeType.AES_CFB_ISO10126Padding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_192,EncodeType.AES_CFB_ISO10126Padding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_192,EncodeType.AES_CFB_ISO10126Padding);
//        encrypt = encryptOrdecrypt(true,content.getBytes(CHARSET),key,null,AESType.AES_256,EncodeType.AES_CFB_ISO10126Padding);
//        encryptOrdecrypt(false,encrypt,key,null,AESType.AES_256,EncodeType.AES_CFB_ISO10126Padding);
    }
    /**
     *
     * @param isEncrypt
     * @param source
     * @param key
     * @param type
     * @param encodeType
     */
    public static byte[] encryptOrdecrypt(boolean isEncrypt,byte[] source,String key,String ivStr,AESType type,String encodeType) throws UnsupportedEncodingException, InvalidAlgorithmParameterException, NoSuchAlgorithmException, NoSuchPaddingException, BadPaddingException, IllegalBlockSizeException, InvalidKeyException {
        
        byte[]  iv = TypeConvert.hexStringToBytes(ivStr);
        if (isEncrypt){
            byte[] encodeByte = encryptOrDecrypt(Cipher.ENCRYPT_MODE,source,key,iv,type,encodeType);
            String encodeStr = TypeConvert.bytesToHexString(encodeByte);
//            System.out.println(encodeStr);
            
            return encodeByte;
        }else{
            
            byte[] decodeByte = encryptOrDecrypt(Cipher.DECRYPT_MODE,source, key,iv,type, encodeType);
            String decodeStr = new String(decodeByte,CHARSET);
//            System.out.println(decodeStr);
            return decodeByte;
        }
    }
    /**
     * 指定一个初始化向量 (Initialization vector，IV)，IV 必须是16位
     */
    public static final String getIV() throws Exception {
        return "2F320E026EACFAC0B95006359E6D5669";
//        return "1234567812345678".getBytes(CHARSET);
    }
    public static final byte[] getIVByte() throws Exception {
        return TypeConvert.hexStringToBytes("2F320E026EACFAC0B95006359E6D5669");
//        return "1234567812345678".getBytes(CHARSET);
    }
}
```

### AESType

```java
public enum AESType {
    AES_128(128), AES_192(192), AES_256(256);
    public int value;
    private AESType(int value) {
        this.value = value;
    }
    public int getValue() {
        return value;
    }
    public void setValue(int value) {
        this.value = value;
    }
}

```

### EncodeType

```java
package com.maywide.oss.utils.aes;
/** 
* @author : Mr.zhang
* @date ：2023年11月30日 下午5:30:47 
* 
*/
public class EncodeType {
//  算法/模式/填充                 16字节加密后数据长度       不满16字节加密后长度
//  AES/CBC/NoPadding                   16                          不支持
//  AES/CBC/PKCS5Padding                32                          16
//  AES/CBC/ISO10126Padding             32                          16
//  AES/CFB/NoPadding                   16                          原始数据长度
//  AES/CFB/PKCS5Padding                32                          16
//  AES/CFB/ISO10126Padding             32                          16
//  AES/ECB/NoPadding                   16                          不支持
//  AES/ECB/PKCS5Padding                32                          16
//  AES/ECB/ISO10126Padding             32                          16
//  AES/OFB/NoPadding                   16                          原始数据长度
//  AES/OFB/PKCS5Padding                32                          16
//  AES/OFB/ISO10126Padding             32                          16
//  AES/PCBC/NoPadding                  16                          不支持
//  AES/PCBC/PKCS5Padding               32                          16
//  AES/PCBC/ISO10126Padding            32                          16
  //默认为 ECB/PKCS5Padding
  public final static String AES_DEFAULT = "AES";
  public final static String AES_CBC_NoPadding = "AES/CBC/NoPadding";
  public final static String AES_CBC_PKCS5Padding = "AES/CBC/PKCS5Padding";
  public final static String AES_CBC_PKCS7Padding = "AES/CBC/PKCS7Padding";
  public final static String AES_CBC_ISO10126Padding = "AES/CBC/ISO10126Padding";
  public final static String AES_CFB_NoPadding = "AES/CFB/NoPadding";
  public final static String AES_CFB_PKCS5Padding = "AES/CFB/PKCS5Padding";
  public final static String AES_CFB_ISO10126Padding = "AES/CFB/ISO10126Padding";
  public final static String AES_ECB_NoPadding = "AES/ECB/NoPadding";
  public final static String AES_ECB_PKCS5Padding = "AES/ECB/PKCS5Padding";
  public final static String AES_ECB_ISO10126Padding = "AES/ECB/ISO10126Padding";
  public final static String AES_OFB_NoPadding = "AES/OFB/NoPadding";
  public final static String AES_OFB_PKCS5Padding = "AES/OFB/PKCS5Padding";
  public final static String AES_OFB_ISO10126Padding = "AES/OFB/ISO10126Padding";
  public final static String AES_PCBC_NoPadding = "AES/PCBC/NoPadding";
  public final static String AES_PCBC_PKCS5Padding = "AES/PCBC/PKCS5Padding";
  public final static String AES_PCBC_ISO10126Padding = "AES/PCBC/ISO10126Padding";
}

```

### TypeConvert

```java
package com.maywide.oss.utils.aes;

import javax.xml.bind.DatatypeConverter;

/** 
* @author : Mr.zhang
* @date ：2023年11月30日 下午5:31:19 
* 
*/
public class TypeConvert {
    /**
     * 字符串转换成十六进制字符串
     */
    public static String str2HexStr(String str) {
        char[] chars = "0123456789ABCDEF".toCharArray();
        StringBuilder sb = new StringBuilder("");
        byte[] bs = str.getBytes();
        int bit;
        for (int i = 0; i < bs.length; i++) {
            bit = (bs[i] & 0x0f0) >> 4;
            sb.append(chars[bit]);
            bit = bs[i] & 0x0f;
            sb.append(chars[bit]);
        }
        return sb.toString();
    }
    /**
     * Convert hex string to byte[]
     *
     * @param hexString the hex string
     * @return byte[]
     */
    public static byte[] hexStringToBytes(String hexString) {
        if (hexString == null || hexString.equals("")) {
            return null;
        }
        hexString = hexString.toUpperCase();
        int length = hexString.length() / 2;
        char[] hexChars = hexString.toCharArray();
        byte[] d = new byte[length];
        for (int i = 0; i < length; i++) {
            int pos = i * 2;
            d[i] = (byte) (charToByte(hexChars[pos]) << 4 | charToByte(hexChars[pos + 1]));
        }
        return d;
    }
    /**
     * Convert char to byte
     *
     * @param c char
     * @return byte
     */
    private static byte charToByte(char c) {
        return (byte) "0123456789ABCDEF".indexOf(c);
    }
    /**
     * 数组转换成十六进制字符串
     * @param bArray byte[]
     * @return HexString
     */
    public static final String bytesToHexString(byte[] bArray) {
        if (bArray == null || bArray.length==0){
            return null;
        }
        StringBuffer sb = new StringBuffer(bArray.length);
        String sTemp;
        for (int i = 0; i < bArray.length; i++) {
            sTemp = Integer.toHexString(0xFF & bArray[i]);
            if (sTemp.length() < 2){
                sb.append(0);
            }
            sb.append(sTemp.toUpperCase());
        }
        return sb.toString();
    }
    /**
     * 十六进制字符串转换成字符串
     * @param hexStr
     * @return String
     */
    public static String hexStr2Str(String hexStr) {
        String str = "0123456789ABCDEF";
        char[] hexs = hexStr.toCharArray();
        byte[] bytes = new byte[hexStr.length() / 2];
        int n;
        for (int i = 0; i < bytes.length; i++) {
            n = str.indexOf(hexs[2 * i]) * 16;
            n += str.indexOf(hexs[2 * i + 1]);
            bytes[i] = (byte) (n & 0xff);
        }
        return new String(bytes);
    }
    /**
     * @param hexString String str = "000AB"
     * @return
     */
    public static int hexString2Int(String hexString){
        Integer num = Integer.valueOf(hexString,16);
        return num;
    }
    /**
     * 把byte转为字符串的bit
     */
    public static String byteToBitString(byte b) {
        return ""
                + (byte) ((b >> 7) & 0x1) + (byte) ((b >> 6) & 0x1)
                + (byte) ((b >> 5) & 0x1) + (byte) ((b >> 4) & 0x1)
                + (byte) ((b >> 3) & 0x1) + (byte) ((b >> 2) & 0x1)
                + (byte) ((b >> 1) & 0x1) + (byte) ((b >> 0) & 0x1);
    }
    /**
     * 把byte转为字符串数组的bit
     */
    public static String[] byteToBitStrings(byte b) {
        String[] bit = new String[8];
        bit[0] = ""+ (byte) ((b >> 7) & 0x1);
        bit[1] = ""+ (byte) ((b >> 6) & 0x1);
        bit[2] = ""+ (byte) ((b >> 5) & 0x1);
        bit[3] = ""+ (byte) ((b >> 4) & 0x1);
        bit[4] = ""+ (byte) ((b >> 3) & 0x1);
        bit[5] = ""+ (byte) ((b >> 2) & 0x1);
        bit[6] = ""+ (byte) ((b >> 1) & 0x1);
        bit[7] = ""+ (byte) ((b >> 0) & 0x1);
        return bit;
    }
    public static void main(String[] args){
        String hexString = "3A60432A5C01211F291E0F4E0C132825";
        byte[] result = hexStringToBytes(hexString);
        System.out.println(new String(result));
        System.out.println(bytesToHexString(result));
    }
    //base64字符串转byte[]
    public static byte[] base64String2ByteFun(String base64Str){
        return DatatypeConverter.parseBase64Binary(base64Str);
//        return Base64.decodeBase64(base64Str);
    }
    //byte[]转base64
    public static String byte2Base64StringFun(byte[] b){
        return DatatypeConverter.printBase64Binary(b);
//        return Base64.encodeBase64String(b);
    }
}

```