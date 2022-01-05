#include "login_qr.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/weapi.h"

login_qr::login_qr(QObject *parent) // from https://github.com/binaryify/NeteaseCloudMusicApi/module/login_qr_*.js
    : QObject{parent}
{

}

QByteArray login_qr::creatQRKey()
{
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(QUrl("https://music.163.com/weapi/login/qrcode/unikey"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata;
    postdata.append("params=" + weapi::params("{\"type\":1}") + "&");
    postdata.append("encSecKey=" + weapi::encSecKey());qDebug()<<postdata;
    QNetworkReply *reply = manager.post(request, postdata);
    connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
