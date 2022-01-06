import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

Item {
    width: parent.width
    Rectangle {
        visible: false
        z: 2
        width: parent.width
        height: 1.8
    }
    Button {
        id: control
        anchors.fill: parent
        background: Rectangle {
            anchors.fill: parent
            radius: 0
            color: "#00000000"
            Ripple {
                clipRadius: 1
                width: parent.width
                height: parent.height
                pressed: control.pressed
                anchor: control
                active: control.down || control.visualFocus || control.hovered
                color: control.flat && control.highlighted ? control.Material.highlightedRippleColor : control.Material.rippleColor
            }
        }
    }
}
