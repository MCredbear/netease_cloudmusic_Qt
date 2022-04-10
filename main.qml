import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15
import QtGraphicalEffects 1.15



Window {
    id: window
    width: 1000  // @disable-check M16
    height: 500  // @disable-check M16
    visible: true // @disable-check M16
    title: qsTr("网易云音乐")  // @disable-check M16
    color: "#eeeeee"

    Component.onCompleted: {
        var userAccount = neteaseAPI.userAccount()
        if (userAccount !== "") {
            var json = JSON.parse(userAccount)
            userProfile = {
                logined : true,
                id : json.profile.userId.toString(),
                name : json.profile.nickname,
                avatarUrl : json.profile.avatarUrl
            }
        }
    }

    property var userProfile : {
        'logined': false,
        'name': "",
        'id': "",
        'avatarUrl': ""
    } //与js不同，这不是键值对

    Audio {
        id: player
    }

//    DropShadow {
//        z: 9
//        anchors.fill: top_toolbar
//        source: top_toolbar
//        samples: radius*2
//        radius: 40
//        spread: 0.1
//        color: "#000000"
//    } 节约内（显）存，换成一条线罢
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
        anchors.right: parent.right
        anchors.top: top_toolbar.bottom
        anchors.bottom: bottom_toolbar.top
        color: "grey"
        Rectangle {
            id: playlistInformation
            anchors.top: parent.top
            width: parent.width
            height: 100
            color: "white"
            Text {
                id: playlistName
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 20
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
                width: playlistView.width
                height: 30
                onReleased: {
                    var songUrl = neteaseAPI.songUrl(id)
                    if (songUrl !== "") {
                        var json = JSON.parse(songUrl)
                        if (json.code === 500) {
                            bannedToast.open()
                        }
                        else {
                            player.source = json.data[0].url
                            player.play()
                        }
                    }
                }

                Text {
                    id: songName
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: name
                }
                Text {
                    id: songAlia
                    anchors.left: songName.right
                    anchors.leftMargin: 2
                    text: alia
                }
                Text {
                    id: songArtist
                    anchors.left: songAlia.right
                    anchors.leftMargin: 5
                    text: artist
                }
                Text {
                    id: songAlbum
                    anchors.left: songArtist.right
                    anchors.leftMargin: 2
                    text: album
                }
            }
        }

    }

    Rectangle {
        id: leftListView
        anchors.left: parent.left
        anchors.top: top_toolbar.bottom
        anchors.bottom: bottom_toolbar.top
        width: window.width/5
        Rectangle {
            z: 3
            anchors.right: parent.right
            width: 3
            height: parent.height
            color: "red"
        }

        Flickable {
            anchors.fill: parent
            contentHeight: 50 + myPlaylistView.contentHeight + subscribedPlaylistView.contentHeight
            contentWidth: width
            Component.onCompleted: {
                var userPlaylist = neteaseAPI.userPlaylist(userProfile.id)
                if (userPlaylist !== "") {
                    var json = JSON.parse(userPlaylist)
                    var playlists = json.playlist
                    for (var playlist in playlists) {
                        if (!playlists[playlist].subscribed) {
                            myPlaylist.append(
                                        {
                                            "id": playlists[playlist].id,
                                            "name": playlists[playlist].name,
                                            "coverUrl": playlists[playlist].coverImgUrl
                                        }
                            )
                        }
                        else {
                            subscribedPlaylist.append(
                                        {
                                            "id": playlists[playlist].id,
                                            "name": playlists[playlist].name,
                                            "coverUrl": playlists[playlist].coverImgUrl
                                        }
                            )
                        }
                    }
                }
            }
            Column {
                id: left_column
                width: parent.width
                height: children.height
                Rectangle {
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
                        anchors.verticalCenter: parent.verticalCenter
                        width: 50
                        height: 50
                        source: userProfile.avatarUrl
                    }
                    Text {
                        id: user_name_text
                        anchors.left: avatar.right
                        anchors.leftMargin: 5
                        anchors.verticalCenter: parent.verticalCenter
                        text: userProfile.name
                    }
                }

                ListView {
                    id: myPlaylistView
                    width: parent.width
                    height: model.count * 50
                    interactive: false
                    model: ListModel {
                        id: myPlaylist
                    }
                    delegate: MouseArea {
                        width: parent.width
                        height: 50
                        onReleased: {
                            playlistName.text = name
                            playlist.clear()
                            var playlistDetail = neteaseAPI.playlistDetail(id)
                            if (playlistDetail !== "") {
                                var json = JSON.parse(playlistDetail)
                                var tracks = json.playlist.tracks
                                for (var song in tracks) {
                                    var _id = tracks[song].id
                                    var _name = tracks[song].name
                                    var artist = ""
                                    for (var _artist in tracks[song].ar) artist += "/" + tracks[song].ar[_artist].name
                                    artist = artist.substr(1)
                                    var alia = ""
                                    for (var _alia in tracks[song].alia) alia += tracks[song].alia[_alia]
                                    if (tracks[song].hasOwnProperty("tns"))
                                        for (var tn in tracks[song].tns) alia +=  tracks[song].tns[tn]
                                    var album = tracks[song].al.name
                                    playlist.append(
                                                {
                                                    "id": _id,
                                                    "name": _name,
                                                    "artist": artist,
                                                    "alia": alia,
                                                    "album": album
                                                }
                                    )
                                }
                            }
                        }

//                        Image {
//                            anchors.left: parent.left
//                            anchors.verticalCenter: parent.verticalCenter
//                            width: 50
//                            height: 50
//                            source: coverUrl
//                        }
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 10
                            height: 50
                            wrapMode: Text.WordWrap
                            text: name
                        }
                    }
                }
                ListView {
                    id: subscribedPlaylistView
                    width: parent.width
                    height: model.count * 50
                    interactive: false
                    model: ListModel {
                        id: subscribedPlaylist
                    }
                    delegate: MouseArea {
                        width: parent.width
                        height: 50
                        onReleased: {
                            playlistName.text = name
                            playlist.clear()
                            var playlistDetail = neteaseAPI.playlistDetail(id)
                            if (playlistDetail !== "") {
                                var json = JSON.parse(playlistDetail)
                                var tracks = json.playlist.tracks
                                for (var song in tracks) {
                                    var _id = tracks[song].id
                                    var _name = tracks[song].name
                                    var artist = ""
                                    for (var _artist in tracks[song].ar) artist += "/" + tracks[song].ar[_artist].name
                                    artist = artist.substr(1)
                                    var alia = ""
                                    for (var _alia in tracks[song].alia) alia += tracks[song].alia[_alia]
                                    if (tracks[song].hasOwnProperty("tns"))
                                        for (var tn in tracks[song].tns) alia +=  tracks[song].tns[tn]
                                    var album = tracks[song].al.name
                                    playlist.append(
                                                {
                                                    "id": _id,
                                                    "name": _name,
                                                    "artist": artist,
                                                    "alia": alia,
                                                    "album": album
                                                }
                                    )
                                }
                            }
                        }

//                        Image {
//                            anchors.left: parent.left
//                            anchors.verticalCenter: parent.verticalCenter
//                            width: 50
//                            height: 50
//                            source: coverUrl
//                        }
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 10
                            height: 50
                            wrapMode: Text.WordWrap
                            text: name
                        }
                    }
                }
            }
        }
    }
    BottomToolbar {
        id: bottom_toolbar
    }

    LoginPage {
        id: login_page
        x: (window.width-width)/2
        y: (window.height-height)/2
    }
    BannedToast {
        id: bannedToast
        x: (window.width-width)/2
        y: (window.height-height)/2
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}D{i:4}D{i:3}D{i:5}D{i:6}D{i:7}D{i:8}D{i:1}D{i:9}
}
##^##*/
