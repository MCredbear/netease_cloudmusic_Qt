import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Popup {
    id: loginPage
    width: 200
    height: 300
    background: Material_Rectangle {
        color: "#ffffff"
    }
    property string key
    onOpened: {
        var loginQRKey = neteaseAPI.loginQRKey()
        var json = JSON.parse(loginQRKey)
        key = json.unikey
        qrCode.value = "https://music.163.com/login?codekey=" + key
        timer.start()
    }
    Timer {
        id: timer
        interval: 1000
        repeat: true
        onTriggered: {
            var loginQRCheck = neteaseAPI.loginQRCheck(key)
            var json = JSON.parse(loginQRCheck)
            if (json.code === 803) {
                timer.stop()
                loginPage.close()
                window.init()
            }
        }
    }

    Column {
        anchors.fill: parent
        Text {
            width: parent.width
            text: qsTr("请使用网易云手机客户端扫描二维码")
            wrapMode: Text.WrapAnywhere
            font.pointSize: 13
        }
        Rectangle {
            width: parent.width
            height: width
            clip: true
            QRCode {
                id: qrCode
                anchors.fill: parent
                anchors.leftMargin: parent.width / 33
                anchors.topMargin: parent.width / 33
            }
            Rectangle {
                id: mask
                anchors.fill: parent
                visible: false
                color: "#97000000"
                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pointSize: 17
                    color: "#3d3d3d"
                    text: qsTr("二维码已过期")
                }
            }
        }



//        Text {
//            anchors.horizontalCenter: parent.horizontalCenter
//            text: qsTr("登录")
//            font.pointSize: 18
//        }
//        Rectangle {
//            width: 150
//            height: 50
//            color: "transparent"
//            TextInput {
//                id: accountInput
//                anchors.fill: parent
//                font.pointSize: 18
//                clip: true
//            }
//            TextInput {
//                id: accountMask
//                anchors.fill: accountInput
//                text: qsTr("手机号")
//                font.pointSize: 18
//                color: "#bbbbbb"
//                visible: accountInput.length === 0 ? accountInput.focus ? true : true : false
//                readOnly: true
//                enabled: false
//            }
//        }
//        Rectangle {
//            width: 130
//            height: 50
//            color: "transparent"
//            TextInput {
//                id: captchaInput
//                anchors.fill: parent
//                font.pointSize: 18
//                clip: true
//            }
//            TextInput {
//                id: captchaMask
//                anchors.fill: captchaInput
//                text: qsTr("验证码")
//                font.pointSize: 18
//                color: "#bbbbbb"
//                visible: captchaInput.length === 0 ? captchaInput.focus ? true : true : false
//                readOnly: true
//                enabled: false
//            }
//        }
//        Button {
//            width: 130
//            height: 50
//            text: qsTr("发送验证码")
//            onReleased: {
//                var captchaSent = neteaseAPI.captchaSent("86", accountInput.text)
//                console.log(captchaSent)
//            }
//        }
//        Button {
//            width: 130
//            height: 50
//            text: qsTr("登录")
//            onReleased: {
//                var captchaVerify = neteaseAPI.captchaVerify("86", accountInput.text, captchaInput.text)
//                if (captchaVerify !== "") {
//                    var captchaVerifyJson = JSON.parse(captchaVerify)
//                    if (captchaVerifyJson.data === true) {
//                        console.log(neteaseAPI.loginCellphone("86", accountInput.text, captchaInput.text))
//                        var userAccount = neteaseAPI.userAccount()

//                        console.log(userAccount)

//                        if (userAccount !== "") {
//                            accountInput.text = ""
//                            captchaInput.text = ""
//                            loginPage.close()
//                            var json = JSON.parse(userAccount)
//                            userProfile = {
//                                logined : true,
//                                id : json.profile.userId.toString(),
//                                name : json.profile.nickname,
//                                avatarUrl : json.profile.avatarUrl
//                            }
//                        }
//                    }
//                    else {
//                        text = "验证码错误"
//                    }
//                }


//            }
//        }
    }




}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
