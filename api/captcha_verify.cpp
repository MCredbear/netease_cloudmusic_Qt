#include "captcha_verify.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/linuxapi.h"

QByteArray captchaVerify(QByteArray countrycode, QByteArray phone, QByteArray captcha) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/captcha_verify.js
{
    const QByteArray url = "https://music.163.com/weapi/sms/captcha/verify";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postData = "{\"ctcode\":\"" + countrycode + "\",\"cellphone\":\"" + phone + "\",\"captcha\":\"" + captcha + "\"}";
    /*
    {
        "ctcode":"$countrycode",
        "cellphone":"$phone",
        "captcha":"$captcha"
    }
    */
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
