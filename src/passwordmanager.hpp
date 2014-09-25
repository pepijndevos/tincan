#ifndef PasswordManager_HPP_
#define PasswordManager_HPP_

#include <QObject>
#include <IrcConnection>

// this class creates instances of itself and provides passwords

class PasswordManager : public QObject
{
    Q_OBJECT
        
public:
    PasswordManager(QObject* parent=0) : QObject(parent)  {}
    PasswordManager(IrcConnection* parent, QString password);
    Q_INVOKABLE void addSession(IrcConnection* session, QString password);

public slots:
    void setPassword(QString* password);

private:
    QString password;

};

#endif /* PasswordManager_HPP_ */
