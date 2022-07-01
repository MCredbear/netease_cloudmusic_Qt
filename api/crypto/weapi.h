#ifndef WEAPI_H
#define WEAPI_H

#include <QObject>

// from https://github.com/binaryify/NeteaseCloudMusicApi/util/crypto.js

const QByteArray publicKey = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ3\n4ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvakl\nV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44o\nncaTWz7OBGLbCiK45wIDAQAB\n-----END PUBLIC KEY-----";
/* OpenSSL public key format:
 * -----BEGIN PUBLIC KEY-----
 * a '\n' behind every 64 words
 * -----END PUBLIC KEY-----
 */
// learn more about OpenSSL's RSA: https://blog.csdn.net/yizhiniu_xuyw/article/details/114371606

const QByteArray iv = "0102030405060708";
const QByteArray presetKey = "0CoJUm6Qyw8W8jud";
const QByteArray base62 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
static QByteArray secretKey;

QByteArray weapi(QByteArray postdata);

static QByteArray params(QByteArray postdata);
static QByteArray encSecKey();

static QByteArray rsaPubEncrypt(QByteArray plainDataArry, QByteArray pubKeyArry);

#endif // WEAPI_H
