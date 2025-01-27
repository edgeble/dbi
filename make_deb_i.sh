#!/bin/sh

SRC=$(pwd)
DEB_I_SRC="debian-installer-20230607+deb12u9"

sudo apt install -y devscripts equivs

cd $SRC/udb/deb_core_sel/
debuild --no-lintian
cp ../deb-core-sel*.udeb $SRC/$DEB_I_SRC/build/localudebs/

cd $SRC/udb/ml_mdl_sel/
debuild --no-lintian
cp ../ml-mdl-sel*.udeb $SRC/$DEB_I_SRC/build/localudebs/

cd $SRC/udb/kimg/
debuild --no-lintian
cp ../kernel-image-rk3588-di*.udeb $SRC/$DEB_I_SRC/build/localudebs/

cd $SRC/$DEB_I_SRC/
mk-build-deps
sudo apt install -y ./debian-installer-*.deb
cd build/
make reallyclean
make build_netboot

DEST=$SRC/boot
mkdir $DEST
cp dest/netboot/debian-installer/arm64/initrd.gz $DEST/
sudo /sbin/losetup -P  /dev/loop0  dest/netboot/mini.iso
MOUNT_POINT_ISO=/mnt/p2
sudo mkdir $MOUNT_POINT_ISO
sudo mount /dev/loop0p2 $MOUNT_POINT_ISO
cp -r $MOUNT_POINT_ISO/efi/ $DEST/efi/
sudo umount $MOUNT_POINT_ISO
sudo mount /dev/loop0p1 $MOUNT_POINT_ISO
cp -r $MOUNT_POINT_ISO/boot/ $DEST/boot/
cp $MOUNT_POINT_ISO/boot.cat $DEST/
sudo umount $MOUNT_POINT_ISO
sudo cp $SRC/udb/grub.cfg $DEST/boot/grub/

echo "dbi build success"

