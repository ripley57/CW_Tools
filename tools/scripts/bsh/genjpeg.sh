#!/bin/bash
for (( i=1 ; i<=23000 ; i++ ))
do
	echo "test jpeg file $i" > test_jpeg${i}.txt
        convert -size 50x50 test_jpeg${i}.txt test_jpeg${i}.jpeg
     	rm -f   test_jpeg${i}.txt
done

