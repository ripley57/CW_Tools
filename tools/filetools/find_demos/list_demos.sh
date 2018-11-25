for d in $(ls -1 demo*.sh | sort)
do
	desc=$(grep 'Description' $d | sed 's/^.*Description://')
	echo "$d: $desc"
done
