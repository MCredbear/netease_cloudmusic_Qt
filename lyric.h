#ifndef LYRIC_H
#define LYRIC_H

#include <QObject>

class lyric : public QObject // from https://github.com/binaryify/NeteaseCloudMusicApi/module/lyric.js
{
    Q_OBJECT
public:
    explicit lyric(QObject *parent = nullptr);
    Q_INVOKABLE QByteArray getLyric(QByteArray id); // I'm thinking about whether define this as a static function

signals:

};

#endif // LYRIC_H
