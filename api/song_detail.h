#ifndef SONG_DETIAL_H
#define SONG_DETIAL_H

#include <QObject>

QByteArray songDetail(QByteArray id); // from https://github.com/binaryify/NeteaseCloudMusicApi/module/song_detail.js

QByteArray songDetail(QByteArrayList idList);

#endif // SONG_DETIAL_H
