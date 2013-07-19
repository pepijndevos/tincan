#ifndef SessionFactory_HPP_
#define SessionFactory_HPP_

#include <QObject>
#include <IrcSession>

class SessionFactory : public QObject
{
    Q_OBJECT

public slots:
    IrcSession* createSession();

};

#endif /* SessionFactory_HPP_ */
