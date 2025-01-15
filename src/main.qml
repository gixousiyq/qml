import QtQuick 2.6
import QtQuick.Window 2.0
import QtQuick.Controls.Material
// Import our Rust classes
import VersesGrabber 1.0

Window {
    id: window
    visible: true;
    width: 550;
    height: 650;
    color: "black"

    ScrollView {
        width: parent.width
        height: parent.height

        // Instantiate the rust struct
        Flow {
            id: flow
            // Make flow layout take full window space
            width: window.width
            height: window.height
            // RTL specific options
            LayoutMirroring.enabled: true
            LayoutMirroring.childrenInherit: true
            padding: 7
    
            // Our Rust structure
            VersesGrabber {
                id: versesGrabber
            }
    
            Component.onCompleted: {
                function addTextItem(textContent, index) {
                    // Define the QML code as a string
                    var qmlCode = `
                        import QtQuick 2.0
                        Text {
                            id: text${index}
                            text: " ${textContent}"
                            font.pixelSize: 30
                            font.family: "KFGQPC HAFS Uthmanic Script"
                            horizontalAlignment: Text.AlignHCenter
                            color: "white" // Initial color
                            // MouseArea to detect click events
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    // Start the color change animation
                                    colorAnimation${index}.running = true;
                                }
                            }
    
                            // SequentialAnimation to change color temporarily
                            SequentialAnimation {
                                id: colorAnimation${index}
                                running: false
                                PropertyAnimation {
                                    target: text${index}
                                    property: "color"
                                    to: "green" // Color when clicked
                                    duration: 100 // Duration of the color change
                                }
                                PauseAnimation {
                                    duration: 200 // Duration to hold the clicked color
                                }
                                PropertyAnimation {
                                    target: text${index}
                                    property: "color"
                                    to: "white" // Revert to original color
                                    duration: 100 // Duration of the revert animation
                                }
                            }
                        }
                    `;
    
                    // Create the QML object from the string passed to us
                    var newItem = Qt.createQmlObject(qmlCode, flow, "verse${index}");
    
                    // Check if the object was created successfully
                    if (newItem === null) {
                        console.error("Error creating object");
                    }
                }
    
                // Grab verses from current_page file under src folder
                const text = versesGrabber.grab_verses();

                // Add a text element for each word
                text.split(" ").forEach((word, index) => {
                    addTextItem(word, index);
                });
            }
        }
    }
}