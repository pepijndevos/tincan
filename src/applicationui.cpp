// Default empty project template
#include "applicationui.hpp"
#include "channelmodel.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/ItemGrouping>

using namespace bb::cascades;

ApplicationUI::ApplicationUI(bb::cascades::Application *app)
: QObject(app)
{
    // create scene document from main.qml asset
    // set parent to created document to ensure it exists for the whole application lifetime
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

	session = new IrcSession(app);
	session->setHost("irc.freenode.net");
	session->setUserName("pepijn___");
	session->setNickName("pepijn___");
	session->setRealName("Pepijn de Vos");
	session->open();

	ChannelModel *mod = new ChannelModel(app);
	mod->setGrouping(ItemGrouping::ByFullValue);
	qml->setContextProperty("_ChannelModel", mod);
	connect(session, SIGNAL(messageReceived(IrcMessage*)), mod, SLOT(receiveMessage(IrcMessage*)));

    // create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();
	connect(root, SIGNAL(sendMessage(QString)), this, SLOT(sendMessage(QString)));
    // set created root object as a scene
    app->setScene(root);
}

void ApplicationUI::sendMessage(QString message) {
	qDebug() << message;
	session->sendRaw(message);
}
