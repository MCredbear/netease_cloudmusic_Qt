import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.12

//qml files in the same qrc directory needn't(shouldn't) import
import QtQuick.Layouts 1.11

Window {
    id: window
    width: 300
    height: 600
    visible: true
    Material.theme: Material.Dark
    color: Material.backgroundColor
    title: qsTr("Netease Cloud Music")
    ToolBar {
        id: top_toolbar
        z: 10
        anchors.top: parent.top
        anchors.topMargin: 0
        width: parent.width
        height: 50
        Material.primary: Material.Red
        ToolButton {
            id: side_drawer_button
            anchors.left: parent.left
            anchors.leftMargin: 0
            text: "\u2261"
            font.pixelSize: 20
            onReleased: side_drawer.open()
        }
        Rectangle {
            anchors.bottom: search_bar.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 0
            width: search_bar.width
            height: 1.5
        }
        TextInput {
            id: text_mask
            anchors.fill: search_bar
            text: qsTr("搜索")
            font.pixelSize: 24
            readOnly: true
            visible: (search_bar.text == "")
            color: "#bbbbbb"
        }
        TextInput {
            id: search_bar
            anchors.horizontalCenter: parent.horizontalCenter
            y: 10
            width: parent.width*0.6
            height: 30
            color: "#ffffff"
            clip: true
            text: ""
            font.pixelSize: 24
        }
    }
    ToolBar {
        id: bottom_toolbar
        z: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        width: parent.width
        height: 50
        Material.primary: Material.Red
        background.rotation: 180 //I just want to turn the shade upside down
    }
    Drawer {
        id: side_drawer
        edge: Qt.LeftEdge
        width: window.width*0.6
        height: window.height
        Overlay.modal: Rectangle {
            color: "#88000000"
        }
        Button {
            id: user_profile_layout
            z: 2
            width: parent.width
            height: profile_photo.y*2+profile_photo.height

            onReleased: {


            }

            Rectangle {
                id: user_profile_layout_unlogged_mask
                visible: true
                z: 2
                anchors.fill: parent
                color: "#88000000"
                Text {
                    z: 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Material.foreground
                    text: qsTr("点击以登录")
                    font.pointSize: 20
                }
            }

            background: Rectangle {
                anchors.fill: parent
                color: !user_profile_layout.enabled ? user_profile_layout.Material.buttonDisabledColor :
                        user_profile_layout.highlighted ? user_profile_layout.Material.highlightedButtonColor : user_profile_layout.Material.backgroundColor
                radius: 0
                layer.enabled: user_profile_layout.enabled && user_profile_layout.Material.buttonColor.a > 0
                layer.effect: ElevationEffect {
                    elevation: user_profile_layout.pressed ? 2 : 4
                    fullWidth: true
                }

                Ripple {
                    clipRadius: 0
                    width: parent.width
                    height: parent.height
                    pressed: user_profile_layout.pressed
                    anchor: user_profile_layout
                    active: user_profile_layout.down || user_profile_layout.visualFocus || user_profile_layout.hovered
                    color: user_profile_layout.flat && user_profile_layout.highlighted ? user_profile_layout.Material.highlightedRippleColor : user_profile_layout.Material.rippleColor
                }
            }
            Image {
                id: profile_photo
                x: side_drawer.width/14
                y: x
                width: side_drawer.width/3.14
                height: width
                source: "http://himg.bdimg.com/sys/portrait/item/public.1.27f909f0.lizX-dyS3heXvAIwZYEXdw.jpg"
                fillMode: Image.PreserveAspectCrop
            }
            Text {
                id: user_name
                x: profile_photo.x*2+profile_photo.width
                y: profile_photo.y+profile_photo.height-height
                width: side_drawer.width-profile_photo.x-x
                height: profile_photo.height*1.2
                color: Material.foreground
                text: "用户名"
                elide: Text.ElideRight
                verticalAlignment: Text.AlignBottom
                wrapMode: Text.WrapAnywhere
                font.pointSize: 15
            }
        }
        Flickable {
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            Column {
                y: profile_photo.y*2+profile_photo.height
                width: parent.width
                height: parent.height-y
                spacing: 0
                Rectangle {
                    y: profile_photo.y*2+profile_photo.height
                    width: parent.width
                    height: 25
                    color: "#00000000"
                }
                Rectangle {
                    width: parent.width
                    height: 1.5
                    color: "#88ffffff"
                }
                Drawer_Button{

                }
                Rectangle {
                    width: parent.width
                    height: 1.5
                    color: "#88ffffff"
                }
                Drawer_Button{

                }
                Rectangle {
                    width: parent.width
                    height: 1.5
                    color: "#88ffffff"
                }
                Drawer_Button{

                }
                Rectangle {
                    width: parent.width
                    height: 1.5
                    color: "#88ffffff"
                }
                Drawer_Button{

                }
                Rectangle {
                    width: parent.width
                    height: 1.5
                    color: "#88ffffff"
                }
            }
        }
    }
    Rectangle {
        id: fixed_layout
        z: 9
        y: top_toolbar.height
        width: parent.width
        height: parent.height/3.14
        color: Material.background
        layer.enabled: true
        layer.effect: ElevationEffect {
            elevation: 4
        }
        Column {
            anchors.fill: parent
            Rectangle {
                width: parent.width
                height: 4
                color: "#00000000"
            }

            Fixed_Button {
                id: local_music
                height: (parent.height-4)/4
                Text {
                    text: qsTr("本地音乐")
                    font.pointSize: 20
                    color: Material.foreground
                }
                Image {
                    x: parent.width-parent.height
                    width: height
                    height: parent.height*0.8
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image/image/local_music_icon.svg"
                    anchors.rightMargin: 0
                }
            }
            Fixed_Button {
                id: historical_music
                height: (parent.height-4)/4
                Text {
                    text: qsTr("最近播放")
                    font.pointSize: 20
                    color: Material.foreground
                }
                Image {
                    x: parent.width-parent.height
                    width: height
                    height: parent.height*0.8
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image/image/historical_music_icon.svg"
                    anchors.rightMargin: 0
                }
            }
            Fixed_Button {
                id: clouddrive_music
                height: (parent.height-4)/4
                Text {
                    text: qsTr("云盘")
                    font.pointSize: 20
                    color: Material.foreground
                }
                Image {
                    x: parent.width-parent.height
                    width: height
                    height: parent.height*0.8
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image/image/clouddrive_music_icon.svg"
                    anchors.rightMargin: 0
                }
            }
            Fixed_Button {
                id: downloaded_music //downloaded,but in this app's own directory
                height: (parent.height-4)/4
                Text {
                    text: qsTr("已下载音乐")
                    font.pointSize: 20
                    color: Material.foreground
                }
                Image {
                    x: parent.width-parent.height
                    width: height
                    height: parent.height*0.8
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image/image/downloaded_music_icon.svg"
                    anchors.rightMargin: 0
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.0625}
}
##^##*/
