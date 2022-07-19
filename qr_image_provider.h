#ifndef QR_IMAGE_PROVIDER_H
#define QR_IMAGE_PROVIDER_H

#include <QObject>
#include <QQuickImageProvider>

class QRImageProvider : public QQuickImageProvider
{
    Q_OBJECT
public:
    explicit QRImageProvider();
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);

signals:
};

#endif // QR_IMAGE_PROVIDER_H
