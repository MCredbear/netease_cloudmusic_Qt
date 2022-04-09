#include "captcha_verify.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/weapi.h"

QByteArray captchaVerify(QByteArray countrycode, QByteArray phone, QByteArray captcha) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/captcha_verify.js
{
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(QUrl("https://music.163.com/weapi/sms/captcha/verify"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata;
    postdata.append("params=" + weapi::params("{\"ctcode\":\"" + countrycode + "\",\"cellphone\":\"" + phone + "\",\"captcha\":\"" + captcha + "\"}") + "&");
    postdata.append("encSecKey=" + weapi::encSecKey());
    QNetworkReply *reply = manager.post(request, postdata);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
