#ifndef ChannelModel_HPP_
#define ChannelModel_HPP_

#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <IrcSession>
#include <IrcBufferModel>
#include <IrcBuffer>

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
    void addSession(IrcSession *session);
    void bufferAdded(IrcBuffer* buf);
    void bufferRemoved(IrcBuffer* buf);

signals:
    void itemAdded (QVariantList indexPath);
    void itemRemoved (QVariantList indexPath);

private:

    QList<IrcBufferModel*> sessions;
};


#endif /* ChannelModel_HPP_ */
