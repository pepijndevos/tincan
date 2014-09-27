import bb.cascades 1.0
import bb.system 1.0

Page {
    id: channelpage
    property string uid: "channelpage"
    titleBar: TitleBar {
        id: channeltitle
        scrollBehavior: TitleBarScrollBehavior.Sticky
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                leftPadding: padding.leftPadding
                layout: DockLayout {

                }
                Label {
                    id: chanTitle
                    verticalAlignment: VerticalAlignment.Center
                    text: "#channel"
                    textStyle {
                        color: padding.titleColor
                        base: SystemDefaults.TextStyles.TitleText
                    }
                }
            }
            expandableArea {
                indicatorVisibility: (chanTopic.text!="")? 1:2;
                content: Label {
                    id: chanTopic
                    multiline: true
                    text: "welcome to this lovely channel"
                }
            }
        }
    }
    actions: [
        // define the actions for first tab here
        ActionItem {
            title: qsTr("Users")
            enabled: root.currentChannel.buffer.channel
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
                changeNameDialog.show();
            }
            imageSource: "asset:///icons/ic_edit_profile.png"
        }
    ]
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        ListView {
            id: chan
            stickToEdgePolicy: ListViewStickToEdgePolicy.End
            listItemComponents: [
                ListItemComponent {
                    type: "" //todo
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: ListItemData.sender
                            minWidth: 200
                            maxWidth: 200
                            rightMargin: 0
                            textStyle {
                                fontWeight: FontWeight.Bold
                                color: (ListItemData.msgtype != "private") ? Color.Gray : Color.Black
                                // fancy color?
                            }
                        }
                        TextArea {
                            //multiline: true
                            text: ListItemData.message
                            editable: false
                            focusHighlightEnabled: false
                            maximumLength: 1000
                            verticalAlignment: VerticalAlignment.Top
                            topPadding: 0
                            bottomPadding: 0
                            leftPadding: 0
                            leftMargin: 0
                            textFormat: TextFormat.Plain
                            textStyle {
                                color: (ListItemData.msgtype != "private") ? Color.Gray : Color.Black
                            }
                        }
                    }
                }
            ]
        }
        Container {
            bottomPadding: 10
            leftPadding: 10
            rightPadding: 10
            background: Color.create("#ff323232")
            topPadding: 10.0
            TextField {
                id: msgbar
                inputMode: TextFieldInputMode.Chat
                input {
                    submitKey: SubmitKey.Send
                    onSubmitted: {
                        if (msgbar.text) {
                            var command = cmd.createMessage(currentChannel.buffer.title, msgbar.text);
                            currentChannel.buffer.sendCommand(command);
                            currentChannel.addMessage(command);
                            msgbar.text = "";
                        }
                    }
                }
            }
        }
    }
    onCreationCompleted: {
        chanTitle.text = currentChannel.buffer.title;
        chanTopic.text = currentChannel.buffer.topic;
        currentChannel.showChannel(chan);
    }
    attachedObjects: [
        ComponentDefinition {
            id: users
            source: "users.qml"
        }
    ]
}
