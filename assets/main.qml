import bb.cascades 1.0

NavigationPane {
    id: root
    signal sendMessage(string msg)
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {}
        settingsAction: SettingsActionItem {}
        actions: [
            ActionItem {
                title: "Add network"
                imageSource: "asset:///icons/ic_add.png"
                onTriggered: {
                    networkDialog.open();
                }
            },
            ActionItem {
                title: "Join channel"
                imageSource: "asset:///icons/ic_add.png"
                onTriggered: {
                    channelDialog.open();
                }
            }
        ] // end of actions list
    } // end of MenuDefinition
    Page {
        Container {
            layout: DockLayout {}
            ListView {
                dataModel: _ChannelModel
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
                       root.sendMessage("JOIN #test");
                   }
               }
            }
        },
        Dialog {
            id: networkDialog
            Container {
                Button {
                    text: "Connect"
                    onClicked: networkDialog.close()
                }
            }
        }
    ] // end of attachedObjects list
}
