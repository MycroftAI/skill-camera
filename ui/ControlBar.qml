import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtMultimedia 5.12
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.11 as Kirigami
import Mycroft 1.0 as Mycroft
import QtGraphicalEffects 1.0

Item {
    id: cameraControlBar
    property bool opened: false
    property bool enabled: true
    property var cameraControl

    clip: true
    implicitWidth: parent.width
    implicitHeight: mainLayout.implicitHeight + Kirigami.Units.largeSpacing * 2
    opacity: opened

    Behavior on opacity {
        OpacityAnimator {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutCubic
        }
    }

    onOpenedChanged: {
        if (opened) {
            hideTimer.restart();
        }
    }
    
    Timer {
        id: hideTimer
        interval: 5000
        onTriggered: { 
            cameraControlBar.opened = false;
        }
    }
    
    Rectangle {
        width: parent.width
        height: parent.height
        color: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.6)
        y: opened ? 0 : parent.height

        Behavior on y {
            YAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutCubic
            }
        }
        
        RowLayout {
            id: mainLayout
            
            anchors {
                fill: parent
                margins: Kirigami.Units.largeSpacing
            }
            
            Controls.RoundButton {
                id: shootButton
                Layout.preferredWidth: Kirigami.Units.iconSizes.huge
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignRight
                highlighted: focus ? 1 : 0
                z: 1000
                onClicked: {
                    cameraShootSound.play()
                    cameraControl.imageCapture.captureToLocation(savePath);
                    shootFeedback.start()
                }
                onFocusChanged: {
                    hideTimer.restart();
                }
                
                background: Rectangle {
                    radius: 200
                    color: "#1a1a1a"
                    border.width: 1.25
                    border.color: "white"
                }
                
                contentItem: Item {
                    Image {
                        width: parent.width - Kirigami.Units.largeSpacing
                        height: width
                        anchors.centerIn: parent
                        source: "images/capture.svg"
                    }
                }
            }
            Controls.RoundButton {
                id: backButton
                Layout.preferredWidth: Kirigami.Units.iconSizes.huge
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignLeft
                highlighted: focus ? 1 : 0
                z: 1000
                onClicked: {
                    triggerGuiEvent("CameraSkill.EndProcess", {})
                    hideTimer.restart();
                }
                onFocusChanged: {
                    hideTimer.restart();
                }
                
                background: Rectangle {
                    radius: 200
                    color: "#1a1a1a"
                    border.width: 1.25
                    border.color: "white"
                }
                
                contentItem: Item {
                    Image {
                        width: parent.width - Kirigami.Units.largeSpacing
                        height: width
                        anchors.centerIn: parent
                        source: "images/back.svg"
                    }
                }
            }
        }
    }
} 
