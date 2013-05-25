#ifndef ChannelModel_HPP_
#define ChannelModel_HPP_

#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <IrcMessage>
#include <IrcSession>

using namespace bb::cascades;

class ChannelModel : public GroupDataModel
{
    Q_OBJECT
public:
    ChannelModel(QObject *parent=0) : GroupDataModel(QStringList() << "network" << "channel", parent) {}
    virtual ~ChannelModel() {}
public slots:
    void receiveMessage(IrcMessage* message);
};


#endif /* ChannelModel_HPP_ */
