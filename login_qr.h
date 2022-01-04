#ifndef LOGIN_QR_H
#define LOGIN_QR_H

#include <QObject>

class login_qr : public QObject // from https://github.com/binaryify/NeteaseCloudMusicApi/module/login_qr_*.js
{
    Q_OBJECT
public:
    explicit login_qr(QObject *parent = nullptr);
    Q_INVOKABLE static QByteArray creatQRKey();

signals:

};

#endif // LOGIN_QR_H
