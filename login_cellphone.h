#ifndef LOGIN_CELLPHONE_H
#define LOGIN_CELLPHONE_H

#include <QObject>

class login_cellphone : public QObject
{
    Q_OBJECT
public:
    explicit login_cellphone(QObject *parent = nullptr);
    Q_INVOKABLE QByteArray login(QByteArray phone, QByteArray password);

signals:

};

#endif // LOGIN_CELLPHONE_H
