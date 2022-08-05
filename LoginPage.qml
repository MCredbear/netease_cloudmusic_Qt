import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Popup {
    id: loginPage
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
                id: accountInput
                anchors.fill: parent
                font.pointSize: 18
                clip: true
            }
            TextInput {
                id: accountMask
                anchors.fill: accountInput
                text: qsTr("手机号")
                font.pointSize: 18
                color: "#bbbbbb"
                visible: accountInput.length === 0 ? accountInput.focus ? true : true : false
                readOnly: true
                enabled: false
            }
        }
        Rectangle {
            width: 130
            height: 50
            color: "transparent"
            TextInput {
                id: captchaInput
                anchors.fill: parent
                font.pointSize: 18
                clip: true
            }
            TextInput {
                id: captchaMask
                anchors.fill: captchaInput
                text: qsTr("验证码")
                font.pointSize: 18
                color: "#bbbbbb"
                visible: captchaInput.length === 0 ? captchaInput.focus ? true : true : false
                readOnly: true
                enabled: false
            }
        }
        Button {
            width: 130
            height: 50
            text: qsTr("发送验证码")
            onReleased: {
                var captchaSent = neteaseAPI.captchaSent("86", accountInput.text)
                console.log(captchaSent)
            }
        }
        Button {
            width: 130
            height: 50
            text: qsTr("登录")
            onReleased: {
                var captchaVerify = neteaseAPI.captchaVerify("86", accountInput.text, captchaInput.text)
                if (captchaVerify !== "") {
                    var captchaVerifyJson = JSON.parse(captchaVerify)
                    if (captchaVerifyJson.data === true) {
                        console.log(neteaseAPI.loginCellphone("86", accountInput.text, captchaInput.text))
                        var userAccount = neteaseAPI.userAccount()

                        console.log(userAccount)

                        if (userAccount !== "") {
                            accountInput.text = ""
                            captchaInput.text = ""
                            loginPage.close()
                            var json = JSON.parse(userAccount)
                            userProfile = {
                                logined : true,
                                id : json.profile.userId.toString(),
                                name : json.profile.nickname,
                                avatarUrl : json.profile.avatarUrl
                            }
                        }
                    }
                    else {
                        text = "验证码错误"
                    }
                }


            }
        }
    }




}
