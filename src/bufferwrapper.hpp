#ifndef BufferWrapper_HPP_
#define BufferWrapper_HPP_

#include <QObject>
#include <IrcCommand>
#include <IrcBuffer>
#include <IrcBufferModel>
#include <IrcConnection>

#include <bb/cascades/ArrayDataModel>
#include <bb/cascades/ListView>
#include <bb/platform/Notification>


using namespace bb::cascades;

class BufferWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString network READ getNetwork)
    Q_PROPERTY(QString title READ getTitle CONSTANT)
    Q_PROPERTY(IrcBuffer* buffer READ getBuffer)
    Q_PROPERTY(ArrayDataModel* messages READ getMessages)
    Q_PROPERTY(int unread READ getUnread NOTIFY unreadChanged)
    Q_PROPERTY(bool active READ getActive WRITE setActive)

public:
    BufferWrapper(IrcBuffer* parent=0);
    ~BufferWrapper() {}
    QString getNetwork();
    QString getTitle();
    IrcBuffer* getBuffer();
    ArrayDataModel* getMessages();
    int getUnread();
    bool getActive();
    void setActive(bool);

public slots:
    void addMessage(IrcMessage* msg);
    void addMessage(IrcCommand* msg);
    void showChannel(QObject* chan);

signals:
    void unreadChanged();

private:
    IrcBuffer* buf;
    ArrayDataModel* msgs;
    int unread;
    bool active;

};

Q_DECLARE_METATYPE( BufferWrapper* )

#endif /* BufferWrapper_HPP_ */
