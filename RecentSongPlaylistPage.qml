import QtQuick 6.2
import QtQuick.Window 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 1.15
import "player.js" as Player

ListView {
    id: playlistView
    Component.onCompleted: {
        var recordRecentSong = neteaseAPI.recordRecentSong("300")
        if (recordRecentSong !== "") {
            var json = JSON.parse(recordRecentSong)
            var list = json.data.list
            for (var song in list) {
                var _id = list[song].data.id
                var _name = list[song].data.name
                var artist = ""
                for (var _artist in list[song].data.ar)
                    artist += "/" + list[song].data.ar[_artist].name
                artist = artist.substr(1)
                var alia = ""
                for (var _alia in list[song].data.alia)
                    alia += list[song].data.alia[_alia]
                if (list[song].hasOwnProperty("tns"))
                    for (var tn in list[song].data.tns)
                        alia += list[song].data.tns[tn]
                var album = list[song].data.al.name
                var cover = list[song].data.al.picUrl
                playlist.append({
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

    model: ListModel {
        id: playlist
    }
    delegate: MouseArea {
        id: mouseArea
        width: playlistView.width
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
