## MakeLive

### **How Create your own DebianLive from netinstall and also include porteus-boot style**

**Further below are the detailed steps, it may look complicated but in fact it isn't, so here's first the short version:**  
**1)** Create a partition dedicated for installing Debian (if you don't have already)  
**2)** Install Debian from netinstall ISO  
**3)** Boot the just installed system, configure as you like  
**4)** Run (in just installed system), the attached script 'mklive'  (it will do everything required, end result is a live ISO)    
 
**Note:** Although DebianDog is similar livesystem (when it's about boot-methods), this guide is **not** for how to create DebianDog (such as made by saintless or fredx181), that would require much more steps, e.g. further tweaking, make small as possible, configure DE, adopt some Puppy programs etc...

Therefore explained here how to install LXDE from a Debian netboot install ISO and transform into a live-system, including 'live-boot' (standard DebianLive) and 'porteus-boot'. (ISO size for LXDE Desktop + Firefox + Gnome-mplayer + Deluge + Synaptic and some more: around 475MB (xz compressed filesystem.squashfs))  
Assumed is that you have already bootloader grub4dos installed to MBR  
(therefore the install instruction at 2): "Continue without bootloader")  

There are different ways to accomplish, but I recommend to follow below steps exactly (to avoid confusion).  

**1)** Create a dedicated partition with Gparted on your harddisk by using e.g. a live system, from Puppy, DebianDog or any other.  
(I used sda3, but can be sda1, sda2 etc..., **Note** that the screenshots and the grub4dos example are for sda3, so you need to adjust for the partition you use)  
    
**2)** Install Debian (not all the steps are described detailled here, just some 'tricky' points)  
- Download netinstall ISO and burn to CD (or to USB, guides can be found on the net howto do it)  
32 bit:    
http://cdimage.debian.org/debian-cd/current/i386/iso-cd/debian-8.7.1-i386-netinst.iso    
64 bit:  
http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-8.7.1-amd64-netinst.iso    
- Boot from it and choose "Graphical Install"  
- Choose as desired: language, keymap, hostname (domain-name can be empty)  
- Enter password for 'root' twice, choose name for normal user and enter password twice.  
- When it comes to partitioning, choose "Manual"  
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/manualpart_400x300.png)
- Then choose the partition you earlier chose/created in 1) and double click on it
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/choose_partition_0_400x300.png)
- Then important are:   
-- "Use as: ext4 journaling filesystem"  
-- "Format the partition Yes format it"  
-- "Mount Point /"  
So if finally looks like this, select "Done setting up the partition" and continue , confirmation will follow and if you agree select 'yes'  
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/done-setting-part_400x300.png)  
- And more confirmations:  
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/finish-part_400x300.png)  
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/partman_confirm_0_400x300.png)  
- Choose mirror nearby your country, proxy you can leave blank, popularity test yes/no  
- Software Selection: **untick** **all** (software: none), we're going to install software later, see 3)  
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/software-sel_400x300.png)  
- Next, installing most basic software...    
- Grub install, your choice, but recommended (for following the 'grub4dos' part of the guide (example)) is to skip it (I'm using grub4dos myself, already installed to MBR)  
- Click "Go Back" on this screen:  
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/nobootloader1_400x300.png)  
- Then select "Continue without bootloader" (confirmation follows)    
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/nobootloader2_400x300.png)  
- Set system-clock to UTC ? yes/no, and installation finished, reboot.  
Here's menu.lst example for sda3, change accordingly if you used e.g. sda2  
```  
title Debian-Jessie-netinstall on sda3
 root (hd0,2)
 kernel /vmlinuz root=/dev/sda3 ro
 initrd /initrd.img
 ```  
  
**3)** After reboot, login as **root** from console, then install LXDE Desktop:  
```  
apt-get install lxde 
```  
- When done (install space used will be around 940MB) activate lightdm login-manager:  
(also a reboot will activate it, btw)  
```  
service lightdm start
```
- And login as **root** again from lightdm  
Now you should be in LXDE:-)  
- First thing you may want to install is Synaptic Package Manager, open terminal:  
```  
apt-get install synaptic --no-install-recommends  
```  

Next, configure the system as desired, e.g. install, uninstall, configure the Desktop, etc.. before creating your personal 'live' system from it (as that is what this guide is for,after all)  
(See below in the "Tips and Aternatives" section for an alternative way, to install a very basic OpenBox)  
    
**4)** Create the 'live' system, with 2 boot-methods: live-boot and porteus-boot  
This would be so many steps (command lines), that I decided to make a script for it.  
**Note:** You need to have a working network connection, otherwise it will fail.  
What it does is:  
- Download some archives (.tar.gz), extract them to (created) /WORK directory  
- Copy some files (needed for porteus-boot) to the system  
- Install some packages required (xorriso isolinux live-boot xz-utils squashfs-tools dialog)  
- Install yad and gtkdialog  
- Set the default shell to bash (by default on Debian it's dash), this makes gtkdialog based programs work properly.  
- CreateSave entry in Menu > Other  
- Create 'live-boot' and 'porteus-boot' initrd (initrd.img and initrd1.xz)  
- Make a remaster of the system (01-filesystem.squashfs)  
- Make ISO from all above prepared files  

Download 'mklive' (right-click > Save Link As):
https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/mklive  
Make executable:  
```  
chmod +x mklive  
```  
Then (in the new full install) run in terminal from where mklive is located:  
```
./mklive
```  
Adviced is to download the 'mklive' script first, put it in some place, e.g. USB-stick or other partition.
(That way you can access it easily after you did the full netinstall, without needing a browser)  

## **Tips and Alternatives**    
**a)** Instead of doing step 3) you may want a much smaller system, for example with Openbox.  
After login as root from console, type:  
```
apt-get install openbox obconf xterm xinit xserver-xorg menu-xdg --no-install-recommends   
```  
When finished, type:
```  
startx
```  
And you should be in a basic openbox environment  
Then maybe install e.g. synaptic, some icon-theme, a file-manager, browser of your choice etc..   
Note well that the disadvantage of it is that you need to tweak much more to get things as desired.    
**b)** Debian is rather conservative including so called 'non-free' software.  
You may want to add non-free repository in /etc/apt/sources.list, so looks like (add 'contrib non-free'):   
``` 
deb http://ftp.de.debian.org/debian/ jessie main contrib non-free 
# deb-src http://ftp.de.debian.org/debian/ jessie main contrib non-free  
deb http://ftp.debian.org/debian/ jessie-updates main contrib non-free 
# deb-src http://ftp.debian.org/debian/ jessie-updates main contrib non-free 

deb http://security.debian.org/ jessie/updates main contrib non-free 
# deb-src http://security.debian.org/ jessie/updates main contrib non-free  
```  

After the edit do:
```
apt-get update 
```
Then there's more choice in e.g. firmware (for WIFI) and for example flashplayer is in the repo.   

**c)** To install always without 'install-recommends' create (if not exist) file /etc/apt/apt.conf and paste in this:   
```  
APT::Install-Recommends "false"; APT::Install-Suggests "false";  
```  
**d)** You may want to install some applications from DebianDog, e.g. sfsload quick-remaster apt2sfs etc...  
To install from DD repo add to /etc/apt/sources.list:  
32 bit:  
```
 deb https://debiandog.github.io/Jessie/i386/Packages/ ./
 ```  
64 bit:  
```
deb http://smokey01.com/saintless/64-bit-DebianDog/Packages/ ./  
```
But no guarantee that all will work properly!  
No LZ4 support, btw, on this new created livesystem (latest DebianDog has it, but has been tweaked that way)  

**e)** See here for boot-methods 'live-boot' and 'porteus-boot' using grub4dos:  
https://github.com/DebianDog/Jessie/wiki/Boot-methods  
Note: The 'live-boot-2' method does not work with this setup, only live-boot-3 and porteus-boot

**mklive running...**    
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/mklive1.png)  
**mklive finished!**    
![](https://raw.githubusercontent.com/DebianDog/MakeLive/gh-pages/images/mklive2.png)    
