#ifndef UserModel_HPP_
#define UserModel_HPP_

#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <IrcConnection>
#include <IrcUserModel>
#include <IrcUser>
#include "bufferwrapper.hpp"

using namespace bb::cascades;

class UserModel : public GroupDataModel
{
    Q_OBJECT
public:
    UserModel(QObject *parent=0);
    ~UserModel() {}

public slots:
    void readChannel(BufferWrapper *channel);
    void userAdded(IrcUser* buf);
    void userRemoved(IrcUser* buf);

private:
    IrcUserModel* model;
};


#endif /* UserModel_HPP_ */
