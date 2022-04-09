#ifndef CAPTCHA_VERIFY_H
#define CAPTCHA_VERIFY_H

#include <QObject>

QByteArray captchaVerify(QByteArray countrycode, QByteArray phone, QByteArray captcha); // from https://github.com/binaryify/NeteaseCloudMusicApi/module/captcha_verify.js

#endif // CAPTCHA_VERIFY_H
