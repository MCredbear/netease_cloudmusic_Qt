import QtQuick 6.2
import QtQuick.Window 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 1.15

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
        x: 0
        anchors.top: playlistInformation.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.topMargin: 0
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
                        console.log(lyric)
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
                            if (/*lyricVersion === 1 | */lyricVersion === 0) {
                                lyricView.hasLyric = false
                                lyricView.autoScroll = false
                                lyricView.model.clear()
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
