#### DevuanDog ‘beowulf’ build system

Very similar as the ‘mklive-stretch’ build system see [Here](https://github.com/DebianDog/MakeLive/blob/gh-pages/README-Stretch.md) and [Forum thread](http://murga-linux.com/puppy/viewtopic.php?t=111199) , but this will build from [Devuan](https://devuan.org/) ‘beowulf’ branch and has many changes and improvements.   

**Update:** New! **mklive-ceres**. The unstable branch of Devuan named "ceres" is the systemd-free version of Debian Sid.   
See for download links below.  

Rather than just one script it’s now packed as appimage, reason is that this way it works ‘out of the box’ on most OS’s including modern puppies. The appimage has included e.g. yad, debootstrap, dpkg, xorriso (for creating ISO), so nothing extra is required to install. Tested on Tahrpup, Xenialpup, Dpup-Stretch, DebianDog, Fatdog (but on the latter I needed to install ‘perl’ first from gslapt).

Note that this doesn’t build a Puppy such as when using Woof-CE, but a puppy-like ‘Dog’ system (see more: [Dog Linux website](https://debiandog.github.io/doglinux/))  
See more info also here: [DevuanDog ‘Beowulf’](http://murga-linux.com/puppy/viewtopic.php?t=115124)

**Download mklive-beowulf:**  
For 32-bit: [mklive-beowulf32](https://debiandog.github.io/MakeLive/mklive-beowulf32)  
For 64-bit: [mklive-beowulf64](https://debiandog.github.io/MakeLive/mklive-beowulf64)   
  
**Download mklive-ceres:**    
For 32-bit: [mklive-ceres32](https://debiandog.github.io/MakeLive/mklive-ceres32)  
For 64-bit: [mklive-ceres64](https://debiandog.github.io/MakeLive/mklive-ceres64)


Make executable, e.g:  
`chmod +x mklive-beowulf32`  
Running without arguments it will show usage help, to run with GUI, e.g.:  
`./mklive-beowulf32 -gui`  
It requires root permissions to run, so when logged in as unprivileged user, use sudo, e.g.  
`sudo ./mklive-beowulf32 -gui`  

**Run the build on a Linux filesystem (ext2 ext3 ext4)** not **on FAT or NTFS , with at least 3GB free space**

Simple demo .gif image using GUI option (clicking on the below will probably show it in browser):  
[Demo .gif image](https://debiandog.github.io/MakeLive/build-beowulf-demo.gif)

Here’s also a single script that should work OOTB on DebianDog, DevuanDog, StretchDog (requirements/dependencies will be downloaded), to use it on Puppy you need to have yad, debootstrap, dpkg, xorriso installed first.  
[mklive-beowulf](https://debiandog.github.io/MakeLive/mklive-beowulf)

Just to mention, synaptic has version 0.84.5 (synaptic=0.84.5) in the configs, the newest is 0.84.6 (at this time) but it has more dependencies (zenity, which takes a lot of space !)