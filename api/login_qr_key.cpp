#include "login_qr_key.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/linuxapi.h"

QByteArray loginQRKey() // from https://github.com/binaryify/NeteaseCloudMusicApi/module/login_qr_key.js
{
    const QByteArray url = "https://music.163.com/weapi/login/qrcode/unikey";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata = "{\"type\":1}";
    /*
    {
        "type":1
    }
    */
    QNetworkReply *reply = manager.post(request, postdata);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
