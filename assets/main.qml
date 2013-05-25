import bb.cascades 1.0

Page {
    signal sendMessage(string msg)
    id: page
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {}
        settingsAction: SettingsActionItem {}
        actions: [
            ActionItem {
                title: "Add network"
                imageSource: "asset:///icons/ic_add.png"
            }
        ] // end of actions list
    } // end of MenuDefinition
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
                                    title: "Add channel"
                                    imageSource: "asset:///icons/ic_add.png"
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
                              ActionItem {
                                    title: "Leave channel"
                                    imageSource: "asset:///icons/ic_delete.png"
                                }
                            }
                        ]
                    }
                } // end of ListItemComponent
            ] // end of listItemComponents list
        }
        TextField {
            id: msgbar
            inputMode: TextFieldInputMode.Chat
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Center
            input {
                onSubmitted: {
                   page.sendMessage(msgbar.text);
                   msgbar.text = "";
                }
            }
        }
    }
}

