#include "playlist_detail.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/linuxapi.h"
#include "cookie.h"

QByteArray playlistDetail(QByteArray id) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/playlist_detail.js
{
    const QByteArray url = "https://music.163.com/api/v6/playlist/detail";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Cookie", cookie);
    QByteArray postData = "{\"id\":\"" + id + "\",\"n\":100000,\"s\":8}";
    /*
    {
        "id":"$id",
        "n":100000,
        "s":8
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
