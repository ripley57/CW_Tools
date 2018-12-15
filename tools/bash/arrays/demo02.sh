# Description:	Initialize an array in one go.

declare -a Unix=('Debian' 'Red hat' 'Red hat' 'Suse' 'Fedora');

echo
echo "Displaying all entries one at a time:"
for t in "${Unix[@]}"
do
	echo $t
done
