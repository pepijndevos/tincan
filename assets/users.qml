import bb.cascades 1.0
import Communi 1.0

Page {
    id: userspage
    titleBar: TitleBar {
        id: userstitle
        title: "#Channel users"
    }
    actions: [
        ActionItem {
            title: qsTr("Edit nick")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                //popup edit nick
                changeNameDialog.show();
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
                        title: (ListItemData.mode == "o" ? "@" : "") + ListItemData.name
                    }
                } // end of ListItemComponent
            ] // end of listItemComponents list
            onTriggered: {
                root.previousChannel = root.currentChannel;
                var selectedItem = dataModel.data(indexPath);
                var buf = currentChannel.buffer.model.add(selectedItem.name);
                var wr = chanmod.getWrapper(buf);
                currentChannel.active=false;
                currentChannel = wr;
                currentChannel.active=true;
                var newPage = channel.createObject();
                root.push(newPage);
            }

            onCreationCompleted: {
                userstitle.title = currentChannel.buffer.title + " users";
                usermod.readChannel(currentChannel);
            }
        }
    }
}
