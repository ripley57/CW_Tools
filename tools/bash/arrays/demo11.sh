# Description:	Deleting an entire array.

Shell=('bash' 'csh' 'jsh' 'rsh' 'ksh' 'rc' 'tcsh');

echo
echo "BEFORE:"
echo ${Shell[@]}

echo
echo "Deleting the array..."
unset Shell

echo
echo "AFTER:"
echo ${Shell[@]}
