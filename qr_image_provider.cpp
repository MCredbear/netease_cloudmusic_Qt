#include "qr_image_provider.h"
#include <QDebug>
#include "api/login_qr_create.h"

QRImageProvider::QRImageProvider() : QQuickImageProvider(QQuickImageProvider::Image)
{
}

QImage QRImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QByteArray htmlData = loginQRCreate(id.toUtf8());
    QByteArray base64Head = "data:image/png;base64,";
    QByteArray base64;
    for (int i = 0; i < htmlData.length(); i++)
    {
        if (htmlData.mid(i, base64Head.length()) == base64Head)
        {
            while (htmlData.mid(i, 1) != "\"")
            {
                base64.append(htmlData.mid(i, 1));
                i++;
            }
            break;
        }
    }
    qDebug()<<htmlData;
    qDebug()<<base64;
    base64 = QByteArray::fromBase64(base64);
    return QImage::fromData(base64);
}