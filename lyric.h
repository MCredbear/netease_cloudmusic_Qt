#ifndef LYRIC_H
#define LYRIC_H

#include <QObject>

class lyric : public QObject
{
    Q_OBJECT
public:
    explicit lyric(QObject *parent = nullptr);
    Q_INVOKABLE static QByteArray getLyric(QByteArray id);

signals:

};

#endif // LYRIC_H
