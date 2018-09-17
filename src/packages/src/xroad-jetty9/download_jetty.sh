#!/bin/bash
# Helper script for downloading Jetty if it is not found locally.
WDIR=$(cd "$(dirname "$0")"; pwd)
cd $WDIR
jetty_url=$(cat jetty.url)

REMOTE_JETTY_SHA1SUM="$(curl -ss ${jetty_url}.sha1)"
LOCAL_JETTY_SHA1SUM=$(sha1sum jetty.tgz  | cut -d' ' -f1|| echo "")
echo "Remote hash: $REMOTE_JETTY_SHA1SUM"
echo "Local hash:  $LOCAL_JETTY_SHA1SUM"

if [[ ${REMOTE_JETTY_SHA1SUM} != ${LOCAL_JETTY_SHA1SUM} ]] ; then
  echo "Downloading Jetty"
  wget -O $WDIR/jetty.tgz "$jetty_url"
fi

if [[ ! -d "build/jetty9-$LOCAL_JETTY_SHA1SUM" ]]; then
    cd build
    tar xf "../jetty.tgz" --wildcards "jetty-distribution*"
    mv jetty-distribution* jetty9-$LOCAL_JETTY_SHA1SUM
    ln -sfn jetty9-$LOCAL_JETTY_SHA1SUM jetty9 
    rm -rf jetty9/lib/setuid
    rm -rf jetty9/demo-base
    mv jetty9/start.ini jetty9/start.ini.bak
    yes | java -Dslf4j.version=1.7.25 -Dlogback.version=1.2.3 -jar jetty9/start.jar --add-to-start=logback-impl,slf4j-logback jetty.base=jetty9
fi

