#include "passwordmanager.hpp"

PasswordManager::PasswordManager(IrcConnection* parent, QString pwd) {
    password = pwd;
    connect(parent, SIGNAL(passwordChanged(QString)), this, SLOT(setPassword(QString)));
}

void PasswordManager::addSession(IrcConnection* session, QString pwd) {
    new PasswordManager(session, pwd);
}


void PasswordManager::setPassword(QString* pwd) {
    pwd->swap(password);
}


void PasswordManager::setPassword(QString pwd) {
    pwd.swap(password);
}

