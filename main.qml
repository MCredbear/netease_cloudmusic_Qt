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
    Material.primary: Material.Red
    ToolBar {
        id: top_toolbar
        z: 10
        anchors.top: parent.top
        anchors.topMargin: 0
        width: parent.width
        height: 50
        ToolButton {
            id: side_drawer_button
            anchors.left: parent.left
            text: "\u2261"
            font.pixelSize: 20
            onReleased: side_drawer.open()
        }
        ToolButton {
            id: back_button
            anchors.right: parent.right
            text: "\u2190"
            font.pixelSize: 20
            visible: stack.depth > 1
            onReleased: stack.pop()
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
    Drawer {
        id: side_drawer
        edge: Qt.LeftEdge
        width: window.width*0.6
        height: window.height
        Overlay.modal: Rectangle {
            color: "#88000000"
        }
        ToolBar {
            z: 1
            width: parent.width
            height: 50
            ToolButton {
                anchors.left: parent.left
                anchors.leftMargin: 0
                text: "\u2190"
                font.pixelSize: 20
                onReleased: side_drawer.close()
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 23
                text: qsTr("设置")
            }
        }

        Flickable {
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            Column {
                y: 50
                width: parent.width
                height: parent.height-y
                spacing: 0
                Rectangle {
                    y: 15
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
    StackView {
        id: stack
        y: top_toolbar.height
        width: window.width
        height: window.height-top_toolbar.height-bottom_toolbar.height

        anchors.horizontalCenter: parent.horizontalCenter

        Component.onCompleted: push(home_page)


    }
    Component {
        id: home_page
        Home_Page {}
    }
    Component {
        id: login_page
        Login_Page {}
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.0625}
}
##^##*/
