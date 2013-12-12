#include "bufferwrapper.hpp"

BufferWrapper::BufferWrapper(IrcBuffer* parent) : QObject(parent) {
    buf = parent;
    unread = 0;
    active = false;
    msgs = new ArrayDataModel(this);
    
    connect(buf, SIGNAL(messageReceived(IrcMessage*)), this, SLOT(addMessage(IrcMessage*)));
}

QString BufferWrapper::getTitle() {
    return buf->title();
}

QString BufferWrapper::getNetwork() {
    QString host = buf->model()->session()->host();
    QString user = buf->model()->session()->userName();
    return host + ":" + user;
}

IrcBuffer* BufferWrapper::getBuffer() {
    return buf;
}

ArrayDataModel* BufferWrapper::getMessages() {
    return msgs;
}

int BufferWrapper::getUnread() {
    return unread;
}

bool BufferWrapper::getActive() {
    return active;
}

void BufferWrapper::setActive(bool sactive){
    active = sactive;
}

void BufferWrapper::addMessage(IrcMessage* msg) {
    QVariantMap map;
    switch(msg->type()) {
        case IrcMessage::Private:
            if(!active) {
                unread++;
                emit unreadChanged();
                if(((IrcPrivateMessage*)msg)->message().contains(((IrcPrivateMessage*)msg)->session()->nickName())) {
                    bb::platform::Notification* pNotification = new bb::platform::Notification();
             
                    pNotification->setTitle(((IrcPrivateMessage*)msg)->sender().name());
                    pNotification->setBody(((IrcPrivateMessage*)msg)->message());
                     
                    pNotification->notify();
                }
            }
            map["message"] = ((IrcPrivateMessage*)msg)->message();
            map["sender"] = ((IrcPrivateMessage*)msg)->sender().name();
            msgs->append(map);
            break;
        case IrcMessage::Join:
            map["message"] = "joined " + ((IrcJoinMessage*)msg)->channel();
            map["sender"] = ((IrcJoinMessage*)msg)->sender().name();
            msgs->append(map);
            break;
        case IrcMessage::Part:
            map["message"] = "left " + ((IrcPartMessage*)msg)->channel();
            map["sender"] = ((IrcPartMessage*)msg)->sender().name();
            msgs->append(map);
            break;
        case IrcMessage::Kick:
            map["message"] = "kicked " + ((IrcKickMessage*)msg)->user() + " from " + ((IrcKickMessage*)msg)->channel() + " for: " + ((IrcKickMessage*)msg)->reason();
            map["sender"] = ((IrcKickMessage*)msg)->sender().name();
            msgs->append(map);
            break;
        case IrcMessage::Quit:
            map["message"] = "quit";
            map["sender"] = ((IrcQuitMessage*)msg)->sender().name();
            msgs->append(map);
            break;
        case IrcMessage::Nick:
            map["message"] = "is now called " + ((IrcNickMessage*)msg)->nick();
            map["sender"] = ((IrcNickMessage*)msg)->sender().name();
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
    unread = 0;
    emit unreadChanged();

    ((ListView*)chan)->setDataModel(msgs);
}
