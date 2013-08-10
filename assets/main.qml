import bb.cascades 1.0
import bb.system 1.0
import Communi 1.0

NavigationPane {
    id: root
    property variant sessions: {}
    property IrcCommand cmd: IrcCommand {}
    property BufferWrapper currentChannel: BufferWrapper { }
    property string currentNetwork: ""
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
            }
        ]
        Container {
            layout: DockLayout {}
            ListView {
                property alias cmd: root.cmd
                property alias sessions: root.sessions

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
                                        text: ListItemData.host + ":" + ListItemData.user
                                    }
                                }
                                ImageView {
                                    imageSource: "asset:///icons/ic_add_dark.png"
                                }
                            }
                            Container {
                                id: statusBorder
                                horizontalAlignment: HorizontalAlignment.Fill
                                minHeight: 5
                                background: ListItemData.connected ? Color.Green : Color.Red
                            }
                            contextActions: [
                                ActionSet {
                                    ActionItem {
                                        title: "Reconnect"
                                        imageSource: "asset:///icons/ic_rotate.png"
                                        onTriggered: {
                                            var s = itemRoot.ListItem.view.sessions[ListItemData.host + ":" + ListItemData.user];
                                            s.close();
                                            s.open();
                                        }
                                    }
                                    DeleteActionItem {
                                        title: "Delete Network"
                                        onTriggered: {
                                            var s = itemRoot.ListItem.view.sessions[ListItemData.host + ":" + ListItemData.user];
                                            itemRoot.ListItem.view.dataModel.removeSession(s);
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    ListItemComponent {
                        type: "channel"
                          
                        StandardListItem {
                            title: ListItemData.title
                            id: itemRoot
                            contextActions: [
                                ActionSet {
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
                                }
                            ]
                        }
                    } // end of ListItemComponent
                ] // end of listItemComponents list
                onTriggered: {
                    var selectedItem = dataModel.data(indexPath);
                    console.log(JSON.stringify(selectedItem), JSON.stringify(indexPath));
                    if(indexPath.length == 1) { //header
                      currentNetwork = selectedItem.host + ":" + selectedItem.user;
                      joinDialog.show();
                    } else { //item
                      currentChannel = selectedItem;
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
                var roomname = joinDialog.inputFieldTextEntry();
                console.log(roomname);
                if(roomname !== "") {
                  var command = cmd.createJoin(roomname);
                  sessions[currentNetwork].sendCommand(command);
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
                          var id = (host + ":" + name);
                          if(!sessions[id]) {
                            var session = chanmod.addSession();
                            session.host = host;
                            session.port = parseInt(port.text || port.hintText);
                            session.secure = ssl.checked;
                            session.userName = nick.text || "tincan";
                            session.nickName = nick.text || "tincan";
                            session.realName = "TinCan User";
                            session.password.connect(function(pw) {
                              //TODO this doesn't work
                            });
                            session.open();

                            var ss = sessions
                            ss[id] = session;
                            sessions = ss;
                          }

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
        }
    ] // end of attachedObjects list
}
