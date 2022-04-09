#ifndef LINUXAPI_H
#define LINUXAPI_H

#include <QObject>
#include <QUrl>
#include <QDebug>
#include "Qt-AES/qaesencryption.h"

const QUrl linuxUrl = QUrl("https://music.163.com/api/linux/forward");

const QByteArray linuxapiKey = "rFgB&h#%2?^eDg:Q";

QByteArray linuxapi(QByteArray url, QByteArray postData);

#endif // LINUXAPI_H
