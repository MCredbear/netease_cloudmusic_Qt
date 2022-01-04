#include "weapi.h"
#include "Qt-AES/qaesencryption.h"
#include <QRandomGenerator>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/aes.h>
#include <QDebug>

weapi::weapi(QObject *parent) // from https://github.com/binaryify/NeteaseCloudMusicApi/util/crypto.js
    : QObject{parent}
{

}

QByteArray weapi::params(QByteArray postdata)
{
    QByteArray data;
    for (int i = 0 ; i < 16 ; i++)  secretKey.append(base62.mid(QRandomGenerator::global()->bounded(0, 61)),1); // generate 16 Byte random key
    QAESEncryption encryption(QAESEncryption::AES_128, QAESEncryption::CBC, QAESEncryption::PKCS7); // nodeJS uses PKSC7
    data = encryption.encode(postdata, presetKey, iv).toBase64();
    data = encryption.encode(data, secretKey, iv).toBase64();
    data = data.toPercentEncoding();
    return data;
}

QByteArray weapi::encSecKey()
{
    QByteArray data;
    QByteArray reversedsecretKey;
    for (int i = 15 ; i >= 0 ; i--) reversedsecretKey += secretKey[i];
    QByteArray paddedsecretKey;
    for (int i = 0 ; i <= 127-16 ; i++) paddedsecretKey += QByteArray::fromHex("00");
    paddedsecretKey += reversedsecretKey;
    data = rsaPubEncrypt(paddedsecretKey ,publicKey).toHex();
    return data;
}

QByteArray weapi::rsaPubEncrypt(QByteArray plainDataArry, QByteArray pubKeyArry) // copied from Internet
{

    uchar* pPubKey = (uchar*)pubKeyArry.data();
    BIO* pKeyBio = BIO_new_mem_buf(pPubKey, pubKeyArry.length());

    RSA* pRsa = RSA_new();
    pRsa = PEM_read_bio_RSA_PUBKEY(pKeyBio, &pRsa, NULL, NULL);

    int nLen = RSA_size(pRsa);
    char* pEncryptBuf = new char[nLen];

    int nPlainDataLen;

    int exppadding = nLen;

    int slice = 1;

    QByteArray arry;
    for(int i=0; i<slice; i++)
    {
        QByteArray baData = plainDataArry.mid(i*exppadding, exppadding);
        nPlainDataLen = baData.length();
        memset(pEncryptBuf, 0, nLen);
        uchar* pPlainData = (uchar*)baData.data();
        int nSize = RSA_public_encrypt(nPlainDataLen,
                                       pPlainData,
                                       (uchar*)pEncryptBuf,
                                       pRsa,
                                       RSA_NO_PADDING);
        if (nSize >= 0)
        {
            arry.append(QByteArray(pEncryptBuf, nSize));
        }
    }

    delete[] pEncryptBuf;
    BIO_free_all(pKeyBio);
    RSA_free(pRsa);

    return arry;
}

/*QString weapi::aesEncrypt(QByteArray key, QByteArray iv, QByteArray code)
{
    unsigned char sourceStringTemp[MSG_LEN];
    memset((unsigned char*)sourceStringTemp, 0x00 ,MSG_LEN);
    strcpy( (char*)sourceStringTemp, code.constData() );

    unsigned char keyArray[AES_BLOCK_SIZE*2];
    memset((unsigned char*)keyArray, 0x00 ,AES_BLOCK_SIZE*2);
    strcpy( (char*)keyArray, key.toLatin1().constData() );

    unsigned char codeKey[AES_BLOCK_SIZE*2];
    for (int j = 0; j < AES_BLOCK_SIZE*2 ; ++j) {
        codeKey[j] = keyArray[j];
    }

    unsigned char codeIvec[ivec.size()];
    for(int j = 0; j < ivec.size(); ++j) {
        codeIvec[j] = ivec[j].unicode();
    }

    unsigned char result[MSG_LEN];
    memset((unsigned char*)result, 0x00 ,MSG_LEN);
    if( !aes_encrypt(sourceStringTemp,codeKey,codeIvec,result) ) {
        qDebug() << "Encode Error";
        return "";
    }

    QByteArray by_result = (char*)result;
    QString s_result(by_result.toBase64());

    memset((char*)sourceStringTemp, 0x00 ,MSG_LEN);
    return s_result;
}*/
