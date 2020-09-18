#!/bin/sh

OPENBOR_MOD=$1
TXT_DOCUMENT=$2
export PND_HOME="/mnt/utmp/$OPENBOR_MOD"

cd $PND_HOME/share/$OPENBOR_MOD

exec mousepad "$PDF_DOCUMENT"
