for d in $(ls -1 demo*.sh | sort)
do
	sh ./$d
done
