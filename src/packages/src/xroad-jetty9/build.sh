#!/bin/bash
if [ ! -e jetty9 ]; then 
    download_jetty.sh
    tar zxf ~/jetty/jetty.tgz -C ~/jetty
    rm -rf jetty9
    mv ~/jetty/jetty-distribution* jetty9
    rm -rf jetty9/lib/setuid
    rm -rf jetty9/demo-base
    mv jetty9/start.ini jetty9/start.ini.bak
    yes | java -Dslf4j.version=1.7.25 -Dlogback.version=1.2.3 -jar jetty9/start.jar --add-to-start=logback-impl,slf4j-logback jetty.base=jetty9
fi


