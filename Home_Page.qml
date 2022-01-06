import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

Item {

    Rectangle {
        id: fixed_layout
        z: 9
        width: parent.width
        height: parent.height/2
        color: Material.background
        layer.enabled: true
        layer.effect: ElevationEffect {
            elevation: 4
        }
        Column {
            anchors.fill: parent
            Button {
                id: user_profile_layout
                z: 2
                width: parent.width
                height: profile_photo.y*2+profile_photo.height
                onReleased: {
                    stack.push(login_page)
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
                    source: "image/image/unlogined.svg"
                    fillMode: Image.PreserveAspectCrop
                }
                Text {
                    id: user_name
                    x: profile_photo.x*2+profile_photo.width
                    y: profile_photo.y+profile_photo.height-height
                    width: side_drawer.width-profile_photo.x-x
                    height: profile_photo.height*1.2
                    color: Material.foreground
                    text: qsTr("未登录")
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignBottom
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: 15
                }
            }


            Rectangle { // a space
                width: parent.width
                height: 4
                color: "#00000000"
            }

            Fixed_Button {
                id: local_music
                height: (parent.height-user_profile_layout.height-4)/4
                Text {
                    text: qsTr("本地音乐")
                    font.pointSize: 20
                    color: Material.foreground
                }
            }
            Fixed_Button {
                id: historical_music
                height: (parent.height-user_profile_layout.height-4)/4
                Text {
                    text: qsTr("最近播放")
                    font.pointSize: 20
                    color: Material.foreground
                }
            }
            Fixed_Button {
                id: clouddrive_music
                height: (parent.height-user_profile_layout.height-4)/4
                Text {
                    text: qsTr("云盘")
                    font.pointSize: 20
                    color: Material.foreground
                }
            }
            Fixed_Button {
                id: downloaded_music //downloaded,but in this app's own directory
                height: (parent.height-user_profile_layout.height-4)/4
                Text {
                    text: qsTr("已下载音乐")
                    font.pointSize: 20
                    color: Material.foreground
                }
            }
        }
    }
}
