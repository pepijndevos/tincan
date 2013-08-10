#ifndef BufferWrapper_HPP_
#define BufferWrapper_HPP_

#include <QObject>
#include <IrcBuffer>
#include <IrcBufferModel>
#include <IrcSession>

#include <bb/cascades/ArrayDataModel>
#include <bb/cascades/ListView>


using namespace bb::cascades;

class BufferWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString network READ getNetwork)
    Q_PROPERTY(QString title READ getTitle)
    Q_PROPERTY(IrcBuffer* buffer READ getBuffer)
    Q_PROPERTY(ArrayDataModel* messages READ getMessages)
        
public:
    BufferWrapper(IrcBuffer* parent=0);
    ~BufferWrapper() {}
    QString getNetwork();
    QString getTitle();
    IrcBuffer* getBuffer();
    ArrayDataModel* getMessages();

public slots:
    void addMessage(IrcMessage* msg);
    void addMessage(IrcCommand* msg);
    void showChannel(QObject* chan);

private:
    IrcBuffer* buf;
    ArrayDataModel* msgs;

};

Q_DECLARE_METATYPE( BufferWrapper* )

#endif /* BufferWrapper_HPP_ */
