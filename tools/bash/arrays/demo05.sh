# Description:	Replace a string contained in all entries.

declare -a Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');

echo
echo "BEFORE:"
for t in "${Unix[@]}"
do
	echo $t
done

# Replace "Ubuntu" with "SCO Unix" in all entries, to create a new array.
declare -a Unix2=( "${Unix[@]/Ubuntu/SCO Unix}" )

echo
echo "AFTER:"
for t in "${Unix2[@]}"
do
	echo $t
done
