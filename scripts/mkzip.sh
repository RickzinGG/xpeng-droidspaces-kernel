#!/usr/bin/env bash

set -e

git clone --depth=1 \
https://github.com/osm0sis/AnyKernel3.git AnyKernel3

IMAGE=$(find kernel/out/arch/arm64/boot -name "Image*" | head -n 1)

if [ -z "$IMAGE" ]; then
  echo "Kernel image not found"
  exit 1
fi

cp $IMAGE AnyKernel3/Image

cat > AnyKernel3/anykernel.sh << 'EOF'
properties() { '
kernel.string=DroidSpaces Kernel for Moto G200
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; }

BLOCK=boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

. tools/ak3-core.sh;

dump_boot;

write_boot;
EOF

cd AnyKernel3

zip -r9 ../droidspaces_kernel.zip ./*
