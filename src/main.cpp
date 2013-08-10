// Default empty project template
#include <bb/cascades/Application>

#include <QObject>
#include <QLocale>
#include <QTranslator>
#include <QSettings>
#include "applicationui.hpp"
#include "channelmodel.hpp"
#include "usermodel.hpp"
#include "bufferwrapper.hpp"

#include <IrcSession>
#include <IrcCommand>
#include <IrcMessage>

// include JS Debugger / CS Profiler enabler
// this feature is enabled by default in the debug build only
#include <Qt/qdeclarativedebug.h>

using namespace bb::cascades;

Q_DECL_EXPORT int main(int argc, char **argv)
{
    QCoreApplication::setOrganizationName("WishfulCoding");
    QCoreApplication::setOrganizationDomain("wishfulcoding.nl");
    QCoreApplication::setApplicationName("TinCan");

    qmlRegisterType<IrcSession>("Communi", 1, 0, "IrcSession");
    qmlRegisterType<SessionWrapper>("Communi", 1, 0, "SessionWrapper");
    qmlRegisterType<IrcBuffer>("Communi", 1, 0, "IrcBuffer");
    qmlRegisterType<BufferWrapper>("Communi", 1, 0, "BufferWrapper");
    qmlRegisterType<IrcBufferModel>("Communi", 1, 0, "IrcBufferModel");
    qmlRegisterType<IrcCommand>("Communi", 1, 0, "IrcCommand");
    qmlRegisterType<ChannelModel>("Communi", 1, 0, "ChannelModel");
    qmlRegisterType<UserModel>("Communi", 1, 0, "UserModel");
    qmlRegisterUncreatableType<IrcMessage>("Communi", 1, 0, "IrcMessage", "");

    // this is where the server is started etc
    Application app(argc, argv);

    // localization support
    QTranslator translator;
    QString locale_string = QLocale().name();
    QString filename = QString( "TinCan_%1" ).arg( locale_string );
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator( &translator );
    }

    new ApplicationUI(&app);

    // we complete the transaction started in the app constructor and start the client event loop here
    return Application::exec();
    // when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
