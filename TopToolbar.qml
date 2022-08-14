import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: topToolbar
    anchors.top: parent.top
    anchors.topMargin: 0
    width: parent.width
    height: 80
    color: "#ffffff"

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 3
        color: "red"
    }

    Image {
        id: icon
        width: 72
        height: 72
        anchors.verticalCenter: parent.verticalCenter
        source: "images/netease-cloud-music.svg"
        Label {
            color: "#000000"
            anchors.left: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            text: qsTr("网易云音乐")
            font.pointSize: 20
        }
    }
    Rectangle {
        anchors.bottom: icon.bottom
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        width: window.width/5
        height: textMask.contentHeight
        radius: 4
        color: "#dddddd"
        TextInput {
            id: searchInput
            anchors.fill: parent
            font.pointSize: 18
            clip: true
            Timer {
                id: timer
                interval: 200
                onTriggered: {
                    var searchSuggest = neteaseAPI.searchSuggest(searchInput.text)
                    console.log(searchSuggest)
                    var json = JSON.parse(searchSuggest)
                    if (json.code !== 400) {
                        searchSuggestListView.model.clear()
                        for (var i in json.result.allMatch) {
                            searchSuggestListView.model.append({
                                                               "keyword": json.result.allMatch[i].keyword
                                                               })
                        }
                    }
                    else {
                        searchSuggestListView.model.clear()
                    }
                }
            }
            onTextEdited: {
                timer.restart()
            }
        }
        TextInput { // Label's text has a position error
            id: textMask
            anchors.fill: searchInput
            text: qsTr("搜索")
            font.pointSize: 18
            color: "#bbbbbb"
            visible: searchInput.length === 0 ? searchInput.focus ? true : true : false
            readOnly: true
            enabled: false
        }
        ListView {
            id: searchSuggestListView
            z: 3
            anchors.top: parent.bottom
            interactive: false
            anchors.left: parent.left
            anchors.right: parent.right
            height: model.count * 30
            model: ListModel {}
            delegate: Material_Button {
                width: searchSuggestListView.width
                height: 30
                color: "#787878"
                Text {
                    color: "#343434"
                    anchors.fill: parent
                    text: keyword
                }
            }
        }
    }
}
