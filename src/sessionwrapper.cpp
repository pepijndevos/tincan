#include "sessionwrapper.hpp"

SessionWrapper::SessionWrapper(IrcSession* parent) {
    session = parent;
}

QString SessionWrapper::getHost() {
    return session->host();
}

QString SessionWrapper::getUser() {
    return session->userName();
}

bool SessionWrapper::isConnected() {
    return session->isConnected();
}

IrcSession* SessionWrapper::getSession() {
    return session;
}
