#### Debian ‘bullseye live’ build system

* * * * *

** Updated 2021-02-19** see [Changes and Fixes]( https://forum.puppylinux.com/viewtopic.php?p=14738#p14738)   
Very similar as the ‘mklive-stretch’ or ‘mklive-buster' build system see
e.g.
[Here](https://github.com/DebianDog/MakeLive/blob/gh-pages/README-Stretch.md)
and [Forum thread
Buster](https://puppylinux.rockedge.org/viewtopic.php?f=46&t=87) , but
this will build from ‘Bullseye’ branch and has many changes and
improvements. [Bullseye build script](https://puppylinux.rockedge.org/viewtopic.php?p=14736#p14736)   

Rather than just one script it’s now also packed as appimage, reason is
that this way it works ‘out of the box’ on most OS’s including modern
puppies. The appimage has included e.g. yad, debootstrap, dpkg, xorriso
(for creating ISO), so nothing extra should be required to install.
Tested on Dpup-Stretch, FossaPup64, DebianDog, Fatdog (but on the latter
I needed to install ‘perl’ first from gslapt).

Note that this doesn’t build a Puppy such as when using Woof-CE, but a
puppy-like ‘Dog’ system (see more: [Dog Linux
website](https://debiandog.github.io/doglinux/))

**Download mklive-bullseye appimage:** (or see single script below)   
 For 32-bit:
[mklive-bullseye32](https://debiandog.github.io/MakeLive/mklive-bullseye32)   
 For 64-bit:
[mklive-bullseye64](https://debiandog.github.io/MakeLive/mklive-bullseye64)

Make executable, e.g:   
 `chmod +x mklive-bullseye32`  
 Running without arguments it will show usage help, to run with GUI,
e.g.:   
 `./mklive-bullseye32 -gui`   
 It requires root permissions to run, so when logged in as unprivileged
user, use sudo, e.g.   
 `sudo ./mklive-bullseye32 -gui`

**Here’s also a single script that should work OOTB on DebianDog,
BusterDog, StretchDog:**    
 Attachment and more info here: [Bullseye build script](https://puppylinux.rockedge.org/viewtopic.php?p=14736#p14736) 
 (requirements/dependencies will be downloaded), to use it on Puppy you
need to have yad, debootstrap, dpkg, xorriso installed first.

**Run the build on a Linux filesystem (ext2 ext3 ext4)** not **on FAT or
NTFS , with at least 3GB free space**

Simple demo .gif image using GUI option (clicking on link below will
probably show it in browser):

(it's from earlier released build script, mklive-devuan, but you get the
picture :)   
 [Demo .gif image](https://debiandog.github.io/MakeLive/build-beowulf-demo.gif)
