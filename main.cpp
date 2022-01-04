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

#include "crypto/weapi.h"
#include "login_cellphone.h"
#include "login_qr.h"
#include "lyric.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Material");
    QQuickWindow::setSceneGraphBackend(QSGRendererInterface::VulkanRhi);
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    login_cellphone login;
    login_qr login_qr;
    weapi weapi;
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
    engine.rootContext()->setContextProperty("weapi",&weapi);
    engine.rootContext()->setContextProperty("login",&login);
    engine.rootContext()->setContextProperty("lyric",&lyric);
    engine.rootContext()->setContextProperty("login_qr",&login_qr);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
