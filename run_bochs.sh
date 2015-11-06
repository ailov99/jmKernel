#!/bin/bash

# mount correct loopback device -> run bochs on it -> disconnect it

sudo /sbin/losetup /dev/loop0 floppy.img
sudo bochs -f bochsrc.txt
sudo /sbin/losetup -d /dev/loop0
