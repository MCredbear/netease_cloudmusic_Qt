import QtQuick 6.2
import QtQuick.Window 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 1.15

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
        x: (swipeView.width / swipeView.count - width) / 2 + swipeView.currentIndex * (swipeView.width / swipeView.count)
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
                    console.log(search)
                    var songs = json.result.songs
                    for (var song in songs) {
                        var _id = songs[song].id
                        var _name = songs[song].name
                        var artist = ""
                        for (var _artist in songs[song].artists)
                            artist += "/" + songs[song].artists[_artist].name
                        artist = artist.substr(1)
                        var alia = ""
                        for (var _alia in songs[song].alia)
                            alia += songs[song].alia[_alia]
                        if (songs[song].hasOwnProperty("tns"))
                            for (var tn in songs[song].tns)
                                alia += songs[song].tns[tn]
                        var album = songs[song].album.name
                        var cover = songs[song].album.artist.img1v1Url
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
                                    for (var n in lyricModel) {
                                        lyricView.model.append({
                                            "time": lyricModel[n].time,
                                            "originalLyric": lyricModel[n].originalLyric,
                                            "translatedLyric": lyricView.hasTranslatedLyric? lyricModel[n].translatedLyric : "",
                                            "romanianLyric": lyricView.hasRomanianLyric? lyricModel[n].romanianLyric : ""
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
        Item {

        }
        Item {

        }
        Item {

        }
        Item {

        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.5;height:480;width:640}
}
##^##*/
