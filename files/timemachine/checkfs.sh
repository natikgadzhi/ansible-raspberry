#!/bin/bash

# Verify that /mnt/timemachine/ is available to read and write
# and if it's not, try fsck-ing it and remounting it back.
# 
# This script runs on reboot via chrontab @reboot, and is
# executed as pi.
#

HFS_MOUNT_POINT="/mnt/timemachine" 
HFS_DEVICE="/dev/sda2"

echo "Checking if $HFS_MOUNT_POINT is rw:" 

TEST_FNAME=".checkfs-"$(date +%s)
TEST_FILE_PATH="$HFS_MOUNT_POINT/$TEST_FNAME"

echo -ne " ----> Creating a file $TEST_FNAME in $HFS_MOUNT_POINT:"

touch $TEST_FILE_PATH > /dev/null

if [ ! -e $TEST_FILE_PATH ]
then
  echo " Failed."
  echo -ne " ----> Attempting to restore fs: "

  sudo umount /mnt/timemachine
  sudo fsck.hfsplus -f $HFS_DEVICE
  sudo mount -a

  echo " OK."
else
  echo " OK."
  echo " ----> Removing the test file."
  rm $TEST_FILE_PATH
fi

exit 0