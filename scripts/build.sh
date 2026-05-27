#!/usr/bin/env bash

set -e

source config/build.env
source scripts/functions.sh

msg "CLONING KERNEL"

git clone --depth=1 \
    -b $KERNEL_BRANCH \
    $KERNEL_REPO kernel

msg "CLONING CLANG"

git clone --depth=1 \
    $CLANG_REPO clang

export ARCH=arm64
export SUBARCH=arm64

export KBUILD_BUILD_USER="github"
export KBUILD_BUILD_HOST="actions"

export PATH=$GITHUB_WORKSPACE/clang/bin:$PATH

cd kernel

mkdir -p out

msg "GENERATING DEFCONFIG"

make O=out $DEFCONFIG

msg "MERGING DROIDSPACES CONFIG"

scripts/kconfig/merge_config.sh \
    -m \
    out/.config \
    ../config/droidspaces.fragment

make O=out olddefconfig

msg "BUILDING KERNEL"

make -j$(nproc --all) \
    O=out \
    CC=clang \
    LLVM=1 \
    LLVM_IAS=1

msg "BUILD FINISHED"
