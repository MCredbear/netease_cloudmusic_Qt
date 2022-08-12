import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

ListView {
    id: subscribedPlaylistView
    width: parent.width
    height: model.count * 50
    interactive: false
    delegate: MouseArea {
        width: parent.width
        height: 50
        onReleased: {
            stackView.push(playlistPage,{"id": id})
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
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

