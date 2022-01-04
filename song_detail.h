#ifndef SONG_DETIAL_H
#define SONG_DETIAL_H

#include <QObject>

class song_detial : public QObject // from https://github.com/binaryify/NeteaseCloudMusicApi/module/song_detail.js
{
    Q_OBJECT
public:
    explicit song_detial(QObject *parent = nullptr);
    QByteArray getSong_detail(QByteArray id);
signals:

};

#endif // SONG_DETIAL_H
