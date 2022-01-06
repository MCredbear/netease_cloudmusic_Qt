import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

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
    Material.primary: "#303030"
    Material.background: "#101010"
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
            font.pixelSize: 22
            onReleased: side_drawer.open()
        }
        ToolButton {
            id: back_button
            anchors.right: parent.right
            text: "\u2190"
            font.pixelSize: 22
            visible: stack.depth > 1
            onReleased: stack.pop()
        }

        Rectangle {
            anchors.bottom: search_bar.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: search_bar.width
            height: 1.5
            visible: search_bar.visible
            opacity: search_bar.opacity
        }
        TextInput { // Label's text has a locaion error
            id: text_mask
            anchors.fill: search_bar
            text: qsTr("搜索")
            font.pointSize: 18
            color: "#bbbbbb"
            visible: search_bar.length === 0
            opacity: search_bar.opacity
            readOnly: true
            enabled: false
        }
        TextInput {
            id: search_bar
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width*0.6
            height: text_mask.contentHeight
            font.pointSize: 18
            color: "#ffffff"
            clip: true
            Behavior on opacity { SmoothedAnimation { duration: 100; velocity: -1 } }
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
                font.pointSize: 22
                onReleased: side_drawer.close()
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
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
        Login_Page {
            Component.onCompleted: {search_bar.opacity = 0; search_bar.enabled = false}
            Component.onDestruction: {search_bar.enabled = true; search_bar.opacity = 1}
        }
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.0625}
}
##^##*/
