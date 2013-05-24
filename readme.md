# Tin Can IRC client

## building

### Simulator

    source bbndk-env.sh
    qmake -spec blackberry-x86-qcc CONFIG+=simulator -o x86/Makefile
    cd x86
    make
    blackberry-nativepackager -package TinCan.bar bar-descriptor.xml -devMode -configuration Simulator
    blackberry-deploy -installApp -device 172.16.28.128 TinCan.bar

### Device

Untested...

    source bbndk-env.sh
    qmake CONFIG+=device -o arm/Makefile
    cd arm
    make
    blackberry-nativepackager -package TinCan.bar bar-descriptor.xml -devMode -configuration Device
    blackberry-deploy -installApp -device 172.16.28.128 TinCan.bar
