#!/bin/sh

# Check the version number to export variables for SDL1 or SDL2.
VERSION=$1
SDL_VERSION="UNKNOWN"
if [ "$VERSION" = "v3.0b3482" ] || [ "$VERSION" = "v3.0b3711" ] || [ "$VERSION" = "v3.0b3979" ] || [ "$VERSION" = "v3.0b4074" ] || [ "$VERSION" = "v3.0b4569" ]
then
  if [ "$VERSION" = "v3.0b3482" ] || [ "$VERSION" = "v3.0b3711" ] || [ "$VERSION" = "v3.0b3979" ] || [ "$VERSION" = "v3.0b4074" ]
  then
    SDL_VERSION="SDL1"
  else 
      if [ "$VERSION" = "v3.0b4569" ]
      then
        SDL_VERSION="SDL2"
      fi
  fi
fi
if [ "$SDL_VERSION" != "UNKNOWN"  ]
then
  ./scripts/start_openbor.sh "$VERSION" "$SDL_VERSION"
fi
