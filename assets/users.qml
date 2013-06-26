import bb.cascades 1.0
import Communi 1.0

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
                /*var newPage = users.createObject();
                root.push(newPage);*/
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
            dataModel: UserModel {
                id: usermod
            }
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Center
            listItemComponents: [
                ListItemComponent {
                    type: "header"

                    Header {
                        title: ListItemData
                    }
                },
                ListItemComponent {
                    type: "item"

                    StandardListItem {
                        title: ListItemData.username
                    }
                } // end of ListItemComponent
            ] // end of listItemComponents list
            onTriggered: {
                var selectedItem = dataModel.data(indexPath);
                /*var newPage = channel.createObject();
                root.push(newPage);*/

            }

            onCreationCompleted: {
                usermod.readChannel(currentChannel);
            }
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
}
