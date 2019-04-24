# mink64os
project ot make OS

Day01. 20190423 Creation of Git repository, directories, makefile test (tab, no space)

Day02: install qemu, install gcc, nasm
 - sudo apt-get install qemu-kvm qemu virt-manager virt-viewer libvirt-bin
 - sudo apt-get install gcc-multilib g++-multilib
 - sudo apt-get install nasm
 
 bootloader using assembly : BootLoader.asm
 - nasm -f bin -o Disk.bin BootLoader.asm

 Tomorrow : make Disk.img through Disk.bin