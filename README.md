# AOS

To compile
make

To boot (virt machine qemu-system-x86)
qemu-system-x86_64 -hda ./boot.bin

Basic bootloader, now has basic output, disk reading functionality(int 0x13), zero interrupt handler, and bootable using USB stick.
