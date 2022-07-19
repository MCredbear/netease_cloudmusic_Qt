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

    // Button {
    //     z: 4
    //     x: 200
    //     y: 200
    //     width: 50
    //     height: 50
    //     onReleased: {
    //         var loginQRKey = neteaseAPI.loginQRKey()
    //         var json = JSON.parse(loginQRKey)
    //         var key = json.unikey
    //         console.log(key)
    //         qrImage.source = "image://qrImage/" + key

    //     }
    //     Image {
    //         id: qrImage
    //         anchors.fill: parent

    //     }
    // }
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

    Rectangle {
        z: 11
        anchors.bottom: top_toolbar.bottom
        width: top_toolbar.width
        height: 3
        color: "red"
    }

    TopToolbar {
        id: top_toolbar
    }

    Rectangle {
        id: playlistPage
        anchors.left: leftListView.right
        //anchors.right: songPage.left
        anchors.top: top_toolbar.bottom
        anchors.bottom: bottom_toolbar.top
        width: 500
        color: "grey"
        Rectangle {
            id: playlistInformation
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 100
            color: "white"
            RowLayout {
                anchors.fill: parent
                anchors.rightMargin: 15
                anchors.leftMargin: 15
                anchors.bottomMargin: 15
                anchors.topMargin: 15
                spacing: 15
                Rectangle {
                    id: rectangle
                    color: "transparent"
                    Layout.minimumWidth: Math.max(
                                             playlistName.contentWidth + height + 15,
                                             playlistTrackCount.contentWidth + height + 15)
                    Layout.preferredHeight: parent.height
                    Material_Image {
                        id: playlistCover
                        width: height
                        height: parent.height
                        elevation: 4
                        radius: 2
                    }
                    Text {
                        id: playlistName
                        anchors.left: playlistCover.right
                        anchors.top: parent.top
                        anchors.leftMargin: 15
                        font.pointSize: 20
                    }
                    Text {
                        id: playlistTrackCount
                        anchors.left: playlistCover.right
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 15
                        verticalAlignment: Text.AlignBottom
                        font.pointSize: 12
                        color: "#888888"
                    }
                }
                Column {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    Text {
                        id: playlistCreatorName
                        width: parent.width
                        color: "#5e5e5e"
                        elide: Text.ElideRight
                        font.pointSize: 11
                    }
                    Text {
                        id: playlistDescription
                        width: parent.width
                        height: parent.height - playlistCreatorName.contentHeight
                        color: "#5e5e5e"
                        elide: Text.ElideRight
                        lineHeight: 0.8
                        wrapMode: Text.Wrap
                        font.pointSize: 9
                    }
                }
            }
        }
        ListView {
            id: playlistView
            anchors.top: playlistInformation.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true
            model: ListModel {
                id: playlist
            }
            delegate: MouseArea {
                id: mouseArea
                width: playlistView.width
                height: 45
                onReleased: {
                    var songUrl = neteaseAPI.songUrl(id)
                    if (songUrl !== "") {
                        var json = JSON.parse(songUrl)
                        if (json.code === 500) {
                            bannedToast.open()
                        } else {
                            player.source = json.data[0].url
                            player.play()
                            var lyric = neteaseAPI.lyric(id)
                            if (lyric !== "") {
                                const lyricElement = {
                                    "time": 0, // millisecond
                                    "originalLyric": "",
                                    "translatedLyric": "",
                                    "romanianLyric": ""
                                }
                                const tiArAlByExpression = /^\[(ti|ar|al|by):(.*)\]$/
                                const lyricExpression = /^\[(\d{2}):(\d{2}).(\d{2}|\d{3})\](.*)/
                                var lyricJson = JSON.parse(lyric)
                                var lyricVersion = lyricJson.lrc.version
                                if (lyricVersion === 1 | lyricVersion === 0) {
                                    lyricView.hasLyric = false
                                    lyricView.autoScroll = false
                                }
                                else {
                                    lyricView.hasLyric = true
                                    lyricView.autoScroll = true // I don't know the format of unautoscrollable lyric yet
                                    var originalLyric = lyricJson.lrc.lyric
                                    var translatedLyric = lyricJson?.tlyric?.lyric ?? ""
                                    var romanianLyric = lyricJson?.romalrc?.lyric ?? ""
                                    var result
                                    var originalLyricModel = originalLyric.split("\n")
                                    .filter(function(value){
                                        return !(value.match(tiArAlByExpression) !== null | value.trim() === "" | ((value.match(lyricExpression) !== null) ? (value.match(lyricExpression)[4].trim() === "") : false))
                                    })
                                    .map(function(value){
//                                        if ((result = value.match(lyricExpression)) !== null) {
                                        result = value.match(lyricExpression)
                                            return {
                                                "time": Number(result[1]) * 60 * 1000 + Number(result[2]) * 1000 + ((result[3].length > 2) ? Number(result[3]) : Number(result[3]) * 10),
                                                "originalLyric": result[4]
                                            }
//                                        }
                                    })
                                    var translatedLyricModel = translatedLyric.split("\n")
                                    .filter(function(value){
                                        return !(value.match(tiArAlByExpression) !== null | value.trim() === "" | ((value.match(lyricExpression) !== null) ? (value.match(lyricExpression)[4].trim() === "") : false))
                                    })
                                    .map(function(value){
//                                        if ((result = value.match(lyricExpression)) !== null) {
                                        result = value.match(lyricExpression)
                                            return {
                                                "time": Number(result[1]) * 60 * 1000 + Number(result[2]) * 1000 + ((result[3].length > 2) ? Number(result[3]) : Number(result[3]) * 10),
                                                "translatedLyric": result[4]
                                            }
//                                        }
                                    })
                                    if (translatedLyricModel.length > 0) lyricView.hasTranslatedLyric = true
                                        else lyricView.hasTranslatedLyric = false
                                    var romanianLyricModel = romanianLyric.split("\n")
                                    .filter(function(value){
                                        return !(value.match(tiArAlByExpression) !== null | value.trim() === "" | ((value.match(lyricExpression) !== null) ? (value.match(lyricExpression)[4].trim() === "") : false))
                                    })
                                    .map(function(value){
//                                        if ((result = value.match(lyricExpression)) !== null) {
                                        result = value.match(lyricExpression)
                                            return {
                                                "time": Number(result[1]) * 60 * 1000 + Number(result[2]) * 1000 + ((result[3].length > 2) ? Number(result[3]) : Number(result[3]) * 10),
                                                "romanianLyric": result[4]
                                            }
//                                        }
                                    })
                                    if (romanianLyricModel.length > 0) lyricView.hasRomanianLyric = true
                                        else lyricView.hasRomanianLyric = false
                                    var lyricModel = []
                                    for (var i in originalLyricModel) {
                                        var _translatedLyric = ""
                                        var _romanianLyric = ""
                                        for (var j in translatedLyricModel) if (translatedLyricModel[j].time === originalLyricModel[i].time) {
                                                                                                                                        _translatedLyric = translatedLyricModel[j].translatedLyric
                                                                                                                                        break
                                                                                                                                        }
                                        for (var k in romanianLyricModel) if (romanianLyricModel[k].time === originalLyricModel[i].time) {
                                                                                                                                        _romanianLyric = romanianLyricModel[k].romanianLyric
                                                                                                                                        break
                                                                                                                                        }
                                        lyricModel.push({
                                                        "time": originalLyricModel[i].time,
                                                        "originalLyric": originalLyricModel[i].originalLyric,
                                                        "translatedLyric": _translatedLyric,
                                                        "romanianLyric": _romanianLyric
                                        })
                                    }
                                    lyricView.model.clear()
                                    for (var i in lyricModel) {
                                        lyricView.model.append({
                                            "time": lyricModel[i].time,
                                            "originalLyric": lyricModel[i].originalLyric,
                                            "translatedLyric": lyricView.hasTranslatedLyric? lyricModel[i].translatedLyric : "",
                                            "romanianLyric": lyricView.hasRomanianLyric? lyricModel[i].romanianLyric : ""
                                        })
                                    }
                                }
                            }
                        }
                    }
                }

                Material_Image {
                    id: songCover
                    width: height
                    radius: 2
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    source: cover
                    elevation: 2
                    anchors.leftMargin: 5
                    anchors.bottomMargin: 5
                    anchors.topMargin: 5
                }

                RowLayout {
                    anchors.left: songCover.right
                    anchors.leftMargin: 5
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    height: 20
                    Text {
                        id: songName
                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: contentWidth
                        text: name
                        elide: Text.ElideRight
                        font.pointSize: 12
                    }
                    Text {
                        id: songAlia
                        color: "#424242"
                        Layout.preferredHeight: parent.height
                        Layout.fillWidth: true
                        text: (alia == "") ? "" : qsTr("（") + alia + qsTr("）")
                        elide: Text.ElideRight
                        font.pointSize: 12
                    }
                }
                RowLayout {
                    anchors.left: songCover.right
                    anchors.leftMargin: 5
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    spacing: 0
                    anchors.bottomMargin: 10
                    height: 10
                    Text {
                        id: songArtist
                        color: "#424242"
                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: contentWidth
                        text: artist
                        elide: Text.ElideRight
                    }
                    Text {
                        id: songAlbum
                        color: "#424242"
                        Layout.preferredHeight: parent.height
                        Layout.fillWidth: true
                        text: qsTr(" - ") + album
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    Rectangle {
        id: songPage
        anchors.left: playlistPage.right
        anchors.right: parent.right
        anchors.top: top_toolbar.bottom
        anchors.bottom: bottom_toolbar.top
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

    Rectangle {
        id: leftListView
        anchors.left: parent.left
        anchors.top: top_toolbar.bottom
        anchors.bottom: bottom_toolbar.top
        width: window.width / 5
        color: "#ffffff"
        Rectangle {
            z: 3
            anchors.right: parent.right
            width: 3
            height: parent.height
            color: "red"
        }

        Rectangle {
            z: 2
            width: parent.width
            height: 50
            Button {
                anchors.fill: parent
                visible: !userProfile.logined
                text: qsTr("登录")
                onReleased: {
                    login_page.open()
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
                                                "creatorName": playlists[playlist].creator.nickname,
                                                "creatorId": playlists[playlist].creator.userId,
                                                "description": playlists[playlist].description ?? ""
                                              })
                        } else {
                            subscribedPlaylistView.model.append({
                                                          "id": playlists[playlist].id,
                                                          "name": playlists[playlist].name,
                                                          "trackCount": playlists[playlist].trackCount,
                                                          "coverUrl": playlists[playlist].coverImgUrl,
                                                          "creatorName": playlists[playlist].creator.nickname,
                                                          "creatorId": playlists[playlist].creator.userId,
                                                          "description": playlists[playlist].description ?? ""
                                                      })
                        }
                    }
                }
            }
            Column {
                id: left_column
                anchors.fill: parent
                spacing: 5
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
    BottomToolbar {
        id: bottom_toolbar
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
    }

    LoginPage {
        id: login_page
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
    D{i:0;formeditorZoom:0.33}
}
##^##*/

