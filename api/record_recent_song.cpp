#include "record_recent_song.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "api/crypto/linuxapi.h"
#include "cookie.h"

QByteArray recordRecentSong(QByteArray limit) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/record_recent_song.js
{
    const QByteArray url = "https://music.163.com/api/play-record/song/list";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Cookie", cookie);
    QByteArray postData = "{\"limit\":" + limit + "}";
    /*
    {
        "limit":"$limit"
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
