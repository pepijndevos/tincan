#include "usermodel.hpp"
#include <QDebug>
#include <bb/cascades/ItemGrouping>

UserModel::UserModel(QObject *parent) : GroupDataModel(QStringList() << "mode", parent) {
    setGrouping(bb::cascades::ItemGrouping::ByFullValue);

}

void UserModel::readChannel(BufferWrapper *channel) {
	model = new IrcUserModel(channel->getBuffer());
    connect(model, SIGNAL(userAdded(IrcUser*)), this, SLOT(userAdded(IrcUser*)));
    connect(model, SIGNAL(userRemoved(IrcUser*)), this, SLOT(userRemoved(IrcUser*)));
    for(int i=0; i < model->count(); i++){
    	insert(model->get(i));
    }
}

void UserModel::userAdded(IrcUser* buf) {
    //QVariantMap map;
    qDebug() << buf->name() + " joined (" + buf->mode() + ")";
    //map["name"] = buf->name();
    //map["flags"] = buf->mode();
    insert(buf);
}

void UserModel::userRemoved(IrcUser* buf) {
    //QVariantMap map;
    //qDebug() << buf->name() + " left";
	qDebug() << "someone left";
    //map["name"] = buf->name();
    //map["flags"] = buf->mode();
    //remove(buf);
	/*clear();
    for(int i=0; i < model->count(); i++){
    	insert(model->get(i));
    }*/

}
