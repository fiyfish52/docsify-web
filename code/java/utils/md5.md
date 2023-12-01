# MD5

```java
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/** 
 * MD5编码工具类
 */  
public class MD5 {
    private static char[] chars = new char[] { '0', '1', '2', '3', '4', '5','6', '7' , '8', '9', 'A', 'B', 'C', 'D', 'E','F' };
    public static byte[] encode(byte[] data) {
        byte[] digest = new byte[0];
        try {
            MessageDigest md5 = MessageDigest.getInstance("md5");
            digest = md5.digest(data);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return digest;
    }

  
    public static String decodeHex(String s) {
        StringBuffer sb = new StringBuffer();
        byte[] digest = encode(s.getBytes());
        for (byte bb : digest) {
            sb.append(chars[(bb >> 4) & 15]);
            sb.append(chars[bb & 15]);
        }
        return sb.toString();
    }  
  

} 
```
