#!/bin/bash

# Usage: ./build.sh <device_codename>

DEVICE_CODENAME=$1
 
if [ -z "$DEVICE_CODENAME" ]; then
    echo "Error: Device codename not provided"
    echo "Usage: ./build.sh <device_codename>"
    exit 1
fi

cd kernel_oneplus_sm8150

# Export required variables
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING=$(clang --version | head -n 1)
export CCACHE_EXEC=$(which ccache)
export KBUILD_BUILD_HOST="Github-actions-kernel"
export LLVM_IAS=1
echo "CONFIG_BUILD_ARM64_DT_OVERLAY=y" >> lineage_sm8150_defconfig

echo "🚀Export required variables..."
echo "⭐ARCH= $ARCH"
echo "⭐SUBARCH= $SUBARCH"
echo "⭐KBUILD_COMPILER_STRING= $KBUILD_COMPILER_STRING"
echo "⭐CCACHE_EXEC= $CCACHE_EXEC"
echo "⭐KBUILD_BUILD_HOST= $KBUILD_BUILD_HOST"

echo "🌌Configure kernel..."
# Configure kernel     
make O=out ARCH=arm64 lineage_sm8150_defconfig
yes "" | make O=out ARCH=arm64 olddefconfig


echo "🔥Start Build..."
# Build kernel
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC="ccache clang" \
    LD=ld.lld \
    AR=llvm-ar \
    NM=llvm-nm \
    LLVM_IAS=1 \
    STRIP=llvm-strip \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    CROSS_COMPILE_COMPAT=arm-linux-androidkernel-
