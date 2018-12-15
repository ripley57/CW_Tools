# Description:	Number of entries in an array, and the size of a specific entry in the array.

declare -a Unix=('Debian' 'Red hat' 'Red hat' 'Suse' 'Fedora');

echo
echo "Size of the array:"
echo ${#Unix[@]}

echo
echo "Displaying all entries one at a time:"
for t in "${Unix[@]}"
do
	echo $t
done

echo
echo "Size of the first entry:"
echo ${#Unix[0]}
