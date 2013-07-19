import bb.cascades 1.0
import bb.system 1.0
import Communi 1.0

NavigationPane {
    id: root
    property variant sessions: {}
    property SessionFactory sfact: SessionFactory {}
    property IrcCommand cmd: IrcCommand {}
    property BufferWrapper currentChannel: BufferWrapper { }
    property string currentNetwork: ""
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
                            subtitle: "Add channel"
                            contextActions: [
                                ActionSet {
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
                            title: ListItemData.title
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
                    console.log(JSON.stringify(selectedItem), JSON.stringify(indexPath));
                    if(indexPath.length == 1) { //header
                      currentNetwork = selectedItem;
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
                background: SystemDefaults.Paints.containerBackground
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
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
                      var host = server.text || "irc.freenode.net";
                      if(!sessions[host]) {
                        var session = sfact.createSession();
                        session.host = host;
                        session.userName = nick.text || "guest";
                        session.nickName = nick.text || "guest";
                        session.realName = "TinCan User";
                        session.open();

                        chanmod.addSession(session);

                        var ss = sessions
                        ss[session.host] = session;
                        sessions = ss;
                      }

                      networkDialog.close()
                    }
                }
            }
        }
    ] // end of attachedObjects list
}
