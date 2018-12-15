# Description:	Remove entries matching a patterns.

declare -a Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Red Bottom' 'UTS' 'OpenLinux');

echo
echo "BEFORE:"
for t in "${Unix[@]}"
do
	echo $t
done

echo
echo "Removing entries containing \"Red\" ..."
declare -a Unix2=( ${Unix[@]/Red*/} )

echo
echo "AFTER:"
for t in "${Unix2[@]}"
do
	echo $t
done
