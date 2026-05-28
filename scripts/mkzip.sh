#!/usr/bin/env bash

set -e

echo "Clonando AnyKernel3..."

git clone --depth=1 https://github.com/osm0sis/AnyKernel3.git AnyKernel3

echo "Copiando kernel..."

# tenta usar Image.gz-dtb primeiro (preferido)
if [ -f kernel/out/arch/arm64/boot/Image.gz-dtb ]; then
    cp kernel/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/Image
elif [ -f kernel/out/arch/arm64/boot/Image.gz ]; then
    cp kernel/out/arch/arm64/boot/Image.gz AnyKernel3/Image
else
    cp kernel/out/arch/arm64/boot/Image AnyKernel3/Image
fi

echo "Criando anykernel.sh..."

cat > AnyKernel3/anykernel.sh << 'EOF'
properties() { '
kernel.string=DroidSpaces Kernel (Moto G200)
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
supported.versions=
'; }

BLOCK=boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

. tools/ak3-core.sh;

dump_boot;

write_boot;
EOF

echo "Gerando ZIP..."

cd AnyKernel3
zip -r9 ../droidspaces_kernel.zip ./*

echo "Pronto!"
