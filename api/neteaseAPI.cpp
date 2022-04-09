#include "neteaseAPI.h"
#include "cookie.h"
#include <QDebug>

#include "captcha_sent.h"
#include "captcha_verify.h"
#include "login_cellphone.h"
#include "login_qr_key.h"
#include "lyric.h"
#include "record_recent_song.h"
#include "song_detail.h"
#include "user_account.h"

neteaseAPI::neteaseAPI(QObject *parent)
    : QObject{parent}
{
    readCookie();
}

QByteArray neteaseAPI::captchaSent(QByteArray countrycode, QByteArray phone)
{
    return ::captchaSent(countrycode, phone);
}
QByteArray neteaseAPI::captchaVerify(QByteArray countrycode, QByteArray phone, QByteArray captcha)
{
    return ::captchaVerify(countrycode, phone, captcha);
}
QByteArray neteaseAPI::loginCellphone(QByteArray countrycode, QByteArray phone, QByteArray password) //暂时只用密码
{
    return ::loginCellphoneWithPassword(countrycode, phone, password);
}
QByteArray neteaseAPI::recordRecentSong(QByteArray limit)
{
    return ::recordRecentSong(limit);
}
QByteArray neteaseAPI::songDetail(QByteArray id)
{
    return ::songDetail(id);
}
QByteArray neteaseAPI::userAccount()
{
    return ::userAccount();
}
