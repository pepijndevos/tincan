import bb.cascades 1.0
import bb.system 1.0
import Communi 1.0

NavigationPane {
    id: root
    property IrcCommand cmd: IrcCommand {}
    property PasswordManager pwmgr: PasswordManager {}
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
    }
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            title: "Help & Feedback"
            onTriggered: {
                googlegroup.trigger("bb.action.OPEN");
            }
            attachedObjects: [
                Invocation {
                    id: googlegroup
                    query {
                        mimeType: "text/html"
                        uri: "https://groups.google.com/forum/m/#!forum/tincan-irc"
                    }
                }
            ]
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
            ListView {
                property alias cmd: root.cmd
                
                id: channelList
                dataModel: ChannelModel { id: chanmod }
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Fill
                listItemComponents: [
                    ListItemComponent {
                        type: "network"
                        
                        Container {
                            id: itemRoot
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
                                        text: ListItemData.host + ":" + ListItemData.userName
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
                                    subtitle: ListItemData.userName
                                    actions:[
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
                                                itemRoot.ListItem.view.dataModel.removeSession(ListItemData);
                                            }
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
                        currentChannel.active=false;
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
                            
                            var session = chanmod.addSession();
                            session.host = host;
                            session.port = parseInt(port.text || port.hintText);
                            session.secure = ssl.checked;
                            session.userName = nick.text || "tincan";
                            session.nickName = nick.text || "tincan";
                            session.realName = "TinCan User";
                            session.open();
                            pwmgr.addSession(session, password.text);
                            chanmod.saveSession(session, password.text);
                            
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
        }
    ] // end of attachedObjects list
}
