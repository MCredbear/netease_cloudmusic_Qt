import QtQuick 6.2
import QtQuick.Window 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 1.15
import "player.js" as Player

Rectangle {
    property string keyword
    TabBar {
        id: tabBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 30
        currentIndex: swipeView.currentIndex
        background: Rectangle {
            color: "transparent"
        }

        TabButton {
            text: qsTr("歌曲")
            anchors.top: parent.top
            height: 30
            background: Rectangle {
                color: "transparent"
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    height: 15
                    width: 1
                    color: "black"
                }
            }
        }
        TabButton {
            text: qsTr("歌手")
            anchors.top: parent.top
            height: 30
            background: Rectangle {
                color: "transparent"
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    height: 15
                    width: 1
                    color: "black"
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    height: 15
                    width: 1
                    color: "black"
                }
            }
        }
        TabButton {
            text: qsTr("专辑")
            anchors.top: parent.top
            height: 30
            background: Rectangle {
                color: "transparent"
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    height: 15
                    width: 1
                    color: "black"
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    height: 15
                    width: 1
                    color: "black"
                }
            }
        }
        TabButton {
            text: qsTr("歌单")
            anchors.top: parent.top
            height: 30
            background: Rectangle {
                color: "transparent"
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    height: 15
                    width: 1
                    color: "black"
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    height: 15
                    width: 1
                    color: "black"
                }
            }
        }
        TabButton {
            text: qsTr("电台")
            anchors.top: parent.top
            height: 30
            background: Rectangle {
                color: "transparent"
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    height: 15
                    width: 1
                    color: "black"
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    height: 15
                    width: 1
                    color: "black"
                }
            }
        }
        TabButton {
            text: qsTr("歌词")
            anchors.top: parent.top
            height: 30
            background: Rectangle {
                color: "transparent"
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    height: 15
                    width: 1
                    color: "black"
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    height: 15
                    width: 1
                    color: "black"
                }
            }
        }
        TabButton {
            text: qsTr("用户")
            anchors.top: parent.top
            height: 30
            background: Rectangle {
                color: "transparent"
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    height: 15
                    width: 1
                    color: "black"
                }
            }
        }
    }

    Rectangle {
        id: indicator
        z: 2
        x: (swipeView.width / swipeView.count - width) / 2
           + swipeView.currentIndex * (swipeView.width / swipeView.count)
        anchors.bottom: tabBar.bottom
        width: swipeView.width / swipeView.count - 20
        height: 2
        radius: 1
        color: "red"
        Behavior on x {
            NumberAnimation {
                duration: 150
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        currentIndex: tabBar.currentIndex

        ListView {
            id: songView
            Component.onCompleted: {
                var search = neteaseAPI.search(keyword, "1", "30", "0")
                if (search !== "") {
                    var json = JSON.parse(search)
                    var songs = json.result.songs
                    var idList = []
                    var song
                    for (song in songs) {
                        idList.push(songs[song].id)
                        //                        var _id = songs[song].id
                        //                        var _name = songs[song].name
                        //                        var artist = ""
                        //                        for (var _artist in songs[song].artists)
                        //                            artist += "/" + songs[song].artists[_artist].name
                        //                        artist = artist.substr(1)
                        //                        var alia = ""
                        //                        for (var _alia in songs[song].alia)
                        //                            alia += songs[song].alia[_alia]
                        //                        if (songs[song].hasOwnProperty("tns"))
                        //                            for (var tn in songs[song].tns)
                        //                                alia += songs[song].tns[tn]
                        //                        var album = songs[song].album.name
                        //                        var cover = songs[song].album.artist.img1v1Url
                        //                        model.append({
                        //                                            "id": _id,
                        //                                            "name": _name,
                        //                                            "artist": artist,
                        //                                            "alia": alia,
                        //                                            "album": album,
                        //                                            "cover": cover
                        //                                        })
                    }
                    var songDetail = neteaseAPI.songDetail(idList)
                    json = JSON.parse(songDetail)
                    songs = json.songs
                    for (song in songs) {
                        var _id = songs[song].id
                        var _name = songs[song].name
                        var artist = ""
                        for (var _artist in songs[song].ar)
                            artist += "/" + songs[song].ar[_artist].name
                        artist = artist.substr(1)
                        var alia = ""
                        for (var _alia in songs[song].alia)
                            alia += songs[song].alia[_alia]
                        if (songs[song].hasOwnProperty("tns"))
                            for (var tn in songs[song].tns)
                                alia += songs[song].tns[tn]
                        var album = songs[song].al.name
                        var cover = songs[song].al.picUrl
                        model.append({
                                         "id": _id,
                                         "name": _name,
                                         "artist": artist,
                                         "alia": alia,
                                         "album": album,
                                         "cover": cover
                                     })
                    }

                }
            }

            model: ListModel {}
            delegate: MouseArea {
                width: songView.width
                height: 45
                onReleased: {
                    Player.play(id)
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
                        text: (alia === "") ? "" : qsTr("（") + alia + qsTr("）")
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
        Rectangle {
            color: "red"
        }
        Rectangle {
            color: "white"
        }
        Item {}
        Item {}
        Item {}
        Item {}
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.5;height:480;width:640}
}
##^##*/

