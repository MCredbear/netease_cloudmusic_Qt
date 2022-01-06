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

#include "login_cellphone.h"
#include "login_qr.h"
#include "lyric.h"

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

int main(int argc, char *argv[])
{

#ifdef Q_OS_ANDROID
    checkPermission();
    checkPermission2();
#endif

    QQuickStyle::setStyle("Material");
    QQuickWindow::setSceneGraphBackend(QSGRendererInterface::VulkanRhi);
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    login_cellphone login_cellphone;
    login_qr login_qr;
    lyric lyric;

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

    engine.rootContext()->setContextProperty("login_cellphone",&login_cellphone);
    engine.rootContext()->setContextProperty("lyric",&lyric);
    engine.rootContext()->setContextProperty("login_qr",&login_qr);

#ifndef Q_OS_ANDROID
    const QUrl url(QStringLiteral("qrc:/main.qml"));
#endif

#ifdef Q_OS_ANDROID
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
