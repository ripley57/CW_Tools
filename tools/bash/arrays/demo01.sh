# Description:	Initialise each array entry at a time.

Unix[0]='Debian'
Unix[1]='Red hat'
Unix[2]='Ubuntu'
Unix[3]='Suse'

echo
echo "Displaying a single entry:"
echo ${Unix[1]}

echo 
echo "Displaying all entries in one go:"
echo ${Unix[@]}

echo
echo "Displaying all entries one at a time:"
for t in "${Unix[@]}"
do
	echo $t
done

