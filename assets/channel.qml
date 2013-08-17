import bb.cascades 1.0
import bb.system 1.0

Page {
    id: channelpage
    titleBar: TitleBar {
        id: channeltitle
        scrollBehavior: TitleBarScrollBehavior.Sticky
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                topPadding: 20
                leftPadding: 10
                Label {
                    id: chanTitle
                    verticalAlignment: VerticalAlignment.Center
                    text: "#channel"
                    textStyle {
                        color: Color.White
                        base: SystemDefaults.TextStyles.TitleText
                    }
                }
            }
            expandableArea {
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
                            minWidth: 50
                            textStyle {
                                fontWeight: FontWeight.Bold
                                // fancy color?
                            }
                        }
                        Label {
                            multiline: true
                            text: ListItemData.message
                        }
                    }
                }
            ]
        }
        TextField {
            id: msgbar
            inputMode: TextFieldInputMode.Chat
            input {
                submitKey: SubmitKey.Send
                onSubmitted: {
                    var command = cmd.createMessage(currentChannel.buffer.title, msgbar.text);
                    currentChannel.buffer.sendCommand(command);
                    currentChannel.addMessage(command);
                    msgbar.text = "";
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
        },
        SystemPrompt {
            id: changeNameDialog
            title: "Friendly Warning"
            body: "Kakel can be habit-forming... "
            onFinished: {
                if (myQmlDialog.result == SystemUiResult.CancelButtonSelection) myQmlToast.show();
            }
        }

    ]
}
