import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {  // This can be any container type that fits your existing UI structure.
    id: leftScreen

    anchors {
        top: parent.top
        right: rightScreen.left
        bottom: bottomBar.top
        left: parent.left
    }
    color: "white"

    Image {
            id: carBlue2
            anchors.centerIn: parent
            width: parent.width * .95
            fillMode: Image.PreserveAspectFit
            source: "qrc:/ui/assets/carBlue2.png"
            opacity: 0.3 // Adjusted opacity for better visibility of the tasks list
    }

    ListModel {
        id: tasksModel
    }

    Component.onCompleted: {
            var loadedTasks = systemHandler.loadTasks();
            for (var i = 0; i < loadedTasks.length; ++i) {
                tasksModel.append(loadedTasks[i]);
            }
        }



        function addTask(taskDescription) {
            var taskId = systemHandler.addTask(taskDescription); // Ensure your C++ addTask method returns the new task's ID
            if (taskId !== -1) {
                tasksModel.append({"id": taskId, "task": taskDescription});
            }
        }

        function deleteTask(taskId) {
            if (systemHandler.deleteTask(taskId)) {
                for (let i = 0; i < tasksModel.count; i++) {
                    if (tasksModel.get(i).id === taskId) {
                        tasksModel.remove(i);
                        break;
                    }
                }
            }
        }


    function updateTask(taskId, newDescription) {
        for (let i = 0; i < tasksModel.count; i++) {
            if (tasksModel.get(i).id === taskId) {
                tasksModel.setProperty(i, "task", newDescription);
                break;
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        // padding: 10

        TextField {
            id: taskInput
            placeholderText: qsTr("Enter a new task")
            Layout.fillWidth: true
        }

        Button {
            text: qsTr("Add Task")
            Layout.fillWidth: true
            onClicked: {
                if (taskInput.text !== "") {
                    addTask(taskInput.text);
                    taskInput.text = ""; // Clear the input field after adding a task
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: tasksListView
                anchors.fill: parent
                model: tasksModel

                delegate: Rectangle {
                    width: parent.width
                    height: 50
                    color: "lightgrey"
                    radius: 5

                    RowLayout {
                        anchors.fill: parent

                        TextField {
                            text: model.task
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            readOnly: false
                            onEditingFinished: {
                                if (text !== model.task) {
                                    updateTask(model.id, text);
                                }
                            }
                        }

                        Button {
                            text: qsTr("Delete")
                            onClicked: {
                                deleteTask(model.id);
                            }
                        }
                    }
                }
            }
        }
    }
}
