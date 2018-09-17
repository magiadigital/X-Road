#!sbin/bash
cp ../generic/* debian/ 
version=$(dpkg-parsechangelog -l ../generic/changelog | sed -n -e 's/^Version: //p')
rel=$(date --utc --date @`git show -s --format=%ct` +'%Y%m%d%H%M%S')$(git show -s --format=git%h)
dch -v $version.$rel~ubuntu14.04 "Build for trusty"
dch --distribution bionic -r ""
dpkg-buildpackage -tc -b -us -uc
