#
# OpenBOR - http://www.ChronoCrash.com
# -----------------------------------------------------------------------
# All rights reserved. See LICENSE in OpenBOR root for details.
#
# Copyright (c) 2004 - 2014 OpenBOR Team
#

#!/bin/bash
# Script acquires the verison number from SVN Repository and creates
# a version.h as well as the environment variable to be used.

function check_svn_bin {
HOST_PLATFORM=$(uname -s)
if [ `echo $HOST_PLATFORM | grep -o "windows"` ]; then
  if [ ! -d "../tools/svn/bin" ]; then
    echo "-------------------------------------------------------"
    echo "           SVN - Not Found, Installing SVN!"
    echo "-------------------------------------------------------"
    7za x -y ../tools/svn/svn-win32-1.7.0.7z -o../tools/svn/
    echo
    echo "-------------------------------------------------------"
    echo "           SVN - Installation Has Completed!"
    echo "-------------------------------------------------------"
  fi
fi
}

# Support the Bazaar VCS as an alternative to SVN through the bzr-svn plugin
function get_revnum {
  if test -d "../.svn" || test -d "./.svn"; then
    VERSION_CONTROL_BUILD=`svn info | grep "Last Changed Rev" | sed s/Last\ Changed\ Rev:\ //g`
  elif test -d ".bzr"; then
    VERSION_CONTROL_BUILD=`bzr version-info | grep "svn-revno" | sed 's/svn-revno: //g'`
    if [ ! $VERSION_CONTROL_BUILD ]; then # use non-SVN revision number if "svn-revno" property not available
      REVNO=`bzr version-info | grep "revno:" | sed 's/revno: //g'`
      BRANCH=`bzr version-info | grep "branch-nick:" | sed 's/branch-nick: //g'`
      VERSION_CONTROL_BUILD=$REVNO-bzr-$BRANCH
    fi
  elif git svn info >/dev/null 2>&1; then
    VERSION_CONTROL_BUILD=`git svn info | grep "Last Changed Rev" | sed s/Last\ Changed\ Rev:\ //g`
  elif test -d "../.git" || test -d ".git"; then
    VERSION_CONTROL_BUILD=`git rev-list --count HEAD`
  elif test -d "../.hg" || test -d ".hg"; then
    VERSION_CONTROL_BUILD=$((`hg id -n` + 1))
  fi
}

function read_version {
check_svn_bin
get_revnum
VERSION_NAME="OpenBOR"
VERSION_MAJOR=3
VERSION_MINOR=0
VERSION_DATE=`date '+%Y%m%d%H%M%S'`
if [ -z "$OPENBOR_REVISION" ]
then
  export VERSION="v$VERSION_MAJOR.$VERSION_MINOR Build $VERSION_CONTROL_BUILD"
  export SHORT_VERSION="v"$VERSION_MAJOR"."$VERSION_MINOR"b"$VERSION_CONTROL_BUILD
else
  export VERSION="v$VERSION_MAJOR.$VERSION_MINOR Build $OPENBOR_REVISION.$VERSION_CONTROL_BUILD"
  export SHORT_VERSION="v"$VERSION_MAJOR"."$VERSION_MINOR"b"$OPENBOR_REVISION"."$VERSION_CONTROL_BUILD
fi
}

function write_version {
rm -rf version.h
echo "/*
 * OpenBOR - http://www.ChronoCrash.com
 * -----------------------------------------------------------------------
 * All rights reserved, see LICENSE in OpenBOR root for details.
 *
 * Copyright (c) 2004 - 2014 OpenBOR Team
 */

#ifndef VERSION_H
#define VERSION_H

#define VERSION_NAME \"$VERSION_NAME\"
#define VERSION_MAJOR \"$VERSION_MAJOR\"
#define VERSION_MINOR \"$VERSION_MINOR\"" >> version.h
if [ -z "$OPENBOR_REVISION" ]
then
echo "#define VERSION_BUILD \"$VERSION_CONTROL_BUILD\"" >> version.h
else
echo "#define VERSION_BUILD \"$OPENBOR_REVISION.$VERSION_CONTROL_BUILD\"" >> version.h
fi
echo "#define VERSION \"v\"VERSION_MAJOR\".\"VERSION_MINOR\" Build \"VERSION_BUILD
#endif" >> version.h

rm -rf resources/meta.xml
echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<app version=\"1\">
	<name>$VERSION_NAME</name>" >> resources/meta.xml
if [ -z "$OPENBOR_REVISION" ]
then
echo "	<version>$VERSION_MAJOR.$VERSION_MINOR.$VERSION_CONTROL_BUILD</version>" >> resources/meta.xml
else
echo "	<version>$VERSION_MAJOR.$VERSION_MINOR.$OPENBOR_REVISION-$VERSION_CONTROL_BUILD</version>" >> resources/meta.xml
fi
echo "	<release_date>$VERSION_DATE</release_date>
	<coder>Damon Caskey, Plombo, SX, Utunnels, White Dragon</coder>
	<short_description>The Ultimate 2D Game Engine</short_description>
	<long_description>OpenBOR is a highly advanced continuation of Senile Team's semi-2D game engine, Beats Of Rage.  Visit http://www.ChronoCrash.com for all news, events, and releases of the engine and game modules.</long_description>
</app>" >> resources/meta.xml

rm -rf resources/Info.plist
echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Author</key>
  <string>Damon Caskey</string>
  <key>Description</key>
  <string>The Ultimate 2D Game Engine</string>
  <key>ExtendedDescription</key>
  <string>OpenBOR is a highly advanced continuation of Senile Team's semi-2D game engine, Beats Of Rage.  Visit http://www.ChronoCrash.com for all news, events, and releases of the engine and game modules.</string>
  <key>CFBundleIdentifier</key>
  <string>com.ChronoCrash.openbor</string>
  <key>CFBundleShortVersionString</key>
  <string>$VERSION_MAJOR.$VERSION_MINOR</string>
  <key>NSHumanReadableCopyright</key>
  <string>The Ultimate 2D Game Engine. Presented by Damon V. Caskey.

Beats of Rage © SenileTeam
OpenBOR © ChronoCrash
All Rights Reserved</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleSignature</key>
  <string>OBOR</string>
  <key>CFBundleName</key>
  <string>OpenBOR</string>
  <key>CFBundleExecutable</key>
  <string>OpenBOR</string>
  <key>CFBundleVersion</key>" >> resources/Info.plist
if [ -z "$OPENBOR_REVISION" ]
then
echo "  <string>$VERSION_CONTROL_BUILD</string>" >> resources/Info.plist
else
echo "  <string>$OPENBOR_REVISION-$VERSION_CONTROL_BUILD</string>" >> resources/Info.plist
fi
echo "  <key>CFBundleDevelopmentRegion</key>
  <string>English</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>LSRequiresCarbon</key>
  <true/>
  <key>LSMinimumSystemVersion</key>
  <string>10.5</string>
  <key>LSMultipleInstancesProhibited</key>
  <true/>
  <key>CFBundleIconFile</key>
  <string>OpenBOR</string>
  <key>CFBundleDocumentTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeExtensions</key>
      <array>
        <string>pak</string>
        <string>spk</string>
      </array>
      <key>CFBundleTypeIconFile</key>
      <string>OpenBOR.icns</string>
      <key>CFBundleTypeName</key>
      <string>PAK File</string>
      <key>CFBundleTypeOSTypes</key>
        <array>
          <string>pak</string>
          <string>spk</string>
        </array>
      <key>CFBundleTypeRole</key>
      <string>Viewer</string>
    </dict>
    <dict>
      <key>CFBundleTypeIconFile</key>
      <string>OpenBOR.icns</string>
      <key>CFBundleTypeName</key>
      <string>SPK File</string>
      <key>CFBundleTypeRole</key>
      <string>Viewer</string>
    </dict>
  </array>
</dict>
</plist>" >> resources/Info.plist
}

function archive_release {
#TRIMMED_URL=`svn info | grep "URL:" | sed s/URL:\ svn\+ssh//g`
#if test -n $TRIMMED_URL;  then
#  TRIMMED_URL="svn"$TRIMMED_URL
#fi
#svn log  $TRIMMED_URL --verbose > ./releases/VERSION_INFO.txt
7za a -t7z -mx9 -r -x!.svn "./releases/OpenBOR $VERSION.7z" ./releases/*
}

export LC_MESSAGES=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_ALL=en_US.UTF-8

case $1 in
1)
    read_version
    echo ------------------------------------------------------
    echo "      Creating Archive OpenBOR $VERSION.7z"
    echo ------------------------------------------------------
    archive_release
    ;;
2)
    export OPENBOR_REVISION=$2
    echo -----------------------------------------------------------
    echo "      Creating version file for OpenBOR revision $OPENBOR_REVISION"
    echo -----------------------------------------------------------
    read_version
    write_version
    ;;
*)
    read_version
    write_version
    ;;
esac

