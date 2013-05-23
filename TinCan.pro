DEPENDPATH += . src
INCLUDEPATH += . src

simulator {
  DESTDIR = $${PWD}/x86
}

device {
  DESTDIR = $${PWD}/arm
}

CONFIG += qt cascades

# Input
HEADERS += src/applicationui.hpp
SOURCES += src/applicationui.cpp \
           src/main.cpp
