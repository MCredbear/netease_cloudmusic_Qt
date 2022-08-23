#include "song_detail.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/linuxapi.h"

QByteArray songDetail(QByteArray id) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/song_detial.js
{
    const QByteArray url = "https://music.163.com/api/v3/song/detail";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postData = "{\"c\":\"[{\\\"id\\\":" + id + "}]\"}";
    /*
    {
        "c":"[{\"id\":$id}]"
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}

QByteArray songDetail(QByteArrayList idList)
{
    const QByteArray url = "https://music.163.com/api/v3/song/detail";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    for (int i = 0; i < idList.count(); i++) idList[i] = "{\\\"id\\\":" + idList.at(i) + "}";
    QByteArray postData = "{\"c\":\"[" + idList.join(",") + "]\"}";
    /*
    {
        "c":"[{\"id\":$idList.at(0)},{\"id\":$idList.at(1)}]"
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
