import QtQuick 6.2
import QtQuick.Window 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 1.15
import QtMultimedia
import Qt5Compat.GraphicalEffects

Window {
    id: window
    width: 1000 // @disable-check M16
    height: 500 // @disable-check M16
    visible: true // @disable-check M16
    title: qsTr("网易云音乐") // @disable-check M16
    color: "#eeeeee"

    function init() {
        var json
        var userAccount = neteaseAPI.userAccount()
        if (userAccount !== "") {
            json = JSON.parse(userAccount)
            userProfile = {
                "logined": true,
                "id": json.profile.userId.toString(),
                "name": json.profile.nickname,
                "avatarUrl": json.profile.avatarUrl
            }
        }
        var recordRecentSong = neteaseAPI.recordRecentSong("300")
        if (recordRecentSong !== "") {
            json = JSON.parse(recordRecentSong)
            recentSongCountText.text = json.data.total.toString() + qsTr("首")
        }
        var userPlaylist = neteaseAPI.userPlaylist(userProfile.id)
        if (userPlaylist !== "") {
            json = JSON.parse(userPlaylist)
            var playlists = json.playlist
            for (var playlist in playlists) {
                if (!playlists[playlist].subscribed) {
                    myPlaylistView.model.append({
                                        "id": playlists[playlist].id,
                                        "name": playlists[playlist].name,
                                        "trackCount": playlists[playlist].trackCount,
                                        "coverUrl": playlists[playlist].coverImgUrl,
                                      })
                } else {
                    subscribedPlaylistView.model.append({
                                                  "id": playlists[playlist].id,
                                                  "name": playlists[playlist].name,
                                                  "trackCount": playlists[playlist].trackCount,
                                                  "coverUrl": playlists[playlist].coverImgUrl,
                                              })
                }
            }
        }
    }

    Component.onCompleted: {
        var userAccount = neteaseAPI.userAccount()
        if (userAccount !== "") {
            var json = JSON.parse(userAccount)
            userProfile = {
                "logined": true,
                "id": json.profile.userId.toString(),
                "name": json.profile.nickname,
                "avatarUrl": json.profile.avatarUrl
            }
        }
    }

    property var userProfile: {
        "logined": false,
        "name": "",
        "id": "",
        "avatarUrl": ""
    } //与js不同，这不是键值对

    MediaPlayer {
        id: player
        audioOutput: AudioOutput {}
        loops: MediaPlayer.Infinite
        onPositionChanged: {
            if (player.playbackState == MediaPlayer.PlayingState)
                for (var i = 0; i < lyricView.model.count; i++) {
                    if (Math.trunc(lyricView.model.get(i).time / 500) === Math.trunc(player.position / 500)) {
                        lyricView.currentIndex = i
                        break
                    }
                }
        }
    }

    TopToolbar {
        id: topToolbar
        z: 2
    }

    RowLayout {
        anchors.top: topToolbar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomToolbar.top
        spacing: 0
        Rectangle {
            id: leftListView
            z: 2
            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: window.width / 5
            Layout.fillHeight: true
            color: "#ffffff"
            Rectangle {
                z: 2
                width: parent.width
                height: 50
                Button {
                    anchors.fill: parent
                    visible: !userProfile.logined
                    text: qsTr("登录")
                    onReleased: {
                        loginPage.open()
                    }
                }
                Image {
                    id: avatar
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    width: 45
                    height: 45
                    source: userProfile.avatarUrl
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: 45
                            height: 45
                            radius: 22.5
                        }
                    }
                }
                Text {
                    id: user_name_text
                    anchors.left: avatar.right
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: userProfile.name
                }
            }

            Flickable {
                y: 54
                height: parent.height - 50
                width: parent.width
                flickableDirection: Flickable.VerticalFlick
                contentHeight: (myPlaylistView.model.count + subscribedPlaylistView.model.count) * 50 + 70
                contentWidth: width
                Component.onCompleted: {
                    var userPlaylist = neteaseAPI.userPlaylist(userProfile.id)
                    if (userPlaylist !== "") {
                        var json = JSON.parse(userPlaylist)
                        var playlists = json.playlist
                        for (var playlist in playlists) {
                            if (!playlists[playlist].subscribed) {
                                myPlaylistView.model.append({
                                                    "id": playlists[playlist].id,
                                                    "name": playlists[playlist].name,
                                                    "trackCount": playlists[playlist].trackCount,
                                                    "coverUrl": playlists[playlist].coverImgUrl,
                                                  })
                            } else {
                                subscribedPlaylistView.model.append({
                                                              "id": playlists[playlist].id,
                                                              "name": playlists[playlist].name,
                                                              "trackCount": playlists[playlist].trackCount,
                                                              "coverUrl": playlists[playlist].coverImgUrl,
                                                          })
                            }
                        }
                    }
                }
                Column {
                    id: left_column
                    anchors.fill: parent
                    spacing: 5

                    MouseArea {
                            width: parent.width
                            height: 50
                            Component.onCompleted: {
                                var recordRecentSong = neteaseAPI.recordRecentSong("300")
                                if (recordRecentSong !== "") {
                                    var json = JSON.parse(recordRecentSong)
                                    recentSongCountText.text = json.data.total.toString() + qsTr("首")
                                }
                            }

                            onReleased: {
                                if (stackView.currentItem.objectName === "recentSongPlaylistPage") {
                                    stackView.replace(recentSongPlaylistPage)
                                }
                                else {
                                    stackView.push(recentSongPlaylistPage)
                                }
                            }

                            Image {
                                id: recentSongCover
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: 45
                                height: 45
                                source: "images/historical_music_icon.svg"
                                anchors.leftMargin: 12
                            }
                            Text {
                                anchors.left: recentSongCover.right
                                verticalAlignment: Text.AlignBottom
                                lineHeight: 0.8
                                anchors.leftMargin: 10
                                width: parent.width - 75
                                height: 35
                                wrapMode: Text.WordWrap
                                font.pointSize: 11
                                text: qsTr("最近播放")
                                elide: Text.ElideRight
                                clip: true
                                color: "#000000"
                            }
                            Text {
                                id: recentSongCountText
                                anchors.left: recentSongCover.right
                                y: 38
                                verticalAlignment: Text.AlignBottom
                                font.pointSize: 8
                                anchors.leftMargin: 10
                                width: parent.width - 75
                                height: 10
                                color: "#9f000000"
                                text: ""
                            }
                        }

                    Text {
                        width: parent.width - 20
                        height: 15
                        color: "#8e8e8e"
                        text: qsTr("我的歌单")
                        verticalAlignment: Text.AlignBottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        Rectangle {
                            width: parent.width
                            height: 0.8
                            color: "#acacac"
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    MyPlaylistView {
                        id: myPlaylistView
                        model: ListModel {
                            id: myPlaylist
                        }
                    }
                    Text {
                        width: parent.width - 20
                        height: 35
                        color: "#8e8e8e"
                        text: qsTr("收藏的歌单")
                        verticalAlignment: Text.AlignBottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        Rectangle {
                            width: parent.width
                            height: 0.8
                            color: "#acacac"
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    SubscribedPlaylistView {
                        id: subscribedPlaylistView
                        model: ListModel {
                            id: subscribedPlaylist
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.maximumWidth: 3
            Layout.minimumWidth: 3
            Layout.preferredWidth: 3
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            color: "red"
        }

        StackView {
            id: stackView
            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: 500
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: initPage
            Component {
                id: initPage
                Rectangle {
                    objectName: "initPage"
                }
            }
            Component {
                id: playlistPage
                PlaylistPage {
                    objectName: "playlistPage"
                }
            }
            Component {
                id: recentSongPlaylistPage
                RecentSongPlaylistPage {
                    objectName: "recentSongPlaylistPage"
                }
            }
            Component {
                id: searchPage
                SearchPage {
                    objectName: "searchPage"
                }
            }
        }

        Rectangle {
            Layout.maximumWidth: 3
            Layout.minimumWidth: 3
            Layout.preferredWidth: 3
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            color: "red"
        }

        Rectangle {
            id: songPage
            Layout.minimumWidth: 200
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            ListView {
                id: lyricView
                anchors.fill: parent
                anchors.rightMargin: 40
                anchors.leftMargin: 40
                spacing: 10
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: height / 2
                preferredHighlightEnd: height / 2
                property bool hasLyric: false
                property bool hasTranslatedLyric: false
                property bool hasRomanianLyric: false
                property bool autoScroll: false
                model: ListModel {}
                delegate: Column {
                    id: lyricColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: originalLyricText.contentHeight + translatedLyricText.contentHeight + romanianLyricText.contentHeight
                    Text {
                        id: originalLyricText
                        visible: lyricView.hasLyric
                        anchors.left: parent.left
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 0.9
                        height: contentHeight
                        wrapMode: Text.WordWrap
                        font.pointSize: 10
                        text: originalLyric
                    }
                    Text {
                        id: translatedLyricText
                        visible: lyricView.hasTranslatedLyric
                        anchors.left: parent.left
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 0.9
                        height: contentHeight
                        wrapMode: Text.WordWrap
                        font.pointSize: 10
                        text: translatedLyric
                    }
                    Text {
                        id: romanianLyricText
                        visible: lyricView.hasRomanianLyric
                        anchors.left: parent.left
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 0.9
                        height: contentHeight
                        wrapMode: Text.WordWrap
                        font.pointSize: 10
                        text: romanianLyric
                    }
                }
            }
        }

    }




    BottomToolbar {
        id: bottomToolbar
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: 80
    }

    LoginPage {
        id: loginPage
        x: (window.width - width) / 2
        y: (window.height - height) / 2
    }
    BannedToast {
        id: bannedToast
        x: (window.width - width) / 2
        y: (window.height - height) / 2
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.2}
}
##^##*/

