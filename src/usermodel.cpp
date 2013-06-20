#include "usermodel.hpp"
#include <QDebug>
#include <bb/cascades/ItemGrouping>

UserModel::UserModel(QObject *parent) : GroupDataModel(QStringList() << "flags" << "username", parent) {
    setGrouping(bb::cascades::ItemGrouping::ByFullValue);

}

void UserModel::readChannel(IrcChannel *channel) {
    //IrcBufferModel* model = new IrcBufferModel(session);
    //connect(model, SIGNAL(bufferAdded(IrcBuffer*)), this, SLOT(bufferAdded(IrcBuffer*)));
    //connect(model, SIGNAL(bufferRemoved(IrcBuffer*)), this, SLOT(bufferRemoved(IrcBuffer*)));
	IrcUserModel* model = new IrcUserModel();
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
