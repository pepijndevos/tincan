#ifndef UserModel_HPP_
#define UserModel_HPP_

#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <IrcSession>
#include <IrcUserModel>
#include <IrcUser>

using namespace bb::cascades;

class UserModel : public GroupDataModel
{
    Q_OBJECT
public:
    UserModel(QObject *parent=0);
    virtual ~UserModel() {}

public slots:
    void readChannel(IrcChannel *channel);
    void userAdded(IrcUser* buf);
    void userRemoved(IrcUser* buf);
};


#endif /* UserModel_HPP_ */
