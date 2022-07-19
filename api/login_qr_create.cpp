#include "login_qr_create.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QCryptographicHash>
#include <QDebug>

QByteArray loginQRCreate(QByteArray key) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/login_qr_create.js
{
    const QByteArray url = "https://music.163.com/login";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(QUrl(url));
    QByteArray postData = "codekey=" + key;
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}