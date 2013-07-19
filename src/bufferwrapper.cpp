#include "bufferwrapper.hpp"

BufferWrapper::BufferWrapper(IrcBuffer* parent) {
    buf = parent;
    msgs = new ArrayDataModel();
    
    connect(buf, SIGNAL(messageReceived(IrcMessage*)), this, SLOT(addMessage(IrcMessage*)));
}

QString BufferWrapper::getTitle() {
    return buf->title();
}

QString BufferWrapper::getNetwork() {
    return buf->model()->session()->host();
}

IrcBuffer* BufferWrapper::getBuffer() {
    return buf;
}

ArrayDataModel* BufferWrapper::getMessages() {
    return msgs;
}


void BufferWrapper::addMessage(IrcMessage* msg) {
    QVariantMap map;
    switch(msg->type()) {
        case IrcMessage::Private:
            map["message"] = ((IrcPrivateMessage*)msg)->message();
            map["sender"] = ((IrcPrivateMessage*)msg)->sender().name();
            msgs->append(map);
            break;
        default:
            break;
    }
}

void BufferWrapper::addMessage(IrcCommand* cmd) {
    IrcSession* session = buf->session();
    QString sender = session->nickName();
    addMessage(IrcMessage::fromCommand(sender, cmd, session));
}

void BufferWrapper::showChannel(QObject* chan){
    ((ListView*)chan)->setDataModel(msgs);
}
