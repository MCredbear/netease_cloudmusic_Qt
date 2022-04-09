#include "linuxapi.h"

QByteArray linuxapi(QByteArray url, QByteArray postData)
{
    QByteArray encryptedData = "{\"method\":\"POST\",\"url\":\"" + url + "\",\"params\":" + postData + "}";
    /*
    {
        "method":"POST",
        "url":"$url",
        "params":$postData
    }
    */
    QAESEncryption encryption(QAESEncryption::AES_128, QAESEncryption::ECB, QAESEncryption::PKCS7); // nodeJS uses PKSC5
    encryptedData = encryption.encode(encryptedData, linuxapiKey, "");
    encryptedData = encryptedData.toHex().toUpper();
    encryptedData = "eparams=" + encryptedData;
    return encryptedData;
}
