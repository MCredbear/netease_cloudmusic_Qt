#include "song_detail.h"
#include "crypto/weapi.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>

song_detial::song_detial(QObject *parent) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/song_detial.js
    : QObject{parent}
{

}

QByteArray song_detial::getSong_detail(QByteArray id)
{
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(QUrl("https://music.163.com/api/v3/song/detail"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata;
}
