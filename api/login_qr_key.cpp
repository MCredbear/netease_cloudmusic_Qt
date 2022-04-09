#include "login_qr_key.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/weapi.h"

QByteArray loginQRKey() // from https://github.com/binaryify/NeteaseCloudMusicApi/module/login_qr_key.js
{
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(QUrl("https://music.163.com/weapi/login/qrcode/unikey"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata;
    postdata.append("params=" + weapi::params("{\"type\":1}") + "&");
    postdata.append("encSecKey=" + weapi::encSecKey());
    QNetworkReply *reply = manager.post(request, postdata);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
