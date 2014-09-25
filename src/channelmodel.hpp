#ifndef ChannelModel_HPP_
#define ChannelModel_HPP_

#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <bb/system/SystemToast>
#include <IrcConnection>
#include <IrcBufferModel>
#include <IrcBuffer>
#include "bufferwrapper.hpp"
#include "passwordmanager.hpp"

using namespace bb::cascades;

class ChannelModel : public DataModel
{
    Q_OBJECT
public:
    ChannelModel(QObject *parent=0);
    ~ChannelModel() {};

    int childCount(const QVariantList &indexPath);
    bool hasChildren(const QVariantList &indexPath);
    QString itemType(const QVariantList &indexPath);
    QVariant data(const QVariantList &indexPath);
    Q_INVOKABLE BufferWrapper* getWrapper(IrcBuffer*);
    Q_INVOKABLE IrcConnection* addSession();
    Q_INVOKABLE void removeSession(IrcConnection*);
    Q_INVOKABLE void saveSession(IrcConnection*, QString password);
    Q_PROPERTY(bool empty READ isEmpty NOTIFY itemAdded)

public slots:
    void bufferAdded(IrcBuffer* buf);
    void bufferRemoved(IrcBuffer* buf);
    void notifyError(IrcNumericMessage* message);
    void notifyNotice(IrcNoticeMessage* message);
signals:
    void itemAdded (QVariantList indexPath);
    void itemRemoved (QVariantList indexPath);
    void itemUpdated (QVariantList indexPath);

private:
    QList<IrcBufferModel*> sessions;
    QMap<IrcBuffer*, BufferWrapper*> wrappers;
    bb::system::SystemToast toast;
    void loadSessions();
    bool isEmpty() { return !hasChildren(QVariantList()); }
};

//Q_DECLARE_METATYPE( IrcConnection* )

#endif /* ChannelModel_HPP_ */
