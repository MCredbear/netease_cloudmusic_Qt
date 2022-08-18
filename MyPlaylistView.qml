import QtQuick 6.2
import QtQuick.Window 6.2
import QtQuick.Controls 6.2
import Qt5Compat.GraphicalEffects

ListView {
    id: myPlaylistView
    width: parent.width
    height: model.count * 50
    interactive: false
    spacing: 2
    delegate: MouseArea {
        id: mouseArea
        width: parent.width
        height: 50
        onReleased: {
            if (stackView.currentItem.objectName === "playlistPage") {
                stackView.replace(playlistPage,{"id": id})
            }
            else {
                stackView.push(playlistPage,{"id": id})
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
