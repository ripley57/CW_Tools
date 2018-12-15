# Description:	Add a new entries to an existing array.

declare -a Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');

echo
echo "BEFORE:"
for t in "${Unix[@]}"
do
	echo $t
done

Unix=("${Unix[@]}" "AIX" "HP-UX")

echo
echo "AFTER:"
for t in "${Unix[@]}"
do
	echo $t
done
