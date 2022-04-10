import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Popup {
    id: login_page
    width: 200
    height: 300
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("登录")
            font.pointSize: 18
        }
        Rectangle {
            width: 150
            height: 50
            color: "transparent"
            TextInput {
                id: account_input
                anchors.fill: parent
                font.pointSize: 18
                clip: true
            }
            TextInput {
                id: account_mask
                anchors.fill: account_input
                text: qsTr("手机号")
                font.pointSize: 18
                color: "#bbbbbb"
                visible: account_input.length === 0 ? account_input.focus ? true : true : false
                readOnly: true
                enabled: false
            }
        }
        Rectangle {
            width: 130
            height: 50
            color: "transparent"
            TextInput {
                id: password_input
                anchors.fill: parent
                font.pointSize: 18
                clip: true
            }
            TextInput {
                id: password_mask
                anchors.fill: password_input
                text: qsTr("密码")
                font.pointSize: 18
                color: "#bbbbbb"
                visible: password_input.length === 0 ? password_input.focus ? true : true : false
                readOnly: true
                enabled: false
            }
        }
        Button {
            width: 130
            height: 50
            text: qsTr("登录")
            onReleased: {
                neteaseAPI.loginCellphone("86", account_input.text, password_input.text)
                var userAccount = neteaseAPI.userAccount()
                if (userAccount !== "") {
                    account_input.text = ""
                    password_input.text = ""
                    login_page.close()
                    var json = JSON.parse(userAccount)
                    userProfile = {
                        logined : true,
                        id : json.profile.userId.toString(),
                        name : json.profile.nickname,
                        avatarUrl : json.profile.avatarUrl
                    }
                }
            }
        }
    }




}
