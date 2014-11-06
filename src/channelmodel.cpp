#include "channelmodel.hpp"
#include <QDebug>

ChannelModel::ChannelModel(QObject *parent) : DataModel(parent) {
    loadSessions();
}

IrcBufferModel* ChannelModel::addSession() {
    IrcConnection* session = new IrcConnection();
    connect(session, SIGNAL(numericMessageReceived(IrcNumericMessage*)), this, SLOT(notifyError(IrcNumericMessage*)));
    connect(session, SIGNAL(noticeMessageReceived(IrcNoticeMessage*)), this, SLOT(notifyNotice(IrcNoticeMessage*)));
    connect(session, SIGNAL(connected()), this, SLOT(loadModel()));

    IrcBufferModel* model = new IrcBufferModel(session);
    connect(model, SIGNAL(added(IrcBuffer*)), this, SLOT(bufferAdded(IrcBuffer*)));
    connect(model, SIGNAL(aboutToBeRemoved(IrcBuffer*)), this, SLOT(bufferRemoved(IrcBuffer*)));
    sessions.append(model);

    QVariantList indexPath = QVariantList();
    indexPath.append(sessions.indexOf(model));
    emit itemAdded(indexPath);

    return model;
}

void ChannelModel::removeSession(IrcConnection* s) {
    s->quit("Goodbye from TinCan");
    s->close(); //bad?
    const int listSize = sessions.size();
    for (int i = 0; i < listSize; ++i) {
        IrcBufferModel* model = sessions.at(i);
        if(model->connection() == s) {
            sessions.removeAt(i);

            QSettings settings;
            settings.remove(s->host() + ":" + s->userName().replace("/", ":"));

            QVariantList indexPath = QVariantList();
            indexPath.append(i);
            emit itemRemoved(indexPath);

            delete s;
            break;
        }
    }
}

void ChannelModel::saveSession(IrcConnection* session) {
    QSettings settings;

    settings.beginGroup(session->host() + ":" + session->userName().replace("/", ":"));
    settings.setValue("session", session->saveState());
    settings.endGroup();
}

void ChannelModel::loadSessions() {
    QSettings settings;
    foreach(QString network, settings.childGroups()) {
        qDebug() << network;
        IrcBufferModel* s = addSession();
        IrcConnection* c = s->connection();

        settings.beginGroup(network);
        c->restoreState(settings.value("session").toByteArray());
        c->open();
        settings.endGroup();

    }
}

void ChannelModel::saveModel(IrcBufferModel* bm) {
    IrcConnection* session = bm->connection();
    QSettings settings;

    settings.beginGroup(session->host() + ":" + session->userName().replace("/", ":"));
    settings.setValue("buffers", bm->saveState());
    settings.endGroup();
}

void ChannelModel::loadModel() {
    QSettings settings;

    const int listSize = sessions.size();
    for (int i = 0; i < listSize; ++i) {
        IrcBufferModel* model = sessions.at(i);
        IrcConnection* session = model->connection();
        if(session->isConnected()) {
            settings.beginGroup(session->host() + ":" + session->userName().replace("/", ":"));
            model->restoreState(settings.value("buffers").toByteArray());
            settings.endGroup();
        }
    }
}

void ChannelModel::bufferAdded(IrcBuffer* buf) {
    BufferWrapper* bw = new BufferWrapper(buf);
    connect(buf->connection(), SIGNAL(enabledChanged(bool)), bw, SIGNAL(enabledChanged()));    
    wrappers.insert(buf, bw);
    saveModel(buf->model());

    QVariantList indexPath = QVariantList();
    int sessionIndex = sessions.indexOf(buf->model());
    int bufferIndex = buf->model()->buffers().indexOf(buf);
    indexPath.append(sessionIndex);
    indexPath.append(bufferIndex);
    emit itemAdded(indexPath);
}

void ChannelModel::bufferRemoved(IrcBuffer* buf) {
    wrappers.remove(buf);
    saveModel(buf->model());

    QVariantList indexPath = QVariantList();
    int sessionIndex = sessions.indexOf(buf->model());
    int bufferIndex = buf->model()->buffers().indexOf(buf);
    qDebug() << sessionIndex << bufferIndex;
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

BufferWrapper* ChannelModel::getWrapper(IrcBuffer* buf) {
    return wrappers.value(buf);
}

QVariant ChannelModel::data(const QVariantList &indexPath) {
    IrcBufferModel* s = sessions.value(indexPath.value(0).toInt());
    if (indexPath.length() == 1) {
        return QVariant::fromValue(s->connection());
    } else {
        IrcBuffer* b = s->buffers().value(indexPath.value(1).toInt());
        BufferWrapper* bw = getWrapper(b);
        return QVariant::fromValue(bw);
    }
}

void ChannelModel::notifyError(IrcNumericMessage* m) {
    if (Irc::codeToString(m->code()).startsWith("ERR_")) {
        toast.setBody("ERROR: " + m->parameters().last());
        toast.show();
    }
}

void ChannelModel::notifyNotice(IrcNoticeMessage* m) {
    toast.setBody(m->content());
    toast.show();
}
