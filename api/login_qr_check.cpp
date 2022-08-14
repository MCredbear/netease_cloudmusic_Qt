#include "login_qr_check.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/linuxapi.h"
#include "cookie.h"

QByteArray loginQRCheck(QByteArray key)
{
    const QByteArray url = "https://music.163.com/api/login/qrcode/client/login";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Cookie", "NMTID=; MUSIC_U=; __remember_me=true; os=pc");
    QByteArray postData = "{\"key\":\"" + key +"\",\"type\":1}";
    /*
    {
        "key":"$key",
        "type":1
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    QByteArray data = reply->readAll();
    if (data.contains("803")) writeCookie(manager.cookieJar()->cookiesForUrl(linuxUrl));
    return data;
}
