import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

Item {
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: window.width*0.1
        height: login_button.y+login_button.height
        width: window.width*0.8
        color: Material.primaryColor
        radius: 4
        layer.enabled: true
        layer.effect: ElevationEffect {
            elevation: 4
            fullWidth: true
            fullHeight: true
        }
        Column {
            id: column
            anchors.fill: parent
            spacing: phone_input.height
            Rectangle { // a space
                width: 1
                height: 1
                color: "#00000000"
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: window.width*0.6
                height: phone_input.contentHeight
                color: "#00000000"
                TextInput {
                    id: phone_input
                    anchors.fill: parent
                    font.pointSize: 20
                    color: Material.color(Material.Teal)
                    validator: RegExpValidator{ regExp:/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]/ }
                    Rectangle {
                        anchors.top: phone_input.bottom
                        anchors.horizontalCenter: phone_input.horizontalCenter
                        anchors.bottomMargin: 0
                        width: phone_input.width
                        height: 1.5
                    }
                    Label {
                        y: phone_input.text==="" ? phone_input.focus? height - phone_input.contentHeight*1.2 : 0 : height - phone_input.contentHeight*1.2
                        width: window.width*0.6
                        height: contentHeight
                        text: qsTr("手机号")
                        font.pointSize: phone_input.text==="" ? phone_input.focus? 10 : 18 : 10
                        Behavior on y { SmoothedAnimation { duration: 200; velocity: -1 } }
                        Behavior on font.pointSize { SmoothedAnimation { duration: 200; velocity: -1 } }
                    }
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: window.width*0.6
                height: password_input.contentHeight
                color: "#00000000"
                TextInput {
                    id: password_input
                    anchors.fill: parent
                    color: Material.color(Material.Teal)
                    selectByMouse: true
                    echoMode: TextInput.Password
                    passwordCharacter: "*"
                    passwordMaskDelay: 500
                    font.pointSize: 20
                    clip: true
                }
                Rectangle {
                    anchors.bottom: password_input.bottom
                    anchors.horizontalCenter: password_input.horizontalCenter
                    anchors.bottomMargin: 0
                    width: password_input.width
                    height: 1.5
                }
                Label {
                    y: password_input.text==="" ? password_input.focus? height - password_input.contentHeight*1.2 : 0 : height - password_input.contentHeight*1.2
                    width: window.width*0.6
                    height: contentHeight
                    text: qsTr("密码")
                    font.pointSize: password_input.text==="" ? password_input.focus? 10 : 18 : 10
                    Behavior on y { SmoothedAnimation { duration: 200; velocity: -1 } }
                    Behavior on font.pointSize { SmoothedAnimation { duration: 200; velocity: -1 } }
                }
            }


            Button {
                id: login_button
                anchors.horizontalCenter: parent.horizontalCenter
                width: window.width/8
                Material.background: Material.primary
                text: qsTr("登录")
                onReleased: console.log(login_cellphone.withPassword(phone_input.text, password_input.text).toString())
            }
        }

    }



}
