import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

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
