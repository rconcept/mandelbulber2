#!/bin/bash
# Build Parameters #
FILEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC=$FILEDIR/../..
BUILD=$SRC/build/
rm -rf $BUILD
mkdir -p $BUILD
cd $BUILD && qmake $SRC/mandelbulber2/qmake/mandelbulber.pro
cd $BUILD && make -j8
#macOS build package
SUPPORT=$SRC/mandelbulber2
PACK=$BUILD/mandelbulber2.app
#making directories
mkdir -vp "$PACK"
#copying README file
cp -v "$SUPPORT/deploy/README" "$PACK"
#copying NEWS file
cp -v "$SUPPORT/deploy/NEWS" "$PACK"
#copying COPYING file
cp -v "$SUPPORT/deploy/COPYING" "$PACK"
#copying share folder
SHARE=$PACK
cp -vr "$SUPPORT/deploy/share" "$SHARE/"
#copying fomula files
cp -vr "$SUPPORT/formula" "$SHARE/"
#copying language files
cp -vr "$SUPPORT/language" "$SHARE/"
#copying opencl files
cp -vr "$SUPPORT/opencl" "$SHARE/"
#copying source files	
cp -vr "$SUPPORT/src" "$PACK/"
cp -vr "$SUPPORT/qt" "$PACK/"
cp -vr "$SUPPORT/opencl" "$PACK/"
#copying makefiles
mkdir -vp "$PACK/makefiles"
cp -v "$SUPPORT/qmake/mandelbulber.pro" "$PACK/makefiles/"
cp -v "$SUPPORT/qmake/mandelbulber-opencl.pro" "$PACK/makefiles/"
cp -v "$SUPPORT/qmake/common.pri" "$PACK/makefiles/"
#copying documentation files
mkdir -vp "$PACK/doc"
cp -v "$SUPPORT/deploy/NEWS" "$PACK/doc"
DOCFILE="$(curl -s https://api.github.com/repos/buddhi1980/mandelbulber_doc/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4)"
echo $DOCFILE
wget -O "$SHARE/doc/Mandelbulber_Manual.pdf" $DOCFILE
cd $BUILD && macdeployqt mandelbulber2.app -dmg
