Kernel 4.16.0 from Debian stretch-backports for Stretch-live or StretchDog.
Modified for to have "aufs" support.

Extract the .tar.gz according to your architecture (e.g. 686-pae or amd64) in the "live" folder of a frugal install and reboot.
(contains the initrd files, vmlinuz1 and kernel-4.16.0 .squashfs module)

The files: initrd1.xz, initrd.img and vmlinuz1 should be overwritten, backup or rename them first before extracting the archive.
