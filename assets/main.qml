import bb.cascades 1.0

Page {
    signal sendMessage(string msg)
    id: page
    Container {
        layout: DockLayout {}
        ListView {
            dataModel: _ChannelModel
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Center
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

