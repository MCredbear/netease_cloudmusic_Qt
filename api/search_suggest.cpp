#include "search_suggest.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "api/crypto/linuxapi.h"
#include "cookie.h"

QByteArray searchSuggest(QByteArray keywords)
{
    const QByteArray url = "https://music.163.com/api/search/suggest/keyword";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Cookie", cookie);
    QByteArray postData = "{\"s\":\"" + keywords + "\"}";
    /*
    {
        "s":"$keywords"
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
