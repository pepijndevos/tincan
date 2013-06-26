#include "usermodel.hpp"
#include <QDebug>
#include <bb/cascades/ItemGrouping>

UserModel::UserModel(QObject *parent) : GroupDataModel(QStringList() << "flags" << "username", parent) {
    setGrouping(bb::cascades::ItemGrouping::ByFullValue);

}

void UserModel::readChannel(BufferWrapper *channel) {
	IrcUserModel* model = new IrcUserModel(channel->getBuffer());
    connect(model, SIGNAL(userAdded(IrcUser*)), this, SLOT(userAdded(IrcUser*)));
    connect(model, SIGNAL(userRemoved(IrcUser*)), this, SLOT(userRemoved(IrcUser*)));
}

void UserModel::userAdded(IrcUser* buf) {
    QVariantMap map;
    qDebug() << buf->name() + " joined";
    map["username"] = buf->name();
    map["flags"] = buf->mode();
    insert(map);
}

void UserModel::userRemoved(IrcUser* buf) {
    QVariantMap map;
    qDebug() << buf->name() + " left";
    map["username"] = buf->name();
    map["flags"] = buf->mode();
    remove(map);
}
