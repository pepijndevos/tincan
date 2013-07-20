#include "channelmodel.hpp"
#include <QDebug>

ChannelModel::ChannelModel(QObject *parent) : DataModel(parent) { }

IrcSession* ChannelModel::addSession() {
    IrcSession* session = new IrcSession();

    IrcBufferModel* model = new IrcBufferModel(session);
    connect(model, SIGNAL(added(IrcBuffer*)), this, SLOT(bufferAdded(IrcBuffer*)));
    connect(model, SIGNAL(removed(IrcBuffer*)), this, SLOT(bufferRemoved(IrcBuffer*)));
    sessions.append(model);

    QVariantList indexPath = QVariantList();
    indexPath.append(sessions.indexOf(model));
    emit itemAdded(indexPath);

    return session;
}

void ChannelModel::bufferAdded(IrcBuffer* buf) {
    wrappers.insert(buf, new BufferWrapper(buf));

    QVariantList indexPath = QVariantList();
    int sessionIndex = sessions.indexOf(buf->model());
    int bufferIndex = buf->model()->buffers().indexOf(buf);
    indexPath.append(sessionIndex);
    indexPath.append(bufferIndex);
    emit itemAdded(indexPath);
}

void ChannelModel::bufferRemoved(IrcBuffer* buf) {
    wrappers.remove(buf);

    QVariantList indexPath = QVariantList();
    int sessionIndex = sessions.indexOf(buf->model());
    int bufferIndex = buf->model()->buffers().indexOf(buf);
    indexPath.append(sessionIndex);
    indexPath.append(bufferIndex);
    emit itemRemoved(indexPath);
}

int ChannelModel::childCount(const QVariantList &indexPath) {
    switch (indexPath.length()) {
        case 0:
            return sessions.length();
        case 1:
            return sessions.value(indexPath.value(0).toInt())->buffers().length();
        default:
            return 0;
    }
}

bool ChannelModel::hasChildren(const QVariantList &indexPath) {
    return childCount(indexPath) != 0;
}

QString ChannelModel::itemType(const QVariantList &indexPath) {
    if (indexPath.length() == 1) {
        return "network";
    } else {
        return "channel";
    }
}

QVariant ChannelModel::data(const QVariantList &indexPath) {
    IrcBufferModel* s = sessions.value(indexPath.value(0).toInt());
    if (indexPath.length() == 1) {
        QString host = s->session()->host();
        QString user = s->session()->userName();
        return host + ":" + user;
    } else {
        IrcBuffer* b = s->buffers().value(indexPath.value(1).toInt());
        BufferWrapper* bw = wrappers.value(b);
        return QVariant::fromValue(bw);
    }
}
