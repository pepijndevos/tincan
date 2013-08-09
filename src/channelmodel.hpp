#ifndef ChannelModel_HPP_
#define ChannelModel_HPP_

#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <bb/platform/Notification>
#include <IrcSession>
#include <IrcBufferModel>
#include <IrcBuffer>
#include "bufferwrapper.hpp"

using namespace bb::cascades;

class ChannelModel : public DataModel
{
    Q_OBJECT
public:
    ChannelModel(QObject *parent=0);
    virtual ~ChannelModel() {}

    int childCount(const QVariantList &indexPath);
    bool hasChildren(const QVariantList &indexPath);
    QString itemType(const QVariantList &indexPath);
    QVariant data(const QVariantList &indexPath);

public slots:
    IrcSession* addSession();
    void removeSession(IrcSession*);
    void bufferAdded(IrcBuffer* buf);
    void bufferRemoved(IrcBuffer* buf);
    void notifyMention(IrcPrivateMessage* message);
    void notifyConnected(bool con);
signals:
    void itemAdded (QVariantList indexPath);
    void itemRemoved (QVariantList indexPath);
    void itemUpdated (QVariantList indexPath);

private:
    QList<IrcBufferModel*> sessions;
    QMap<IrcBuffer*, BufferWrapper*> wrappers;
};


#endif /* ChannelModel_HPP_ */
