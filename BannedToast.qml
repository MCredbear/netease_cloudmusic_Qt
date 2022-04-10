import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Popup {
    width: 200
    height: 30
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: qsTr("被网易云Ban了")
    }
}
