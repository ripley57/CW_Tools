# Description:	Concatenate two arrays.

Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
Shell=('bash' 'csh' 'jsh' 'rsh' 'ksh' 'rc' 'tcsh');

echo
echo "Array 1:"
echo ${Unix[@]}

echo 
echo "Array 2:"
echo ${Shell[@]}

echo
echo "Combined array:"
UnixShell=("${Unix[@]}" "${Shell[@]}")
echo ${UnixShell[@]}
echo ${#UnixShell[@]}
