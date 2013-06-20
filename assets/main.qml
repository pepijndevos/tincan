import bb.cascades 1.0
import Communi 1.0

NavigationPane {
    id: root
    property IrcSession session: IrcSession {}
    property IrcCommand cmd: IrcCommand {}
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {}
        settingsAction: SettingsActionItem {}
    }
    property IrcChannel currentChannel: IrcChannel {
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
            },
            ActionItem {
                title: "Join channel"
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///icons/ic_add.png"
                onTriggered: {
                    channelDialog.open();
                }
            }
        ]
        Container {
            layout: DockLayout {}
            ListView {
                id: channelList
                dataModel: ChannelModel { id: chanmod }
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Center
                listItemComponents: [
                    ListItemComponent {
                        type: "header"
                         
                        Header {
                            title: ListItemData
                            contextActions: [
                                ActionSet {
                                    ActionItem {
                                        title: "Join channel"
                                        imageSource: "asset:///icons/ic_add.png"
                                        onTriggered: {
                                            channelDialog.open();
                                        }
                                    }
                                    DeleteActionItem {
                                        title: "Delete Network"
                                    }
                                }
                            ]
                        }
                    },
                    ListItemComponent {
                        type: "item"
                          
                        StandardListItem {
                            title: ListItemData.channel
                            contextActions: [
                                ActionSet {
                                    DeleteActionItem {
                                        title: "Leave channel"
                                    }
                                }
                            ]
                        }
                    } // end of ListItemComponent
                ] // end of listItemComponents list
                onTriggered: {
                    var selectedItem = dataModel.data(indexPath);
                    //currentChannel = selectedItem //hier moet iets komen zodat bekend wordt in welk channel je zit
                    var newPage = channel.createObject();
                    root.push(newPage);
                    
                }
            }
        }
    }
    attachedObjects: [
        ComponentDefinition {
            id: channel
            source: "channel.qml"
        },
        Dialog {
            id: channelDialog
            Container {
                TextField {
                    id: roomname
                    text: "#test"
                    inputMode: TextFieldInputMode.Text
                }
                Button {
                    text: "Join"
                    onClicked: {
                        channelDialog.close();
                        var command = cmd.createJoin(roomname.text);
                        session.sendCommand(command);
                    }
                }
            }
        },
        Dialog {
            id: networkDialog
            Container {
                TextField {
                    id: server
                    inputMode: TextFieldInputMode.Url
                    text: "irc.freenode.net"
                }
                TextField {
                    id: nick
                    inputMode: TextFieldInputMode.Text
                    text: "riktincantest"
                }
                Button {
                    text: "Connect"
                    onClicked: {
                      session.host = server.text || "irc.freenode.net";
                      session.userName = nick.text || "guest";
                      session.nickName = nick.text || "guest";
                      session.realName = "TinCan User";
                      session.open();

                      chanmod.addSession(session);

                      networkDialog.close()
                    }
                }
            }
        }
    ] // end of attachedObjects list
}
