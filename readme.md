# Tin Can IRC client

## building

### Simulator

    source bbndk-env.sh
    qmake -spec blackberry-x86-qcc CONFIG+=simulator -o x86/Makefile
    cd x86
    make
    blackberry-nativepackager -package TinCan.bar ../bar-descriptor.xml -devMode -configuration Simulator
    blackberry-deploy -installApp -launchApp -device 172.16.28.128 TinCan.bar

### Device

    source bbndk-env.sh
    qmake CONFIG+=device -o arm/Makefile
    cd arm
    make
    blackberry-nativepackager -package TinCan.bar ../bar-descriptor.xml -devMode -configuration Device -installApp -launchApp -device 169.254.0.1 -password ***REMOVED*** -debugToken ../debugtoken.bar

### Publish

    blackberry-signer -bbidtoken bbidtoken.csk -storepass ***REMOVED*** TinCan.bar
