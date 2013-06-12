#include "channelmodel.hpp"
#include <QDebug>

void ChannelModel::receiveMessage(IrcMessage* message) {
    QVariantMap map;
    if (message->sender().name() == message->session()->nickName()) {
        switch(message->type()) {
            case IrcMessage::Join:
                qDebug() << "joining";
                map["channel"] = ((IrcJoinMessage*)message)->channel();
                map["network"] = message->session()->host();
                insert(map);
                break;
            case IrcMessage::Part:
                qDebug() << "parting";
                map["channel"] = ((IrcPartMessage*)message)->channel();
                map["network"] = message->session()->host();
                remove(map);
                break;
            default:
                qDebug() << "other";
        }
    }
}
