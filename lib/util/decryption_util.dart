import 'dart:convert';

class DecryptionUtil {
  static String decryption(String pluginString) {
    int start = pluginString.indexOf("::") + 2;
    int end = pluginString.lastIndexOf("::");
    String txt = pluginString.substring(start, end);
    String key = pluginString.substring(end + 2);

    StringBuffer sb = new StringBuffer();
    for (int i = 0, len = txt.length; i < len; i++) {
      if (i % 2 == 0) {
        sb.write(txt[i]);
      }
    }

    txt = sb.toString();
    txt = utf8.decode(base64.decode(txt));
    key = key + "ro4w78Jx";

    var data = utf8.encode(txt);
    var keyData = utf8.encode(key);

    int keyIndex = 0;

    for (int x = 0; x < data.length; x++) {
      data[x] = (data[x] ^ keyData[keyIndex]);
      keyIndex += 1;

      if (keyIndex == keyData.length) {
        keyIndex = 0;
      }
    }

    txt = utf8.decode(data);

    txt = utf8.decode(base64.decode(txt));
    return txt;
  }
}
