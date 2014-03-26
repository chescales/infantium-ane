#!/bin/bash

echo "Building ANE..."
mkdir -p build
cp 
cp InfantiumLib/bin/InfantiumLib.swc build
pushd build && unzip -o InfantiumLib.swc && popd
pushd InfantiumANE
cp -f ../build/library.swf android/library.swf
cp -f ../build/library.swf default/library.swf
cp -f ../build/InfantiumLib.swc InfantiumLib.swc
adt -package -target ane InfantiumLib.ane extension.xml -swc InfantiumLib.swc -platform Android-ARM -C android . -platform default -C default .
popd
rm -f build/*
mv -f InfantiumANE/InfantiumLib.ane build/InfantiumLib_$(cat VERSION.txt).ane
echo "Done!"
