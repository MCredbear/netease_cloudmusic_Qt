#include "record_recent_song.h"
#include <QNetworkAccessManager>
#include <QNetworkCookieJar>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>

QByteArray recordRecentSong(QByteArray limit) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/record_recent_song.js
{
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    QNetworkCookieJar cookieJar;
    manager.setCookieJar(&cookieJar);
    request.setUrl(QUrl("https://music.163.com/api/play-record/song/list"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata;
    postdata.append("limit=" + limit);
    QNetworkReply *reply = manager.post(request, postdata);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
