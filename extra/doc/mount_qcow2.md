<!--
Source: https://gist.github.com/shamil/62935d9b456a6f9877b5
-->
How to mount a qcow2 disk image
-------------------------------

This is a quick guide to mounting a qcow2 disk images on your host server. This is useful to reset passwords,
edit files, or recover something without the virtual machine running.

**Step 1 - Enable NBD on the Host**
    
    modprobe nbd max_part=8

**Step 2 - Connect the QCOW2 as network block device**

    qemu-nbd --connect=/dev/nbd0 /var/lib/vz/images/100/vm-100-disk-1.qcow2

**Step 3 - Find The Virtual Machine Partitions**

    fdisk /dev/nbd0 -l

**Step 4 - Mount the partition from the VM**

    mount /dev/nbd0p1 /mnt/somepoint/

**Step 5 - After you done, unmount and disconnect**

    umount /mnt/somepoint/
    qemu-nbd --disconnect /dev/nbd0
    rmmod nbd
