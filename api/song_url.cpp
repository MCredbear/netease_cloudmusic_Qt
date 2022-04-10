#include "song_url.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/linuxapi.h"
#include "cookie.h"

QByteArray songUrl(QByteArray id)
{
    const QByteArray url = "https://interface3.music.163.com/api/song/enhance/player/url";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Cookie", cookie);
    QByteArray postData = "{\"ids\":\"[" + id + "]\",\"br\":999000}";
    /*
    {
        "ids":"[$id]",
        "br":990000
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
