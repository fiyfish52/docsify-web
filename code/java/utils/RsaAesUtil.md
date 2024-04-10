# RSA + AES

## 应用

?> RSA 和 AES 的结合常常被用于实现一种安全的数据传输和存储方案。 一般而言，RSA 负责密钥的安全传递，而 AES 负责实际数据的加解密。


## 说明 
````vim
这个示例中，首先生成了一个 RSA 密钥对和一个 AES 密钥。
然后使用 RSA 公钥加密 AES 密钥，以安全地传递给接收方。
接着，使用 AES 密钥加密实际的数据。
在接收方，使用 RSA 私钥解密 AES 密钥，再使用解密后的 AES 密钥解密数据。
这样，RSA 负责密钥的安全传递，而 AES 负责实际数据的加解密。
请注意，实际应用中，密钥的生成、传递和存储需要更加谨慎，特别是在生产环境中。
````

## 示例

````java
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.Base64;

public class RSA_AESExample {

    public static void main(String[] args) {
        try {
            // 生成 RSA 密钥对
            KeyPair keyPair = generateRSAKeyPair();

            // 生成 AES 密钥
            SecretKey secretKey = generateAESKey();

            // 假设要加密的数据
            String originalData = "Hello, RSA + AES!";

            // 使用 RSA 公钥加密 AES 密钥
            byte[] encryptedAESKey = encryptRSA(secretKey.getEncoded(), keyPair.getPublic());

            // 使用 AES 密钥加密数据
            String encryptedData = encryptAES(originalData, secretKey);

            System.out.println("Original Data: " + originalData);
            System.out.println("Encrypted Data: " + encryptedData);

            // 使用 RSA 私钥解密 AES 密钥
            byte[] decryptedAESKey = decryptRSA(encryptedAESKey, keyPair.getPrivate());

            // 使用 AES 密钥解密数据
            String decryptedData = decryptAES(encryptedData, decryptedAESKey);

            System.out.println("Decrypted Data: " + decryptedData);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 生成 RSA 密钥对
    private static KeyPair generateRSAKeyPair() throws Exception {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(2048);
        return keyPairGenerator.generateKeyPair();
    }

    // 生成 AES 密钥
    private static SecretKey generateAESKey() throws Exception {
        KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
        keyGenerator.init(128);
        return keyGenerator.generateKey();
    }

    // 使用 RSA 公钥加密
    private static byte[] encryptRSA(byte[] data, PublicKey publicKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        return cipher.doFinal(data);
    }

    // 使用 RSA 私钥解密
    private static byte[] decryptRSA(byte[] data, PrivateKey privateKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        return cipher.doFinal(data);
    }

    // 使用 AES 密钥加密
    private static String encryptAES(String data, SecretKey secretKey) throws Exception {
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);
        byte[] encryptedBytes = cipher.doFinal(data.getBytes());
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    // 使用 AES 密钥解密
    private static String decryptAES(String encryptedData, byte[] secretKey) throws Exception {
        Cipher cipher = Cipher.getInstance("AES");
        SecretKey aesKey = new SecretKeySpec(secretKey, "AES");
        cipher.init(Cipher.DECRYPT_MODE, aesKey);
        byte[] decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedData));
        return new String(decryptedBytes);
    }
}

````
