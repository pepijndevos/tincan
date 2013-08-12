#include "passwordmanager.hpp"

PasswordManager::PasswordManager(IrcSession* parent, QString pwd) {
    password = pwd;
    connect(parent, SIGNAL(password(QString*)), this, SLOT(setPassword(QString*)));
}

void PasswordManager::addSession(IrcSession* session, QString pwd) {
    new PasswordManager(session, pwd);
}


void PasswordManager::setPassword(QString* pwd) {
    pwd->swap(password);
}
