# imgUtils

```java
package com.maywide.oss.utils.img;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.xml.bind.DatatypeConverter;


public class ImgUtils {

    public static String getImgBase64(String fileFullPath) {
        File f = new File(fileFullPath);
        String base64 = "";
        byte[] content = new byte[(int) f.length()];
        InputStream in = null;
        try {
            in = new FileInputStream(f);
            for (int off = 0, read;
                (read = in.read(content, off, content.length - off)) > 0;
                off += read);

            base64 = DatatypeConverter.printBase64Binary(content);
        } catch (IOException e) {
            // Some error occured
        } finally {
            if (in != null)
                try { in.close(); } catch (IOException e) {}
        }
        return base64;
    }
}

```
