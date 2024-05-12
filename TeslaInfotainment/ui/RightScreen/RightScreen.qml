import QtQuick 2.15
import QtLocation 5.12
import QtPositioning 5.12

Rectangle{
    id: rightscreen
    anchors{
        top: parent.top
        bottom: bottomBar.top
        right: parent.right
    }



    Plugin {
            id: mapPlugin
            name: "osm" // "mapboxgl", "esri", ...
            // specify plugin parameters if necessary
            // PluginParameter {
            //     name:
            //     value:
            // }
        }

    Map {
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(37.46, -122.14) // PaloAlto
            zoomLevel: 14
    }

    // Map {
    //         anchors.fill: parent
    //         zoomLevel: 14
    //         center: QtPositioning.coordinate(37.46, -122.14) // PaloAlto
    //         plugin: Plugin {
    //             name: "osm"
    //             PluginParameter { name: "osm.mapping.providersrepository.address"; value: "http://www.mywebsite.com/osm_repository" }
    //             PluginParameter { name: "osm.mapping.highdpi_tiles"; value: true }
    //         }
    //         activeMapType: supportedMapTypes[1] // Cycle map provided by Thunderforest
    //     }


    Image{
        id: lockIcon
        anchors{
            left: parent.left
            top: parent.top
            margins: 20
        }

        width: parent.width / 40
        fillMode: Image.PreserveAspectFit
        source: ( systemHandler.carLocked ? "qrc:/ui/assets/lock.png" : "qrc:/ui/assets/unlock.png")
        MouseArea{
            anchors.fill: parent
            onClicked: systemHandler.setCarLocked( !systemHandler.carLocked)
        }
    }

    Text{
        id: dateTimeDisplay
        anchors{
            left: lockIcon.right
            leftMargin: 40
            bottom: lockIcon.bottom
        }

        font.pixelSize: 14
        font.bold: true
        color: "black"

        text: systemHandler.currentTime
    }

    Text{
        id: oudoorTempperatureDisplay
        anchors{
            left: dateTimeDisplay.right
            leftMargin: 30
            bottom: lockIcon.bottom
        }

        font.pixelSize: 14
        font.bold: true
        color: "black"

        text: systemHandler.outdoorTemp + "°F"
    }

    Text{
        id: userNameDisplay
        anchors{
            left: oudoorTempperatureDisplay.right
            leftMargin: 40
            bottom: lockIcon.bottom
        }

        font.pixelSize: 14
        font.bold: true
        color: "black"

        text: systemHandler.userName
    }


    width: parent.width * 2/3
}
