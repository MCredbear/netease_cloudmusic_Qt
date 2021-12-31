#ifndef WEAPI_H
#define WEAPI_H

#include <QObject>

class weapi : public QObject // from https://github.com/binaryify/NeteaseCloudMusicApi/util/crypto.js
{
    Q_OBJECT
public:
    explicit weapi(QObject *parent = nullptr);

    QByteArray rsaPubEncrypt(QByteArray plainDataArry, QByteArray pubKeyArry);
    QByteArray publicKey = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ3\n4ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvakl\nV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44o\nncaTWz7OBGLbCiK45wIDAQAB\n-----END PUBLIC KEY-----";
    /* OpenSSL public key format:
     * -----BEGIN PUBLIC KEY-----
     *
     * a '\n' behind every 64 words
     *
     * -----END PUBLIC KEY-----
     */
    // learn more about OpenSSL's RSA: https://blog.csdn.net/yizhiniu_xuyw/article/details/114371606
    QByteArray iv = "0102030405060708";
    QByteArray presetKey = "0CoJUm6Qyw8W8jud";
    QByteArray base62 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    QByteArray secretKey;

    QByteArray params();
    QByteArray encSecKey();


signals:

};

#endif // WEAPI_H
