#ifndef SessionWrapper_HPP_
#define SessionWrapper_HPP_

#include <QObject>
#include <IrcBuffer>
#include <IrcBufferModel>
#include <IrcSession>

#include <bb/cascades/ArrayDataModel>
#include <bb/cascades/ListView>


using namespace bb::cascades;

class SessionWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString host READ getHost)
    Q_PROPERTY(QString user READ getUser)
    Q_PROPERTY(bool connected READ isConnected)
    Q_PROPERTY(IrcSession* session READ getSession)
        
public:
    SessionWrapper(IrcSession* parent=0);
    ~SessionWrapper() {}
    QString getHost();
    QString getUser();
    bool isConnected();
    IrcSession* getSession();

private:
    IrcSession* session;
};

Q_DECLARE_METATYPE( SessionWrapper* )

#endif /* SessionWrapper_HPP_ */
