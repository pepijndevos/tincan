#ifndef ChannelModel_HPP_
#define ChannelModel_HPP_

#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <IrcSession>
#include <IrcBufferModel>
#include <IrcBuffer>

using namespace bb::cascades;

class ChannelModel : public GroupDataModel
{
    Q_OBJECT
public:
    ChannelModel(QObject *parent=0);
    virtual ~ChannelModel() {}

public slots:
    void addSession(IrcSession *session);
    void bufferAdded(IrcBuffer* buf);
    void bufferRemoved(IrcBuffer* buf);
};


#endif /* ChannelModel_HPP_ */
