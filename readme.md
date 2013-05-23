# Tin Can IRC client

## building

### Simulator

    source bbndk-env.sh
    qmake -spec blackberry-x86-qcc CONFIG+=simulator
    make
    blackberry-nativepackager -package TinCan.bar bar-descriptor.xml -devMode -configuration Simulator
    blackberry-deploy -installApp -device 172.16.28.128 TinCan.bar

### Device

Untested...

    source bbndk-env.sh
    qmake CONFIG+=device
    make
    blackberry-nativepackager -package TinCan.bar bar-descriptor.xml -devMode -configuration Device
    blackberry-deploy -installApp -device 172.16.28.128 TinCan.bar
