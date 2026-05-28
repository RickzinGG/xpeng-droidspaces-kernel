#!/usr/bin/env bash

set -e

cd kernel

export ARCH=arm64
export SUBARCH=arm64

export LLVM=1
export LLVM_IAS=1

export PATH="$(pwd)/../clang/bin:$PATH"

export CC=clang
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip

mkdir -p out

echo "USING GKI DEFCONFIG"

make O=out gki_defconfig

cat ../config/droidspaces.fragment >> out/.config

make O=out olddefconfig

make -j$(nproc --all) \
    O=out \
    CC=clang \
    LLVM=1 \
    LLVM_IAS=1 \
    KCFLAGS="-Wno-error" \
    KBUILD_MODPOST_WARN=1
