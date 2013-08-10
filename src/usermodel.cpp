#include "usermodel.hpp"
#include <QDebug>
#include <bb/cascades/ItemGrouping>

UserModel::UserModel(QObject *parent) : GroupDataModel(QStringList() << "name", parent) {
    setGrouping(bb::cascades::ItemGrouping::ByFirstChar);
}

void UserModel::readChannel(BufferWrapper *channel) {
	model = new IrcUserModel(channel->getBuffer());
    connect(model, SIGNAL(added(IrcUser*)), this, SLOT(userAdded(IrcUser*)));
    connect(model, SIGNAL(removed(IrcUser*)), this, SLOT(userRemoved(IrcUser*)));
    for(int i=0; i < model->count(); i++){
    	insert(model->get(i));
    }
}

void UserModel::userAdded(IrcUser* usr) {
    qDebug() << "joined";
    insert(usr);
}

void UserModel::userRemoved(IrcUser* usr) {
    qDebug() << "left" << usr->name();
    removeAt(find(usr));
}
