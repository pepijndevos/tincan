import bb.cascades 1.0
import bb.system 1.0
import Communi 1.0

NavigationPane {
    id: root
    property IrcCommand cmd: IrcCommand {}
    property BufferWrapper currentChannel: null
    property BufferWrapper previousChannel: null
    property IrcConnection currentNetwork: null
    property variant lastSelectedItem
    onPopTransitionEnded: {
        if(page.uid == "channelpage") {
            console.log("AAAAAAAAA");
            currentChannel.active=false;
        }
        if(previousChannel != null){
            currentChannel.active=false;
            currentChannel = previousChannel;
            currentChannel.active=true;
            previousChannel = null;
        }
        Application.menuEnabled = true;
    }
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            title: "Info & Feedback"
            onTriggered: {
                var newPage = aboutPage.createObject();
                root.push(newPage);
                Application.menuEnabled = false;
            }
        }
        //settingsAction: SettingsActionItem {}
        actions: [
            ActionItem {
                title: "Get a Bouncer"
                imageSource: "asset:///icons/ic_to_bottom.png"
                onTriggered: {
                    bouncer.trigger("bb.action.OPEN");
                }
                attachedObjects: [
                    Invocation {
                        id: bouncer
                        query {
                            mimeType: "text/html"
                            uri: "http://teamrelaychat.nl/bouncer/"
                        }
                    }
                ]
            }
        ]
    }
    Page {
        actions: [
            ActionItem {
                title: "Add network"
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///icons/ic_add.png"
                onTriggered: {
                    networkDialog.open();
                }
            }
        ]
        Container {
            layout: DockLayout {}
            Container {
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Fill
                visible: chanmod.empty
                Label {
                    textStyle.base: SystemDefaults.TextStyles.BigText  
                    textStyle.textAlign: TextAlign.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    text: "Add a network to get started"
                    multiline: true
                }
            }
            ListView {
                property alias cmd: root.cmd
                property alias cnd: changeNameDialog
                property alias curnet: root.currentNetwork

                id: channelList
                dataModel: ChannelModel { id: chanmod }
                
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Fill
                listItemComponents: [
                    ListItemComponent {
                        type: "network"
                        
                        Container {
                            id: itemRoot
                            visible: ListItemData.enabled
                            Container {
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight
                                }
                                Container {
                                    topPadding: 10
                                    leftPadding: 10
                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: 1
                                    }
                                    Label {
                                        text: ListItemData.host + ":" + ListItemData.nickName
                                    }
                                }
                                ImageView {
                                    imageSource: "asset:///icons/ic_add_dark.png"
                                }
                            }
                            Container {
                                id: statusBorder
                                horizontalAlignment: HorizontalAlignment.Fill
                                minHeight: 4
                                background: ListItemData.connected ? Color.Green : Color.Red
                            }
                            contextActions: [
                                ActionSet {
                                    title: ListItemData.host
                                    subtitle: ListItemData.nickName
                                    actions:[
                                        ActionItem {
                                            title: "Change Nick"
                                            imageSource: "asset:///icons/ic_edit_profile.png"
                                            onTriggered: {
                                                itemRoot.ListItem.view.curnet = ListItemData
                                                itemRoot.ListItem.view.cnd.show();
                                            }
                                        },
                                        ActionItem {
                                            title: "Reconnect"
                                            imageSource: "asset:///icons/ic_rotate.png"
                                            onTriggered: {
                                                var s = ListItemData;
                                                s.close();
                                                s.open();
                                            }
                                        },
                                        ActionItem {
                                            title: "Disconnect"
                                            imageSource: "asset:///icons/ic_clear.png"
                                            onTriggered: {
                                                var s = ListItemData;
                                                s.close();
                                            }
                                        },
                                        DeleteActionItem {
                                            title: "Delete Network"
                                            onTriggered: {
                                                netdeltoast.body = "Network " + ListItemData.host + " will be deleted!"
                                                var dm = itemRoot.ListItem.view.dataModel
                                                ListItemData.enabled = false;
                                                var lmd = ListItemData
                                                netdeltoast.finished.connect(function (state) {
                                                    if (state == 1) { //undo
                                                        ListItemData.enabled = true;
                                                        itemRoot.ListItem.view.scroll(0, 0);
                                                    } else {
                                                        dm.removeSession(lmd);
                                                    }
                                                })
                                                netdeltoast.show()
                                            }
                                            attachedObjects: [
                                                SystemToast {
                                                    id: netdeltoast
                                                    button.label: "Undo"
                                                    button.enabled: true
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    },
                    ListItemComponent {
                        type: "channel"
                        
                        StandardListItem {
                            title: ListItemData.title
                            status: ListItemData.unread ? ListItemData.unread : ""
                            id: itemRoot2
                            visible: ListItemData.enabled
                            contextActions: [
                                ActionSet {
                                    title: ListItemData.title
                                    subtitle: ListItemData.unread ? ListItemData.unread +" unread messages" : ""
                                    actions:[
                                        DeleteActionItem {
                                            title: "Leave channel"
                                            onTriggered: {
                                                console.log(JSON.stringify(ListItemData));
                                                if(ListItemData.buffer.channel) {
                                                    ListItemData.buffer.part("");
                                                } else {
                                                    ListItemData.buffer.model.remove(ListItemData.title);
                                                }
                                            }
                                        }
                                    ]
                                }
                            ]
                        }
                    } // end of ListItemComponent
                ] // end of listItemComponents list
                onTriggered: {
                    var selectedItem = dataModel.data(indexPath);
                    lastSelectedItem = selectedItem;
                    //console.log(JSON.stringify(selectedItem), JSON.stringify(indexPath));
                    if(indexPath.length == 1) { //header
                        currentNetwork = selectedItem;
                        if(selectedItem.connected){
                            joinDialog.show();
                        }else{
                            //console.log("should show reconnect dialog");
                            reconnectDialog.show();
                        }
                    } else { //item
                        if(currentChannel!=null){
	                        currentChannel.active=false;
	                    }
                        currentChannel = selectedItem;
                        currentChannel.active=true;
                        var newPage = channel.createObject();
                        root.push(newPage);
                    }
                }
            }
        }
    }
    attachedObjects: [
        ComponentDefinition {
            id: channel
            source: "channel.qml"
        },
        SystemPrompt {
            id: changeNameDialog
            title: "Change nickname"
            body: "Enter your desired nickname"
            inputField.defaultText: (root.currentNetwork!=null)? root.currentNetwork.nickName : "";
            inputField.emptyText: "nickname"
            onFinished: {
                if(value == SystemUiResult.ConfirmButtonSelection){
                    root.currentNetwork.nickName = changeNameDialog.inputFieldTextEntry()
                }
            }
        },
        SystemPrompt {
            id: joinDialog
            title: "Join a channel"
            body: "Enter channel name"
            inputField.defaultText: "#"
            onFinished: {
                if(value == SystemUiResult.ConfirmButtonSelection){
                    var roomname = joinDialog.inputFieldTextEntry();
                    console.log(roomname);
                    if(roomname !== "") {
                        var command = cmd.createJoin(roomname);
                        currentNetwork.sendCommand(command);
                    }
                }else{
                    //console.log("cancel join channel");
                }
            }
            returnKeyAction: SystemUiReturnKeyAction.Join
        },
        SystemDialog {
            id: reconnectDialog
            title: "Server disconnected"
            body: "Do you want to reconnect?"
            onFinished: {
                if(value == SystemUiResult.ConfirmButtonSelection){
                    /*var roomname = joinDialog.inputFieldTextEntry();
                    console.log(roomname);
                    if(roomname !== "") {
                        var command = cmd.createJoin(roomname);
                        currentNetwork.sendCommand(command);
                    }*/
                    lastSelectedItem.close();
                    lastSelectedItem.open();
                    //joinDialog.show();
                }else{
                    console.log("cancel join channel");
                }
            }
        },
        Dialog {
            id: networkDialog
            Container {
                topPadding: 40
                bottomMargin: 40
                leftPadding: 40
                rightPadding: 40
                background: Color.create("#99000000")
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                TextField {
                    id: server
                    inputMode: TextFieldInputMode.Url
                    hintText: "irc.freenode.net"
                }
                TextField {
                    id: port
                    inputMode: TextFieldInputMode.PhoneNumber //weird
                    hintText: "6667"
                }
                CheckBox {
                    id: ssl
                    checked: false
                    text: "SSL"
                }
                TextField {
                    id: nick
                    inputMode: TextFieldInputMode.Text
                    hintText: "nickname"
                }
                TextField {
                    id: password
                    inputMode: TextFieldInputMode.Password
                    hintText: "password, optional"
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Button {
                        text: "Connect"
                        onClicked: {
                            var host = server.text || server.hintText;
                            var name = nick.text || "tincan";
                            
                            var session = chanmod.addSession().connection;
                            session.host = host;
                            session.port = parseInt(port.text || port.hintText);
                            session.secure = ssl.checked;
                            session.userName = nick.text || "tincan";
                            session.nickName = nick.text || "tincan";
                            session.realName = "TinCan User";
                            session.password = password.text;
                            session.open();
                            chanmod.saveSession(session);
                            
                            networkDialog.close()
                        }
                    }
                    Button {
                        text: "Cancel"
                        onClicked: {
                            networkDialog.close()
                        }
                    }
                }
            }
        },
        Padding {
            id: padding
        },
        ComponentDefinition {
            id: aboutPage;
            source: "about.qml";
        }
    ] // end of attachedObjects list
}
