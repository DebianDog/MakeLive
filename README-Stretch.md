
## Create a Debian 9 (Stretch) minimal live ISO similar to 'DebianDog'

[Forum Thread](http://murga-linux.com/puppy/viewtopic.php?t=111199)

**Updated 2017-08-18**     
Bug fixes and improvements, info below updated               

#### With aufs support and porteus-boot style included   
It's required to have at least 3 GB free space and to run the script on a Linux filesystem, e.g. ext4   

Similar to [This](README.md) (for Jessie) but this is **way** better, easier, faster!  
Just download and run [This mklive-stretch script](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/mklive-stretch) (right-click > Save link as)   
Before running, make it executable:
```   
chmod +x mklive-stretch
```   

The script does it **all**, except during run, 3 times user input is required:  
Choose keyboard-layout, set the 'root' passwd and choose for gzip or xz compression   

Run from a Debian based system 32-bit or 64-bit (will create i686 (32-bit) or x86_64 (64-bit) live system accordingly to the architecture of the OS you are running from)
Works well building from Debian Jessie (bug fixed) and Stretch, not from Wheezy (oldoldstable) and not from Xenial(dog), from terminal:   
   
```   
./mklive-stretch --help
```   
To show the options  

Changes on 2017-08-18:   
- GUI and CLI version into one, added different options: -help (no option, will show help) -gui -cli, or e.g. -cli <config_file> (use config file), -conf (create standard config file 'stretchlive.conf')    
- The apt cache in /var/cache/apt will be kept (instead of downloading each time script is run)   
- Added field 'Desktop' to the gui (see more info when clicking Information button)  
- Creates 'build_setup.txt' in stretch folder containing how you configured the build and create 'build_setup.conf' (ready to use as config file)      
- Added checkboxes (GUI):   
  ------ Remove some automatically installed packages   
 (to keep ISO size more down)   
 (more info when clicking Information button)   
  ------ If running 64 bit host OS, create a 32 bit build  
- Multi-user support improved ('Add new user' in Menu)  
(user puppy does not exist in the system but can be added, /home/puppy folder exists preconfigured already for openbox type of build)  
- Added google-chrome repository (64 bit only)   
(google-chrome-stable package can be added to apps list in the GUI)  
  (in /usr/local/bin there are launchers 'chrome-root.sh' and 'chrome-puppy.sh', thanks to dancytron  
- Pin the kernel version (lock)  
- Allow the user to make changes in chroot just before creating 01-filesystem.squashfs (script paused)  
(use upgrade-kernel to upgrade to newer version)  

To create log from output run e.g:  
```    
./mklive-stretch -cli 2>&1 | tee mklive-stretch.log   
```    
(note that progress of mksquashfs looks like it's idle for sometime)      

#### If all went well...
#### In folder stretch DebLive_Stretch-yourarch.iso is created and also the required files for a frugal install are in stretch/isodata/live folder   

Currenly the contents of the created live ISO are (preconfigured): (updated 2017-08-07)   
(but this might well be a work in progress, e.g. modify the script to have more choice of window-managers, applications, add more 'DebianDog goodies', right-click actions etc...)      
- Openbox with PcManFM providing the desktop and bottom panel is lxpanel   
- Applications included are:   
Firefox-ESR webbrowser (older version), gparted, pcmanfm, leafpad viewnior, xterm, synaptic, peasywifi, lxappearance, lxinput, lxrandr, more 'dog' specific applications, e.g. sfs-load, remaster tools, apt2sfs etc...    
- Right-click actions for e.g. activate module, deb extract...       
- LZ4 squashfs support, for booting and mounting  
- Conky display on the desktop   

The build process takes around 12-20 minutes, depending on your internet speed and computer power.   
**Size of the created ISO will be around 161 MB (with xz compressed filesystem.squashfs)**      

The packages installed by the script can be easily changed, edit with texteditor.  
See at the top e.g. the BASE_INSTALL= variable, add or remove as desired.  
Update 2017-08-18: or by specyfying a config file or by running the GUI, run without option or with -help for more info   

**Below are very basically the commands used (for 32-bit) in the 'mklive-stretch' script**     
**Note that this is written down below just to give some insight in how the build process is done**     
The script does much more, e.g. error checking, cleaning, e.g. remove man and doc files, locales**
**Update 2017-08-07: the script is now even more modified, below just for reference**           

---    
---   

### Install required packages for the build process   
```   
apt-get update
apt-get install debootstrap wget xorriso isolinux xz-utils squashfs-tools -y --force-yes
```   

### Setup debootstrap in directory stretch/chroot      
```   
mkdir -p stretch/chroot && cd stretch &&
debootstrap --arch=i386 --variant=minbase stretch chroot http://ftp.us.debian.org/debian/
```   

### Download and extract archives for later use   
```   
wget --no-check-certificate https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/dog-boot-stretch.tar.gz
wget --no-check-certificate https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/initrdport-stretch.tar.gz
wget --no-check-certificate https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/isodata-stretch.tar.gz
tar -zxvf dog-boot-stretch.tar.gz
tar -zxvf isodata-stretch.tar.gz
tar -zxvf initrdport-stretch.tar.gz
# copy contents of 'dog-boot-stretch' folder to chroot
cp -af dog-boot-stretch/* chroot/
```   
### Mount bind /proc /dev and /sys in chroot   
```   
mount --bind /proc chroot/proc
mount --bind /dev chroot/dev
mount --bind /sys chroot/sys
mount -t devpts devpts chroot/dev/pts
echo -en "`cat /etc/resolv.conf`" > chroot/etc/resolv.conf
```   

### 'chroot' in the chroot environment (in directory named chroot)    
```   
chroot chroot
```   

### Start the commands in chroot environment   
```   
export HOME=/root
export LC_ALL=C
apt-get update
echo "APT::Install-Recommends "false"; APT::Install-Suggests "false";" > /etc/apt/apt.conf
sleep 1
apt-get install dialog dbus ca-certificates apt-transport-https --yes --force-yes
dbus-uuidgen > /var/lib/dbus/machine-id
echo "live" > /etc/hostname
echo "127.0.0.1	 localhost" > /etc/hosts
echo "127.0.1.1	 live" >> /etc/hosts
mkdir /live
# for porteus-boot save-on-exit from console:
update-rc.d snapexit defaults

# make /bin/sh symlink to bash instead of dash (required to make gtkdialog work):
echo "dash dash/sh boolean false" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Activate dog repository and update package list
sed -i '1 s|^|deb https://fredx181.github.io/StretchDog/i386/Packages/ ./\n|' /etc/apt/sources.list
apt-get update

# Install kernel
apt-get install --yes linux-image-4.9.0-3-686-pae
# Install packages, for example:
apt-get install --no-install-recommends --yes live-boot wget net-tools ifupdown wireless-tools sysvinit-core xserver-xorg-core xserver-xorg psmisc fuse x11-utils x11-xserver-utils dbus-x11 busybox sudo mawk xinit xterm openbox obconf menu leafpad pcmanfm lxpanel pciutils usbutils gparted file rsync dosfstools parted nano pv synaptic volumeicon-alsa alsa-utils midori pup-volume-monitor pm-utils yad gtkdialog obshutdown peasywifi

# Instead of the 'cryptic' network interface names, make it traditional, e.g. ethernet is eth0
ln -s /dev/null /etc/systemd/network/99-default.link # traditional network interface names
# install linux-headers and aufs-dkms
# and remove directly after initrd (aufs included) is created
rm -f /var/log/dpkg.log    # to start fresh logging
apt-get install --no-install-recommends --yes linux-headers-4.9.0-3-686-pae aufs-dkms
# create new initrd with aufs included
CRYPTSETUP=Y update-initramfs -t -c -k $(uname -r)
# remove just installed linux-headers and aufs-dkms
PURGE=`cat /var/log/dpkg.log  |grep ' unpacked ' |cut -d\  -f5 |cut -d: -f1 |sort |uniq`
echo -e "\e[0;36mRemoving linux-headers and aufs-dkms + dependencies...\033[0m"
sleep 2
apt-get purge --yes --force-yes $PURGE
rm -f vmlinuz* initrd* # remove symlinks on /
# set the password for 'root'
passwd root
# Clean up
rm -f /var/lib/dbus/machine-id
apt-get clean
rm -rf /tmp/*
rm /etc/resolv.conf
rm -f /boot/System.map*
exit # exit chroot
```         
### End of the commands in chroot environment   

### Unmount mount binds in chroot directory   
```   
umount chroot/proc
umount chroot/dev/pts
umount chroot/dev
umount chroot/sys      
```   

### Create initrd.img and initrd1.xz, xz compressed   
```   
mkdir initrdlive
mv -f chroot/boot/initrd.img-* initrdlive/initrd.img
cd initrdlive
# extract initrd.img
zcat initrd.img | cpio -i -d
rm -f initrd.img
# create new (xz compressed) initrd.img 
find . -print | cpio -o -H newc 2>/dev/null | xz -f --extreme --check=crc32 > ../initrd.img
cd ..
# Copy kernel modules, contents of lib/modules, from extracted 'live-boot' initrd
# to extracted 'porteus-boot' initrd skeleton: initrdport/lib/modules/  
cp -a initrdlive/lib/modules/* initrdport/lib/modules/
# Creating initrd1.xz
cd initrdport
find . -print | cpio -o -H newc 2>/dev/null | xz -f --extreme --check=crc32 > ../initrd1.xz
cd ..
mv -f initrd.img isodata/live/ # move to isodata/live folder
mv -f initrd1.xz isodata/live/
# Move vmlinuz-*, from chroot/boot/, to isodata/live/vmlinuz1
mv -f chroot/boot/vmlinuz-* isodata/live/vmlinuz1

```   

### Create 01-filesystem.squashfs and ISO   
```   
# Now we will create compressed filesystem: '01-filesystem.squashfs', xz compressed
mksquashfs chroot isodata/live/01-filesystem.squashfs -comp xz -b 512k

NEWISO=$PWD/isodata
LABEL=deblive
NAME=../DebLive_Stretch-i386.iso

cd "$NEWISO"

xorriso -as mkisofs -r -J -joliet-long -l -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -partition_offset 16 -V "$LABEL" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ${NAME} "$NEWISO"
```   
