#include "captcha_sent.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/linuxapi.h"

QByteArray captchaSent(QByteArray countrycode, QByteArray phone) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/captcha_sent.js
{
    const QByteArray url = "https://music.163.com/api/sms/captcha/sent";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postData = "{\"ctcode\":\"" + countrycode + "\",\"cellphone\":\"" + phone + "\"}";
    /*
    {
        "ctcode":"$countrycode",
        "cellphone":"$phone"
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
