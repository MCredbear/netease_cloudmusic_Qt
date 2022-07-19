#ifndef LOGIN_CELLPHONE_H
#define LOGIN_CELLPHONE_H

#include <QObject>

// from https://github.com/binaryify/NeteaseCloudMusicApi/module/login_cellphone.js

QByteArray loginCellphoneWithPassword(QByteArray countrycode, QByteArray phone, QByteArray password);

QByteArray loginCellphoneWithCaptcha(QByteArray countrycode, QByteArray phone, QByteArray captcha);

#endif // LOGIN_CELLPHONE_H
