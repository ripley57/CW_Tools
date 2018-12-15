# Description:	Extract part of an entry.

declare -a Unix=('Debian' 'Red hat' 'Red hat' 'Suse' 'Fedora');

echo
echo "Displaying all entries one at a time:"
for t in "${Unix[@]}"
do
	echo $t
done

echo
echo "Extract the first two chars if the 4 entry:"
echo ${Unix[3]:0:2}
