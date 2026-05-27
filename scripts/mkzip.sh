#!/usr/bin/env bash

set -e

source config/build.env
source scripts/functions.sh

msg "CLONING ANYKERNEL3"

git clone --depth=1 \
    $ANYKERNEL_REPO AnyKernel3

msg "COPYING IMAGE"

cp kernel/out/arch/arm64/boot/Image \
   AnyKernel3/

cd AnyKernel3

ZIPNAME="${KERNEL_NAME}-${DEVICE}-$(date +%Y%m%d).zip"

msg "CREATING ZIP"

zip -r9 $ZIPNAME *

mv $ZIPNAME ../
