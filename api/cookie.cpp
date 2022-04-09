#include "cookie.h"
#include <QFile>
#include <QDebug>

QByteArray cookie;

void readCookie()
{
    QFile cookieFile("./cookie");
    cookieFile.open(QIODevice::ReadWrite);
    cookie = cookieFile.readAll();
    cookie = cookie.mid(0,cookie.length()-1); //不知道为什么结尾会多出来一个换行符
    cookieFile.close();
}

void writeCookie(QList<QNetworkCookie> cookieList) //覆盖原有cookie
{
    QFile cookieFile("./cookie");
    cookieFile.open(QIODevice::WriteOnly);
    QByteArray cookieString;
    for (int i = 0; i < cookieList.length(); i++) cookieString.append(cookieList.at(i).toRawForm());
    cookie = cookieString;
    cookieFile.write(cookieString);
    cookieFile.close();
}
