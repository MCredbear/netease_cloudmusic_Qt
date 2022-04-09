import QtQuick 2.15
import QtQuick.Controls 2.15

MouseArea {
    id: control
    width: parent.width
    height: 50
    cursorShape: Qt.PointingHandCursor
    property bool holding: false
    onPressed: holding = true
    onReleased: holding = false

    Rectangle {
        anchors.fill: parent
        color: parent.holding ? "#11000000" : "#00000000"
    }
}
