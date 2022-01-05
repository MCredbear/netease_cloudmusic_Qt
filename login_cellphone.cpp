#include "login_cellphone.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QCryptographicHash>
#include <QDebug>
#include "crypto/weapi.h"

login_cellphone::login_cellphone(QObject *parent)
    : QObject{parent}
{

}

QByteArray login_cellphone::withPassword(QByteArray phone, QByteArray password)
{
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(QUrl("https://music.163.com/weapi/login/cellphone"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata;
    password = QCryptographicHash::hash(password, QCryptographicHash::Md5).toHex();
    postdata.append("params=" + weapi::params("{\"phone\":\"" + phone + "\",\"countrycode\":\"86\",\"password\":\"" + password + "\",\"rememberLogin\":\"true\",\"csrf_token\":\"\"}") + "&");
    postdata.append("encSecKey=" + weapi::encSecKey());
    QNetworkReply *reply = manager.post(request, postdata);
    connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    return reply->readAll();
}
