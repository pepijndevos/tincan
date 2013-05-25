DEPENDPATH += . src
INCLUDEPATH += . src

CONFIG += qt cascades

# Input
HEADERS += src/applicationui.hpp \
           src/channelmodel.hpp
SOURCES += src/applicationui.cpp \
           src/channelmodel.cpp \
           src/main.cpp

include(communi/src/src.pri)
