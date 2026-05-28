#!/usr/bin/env bash

set -e

source config/build.env
source scripts/functions.sh

msg "CLONING ANYKERNEL3"

git clone --depth=1 \
    $ANYKERNEL_REPO AnyKernel3

msg "COPYING IMAGE"

cp kernel/out/arch/arm64/boot/Image \
   AnyKernel3/Image

cd AnyKernel3

rm -f README.md
rm -f .gitignore
rm -rf .git

ZIPNAME="../droidspaces_kernel.zip"

msg "CREATING FLASHABLE ZIP"

zip -r9 $ZIPNAME ./*
