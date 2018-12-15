# Description:	Copy an array.

declare -a Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Red Bottom' 'UTS' 'OpenLinux');

echo
echo "Original:"
echo "${Unix[@]}"

Linux=("${Unix[@]}")

echo
echo "Copy:"
echo "${Linux[@]}"
