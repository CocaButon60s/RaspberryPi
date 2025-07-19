#!/bin/bash

BUILD_DIR=pi-build
BBLAYERS_CONF=conf/bblayers.conf
LOCAL_CONF=conf/local.conf
MACHINE=raspberrypi3-64

WORKSPACE=~/shared

IMGDIR=$WORKSPACE/$BUILD_DIR/tmp/deploy/images/$MACHINE

if [ -d $BUILD_DIR ]; then
  rm $BUILD_DIR/$BBLAYERS_CONF $BUILD_DIR/$LOCAL_CONF
fi

source poky/oe-init-build-env $BUILD_DIR

bitbake-layers add-layer \
  ../meta-openembedded/meta-oe \
  ../meta-raspberrypi \
  ../meta-customize

cat <<EOF >> $LOCAL_CONF
MACHINE = "$MACHINE"

# for u-boot
RPI_USE_U_BOOT = "1"
# for serial console. appear /dev/ttyS0
ENABLE_UART = "1"

# for systemd
INIT_MANAGER = "systemd"

IMAGE_INSTALL:append = " testapp libexample"
# for ssh
IMAGE_INSTALL:append = " openssh ssh-pregen-hostkeys avahi-daemon"
# for gdbserver
IMAGE_INSTALL:append = " gdbserver"
INHIBIT_PACKAGE_STRIP = "1"
# for nfs boot
# CMDLINE_ROOTFS = "ip=dhcp root=/dev/nfs nfsroot=192.168.1.29:/,vers=4,tcp rw rootfstype=ext4 rootwait"

EOF


function cpimg() {
  DSTDIR=/mnt
  sudo cp $IMGDIR/core-image-minimal-$MACHINE.rootfs.wic.bz2 $DSTDIR
  sudo cp $IMGDIR/core-image-minimal-$MACHINE.rootfs.wic.bmap $DSTDIR
}

i=$IMGDIR
b=$WORKSPACE/$BUILD_DIR
r=$WORKSPACE/$BUILD_DIR/tmp/work/${MACHINE/-/_}-poky-linux/core-image-minimal/1.0/rootfs
