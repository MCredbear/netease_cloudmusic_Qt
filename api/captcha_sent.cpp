#include "captcha_sent.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/weapi.h"

QByteArray captchaSent(QByteArray countrycode, QByteArray phone) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/captcha_sent.js
{
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(QUrl("https://music.163.com/api/sms/captcha/sent"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata;
    postdata.append("params=" + weapi::params("{\"ctcode\":\"" + countrycode + "\",\"cellphone\":\"" + phone + "\"}") + "&");
    postdata.append("encSecKey=" + weapi::encSecKey());
    QNetworkReply *reply = manager.post(request, postdata);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
