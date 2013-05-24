DEPENDPATH += . src
INCLUDEPATH += . src

CONFIG += qt cascades

# Input
HEADERS += src/applicationui.hpp
SOURCES += src/applicationui.cpp \
           src/main.cpp

include(communi/src/src.pri)
