#ifndef COOKIE_H
#define COOKIE_H

#include <QNetworkCookieJar>
#include <QNetworkCookie>
#include <QFile>
#include <QDebug>

extern QByteArray cookie;

void readCookie();

void writeCookie(QList<QNetworkCookie> cookie); //覆盖原有cookie

#endif // COOKIE_H
