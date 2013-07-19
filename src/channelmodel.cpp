#include "channelmodel.hpp"
#include "bufferwrapper.hpp"
#include <QDebug>
#include <bb/cascades/ItemGrouping>

ChannelModel::ChannelModel(QObject *parent) : GroupDataModel(QStringList() << "network" << "title", parent) {
    setGrouping(bb::cascades::ItemGrouping::ByFullValue);
}

void ChannelModel::addSession(IrcSession *session) {
    IrcBufferModel* model = new IrcBufferModel(session);
    connect(model, SIGNAL(added(IrcBuffer*)), this, SLOT(bufferAdded(IrcBuffer*)));
    connect(model, SIGNAL(removed(IrcBuffer*)), this, SLOT(bufferRemoved(IrcBuffer*)));

    QVariantMap m;
    m["network"] = session->host();
    m["title"] = "No channels";
    insert(m);
}

void ChannelModel::bufferAdded(IrcBuffer* buf) {
    BufferWrapper* bufw = new BufferWrapper(buf);
    insert(bufw);

    QVariantMap m;
    m["network"] = buf->session()->host();
    m["title"] = "No channels";
    remove(m);
}

void ChannelModel::bufferRemoved(IrcBuffer* buf) {
    BufferWrapper* bufw = new BufferWrapper(buf);
    QVariantList indexPath = find(bufw);
    removeAt(indexPath);
}
