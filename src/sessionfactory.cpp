#include "sessionfactory.hpp"

IrcSession* SessionFactory::createSession() {
    return new IrcSession(parent());
}
