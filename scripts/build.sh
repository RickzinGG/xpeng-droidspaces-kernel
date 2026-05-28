#!/usr/bin/env bash

set -e

cd kernel

export ARCH=arm64
export SUBARCH=arm64

export KBUILD_BUILD_USER=github
export KBUILD_BUILD_HOST=actions

export CC=clang
export LD=ld.lld

export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

mkdir -p out

echo "USING GKI DEFCONFIG"

make \
    O=out \
    ARCH=arm64 \
    gki_defconfig

cat ../config/droidspaces.fragment >> out/.config

make \
    O=out \
    ARCH=arm64 \
    olddefconfig

make -j$(nproc --all) \
    O=out \
    ARCH=arm64 \
    CC=clang \
    LD=ld.lld \
    LLVM=1 \
    LLVM_IAS=1 \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    HOSTCC=gcc \
    HOSTCXX=g++ \
    KCFLAGS="-Wno-error"
