import QtQuick 6.2
import QtQuick.Window 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 1.15
import "player.js" as Player

Rectangle {
    id: playlistPage
    color: "grey"
    property string id

    Component.onCompleted: {
        var playlistDetail = neteaseAPI.playlistDetail(id)
        if (playlistDetail !== "") {
            var json = JSON.parse(playlistDetail)
            playlistName.text = json.playlist.name
            playlistCreatorName.text = json.playlist.creator.nickname
            playlistDescription.text = json.playlist.description ?? ""
            playlistTrackCount.text = json.playlist.trackCount.toString() + qsTr("首")
            playlistCover.source = json.playlist.coverImgUrl
            var tracks = json.playlist.tracks
            for (var song in tracks) {
                var _id = tracks[song].id
                var _name = tracks[song].name
                var artist = ""
                for (var _artist in tracks[song].ar)
                    artist += "/" + tracks[song].ar[_artist].name
                artist = artist.substr(1)
                var alia = ""
                for (var _alia in tracks[song].alia)
                    alia += tracks[song].alia[_alia]
                if (tracks[song].hasOwnProperty("tns"))
                    for (var tn in tracks[song].tns)
                        alia += tracks[song].tns[tn]
                var album = tracks[song].al.name
                var cover = tracks[song].al.picUrl
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

    Rectangle {
        id: playlistInformation
        z: 2
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
        anchors.left: parent.left
        anchors.right: parent.right
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
}
