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
                    text: "welcome to this lovely channel"
                }
            }
        }
    }
    actions: [
        // define the actions for first tab here
        ActionItem {
            title: qsTr("Send")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                //root.sendMessage(msgbar.text);
                chan.append({"sender": "tom", "message": "hello world", "type": "privmsg"});
                msgbar.text = "";
            }
            imageSource: "asset:///icons/ic_textmessage.png"
        },
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
                myQmlDialog.show();
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
                            textStyle {
                                fontWeight: FontWeight.Bold
                                // fancy color?
                            }
                        }
                        Label {
                            text: ListItemData.message
                        }
                    }
                }
            ]
            onCreationCompleted: {
                console.log("created#################");
                console.log(currentChannel.title);
                console.log(currentChannel.messages);
                chanTitle.text = currentChannel.title;
                //chan.dataModel = currentChannel.messages;
                //currentChannel.showChannel(chan);
            }
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            TextField {
                id: msgbar
                inputMode: TextFieldInputMode.Chat
                input {
                    onSubmitted: {
                        root.sendMessage(msgbar.text);
                        msgbar.text = "";
                    }
                }
            }
            ImageView {
                imageSource: "asset:///icons/ic_add.png"
            }

        }

    }
    attachedObjects: [
        ComponentDefinition {
            id: users
            source: "users.qml"
        },
        SystemPrompt {
            id: myQmlDialog
            title: "Friendly Warning"
            body: "Kakel can be habit-forming... "
            onFinished: {
                if (myQmlDialog.result == SystemUiResult.CancelButtonSelection) myQmlToast.show();
            }
        }

    ]
}
