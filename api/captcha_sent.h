#ifndef CAPTCHA_SENT_H
#define CAPTCHA_SENT_H

#include <QObject>

QByteArray captchaSent(QByteArray countrycode, QByteArray phone); // from https://github.com/binaryify/NeteaseCloudMusicApi/module/captcha_sent.js

#endif // CAPTCHA_SENT_H
