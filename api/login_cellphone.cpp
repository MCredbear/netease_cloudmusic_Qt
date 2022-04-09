#include "login_cellphone.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QCryptographicHash>
#include <QDebug>
#include "crypto/linuxapi.h"
#include "cookie.h"

// from https://github.com/binaryify/NeteaseCloudMusicApi/module/login_cellphone



QByteArray loginCellphoneWithPassword(QByteArray countrycode, QByteArray phone, QByteArray password)
{
    const QByteArray url = "https://music.163.com/api/login/cellphone";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Cookie", "NMTID=; MUSIC_U=; __remember_me=true; os=pc"); //不知道为什么 setHeader(QNetworkRequest::CookieHeader, xxxxx) 会401
    password = QCryptographicHash::hash(password, QCryptographicHash::Md5).toHex();
    QByteArray postData = "{\"phone\":\"" + phone + "\",\"countrycode\":\"" + countrycode + "\",\"password\":\"" + password + "\",\"rememberLogin\":\"true\"}";
    /*
    {
          "phone":"$cellphone",
          "countrycode":"$countrycode",
          "password":"$password",
          "rememberLogin":"true"
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    writeCookie(manager.cookieJar()->cookiesForUrl(linuxUrl));
    return reply->readAll();
}

QByteArray loginCellphoneWithCaptcha(QByteArray countrycode, QByteArray phone, QByteArray captcha)
{
    const QByteArray url = "https://music.163.com/api/login/cellphone";
    QNetworkAccessManager manager;
    QNetworkRequest request;
    QEventLoop eventloop;
    request.setUrl(linuxUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray postData = "{\"phone\":\"" + phone + "\",\"countrycode\":\"" + countrycode + "\",\"captcha\":\"" + captcha + "\",\"rememberLogin\":\"true\"}";
    /*
    {
        "phone":"$cellphone",
        "countrycode":"$countrycode",
        "captcha":"$captcha",
        "rememberLogin":"true"
    }
    */
    postData = linuxapi(url, postData);
    QNetworkReply *reply = manager.post(request, postData);
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &eventloop, SLOT(quit()));
    eventloop.exec();
    //cookie = reply->rawHeader("Set-Cookie");
    //writeCookie();
    return reply->readAll();
}
