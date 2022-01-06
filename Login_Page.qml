import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.12

Item {
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Label {
            width: window.width*0.6
            height: 50
            text: qsTr("手机号")
        }
        TextInput {
            id: phone_input
            width: window.width*0.6
            height: 50
            font.pointSize: 20
            color: Material.color(Material.Teal)
        }
        Label {
            width: window.width*0.6
            height: 50
            text: qsTr("密码")
        }

        TextInput {
            id: password_input
            width: window.width*0.6
            height: 50
            color: Material.accent
            selectByMouse: true
            echoMode: TextInput.Password
            passwordCharacter: "*"
            passwordMaskDelay: 500
            text: "23232adafs"
        }
    }


}
