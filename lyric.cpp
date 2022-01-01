#include "lyric.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>

lyric::lyric(QObject *parent)
    : QObject{parent}
{

}

QByteArray lyric::getLyric(QByteArray id)
{
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(QUrl("https://music.163.com/api/song/lyric"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata;
    postdata.append("id=" + id);
    QNetworkReply *reply = manager.post(request, postdata);
    connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
