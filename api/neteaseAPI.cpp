#include "neteaseAPI.h"
#include "cookie.h"
#include <QDebug>

#include "captcha_sent.h"
#include "captcha_verify.h"
#include "login_cellphone.h"
#include "login_qr_check.h"
#include "login_qr_create.h"
#include "login_qr_key.h"
#include "lyric.h"
#include "record_recent_song.h"
#include "song_detail.h"
#include "user_account.h"
#include "user_playlist.h"

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
QByteArray neteaseAPI::cloudSearch(QByteArray keywords, QByteArray type, QByteArray limit, QByteArray offset)
{
    return ::cloudSearch(keywords, type, limit, offset);
}
QByteArray neteaseAPI::loginCellphone(QByteArray countrycode, QByteArray phone, QByteArray captcha) //暂时只用验证码
{
    return ::loginCellphoneWithCaptcha(countrycode, phone, captcha);
}
QByteArray neteaseAPI::loginQRCheck(QByteArray key)
{
    return ::loginQRCheck(key);
}
QByteArray neteaseAPI::loginQRCreate(QByteArray key)
{
    return ::loginQRCreate(key);
}
QByteArray neteaseAPI::loginQRKey()
{
    return ::loginQRKey();
}
QByteArray neteaseAPI::lyric(QByteArray id)
{
    return ::lyric(id);
}
QByteArray neteaseAPI::playlistDetail(QByteArray id)
{
    return ::playlistDetail(id);
}
QByteArray neteaseAPI::recordRecentSong(QByteArray limit)
{
    return ::recordRecentSong(limit);
}
QByteArray neteaseAPI::search(QByteArray keywords, QByteArray type, QByteArray limit, QByteArray offset)
{
    return ::search(keywords, type, limit, offset);
}
QByteArray neteaseAPI::searchSuggest(QByteArray keywords)
{
    return ::searchSuggest(keywords);
}
QByteArray neteaseAPI::songDetail(QByteArray id)
{
    return ::songDetail(id);
}
QByteArray neteaseAPI::songDetail(QByteArrayList idList)
{
    return ::songDetail(idList);
}
QByteArray neteaseAPI::songUrl(QByteArray id)
{
    return ::songUrl(id);
}
QByteArray neteaseAPI::userAccount()
{
    return ::userAccount();
}
QByteArray neteaseAPI::userPlaylist(QByteArray id)
{
    return ::userPlaylist(id);
}
QByteArray neteaseAPI::vipInfo()
{
    return ::vipInfo();
}
