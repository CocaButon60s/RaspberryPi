#!/bin/bash

WORKSPACE=~/shared

BUILD_DIR=$WORKSPACE/pi-build
LAYERS_DIR=$WORKSPACE/layers

BBLAYERS_CONF=$BUILD_DIR/conf/bblayers.conf
LOCAL_CONF=$BUILD_DIR/conf/local.conf

MACHINE=raspberrypi3-64


IMGDIR=$BUILD_DIR/tmp/deploy/images/$MACHINE

if [ -d $BUILD_DIR ]; then
  rm $BBLAYERS_CONF $LOCAL_CONF
fi

source $LAYERS_DIR/poky/oe-init-build-env $BUILD_DIR

bitbake-layers add-layer \
  $LAYERS_DIR/meta-webkit \
  $LAYERS_DIR/meta-openembedded/meta-oe \
  $LAYERS_DIR/meta-openembedded/meta-python \
  $LAYERS_DIR/meta-openembedded/meta-multimedia \
  $LAYERS_DIR/meta-raspberrypi \

cat <<EOF >> $LOCAL_CONF

MACHINE = "$MACHINE"

# for u-boot
RPI_USE_U_BOOT = "1"

# for systemd
INIT_MANAGER = "systemd"

# for wpe
MACHINE_FEATURES:append = " vc4graphics"
GPU_MEM_256 = "128"
GPU_MEM_512 = "196"
GPU_MEM_1024 = "396"
DISTRO_FEATURES:append = " opengl egl wayland pam"
IMAGE_FEATURES:append = " ssh-server-dropbear hwcodecs"
PREFERRED_PROVIDER_virtual/wpebackend = "wpebackend-fdo"
IMAGE_INSTALL:append = " wpewebkit cog"
LICENSE_FLAGS_ACCEPTED += "synaptics-killswitch"
## font
IMAGE_INSTALL:append = " source-han-sans-jp-fonts"
EOF

i=$IMGDIR
b=$BUILD_DIR
r=$BUILD_DIR/tmp/work/${MACHINE/-/_}-poky-linux/core-image-weston/1.0/rootfs
