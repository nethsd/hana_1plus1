#!/bin/bash

LUNS=$1
VG=$2
LV=$3
MOUNT=$4
STRIPES=$5

usage() {
    echo "Usage : $0 <LUNS> <VG NAME>  <LV NAME>  <MOUNT POINT>"
    exit 1
}
if [[ $# -lt 4 ]];then
    usage
fi

stripes=""
[ ! -z "$STRIPES" ] && stripes="-i $STRIPES"
DEV_STR=""
IFS=','
read -ra LUN_ARR <<< "$LUNS"
for LUN in "${LUN_ARR[@]}"; do
  DISK=$(lsscsi | grep ":$LUN:0]" | awk '{print $NF}' | tail -1)
  if [[ -z $DISK ]];then
    echo "ERROR:: not all disks available; $LUN"
    exit 1
  fi
done
for LUN in "${LUN_ARR[@]}"; do
  DISK=$(lsscsi | grep ":$LUN:0]" | awk '{print $NF}' | tail -1)
  df -h | grep $VG-$LV > /dev/null 2>&1
  if [ $? -ne 0 ];then
    echo "sudo /sbin/pvcreate $DISK"
    sudo /sbin/pvcreate $DISK
  fi
  if [ ! -z $DEV_STR ]; then
    echo "subsequent disks"
    DEV_STR=$DEV_STR" "$DISK
  else
    DEV_STR=$DISK
  fi
done
IFS=' '
echo "sudo /sbin/vgcreate $VG $DEV_STR"
sudo /sbin/vgcreate $VG $DEV_STR
echo "sudo /sbin/lvcreate $stripes -n $LV -l 100%FREE $VG"
sudo /sbin/lvcreate $stripes -n $LV -l 100%FREE $VG
echo "sudo mkdir -p $MOUNT"
sudo mkdir -p $MOUNT
if [ $? -eq 0 ];then
    sed -i "/$VG-$LV/d"
    echo "sudo /sbin/mkfs.xfs -f /dev/mapper/$VG-$LV && echo \"/dev/mapper/$VG-$LV $MOUNT xfs defaults 0 0\" | sudo tee -a /etc/fstab"
    sudo /sbin/mkfs.xfs -f /dev/mapper/$VG-$LV && echo "/dev/mapper/$VG-$LV $MOUNT xfs defaults 0 0" | sudo tee -a /etc/fstab
    echo "mount -a"
    mount -a
fi

