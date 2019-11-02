#### Debian ‘buster live’ build system   
---------------------------------------

Very similar as the ‘mklive-stretch’ build system see [Here](https://github.com/DebianDog/MakeLive/blob/gh-pages/README-Stretch.md) and [Forum thread](http://murga-linux.com/puppy/viewtopic.php?t=111199) , but this will build from 'Buster' branch and has many changes and improvements.

**Updated 2019-11-02:** See: [Changes and Fixes](http://murga-linux.com/puppy/viewtopic.php?p=1027840#1027840)     

Rather than just one script it’s now packed as appimage, reason is that this way it works ‘out of the box’ on most OS’s including modern puppies. The appimage has included e.g. yad, debootstrap, dpkg, xorriso (for creating ISO), so nothing extra is required to install. Tested on Tahrpup, Xenialpup, Dpup-Stretch, DebianDog, Fatdog (but on the latter I needed to install ‘perl’ first from gslapt).

Note that this doesn’t build a Puppy such as when using Woof-CE, but a puppy-like ‘Dog’ system (see more: [Dog Linux website](https://debiandog.github.io/doglinux/))  
See more info also here: [Busterdog](http://murga-linux.com/puppy/viewtopic.php?t=115124)

**Download mklive-buster:**  
For 32-bit: [mklive-buster32](https://debiandog.github.io/MakeLive/mklive-buster32)  
For 64-bit: [mklive-buster64](https://debiandog.github.io/MakeLive/mklive-buster64)   

Make executable, e.g:  
`chmod +x mklive-buster32`  
Running without arguments it will show usage help, to run with GUI, e.g.:  
`./mklive-buster32 -gui`  
It requires root permissions to run, so when logged in as unprivileged user, use sudo, e.g.  
`sudo ./mklive-buster32 -gui`  

**Run the build on a Linux filesystem (ext2 ext3 ext4)** not **on FAT or NTFS , with at least 3GB free space**

Simple demo .gif image using GUI option (clicking on the below will probably show it in browser):  
[Demo .gif image](https://debiandog.github.io/MakeLive/build-beowulf-demo.gif)

Here’s also a single script that should work OOTB on DebianDog, BusterDog, StretchDog (requirements/dependencies will be downloaded), to use it on Puppy you need to have yad, debootstrap, dpkg, xorriso installed first.  
[mklive-buster](https://debiandog.github.io/MakeLive/mklive-buster)
