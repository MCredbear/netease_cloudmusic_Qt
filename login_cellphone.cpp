#include "login_cellphone.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>
#include "crypto/weapi.h"

login_cellphone::login_cellphone(QObject *parent)
    : QObject{parent}
{

}

QByteArray login_cellphone::login(QByteArray phone, QByteArray password)
{
    QNetworkAccessManager manager;
    QNetworkRequest request;
    request.setUrl(QUrl("https://music.163.com/weapi/login/cellphone"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postdata;

}
