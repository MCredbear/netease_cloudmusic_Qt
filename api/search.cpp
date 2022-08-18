#include "search.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "api/crypto/linuxapi.h"
#include "cookie.h"

QByteArray search(QByteArray keywords,
                  QByteArray type, // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
                  QByteArray limit,
                  QByteArray offset)
{
    const QByteArray url = "https://music.163.com/api/search/get";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Cookie", cookie);
    QByteArray postData = "{\"s\":\"" + keywords + "\",\"type\":" + type + ",\"limit\":" + limit + ",\"offset\":" + offset + "}";
    /*
    {
        "s":"$keywords",
        "type":$type,
        "limit":$limit,
        "offset":$offset
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
