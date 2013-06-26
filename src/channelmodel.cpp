#include "channelmodel.hpp"
#include "bufferwrapper.hpp"
#include <QDebug>
#include <bb/cascades/ItemGrouping>

ChannelModel::ChannelModel(QObject *parent) : GroupDataModel(QStringList() << "network" << "title", parent) {
    setGrouping(bb::cascades::ItemGrouping::ByFullValue);
}

void ChannelModel::addSession(IrcSession *session) {
    IrcBufferModel* model = new IrcBufferModel(session);
    connect(model, SIGNAL(bufferAdded(IrcBuffer*)), this, SLOT(bufferAdded(IrcBuffer*)));
    connect(model, SIGNAL(bufferRemoved(IrcBuffer*)), this, SLOT(bufferRemoved(IrcBuffer*)));
}

void ChannelModel::bufferAdded(IrcBuffer* buf) {
    BufferWrapper* bufw = new BufferWrapper(buf);
    insert(bufw);
}

void ChannelModel::bufferRemoved(IrcBuffer* buf) {
    BufferWrapper* bufw = new BufferWrapper(buf);
    QVariantList indexPath = find(bufw);
    removeAt(indexPath);
}
