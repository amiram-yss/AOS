# AOS

To compile
nasm -f bin ./boot.asm -o ./boot.bin

To boot (virt machine qemu-system-x86)
qemu-system-x86_64 -hda ./boot.bin
