# Description:	Remove an entry from an array.

declare -a Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');

echo
echo "BEFORE:"
for t in "${Unix[@]}"
do
	echo $t
done

echo
echo "Removing the 4th element using \"unset\":"
unset Unix[3]

echo
echo "AFTER:"
for t in "${Unix[@]}"
do
	echo $t
done

echo
echo "Removing the 2nd element by copying the array and excluding the one entry to remove:"
pos=1
declare -a Unix2=( "${Unix[@]:0:$pos}" "${Unix[@]:$(($pos + 1))}" )

echo 
echo "AFTER:"
for t in "${Unix2[@]}"
do
	echo $t
done
