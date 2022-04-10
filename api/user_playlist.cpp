#include "user_playlist.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/linuxapi.h"
#include "cookie.h"
#include "cache.h"

QByteArray userPlaylist(QByteArray id)
{
    const QByteArray url = "https://music.163.com/api/user/playlist";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Cookie", cookie);
    QByteArray postData = "{\"uid\":\"" + id + "\",\"limit\":114,\"offset\":0,\"includeVideo\":true}";
    /*
    {
        "uid":"$id",
        "limit":114,
        "offset":0,
        "includeVideo":true
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
