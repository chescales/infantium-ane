#!/bin/bash

# Get version number
VERSION_STRING=$(cat VERSION.txt)

echo "Building ANE $VERSION_STRING..."
mkdir -p build

# Unzip .swc file to create library.swf file
cp infantium-lib-actionscript/bin/infantium-lib-actionscript.swc build
pushd build && unzip -o infantium-lib-actionscript.swc && popd

# Get .swf files and place it on infantium-ane folder
pushd infantium-ane
cp -f ../build/library.swf android/library.swf
cp -f ../build/library.swf default/library.swf
cp -f ../build/infantium-lib-actionscript.swc infantium-lib-actionscript.swc

# Finally generate ANE extension. Note: Ensure adt is on path
adt -package -target ane Infantium.ane extension.xml -swc infantium-lib-actionscript.swc -platform Android-ARM -C android . -platform default -C default .
popd

# Delete previous compiled versions and put version string on file
rm -f build/*
mv -f infantium-ane/Infantium.ane build/Infantium_$VERSION_STRING.ane
echo "Done!"
