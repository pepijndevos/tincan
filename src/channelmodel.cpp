#include "channelmodel.hpp"
#include <QDebug>
#include <bb/cascades/ItemGrouping>

ChannelModel::ChannelModel(QObject *parent) : GroupDataModel(QStringList() << "network" << "channel", parent) {
    setGrouping(bb::cascades::ItemGrouping::ByFullValue);
}

void ChannelModel::addSession(IrcSession *session) {
    IrcBufferModel* model = new IrcBufferModel(session);
    connect(model, SIGNAL(bufferAdded(IrcBuffer*)), this, SLOT(bufferAdded(IrcBuffer*)));
    connect(model, SIGNAL(bufferRemoved(IrcBuffer*)), this, SLOT(bufferRemoved(IrcBuffer*)));
}

void ChannelModel::bufferAdded(IrcBuffer* buf) {
    QVariantMap map;
    qDebug() << "joining";
    map["channel"] = buf->title();
    map["network"] = buf->model()->session()->host();
    insert(map);
}

void ChannelModel::bufferRemoved(IrcBuffer* buf) {
    QVariantMap map;
    qDebug() << "parting";
    map["channel"] = buf->title();
    map["network"] = buf->model()->session()->host();
    remove(map);
}
