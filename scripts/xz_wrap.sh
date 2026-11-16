#!/bin/sh
#
# This is a wrapper for xz to compress the kernel image using appropriate
# compression options depending on the architecture.
#
# Author: Lasse Collin <lasse.collin@tukaani.org>
#
# This file has been put into the public domain.
# You can do whatever you want with this file.
#

BCJ=
LZMA2OPTS=

case $SRCARCH in
	x86)            BCJ=--x86 ;;
	powerpc)        BCJ=--powerpc ;;
	ia64)           BCJ=--ia64; LZMA2OPTS=pb=4 ;;
	arm)            BCJ=--arm ;;
	sparc)          BCJ=--sparc ;;
esac

# Some xz builds (e.g. the Android prebuilt) lack the BCJ filters. The
# filter is optional for the in-kernel decompressor, so only use it when
# this xz supports it.
if [ -n "$BCJ" ] && ! echo | xz --check=crc32 $BCJ --lzma2=dict=1MiB >/dev/null 2>&1; then
	BCJ=
fi

exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB
