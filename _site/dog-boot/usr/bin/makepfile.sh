#!/bin/bash
#set -x
# Savefile creator
# Copyright (c) alphaOS
# Written by simargl <archpup-at-gmail-dot-com> modified for DebianDog by fredx181
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [ -z `which gsu` ]; then
[ "`whoami`" != "root" ] && exec gksu ${0} "$@"
else
[ "`whoami`" != "root" ] && exec gsu ${0} "$@"
fi

# VARIABLES
export LC_ALL=C

PROG=$0

export wrk=/tmp/savefile
PIDLOCK=$wrk/.svdlock
[ -d $wrk ] && rm -rf $wrk
mkdir $wrk
echo "0" > $PIDLOCK

function gtk_message(){
export PMESSAGE='
<window window_position="1" title="DebianDog message" icon-name="cdr" allow-shrink="false" width-request="'$2'">
<vbox>
 <hbox>
  <frame>
  <pixmap icon_size="6">
   <input file stock="'$3'"></input>
  </pixmap>
  </frame>
  <frame>
  <text wrap="true"><label>"'$1'"</label></text>
  </frame>
 </hbox>
 <hbox>
  <button ok></button>
 </hbox>
</vbox>
</window>
'
gtkdialog -p PMESSAGE > $wrk/junk
}; export -f gtk_message

function cleanup(){
rm -rf $wrk >/dev/null 2>&1
rm -rf /mnt/vault*
[ -f $PIDLOCK ] && rm $PIDLOCK
}

function check_loop(){
x=`ls -1 /dev/loop*|tr -d [:alpha:][:punct:]|sort -g|tail -n1`
let y=x+1
loop=/dev/loop$y
[ ! -e $loop ] && mknod $loop b 7 $y
};export -f check_loop

function bad_passphrase(){
gtk_message "No key available with this passphrase." 500 gtk-dialog-warning
cleanup
exit
};export -f bad_passphrase


function create_passphrase(){
secret=$wrk/.passphrase
export CREATE_A_PASSPRASE='
<window window_position="1" title="Passphrase" width-request="400" icon-name="cdr" resizable="false">
<vbox margin="20">
	<text use-markup="true">
		<label>"Please provide a passphrase which will be used to decrypt your savefile container."</label>
	</text>
	<frame>
		<hbox>
			<text width-request="90"><label>Passphrase:</label></text>
			<entry visibility="false" invisible-char="120" tooltip-text="visibility, invisible-char">
				<default>""</default>
				<variable>pp</variable>
				<action signal="changed">enable:pp2</action>
			</entry>
		</hbox>
		<hbox>
			<text width-request="90"><label>Repeat:</label></text>
			<entry visibility="false" invisible-char="120" tooltip-text="visibility, invisible-char" sensitive="false">
				<default>""</default>
				<variable>pp2</variable>
			</entry>
		</hbox>
	</frame>
	<hbox>
		<button cancel></button>
		<button ok></button>
	</hbox>
</vbox>
</window>'
gtkdialog -p CREATE_A_PASSPRASE > $secret
[ `egrep "Exit|exit|abort|Cancel|cancel" $secret` ] && { rm $secret; exit; }
## Make sure the passwords matched
sed -i 's@"@@g' $secret
p1=`grep "pp=" $secret|awk -F= '{print$NF}'`
p2=`grep "pp2=" $secret|awk -F= '{print$NF}'`
rm $secret
if [ "$p1" != "$p2" ]; then
	gtk_message "PASSWORDS DO NOT MATCH" 500 gtk-dialog-warning
	unset p1 p2
	$FUNCNAME
	return
fi

## Make sure password is not blank
if [ -z "$p1" -o -z "$p2" ]; then
	gtk_message "BLANK PASSWORDS NOT ALLOWED" 500 gtk-dialog-warning
	unset p1 p2
	$FUNCNAME
	return
fi
export PPHRASE=${p2}
unset p1 p2
}; export -f create_passphrase

TEXT="All of your settings and additional software that you install, 
will be stored within the save file, by default, so it can 
become quite large if not managed. I suggest you keep 
all of your documents and photos etc. in another location.
   Select a directory outside the actual running filesytem, e.g. inside /mnt/sda*.

 Please select desired size, name and directory below.
"

# QUESTION DIALOGS
save_folder () {
#if [ ! -f /mnt/live/tmp/changes-exit ]; then

HDRV=`cat /mnt/live/etc/homedrv`
#else
#if grep -qv noauto /proc/cmdline; then
#HDRV=`cat /mnt/live/etc/homedrv`

#else
#HDRV=`cat /mnt/live/etc/homedrv`
#HDRV="/mnt/live/$HDRV"
#fi
#fi
SAVEFILE_DIR=$(yad  --center --title="Save Creator" --filename="$HDRV" --height=600 --width=800 --text=" Please select a directory \n A directory named 'changes' will be created inside selected directory \n Make sure it is on a linux filesystem such as ext2/3/4  " --directory  --file )
ret=$?
[[ $ret -ne 0 ]] && exit

if [ -d "$SAVEFILE_DIR"/changes ]; then
yad  --center --title="Save Creator" --width=500 --text=" Directory: \n <b>$SAVEFILE_DIR/changes</b> \n already exists \n There's a risk in using it, might be from another DD version  \n       <b>Use it?</b> \n Clicking 'No' will run save setup from start, so you can choose again " --button="gtk-no:1"  --button="gtk-yes:0"
ret=$?

  case $ret in
0)
echo "Continue, using existing directory"
;;
1)
echo "Start all over again"
exec "$PROG"
;;
252)
echo "Window closed"
exit
;;
  esac
fi

FS=`stat -f -c %T "$SAVEFILE_DIR"`
if [[ "$FS" == "ext"* ]]; then
echo "Directory $SAVEFILE_DIR is on a linux filesytem, OK, let's continue"
else
yad  --center --title="Savefile Creator" --width=500 --text=" Directory $SAVEFILE_DIR cannot be used as save \n Make sure the directory is on a linux filesystem such as ext2/ 3/ 4 "  --button="gtk-ok"
ret=$?
[[ $ret -ne 0 ]] && exit
exec "$PROG" 
fi
 

mkdir -p "$SAVEFILE_DIR"/changes 2> /dev/null
echo "SAVEFILE=\"$SAVEFILE_DIR/changes\"" > /tmp/savefile.txt
}

save_file () {
#if [ ! -f /mnt/live/tmp/changes-exit ]; then

HDRV=`cat /mnt/live/etc/homedrv`
#else
#if grep -qv noauto /proc/cmdline; then
#HDRV=`cat /mnt/live/etc/homedrv`

#else
#HDRV=`cat /mnt/live/etc/homedrv`
#HDRV="/mnt/live/$HDRV"
#fi
#fi

create_save () {
SAVEFILE_NAME="$SAVEFILE_DR/$SAVEFILE_NME"

FS=`stat -f -c %T "$SAVEFILE_DR"`
if [[ "$FS" != "aufs" ]]; then
echo "Save file $SAVEFILE_NAME is not on aufs, OK, let's continue"
else
yad  --center --title="Savefile Creator" --width=500 --text=" Will not create $SAVEFILE_NAME as it cannot be used as savefile \n Make sure that the path to create savefile is on an actual storage such as /mnt/sda* "  --button="gtk-ok"
ret=$?
[[ $ret -ne 0 ]] && exit
exec "$PROG" 
fi

if [ -f "$SAVEFILE_NAME" ]; then
yad  --center --title="Savefile Creator" --width=500 --text=" File $SAVEFILE_NAME already exists.  \n Please try again and choose another name.  "  --button="gtk-ok"
ret=$?
[[ $ret -ne 0 ]] && exit
exec "$PROG"
fi
 

QUESTION="Do you want to create personal file $SAVEFILE_NAME 
with size of $SAVEFILE_SIZE MB?
"
INFO=`yad --title="Savefile Creator" --center --text="$QUESTION" \
--image="dialog-question" --window-icon="dialog-question" \
--button="gtk-cancel:1" --button="gtk-ok:0"`

ret=$?
[[ $ret -ne 0 ]] && exit 1


# MAKE SAVEFILE
#cd $SYSTEM_DIR
if [ "$ENCRYPT" = "TRUE" ]; then
create_passphrase
SAVEBASE="$(basename "$SAVEFILE_NAME")"
#xterm -T "Savefile Creator" -si -sb -fg white -bg SkyBlue4 -geometry 65x14 -e "dd if=/dev/zero | bar -s ${SAVEFILE_SIZE}m | dd of=$SAVEFILE_NAME bs=1M count=$SAVEFILE_SIZE iflag=fullblock"
(dd if=/dev/zero | pv -n -s ${SAVEFILE_SIZE}m | dd of=$SAVEFILE_NAME bs=1M count=$SAVEFILE_SIZE iflag=fullblock) 2>&1 | yad --title="Savefile Creator" --center --height="100" --width="400" --progress --no-buttons --auto-close --text=" Creating $SAVEBASE... "
sync
check_loop
if [ -e /dev/mapper/crypt ]; then
x=`ls -1 /dev/mapper/crypt*|tr -d [:alpha:][:punct:]|sort -g|tail -n1`
let y=x+1
crpt=crypt$y
else
crpt=crypt
fi
echo "Formatting $SAVEFILE_NAME"
yad --on-top --title="Make-Save" --text="  <span size='large' foreground='dark green'><b>*** Formatting $SAVEBASE... ***</b></span>  " --center --undecorated --no-buttons &
pd=$!
losetup $loop $SAVEFILE_NAME
cryptsetup -y luksFormat $loop <<< $PPHRASE 2> /dev/null
cryptsetup luksOpen $loop $crpt <<< $PPHRASE 2> /dev/null || bad_passphrase

## We need to feed 'yes' to terminal because it will complain
## about the device not being valid block.
	mkfs.ext4 /dev/mapper/$crpt <<<YES
e2fsck -f /dev/mapper/$crpt
#cryptsetup luksClose $crpt
#losetup -d $loop
echo "SAVEFILE=\"/dev/mapper/$crpt\"" > /tmp/savefile.txt
kill $pd

else
SAVEBASE="$(basename "$SAVEFILE_NAME")"
#xterm -T "Savefile Creator" -si -sb -fg white -bg SkyBlue4 -geometry 65x14 -e "dd if=/dev/zero | bar -s ${SAVEFILE_SIZE}m | dd of=$SAVEFILE_NAME bs=1M count=$SAVEFILE_SIZE iflag=fullblock"
(dd if=/dev/zero | pv -n -s ${SAVEFILE_SIZE}m | dd of=$SAVEFILE_NAME bs=1M count=$SAVEFILE_SIZE iflag=fullblock) 2>&1 | yad --title="Savefile Creator" --center --height="100" --width="400" --progress --no-buttons --auto-close --text=" Creating $SAVEBASE... "
echo "Formatting $SAVEFILE_NAME"
yad --on-top --title="Make-Save" --text="  <span size='large' foreground='dark green'><b>*** Formatting $SAVEBASE... ***</b></span>  " --center --undecorated --no-buttons &
pd=$!	
echo y | mkfs.ext4 $SAVEFILE_NAME
echo "SAVEFILE=\"$SAVEFILE_NAME\"" > /tmp/savefile.txt
kill $pd
fi
}
export -f create_save

use_save () {
SAVEFILE_NAME=$(yad  --center --title="Select Savefile" --filename="$HDRV" --height=600 --width=800 --text="Select existing savefile. \nE.g. changes.dat or debsave.dat." --file )
ret=$?
[[ $ret -ne 0 ]] && exit 1
   if [ ! -f "$SAVEFILE_NAME" ]; then
yad --center --title="Savefile Select" --width=500 --text=" $SAVEFILE_NAME is not a file.  \n Please try again and choose a file instead of a folder.  "  --button="gtk-ok"
# Another chance...
SAVEFILE_NAME=$(yad --center --title="Select Savefile" --filename="$HDRV" --height=600 --width=800 --text="Select existing savefile. \nE.g. changes.dat or debsave.dat." --file )
ret=$?
[[ $ret -ne 0 ]] && exit 1

      if [ ! -f "$SAVEFILE_NAME" ]; then
yad  --center --title="Savefile Select" --width=500 --text=" $SAVEFILE_NAME is not a file.  "  --button="gtk-ok"
exec $PROG
      fi
   fi

# Check if savefile is encrypted
if blkid $SAVEFILE_NAME 2>/dev/null | cut -d" " -f3- | grep -q _LUKS; then

PPHRASE=$(yad --width=300  \
    --title="Password" \
    --text="Enter password for decrypting :" \
    --image="dialog-password" \
    --entry --hide-text)
[[ -z "$PPHRASE" ]] && exit 1

SAVEBASE="$(basename "$SAVEFILE_NAME")"

check_loop
if [ -e /dev/mapper/crypt ]; then
x=`ls -1 /dev/mapper/crypt*|tr -d [:alpha:][:punct:]|sort -g|tail -n1`
let y=x+1
crpt=crypt$y
else
crpt=crypt
fi

losetup $loop $SAVEFILE_NAME
cryptsetup luksOpen $loop $crpt <<< $PPHRASE 2> /dev/null || bad_passphrase

e2fsck -f /dev/mapper/$crpt
#cryptsetup luksClose $crpt
#losetup -d $loop
echo "SAVEFILE=\"/dev/mapper/$crpt\"" > /tmp/savefile.txt
else
echo "SAVEFILE=\"$SAVEFILE_NAME\"" > /tmp/savefile.txt
fi
}
export -f use_save

if [ ! -f /mnt/live/etc/nochanges ]; then 
SETUP=`yad --title="Savefile Creator" --center --text="$TEXT" \
--text-align=center --width=600 \
--window-icon="folder-system" --form  \
--field=" Savefile Size   MB:NUM" "100!100..20000!10" \
--field=" Type name e.g: changes.dat or debsave.dat : " "changes.dat" \
--field=" Directory: (savefile will be created inside) :DIR" "$HDRV" \
--field=" Encrypt the savefile:CHK" "FALSE" \
--button="gtk-cancel:1" --button="gtk-ok:0"`
ret=$?
[[ $ret -ne 0 ]] && exit 1

export SAVEFILE_SIZE=$(echo $SETUP | cut -d "|" -f 1 | cut -f1 -d".")
export SAVEFILE_NME=$(echo $SETUP | cut -d "|" -f 2)
export SAVEFILE_DR=$(echo $SETUP | cut -d "|" -f 3)
export ENCRYPT=$(echo $SETUP | cut -d "|" -f 4)

create_save

else
 
SETUP=`yad --title="Savefile Creator" --center --text="$TEXT <b>Click 'Skip' to select an already existing savefile</b>" \
--text-align=center --width=600 \
--window-icon="folder-system" --form  \
--field=" Savefile Size   MB:NUM" "100!100..20000!10" \
--field=" Type name e.g: changes.dat or debsave.dat : " "changes.dat" \
--field=" Directory: (savefile will be created inside) :DIR" "$HDRV" \
--field=" Encrypt the savefile:CHK" "FALSE" \
--button="Skip:2" --button="gtk-cancel:1" --button="gtk-ok:0"`

ret=$?

export SAVEFILE_SIZE=$(echo $SETUP | cut -d "|" -f 1 | cut -f1 -d".")
export SAVEFILE_NME=$(echo $SETUP | cut -d "|" -f 2)
export SAVEFILE_DR=$(echo $SETUP | cut -d "|" -f 3)
export ENCRYPT=$(echo $SETUP | cut -d "|" -f 4)

  case $ret in
0)
create_save
;;
1)
exit 1
;;
2)
use_save
;;
252)
exit 1
;;
esac

fi
}

save_file_folder () {
CHOICE=$(yad --list \
    --title="Create Save" --window-icon="folder-system" --height 200 --width 650 \
    --text="  Please select one of the options                           " \
    --radiolist --center --borders 5 --print-column=2 \
    --column="Pick" --column="Option" --column="Description" \
    "TRUE" "Create or Use Save File" "Create savefile (or use existing) e.g. changes.dat" \
    "FALSE" "Create or Use Save Folder" "Create save (or use existing) folder inside selected directory ")

[ $? -ne 0 ] && exit

if [ "$CHOICE" = "Create or Use Save File|" ]; then
save_file
fi

if [ "$CHOICE" = "Create or Use Save Folder|" ]; then
save_folder
fi
}

CHANGES=" It seems like you are already running the system with changes enabled. \n You can proceed creating a savefile but it will not be used until rebooted. 
"

if [ ! -f /mnt/live/etc/nochanges ]; then
yad --width=550 --title="Savefile Creator" --center --text="$CHANGES" \
--image="dialog-information" --window-icon="dialog-information"
ret=$?
[[ $ret -ne 0 ]] && exit 1
save_file
else
save_file_folder
fi

. /tmp/savefile.txt

MESSAGE="Setup $SAVEFILE_NAME created successfully! \nYou may need to update your boot options:
(changes=/path/to/savefile).
"
MESSAGES="Setup $SAVEFILE_NAME created successfully!  \nIt will be mounted and session will be saved. \nYou may need to update your boot options:
(changes=/path/to/savefile).
"
MESSAGE_DIR="Setup changes in $SAVEFILE created successfully! \nYou may need to update your boot options:
(changes=/path/to/).
"
MESSAGES_DIR="Setup changes in $SAVEFILE created successfully!  \nIt will be mounted and session will be saved. \nYou may need to update your boot options:
(changes=/path/to/).
"

if [ -f /mnt/live/etc/nochanges ]; then
   if [ ! -d $SAVEFILE ] ; then
EXIT1=`yad --width=550 --title="Savefile Creator" --center --text="$MESSAGES" \
--image="dialog-information" --window-icon="dialog-information" \
--button="gtk-ok:0"`
   else
EXIT1=`yad --width=550 --title="Save Creator" --center --text="$MESSAGES_DIR" \
--image="dialog-information" --window-icon="dialog-information" \
--button="gtk-ok:0"`
   fi
else
   if [ ! -d $SAVEFILE ] ; then
EXIT=`yad --width=550 --title="Savefile Creator" --center --text="$MESSAGE" \
--image="dialog-information" --window-icon="dialog-information" \
--button="gtk-ok:0"`
   else
EXIT=`yad --width=550 --title="Save Creator" --center --text="$MESSAGE_DIR" \
--image="dialog-information" --window-icon="dialog-information" \
--button="gtk-ok:0"`
   fi
fi

