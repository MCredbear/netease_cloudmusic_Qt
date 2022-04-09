import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

//qml files in the same qrc directory needn't(shouldn't) import

Window {
    id: window
    width: 1000  // @disable-check M16
    height: 500  // @disable-check M16
    visible: true // @disable-check M16
    title: qsTr("网易云音乐")  // @disable-check M16
    color: "#eeeeee"
    DropShadow {
        z: 9
        anchors.fill: top_toolbar
        source: top_toolbar
        samples: radius*2
        radius: 40
        spread: 0.1
        color: "#000000"
    }
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

    Rectangle {
        anchors.left: parent.left
        anchors.top: top_toolbar.bottom
        anchors.bottom: bottom_toolbar.top
        width: window.width/5
        Flickable {
            anchors.fill: parent
            contentHeight: left_column.height
            contentWidth: width

            Column {
                id: left_column
                width: parent.width
                height: children.height
                Button {
                    width: parent.width
                    height: 50
                    text: qsTr("登录")
                    onReleased: {
                        login_page.open()
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 100
                    color: "#00000000"
                }
                LeftColumnButton {

                }
            }
        }
    }
    ToolBar {
        id: bottom_toolbar
        z: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        width: parent.width
        height: 80
        background: Rectangle {
            color: "#ffffff"
        }
        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 3
            color: "red"
        }
        Button {
            id: play_button
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            text: "play"
        }
        Button {
            id: previous_button
            anchors.right: play_button.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            text: "pre"
        }
        Button {
            id: next_button
            anchors.left: play_button.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            text: "next"
        }
        Button {
            id: playlist_button
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            text: "repeat"
        }
        Button {
            id: repeat_method_button
            anchors.right: playlist_button.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            text: "playlist"
        }
        Text {
            id: song_name_text
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "Name"
        }
        Text {
            id: artist_name_text
            anchors.left: song_name_text.left
            anchors.top: song_name_text.bottom
            text: "artist"
        }
    }
    LoginPage {
        id: login_page
        x: (window.width-width)/2
        y: (window.height-height)/2
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}D{i:4}D{i:3}D{i:5}D{i:6}D{i:7}D{i:8}D{i:1}D{i:9}
}
##^##*/
