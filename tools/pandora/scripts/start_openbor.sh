#!/bin/sh

OPENBOR_VERSION=$1
SDL_VERSION=$2
OPENBOR_MOD=$3
export PATH="/mnt/utmp/$OPENBOR_MOD/bin/$OPENBOR_VERSION:${PATH:-"/usr/bin:/bin:/usr/local/bin"}"
export LD_LIBRARY_PATH="/mnt/utmp/$OPENBOR_MOD/lib:${LD_LIBRARY_PATH:-"/usr/lib:/lib"}"
export PND_HOME="/mnt/utmp/$OPENBOR_MOD"
export XDG_CONFIG_HOME="/mnt/utmp/$OPENBOR_MOD"

if [ -d /mnt/utmp/$OPENBOR_MOD/share ];then
  export XDG_DATA_DIRS=/mnt/utmp/$OPENBOR_MOD/share:$XDG_DATA_DIRS:/usr/share
fi
if [ $SDL_VERSION = "SDL1" ]
then
  export SDL_AUDIODRIVER="alsa"
  export SDL_VIDEODRIVER="omapdss"
  export SDL_OMAP_LAYER_SIZE="fullscreen"
else
  if [ $SDL_VERSION = "SDL2" ]
  then
    export SDL_VIDEO_GLES2=1
    export SDL_VIDEO_GL_DRIVER=libGLESv2.so
  else
    echo "Unknown SDL version\n"
    exit -2
  fi
fi
cd $PND_HOME
if [ ! -e Images ]
then
  mkdir Images
fi
if [ ! -e Logs ]
then
  mkdir Logs
fi
if [ ! -e Modules ]
then
  mkdir Modules
fi
if [ ! -e Paks ]
then
  mkdir Paks
fi
if [ ! -e Saves ]
then
  mkdir Saves
fi
if [ ! -e ScreenShots ]
then
  mkdir ScreenShots
fi
[ -e "$PND_HOME/scripts/pre_script.sh" ] && . $PND_HOME/scripts/pre_script.sh
if [ -e "$PND_HOME/scripts/post_script.sh" ];then
	OpenBOR $*
	. $PND_HOME/scripts/post_script.sh
else
	exec OpenBOR $*
fi

