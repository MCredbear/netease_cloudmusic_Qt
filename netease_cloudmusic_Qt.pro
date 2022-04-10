QT += quick quickcontrols2 svg network multimedia
android: QT += androidextras
CONFIG += c++11 #qtquickcompiler

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        Qt-AES/qaesencryption.cpp \
        api/captcha_sent.cpp \
        api/captcha_verify.cpp \
        api/cookie.cpp \
        api/login_cellphone.cpp \
        api/login_qr_key.cpp \
        api/lyric.cpp \
        api/crypto/weapi.cpp \
        api/crypto/linuxapi.cpp \
        api/neteaseAPI.cpp \
        api/playlist_detail.cpp \
        api/record_recent_song.cpp \
        api/song_detail.cpp \
        api/song_url.cpp \
        api/user_account.cpp \
        api/user_playlist.cpp \
        main.cpp \
        permissions.cpp


RESOURCES += qml.qrc \
             image.qrc

CONFIG += lrelease
CONFIG += embed_translations

include(statusbar/src/statusbar.pri)

#!android: LIBS += -lcrypto
android: include(/home/redbear/android-sdk-linux/android_openssl/openssl.pri)   # Qt's support for Android is still too poor
android: LIBS+= /home/redbear/android-sdk-linux/android_openssl/no-asm/latest/arm64/libcrypto.so.
android: INCLUDEPATH += /home/redbear/android-sdk-linux/android_openssl/static/include/

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    Qt-AES/aesni/aesni-enc-cbc.h \
    Qt-AES/aesni/aesni-enc-ecb.h \
    Qt-AES/aesni/aesni-key-exp.h \
    Qt-AES/qaesencryption.h \
    api/cache.h \
    api/captcha_sent.h \
    api/captcha_verify.h \
    api/cookie.h \
    api/crypto/linuxapi.h \
    api/crypto/weapi.h \
    api/login_cellphone.h \
    api/login_qr_key.h \
    api/lyric.h \
    api/neteaseAPI.h \
    api/record_recent_song.h \
    api/song_detail.h \
    api/song_url.h \
    api/user_account.h \
    api/user_playlist.h \
    api/playlist_detail.h \
    permissions.h

