#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QTranslator>
#include <QQmlContext>
#include <QLocale>
#include <QTranslator>
#include <QSGRendererInterface>
#include <QQuickWindow>
#include <QNetworkDiskCache>
#include <QQmlNetworkAccessManagerFactory>
#include <QNetworkAccessManager>

#ifdef Q_OS_ANDROID
#include "statusbar.h"
#endif

#include "api/neteaseAPI.h"
#include "api/cookie.h"
#include "qr_image_provider.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>
bool checkPermission() {
    QtAndroid::PermissionResult r = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
    if(r == QtAndroid::PermissionResult::Denied) {
        QtAndroid::requestPermissionsSync( QStringList() << "android.permission.WRITE_EXTERNAL_STORAGE" );
        r = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
        if(r == QtAndroid::PermissionResult::Denied) {
            return false;
        }
    }
    return true;
}
bool checkPermission2() {
    QtAndroid::PermissionResult r = QtAndroid::checkPermission("android.permission.READ_EXTERNAL_STORAGE");
    if(r == QtAndroid::PermissionResult::Denied) {
        QtAndroid::requestPermissionsSync( QStringList() << "android.permission.READ_EXTERNAL_STORAGE" );
        r = QtAndroid::checkPermission("android.permission.READ_EXTERNAL_STORAGE");
        if(r == QtAndroid::PermissionResult::Denied) {
            return false;
        }
    }
    return true;
}
#endif

class CachingNetworkAccessManagerFactory : public QQmlNetworkAccessManagerFactory //QML网络缓存
{
public:
    virtual QNetworkAccessManager *create(QObject *parent)
    {
        QNetworkAccessManager *nam = new QNetworkAccessManager(parent);
        QNetworkDiskCache* diskCache = new QNetworkDiskCache(nam);
        diskCache->setCacheDirectory("./cache/");
        diskCache->setMaximumCacheSize(500 * 1024 * 1024); //单位：B
        nam->setCache(diskCache);
        return nam;
    }
};

int main(int argc, char *argv[])
{
#ifdef Q_OS_ANDROID
    checkPermission();
    checkPermission2();
#endif

    //QQuickStyle::setStyle("Material");
    //QQuickWindow::setSceneGraphBackend(QSGRendererInterface::VulkanRhi);
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    CachingNetworkAccessManagerFactory QMLNetworkAccessManagerFactory;

    neteaseAPI api;

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "untitled1_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("neteaseAPI", &api);
    engine.setNetworkAccessManagerFactory(&QMLNetworkAccessManagerFactory);
    engine.addImageProvider("qrImage", new QRImageProvider);

#ifndef Q_OS_ANDROID
    const QUrl url(QStringLiteral("qrc:/main.qml"));
#endif

#ifdef Q_OS_ANDROID
    //const QUrl url(QStringLiteral("qrc:/main.qml"));
    const QUrl url(QStringLiteral("/sdcard/main.qml")); // for debug
#endif

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
