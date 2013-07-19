DEPENDPATH += . src
INCLUDEPATH += . src

CONFIG += qt cascades

LIBS += -lbbsystem

# Input
HEADERS += src/applicationui.hpp \
           src/channelmodel.hpp \
           src/bufferwrapper.hpp \
           src/sessionfactory.hpp \
           src/usermodel.hpp
SOURCES += src/applicationui.cpp \
           src/channelmodel.cpp \
           src/usermodel.cpp \
           src/bufferwrapper.cpp \
           src/sessionfactory.cpp \
           src/main.cpp

include(communi/src/src.pri)
