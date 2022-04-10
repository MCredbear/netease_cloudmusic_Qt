import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

ToolBar {
    id: top_toolbar
    z: 10
    anchors.top: parent.top
    anchors.topMargin: 0
    width: parent.width
    height: 80
    background: Rectangle {
        color: "#ffffff"
    }
    Image {
        id: icon
        width: 72
        height: 72
        anchors.verticalCenter: parent.verticalCenter
        source: "images/netease-cloud-music.svg"
        Label {
            anchors.left: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            text: qsTr("网易云音乐")
            font.pointSize: 20
        }
    }
    Rectangle {
        anchors.bottom: icon.bottom
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        width: window.width/5
        height: text_mask.contentHeight
        radius: 4
        color: "#dddddd"
        TextInput {
            id: search_input
            anchors.fill: parent
            font.pointSize: 18
            clip: true
        }
        TextInput { // Label's text has a position error
            id: text_mask
            anchors.fill: search_input
            text: qsTr("搜索")
            font.pointSize: 18
            color: "#bbbbbb"
            visible: search_input.length === 0 ? search_input.focus ? true : true : false
            readOnly: true
            enabled: false
        }
    }
}
