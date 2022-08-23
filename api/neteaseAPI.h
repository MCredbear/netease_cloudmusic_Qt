#ifndef NETEASEAPI_H
#define NETEASEAPI_H

#include <QObject>

#include "captcha_sent.h"
#include "captcha_verify.h"
#include "cloudsearch.h"
#include "login_cellphone.h"
#include "login_qr_key.h"
#include "login_qr_create.h"
#include "lyric.h"
#include "playlist_detail.h"
#include "record_recent_song.h"
#include "search.h"
#include "search_suggest.h"
#include "song_detail.h"
#include "song_url.h"
#include "user_account.h"
#include "user_playlist.h"
#include "vip_info.h"

class neteaseAPI : public QObject
{
    Q_OBJECT
public:
    explicit neteaseAPI(QObject *parent = nullptr);

    Q_INVOKABLE QByteArray captchaSent(QByteArray countrycode, QByteArray phone);
    Q_INVOKABLE QByteArray captchaVerify(QByteArray countrycode, QByteArray phone, QByteArray captcha);
    Q_INVOKABLE QByteArray cloudSearch(QByteArray keywords, QByteArray type, QByteArray limit, QByteArray offset);
    Q_INVOKABLE QByteArray loginCellphone(QByteArray countrycode, QByteArray phone, QByteArray password); //暂时只用密码
    Q_INVOKABLE QByteArray loginQRKey();
    Q_INVOKABLE QByteArray loginQRCheck(QByteArray key);
    Q_INVOKABLE QByteArray loginQRCreate(QByteArray key);
    Q_INVOKABLE QByteArray lyric(QByteArray id);
    Q_INVOKABLE QByteArray playlistDetail(QByteArray id);
    Q_INVOKABLE QByteArray recordRecentSong(QByteArray limit);
    Q_INVOKABLE QByteArray search(QByteArray keywords, QByteArray type, QByteArray limit, QByteArray offset);
    Q_INVOKABLE QByteArray searchSuggest(QByteArray keywords);
    Q_INVOKABLE QByteArray songDetail(QByteArray id);
    Q_INVOKABLE QByteArray songDetail(QByteArrayList idList);
    Q_INVOKABLE QByteArray songUrl(QByteArray id);
    Q_INVOKABLE QByteArray userAccount();
    Q_INVOKABLE QByteArray userPlaylist(QByteArray id);
    Q_INVOKABLE QByteArray vipInfo();

signals:

};

#endif // NETEASEAPI_H
