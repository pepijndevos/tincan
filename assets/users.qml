import bb.cascades 1.0

Page {
    id: userspage
    titleBar: TitleBar {
        id: userstitle
        title: "#Channel users"
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
        }
    ]
}
