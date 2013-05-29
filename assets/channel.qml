import bb.cascades 1.0
import bb.system 1.0

Page {
    id: channelpage
    titleBar: TitleBar {
        id: channeltitle
        title: "#Channel"
    }
    actions: [
        // define the actions for first tab here
        ActionItem {
            title: qsTr("Send")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                //Send message
            }
            imageSource: "asset:///icons/ic_textmessage.png"
        },
        ActionItem {
            title: qsTr("Users")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                //open users
                var newPage = users.createObject();
                root.push(newPage);
            }
            imageSource: "asset:///icons/user-group.png"
        },
        ActionItem {
            title: qsTr("Edit nick")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                //popup edit nick
                myQmlDialog.show();
            }
            imageSource: "asset:///icons/ic_edit_profile.png"
        }
    ]
    Container {
        ListView {

        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight

            }
            TextField {

            }
            ImageView {
                imageSource: "asset:///icons/ic_add.png"

            }

        }

    }
    attachedObjects: [
        ComponentDefinition {
            id: users
            source: "users.qml"
        },
        SystemPrompt {
            id: myQmlDialog
            title: "Friendly Warning"
            body: "Kakel can be habit-forming... "
            onFinished: {
                if (myQmlDialog.result == SystemUiResult.CancelButtonSelection) myQmlToast.show();
            }
        }

    ]
}
