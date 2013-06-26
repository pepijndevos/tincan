#include "bufferwrapper.hpp"

BufferWrapper::BufferWrapper(IrcBuffer* parent) {
    buf = parent;
    msgs = new ArrayDataModel();
    
    QVariantMap map;

            map["message"] = "iets";
            map["sender"] = "iemand";
            msgs->append(map);

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
    qDebug() << "message***********************";
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

void BufferWrapper::showChannel(ListView* chan){
    chan->setDataModel(msgs);
}
