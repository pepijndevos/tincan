import bb.cascades 1.2

Page {
    titleBar: TitleBar {
        title: qsTr("About") + Retranslate.onLocaleOrLanguageChanged
        scrollBehavior: TitleBarScrollBehavior.Sticky
    }
    ScrollView {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
            leftPadding: padding.leftPadding;
            rightPadding: padding.rightPadding;
            Label {
                text: qsTr("<p>Tin Can IRC is a BlackBerry 10 app built by Wishful Coding &amp; Heris IT.</p><br/><p>The app was made to provide a good native IRC app for every BlackBerry 10 device.</p><br/><p>Heris IT is a small company that builds apps for all mobile devices, both freelance and on request.</p><br/><p>For supportrequests &amp; feedback please visit <a href='https://groups.google.com/forum/m/#!forum/tincan-irc'>https://groups.google.com/forum/m/#!forum/tincan-irc</a>, connect to #tincan on irc.freenode.net or send us an email.</p><br/><p>For more information about Wishful Coding please visit <a href='http://www.wishfulcoding.nl/'>http://www.wishfulcoding.nl/</a> or contact us at <a href='mailto:pepijndevos@gmail.com'>pepijndevos@gmail.com</a>.</p><br/><p>For more information about Heris IT please visit <a href='http://www.heris.nl/'>http://www.heris.nl/</a> or contact us at <a href='mailto:info@heris.nl'>info@heris.nl</a>.</p>") + Retranslate.onLocaleOrLanguageChanged
                textFormat: TextFormat.Html
                multiline: true
                autoSize.maxLineCount: 200
            }
        }
    }
}
