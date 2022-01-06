import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

Item {
    height: 50
    width: parent.width
    Button {
        id: control
        anchors.fill: parent
        background: Rectangle {
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            color: !control.enabled ? control.Material.buttonDisabledColor :
                    control.highlighted ? control.Material.highlightedbuttonColor : control.Material.buttonColor
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

