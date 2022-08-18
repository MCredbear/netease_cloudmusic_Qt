#ifndef SEARCH_H
#define SEARCH_H

#include <QObject>

QByteArray search(QByteArray keywords,
                  QByteArray type, // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
                  QByteArray limit,
                  QByteArray offset);

#endif // SEARCH_H
