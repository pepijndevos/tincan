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
                //dataModel: _ChannelModel
                //TODO QlistDataModel based on IrcBufferModel
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
               Button {
                   text: "Join"
                   onClicked: {
                       channelDialog.close();
                       console.log(IrcCommand);
                       var command = cmd.createJoin("#test");
                       session.sendCommand(command);
                   }
               }
            }
        },
        Dialog {
            id: networkDialog
            Container {
                Button {
                    text: "Connect"
                    onClicked: {
                      console.log(session)
                      session.host = "irc.freenode.net";
                      session.userName = "pepijn__";
                      session.nickName = "pepijn__";
                      session.realName = "Pepijn de Vos";
                      session.open();
                      networkDialog.close()
                    }
                }
            }
        }
    ] // end of attachedObjects list
}
