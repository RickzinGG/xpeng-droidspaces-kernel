#!/usr/bin/env bash

set -e

cd kernel

export ARCH=arm64
export SUBARCH=arm64

export KBUILD_BUILD_USER=github
export KBUILD_BUILD_HOST=actions

export PATH="$(pwd)/../clang/bin:$PATH"

export CC=clang
export LD=ld.lld

mkdir -p out

echo "USING GKI DEFCONFIG"

make O=out gki_defconfig

cat ../config/droidspaces.fragment >> out/.config

make O=out olddefconfig

make -j$(nproc --all) \
    O=out \
    CC=clang \
    LD=ld.lld \
    LLVM=1 \
    LLVM_IAS=1 \
    HOSTCC=gcc \
    HOSTCXX=g++ \
    KCFLAGS="-Wno-error"
