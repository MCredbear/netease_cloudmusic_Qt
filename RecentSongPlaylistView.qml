import QtQuick 6.2
import QtQuick.Window 6.2
import QtQuick.Controls 6.2
import Qt5Compat.GraphicalEffects

ListView {
    id: recentSongPlaylistView
    width: parent.width
    height: model.count * 50
    interactive: false
    spacing: 2
    delegate: MouseArea {
        id: mouseArea
        width: parent.width
        height: 50
        onReleased: {
            playlistName.text = name
            playlistCover.source = coverUrl
            playlistTrackCount.text = trackCount.toString() + qsTr("首")
            playlistCreatorName.text = qsTr("创建者：") + creatorName
            playlistDescription.text = description
            playlist.clear()
            var playlistDetail = neteaseAPI.playlistDetail(id)
            if (playlistDetail !== "") {
                var json = JSON.parse(playlistDetail)
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

        Material_Image {
            id: cover
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 45
            height: 45
            source: coverUrl
            anchors.leftMargin: 12
            elevation: 2
            radius: 5
        }
        Text {
            anchors.left: cover.right
            verticalAlignment: Text.AlignBottom
            lineHeight: 0.8
            anchors.leftMargin: 10
            width: parent.width - 75
            height: 35
            wrapMode: Text.WordWrap
            font.pointSize: 11
            text: name
            elide: Text.ElideRight
            clip: true
            color: "#000000"
        }
        Text {
            anchors.left: cover.right
            y: 38
            verticalAlignment: Text.AlignBottom
            font.pointSize: 8
            anchors.leftMargin: 10
            width: parent.width - 75
            height: 10
            color: "#9f000000"
            text: trackCount.toString() + qsTr("首")
        }
    }
}
