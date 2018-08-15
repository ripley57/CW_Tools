#!/bin/bash
# Description:
#	Resize Pi image via loopback device (/dev/loop0) in 
#	order for the image to be clonable to another memory
#	card without boot-up issues (or at least result in a
#	Pi image that boot-up can auto-repair).   
#
#       By default this script will reduce the size of the
#	ext4 partition by 1GB.
#
# NOTE: Manually run the parted commands without the "-m" 
#       option to clearly see the column names associated
#       with each value.
#
#       Remember the command for cloning an image:
#       sudo dd if=/dev/sdb of=image.img bs=4M
#
# Example:
#    Before and after image sizes:
#    -rw-r--r-- 1 root root  15G Feb  7 18:52 image.img
#    -rw-r--r-- 1 root root  14G Feb  7 22:42 play.img
#
#    Before and after partition sizes:
#    Before:
#    $ parted image.img unit B print
#    Model:  (file)
#    Disk /files/Pi_MicroSD_Cards/image.img: 15720251392B
#    Sector size (logical/physical): 512B/512B
#    Partition Table: msdos
#
#    Number  Start       End           Size          Type     File system  Flags
#    1       1048576B    537919999B    536871424B    primary  fat16        boot, lba
#    2       538968064B  15720251391B  15181283328B  primary  ext4
#
#    After:    
#    $ parted play.img unit B print
#    Model:  (file)
#    Disk /files/Pi_MicroSD_Cards/play.img: 14646510592B
#    Sector size (logical/physical): 512B/512B
#    Partition Table: msdos
#
#    Number  Start       End           Size          Type     File system  Flags
#    1       1048576B    537919999B    536871424B    primary  fat16        boot, lba
#    2       538968064B  14646510079B  14107542016B  primary  ext4
#
# JeremyC 07-02-2018

if [[ ! $(whoami) =~ "root" ]]; then
    echo ""
    echo "*** You must be root to run this script! ***"
    echo ""
    exit
fi

if [[ -z $1 ]]; then
    echo ""
    echo "Usage: ./resizepi.sh <image file>"
    echo ""
    echo "Example:"
    echo "       ./resizepi.sh play.img"
    echo ""
    exit
fi

IMAGE=$1

if [[ ! -e $IMAGE || ! $(file $IMAGE) =~ "x86" ]]; then
    echo ""
    echo "Error : Not an image file, or file does not exist!"
    echo ""
    exit
fi

# Get partition information. Note: We don't even need to mount the image!
# This return output similar to this (which seems to be displayed as one
# long line for some reason (hence the need to use the "tr" command):
#
#BYT; /files/Pi_MicroSD_Cards/play.img:15720251392B:file:512:512:msdos:; 1:1048576B:537919999B:536871424B:fat16::boot, lba; 2:538968064B:15720251391B:15181283328B:ext4::;
#
PARTINFO=$(parted -m $IMAGE unit B print)
if [[ -z $PARTINFO ]]; then
    echo ""
    echo "Error : Could not determine partition details of image $IMAGE !"
    echo ""
    exit
fi
echo "PARTINFO=$PARTINFO"

# Determine the ext4 partition number from the partition information.
# This will usually be partition number 2.
PARTNUMBER=$(echo $PARTINFO | tr ' ' '\n' | grep ext4 | awk -F: '{ print $1 }')
echo "PARTNUMBER=$PARTNUMBER"
if [[ ! $PARTNUMBER =~ [0-9] ]]; then
    echo ""
    echo "Error : Could not determine the ext4 partition number!"
    echo ""
    exit 
fi

# Determine start of ext4 partition (bytes). Note: We remove the trailing 'B'.
PARTSTARTB=$(echo $PARTINFO | tr ' ' '\n' | grep ext4 | awk -F: '{ print substr($2,0,length($2)) }')
echo "PARTSTARTB=$PARTSTARTB"
if [[ ! $PARTSTARTB =~ [0-9]+ ]]; then
    echo ""
    echo "Error : Could not determine start of ext4 partition!"
    echo ""
    exit
fi

# Determine the current partition end (bytes).
PARTENDB=$(echo $PARTINFO | tr ' ' '\n' | grep ext4 | awk -F: '{ print substr($3,0,length($3)) }')
echo "PARTENDB=$PARTENDB"
if [[ ! $PARTENDB =~ [0-9]+ ]]; then
    echo ""
    echo "Error : Could not determine the current ext4 partition end!"
    echo ""
    exit
fi

# Determine the current size of the ext4 partition (bytes). Note: We remove the trailing 'B'.
PARTSIZE=$(echo $PARTINFO | tr ' ' '\n' | grep ext4 | awk -F: '{ print substr($4,0,length($4)) }')
echo "PARTSIZE=$PARTSIZE"
if [[ ! $PARTSIZE =~ [0-9]+ ]]; then
    echo ""
    echo "Error : Could not determine the current ext4 partition size!"
    echo ""
    exit
fi

# Calculate the new smaller size (-1GB) for the ext4 partition (in bytes and kilobytes).
NEWPARTSIZEB=$(echo "$PARTSIZE - 1*1024*1024*1024" | bc)
NEWPARTSIZEKB=$(echo "$NEWPARTSIZEB / 1024" | bc)
echo "NEWPARTSIZEB=$NEWPARTSIZEB"
echo "NEWPARTSIZEKB=$NEWPARTSIZEKB"

# Calculate the new (smaller) end of the ext4 partition (bytes).
NEWPARTENDB=$(echo $PARTSTARTB + $NEWPARTSIZEB | bc)
echo "NEWPARTENDB=$NEWPARTENDB"

# Mount the image using the loopback device, ready to run a filesystem repair.
# Note that we use the ext4 starting offset, to mount that filesystem directly.
loopback=$(losetup -f --show -o $PARTSTARTB $IMAGE)
if [[ -z $loopback ]]; then
    echo ""
    echo "Error : Could not mount the ext4 filesystem!"
    echo ""
    exit 
fi
#echo "loopback=$loopback"

# Force (-f) a non-interactive (-y) repair of the mounted ext4 filesystem.
e2fsck -f -y $loopback
rtn=$?
if [ $rtn -ne 0 -a $rtn -ne 1 -a $rtn -ne 2 ]; then
    echo ""
    echo "Error : Could not repair ext4 filesystem using e2fsck ($rtn) !"
    echo ""
    $(losetup -d $loopback)
    exit 
fi

# Resize the ext4 filesystem. Note the trailing "K" for kilobytes.
resize2fs -p $loopback ${NEWPARTSIZEKB}K
rtn=$?
if [ $rtn -ne 0 ]; then
    echo ""
    echo "Error : Could not resize the ext4 filesystem to size $NEWPARTSIZE (KB) !"
    echo ""
    $(losetup -d $loopback)
    exit
else
    echo ""
    echo "Warning : The ext4 filesystem has now been successfully resized to a smaller size!"
    echo "          If you need to re-perform any of the following remaining steps then you"
    echo "          will probably want to restore a copy of the original image file first."
    echo ""
fi

# Unmount the loopback device as we have now finished with it.
sleep 1
losetup -d $loopback

# Update the partition table, by recreating the ext4 
# partition with the new size of the ext4 filesystem.
# Remove the existing ex4 partition:
parted $IMAGE rm $PARTNUMBER
rtn=$?
if [ $rtn -ne 0 ]; then
    echo ""
    echo "Error : Could not remove existing ext4 partition (number: $PARTNUMBER) !"
    echo ""
    exit 
fi
# Create a new ext4 partition:
parted -m $IMAGE unit B mkpart primary $PARTSTARTB $NEWPARTENDB
rtn=$?
if [ $rtn -ne 0 ]; then
    echo ""
    echo "Error : Could not create new ext4 partition!"
    echo ""
    exit
fi

# Determine the start (bytes) of the (now) free space on the ext4 filesystem.
# This will display output like this:
#
#BYT;
#/files/Pi_MicroSD_Cards/play.img:15720251392B:file:512:512:msdos:;
#1:16384B:1048575B:1032192B:free;
#1:1048576B:537919999B:536871424B:fat16::boot, lba;
#1:537920000B:538968063B:1048064B:free;
#2:538968064B:14646510079B:14107542016B:ext4::;
#1:14646510080B:15720251391B:1073741312B:free;
#
UNALLOCATEDB=$(parted -m $IMAGE unit B print free | tail -1 | awk -F: '{ print substr($4,0,length($4)) }')
echo "UNALLOCATEDB=$UNALLOCATEDB"
if [[ ! $UNALLOCATEDB =~ [0-9]+ ]]; then
    echo ""
    echo "Error : Could not determine the unallocated space of the ext4 partition!"
    echo ""
    exit
fi

# Truncate the image file.
UNALLOCATEDKB=$(echo "$UNALLOCATEDB / 1024" | bc)
echo "UNALLOCATEDKB=$UNALLOCATEDKB"
truncate --size=-${UNALLOCATEDKB}K $IMAGE
rtn=$?
if [ $rtn -ne 0 ]; then
    echo ""
    echo "Error : Could not truncate the image file by $UNALLOCATEDKB KB !"
    echo 
    exit 
fi

echo ""
echo "*** Successfully resized image file: $IMAGE ! ***"
echo ""
