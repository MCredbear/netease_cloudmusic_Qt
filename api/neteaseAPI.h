#ifndef NETEASEAPI_H
#define NETEASEAPI_H

#include <QObject>

#include "captcha_sent.h"
#include "captcha_verify.h"
#include "login_cellphone.h"
#include "login_qr_key.h"
#include "lyric.h"
#include "record_recent_song.h"
#include "song_detail.h"
#include "user_account.h"

class neteaseAPI : public QObject
{
    Q_OBJECT
public:
    explicit neteaseAPI(QObject *parent = nullptr);

    Q_INVOKABLE QByteArray captchaSent(QByteArray countrycode, QByteArray phone);
    Q_INVOKABLE QByteArray captchaVerify(QByteArray countrycode, QByteArray phone, QByteArray captcha);
    Q_INVOKABLE QByteArray loginCellphone(QByteArray countrycode, QByteArray phone, QByteArray password); //暂时只用密码
    Q_INVOKABLE QByteArray recordRecentSong(QByteArray limit);
    Q_INVOKABLE QByteArray songDetail(QByteArray id);
    Q_INVOKABLE QByteArray userAccount();

signals:

};

#endif // NETEASEAPI_H
