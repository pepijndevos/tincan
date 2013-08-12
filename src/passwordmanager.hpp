#ifndef PasswordManager_HPP_
#define PasswordManager_HPP_

#include <QObject>
#include <IrcSession>

// this class creates instances of itself and provides passwords

class PasswordManager : public QObject
{
    Q_OBJECT
        
public:
    PasswordManager(QObject* parent=0) : QObject(parent)  {}
    PasswordManager(IrcSession* parent, QString password);
    Q_INVOKABLE void addSession(IrcSession* session, QString password);

public slots:
    void setPassword(QString* password);

private:
    QString password;

};

#endif /* PasswordManager_HPP_ */
