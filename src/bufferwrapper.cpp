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
    QString host = buf->model()->connection()->host();
    QString user = buf->model()->connection()->userName();
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
                if(((IrcPrivateMessage*)msg)->content().contains(((IrcPrivateMessage*)msg)->connection()->nickName())) {
                    bb::platform::Notification* pNotification = new bb::platform::Notification();

                    pNotification->setTitle(((IrcPrivateMessage*)msg)->nick());
                    pNotification->setBody(((IrcPrivateMessage*)msg)->content());

                    pNotification->notify();
                }
            }
            map["message"] = ((IrcPrivateMessage*)msg)->content();
            map["sender"] = ((IrcPrivateMessage*)msg)->nick();
            map["msgtype"] = "private";
            msgs->append(map);
            break;
        case IrcMessage::Join:
            map["message"] = "joined " + ((IrcJoinMessage*)msg)->channel();
            map["sender"] = ((IrcJoinMessage*)msg)->nick();
            map["msgtype"] = "join";
            msgs->append(map);
            break;
        case IrcMessage::Part:
            map["message"] = "left " + ((IrcPartMessage*)msg)->channel();
            map["sender"] = ((IrcPartMessage*)msg)->nick();
            map["msgtype"] = "part";
            msgs->append(map);
            break;
        case IrcMessage::Kick:
            map["message"] = "kicked " + ((IrcKickMessage*)msg)->user() + " from " + ((IrcKickMessage*)msg)->channel() + " for: " + ((IrcKickMessage*)msg)->reason();
            map["sender"] = ((IrcKickMessage*)msg)->nick();
            map["msgtype"] = "kick";
            msgs->append(map);
            break;
        case IrcMessage::Quit:
            map["message"] = "quit";
            map["sender"] = ((IrcQuitMessage*)msg)->nick();
            map["msgtype"] = "quit";
            msgs->append(map);
            break;
        case IrcMessage::Nick:
            map["message"] = "is now called " + ((IrcNickMessage*)msg)->newNick();
            map["sender"] = ((IrcNickMessage*)msg)->oldNick();
            map["msgtype"] = "nick";
            msgs->append(map);
            break;
        case IrcMessage::Topic:
            map["message"] = "set topic to " + ((IrcTopicMessage*)msg)->topic();
            map["sender"] = ((IrcTopicMessage*)msg)->nick();
            map["msgtype"] = "nick";
            msgs->append(map);
            break;
        default:
            break;
    }
}

void BufferWrapper::addMessage(IrcCommand* cmd) {
    IrcConnection* connection = buf->connection();
    QString sender = connection->nickName();
    //addMessage(IrcCommand::toMessage(sender, cmd, connection));
	IrcMessage* message = cmd->toMessage(sender,connection);
	addMessage(message);
}

void BufferWrapper::showChannel(QObject* chan){
    unread = 0;
    emit unreadChanged();

    ((ListView*)chan)->setDataModel(msgs);
}

bool BufferWrapper::isEnabled() {
    return ((IrcBuffer*)parent())->connection()->isEnabled();
}
