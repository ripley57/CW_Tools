#!/bin/bash

function addcountprefix() {
	local f
	local count=0

	ls -1 *.mp3 | sort | while read f
	do
		echo Adding count prefix to: $f ...

		# Get the current mp3 title.
		local f_title=$(./mp3edit.sh "$f" --list_title)
		if [ "x$f_title" = "x" ]; then
			echo "ERROR: Could not determine mp3 title, skipping file $f ..."
			continue
		fi

		echo f_title=$f_title

		# Check if the file name already has a numeric prefix. This
		# would indicate that we've already change it previously.
		local f_name=$(echo "$f" | grep '^[0-9][0-9]* .*')
		if [ "x$f_name" != "x" ]; then
			echo ERROR: File already has a count prefix: 
			echo $f
			echo Use function to remove the prefix.
			echo Ingnoring file...
			continue
		fi

		# Add count prefix ...
		echo addcountprefix: Adding prefix to $f ...

		# Increment count value for the new file name and new mp3 title.
		count=$((count+1))
		count_str=$(printf "%04d" $count)

		# Create the new file name.
		local f_new_name="$count_str $f"

		# Create the new mp3 title.
		local f_new_title="$count_str $f_title"

		# Set the new file name.
		mv "$f" "$f_new_name" || (echo ERROR: Could not rename file $f. Exiting... && exit 1)

		# Set the new mp3 title.
		./mp3edit.sh "$f_new_name" --title "$f_new_title"

		#echo 
		#echo Adding count value prefix...
		#echo File name before: $f
		#echo File name after : $f_new_name
		#echo Title before    : $f_title
		#echo Title after     : $f_new_title
	done
}

function removecountprefix() {
	local f

	ls -1 *.mp3 | sort | while read f
	do
		echo Removing count prefix from: $f ...

		# Get the current mp3 title.
		local f_title=$(./mp3edit.sh "$f" --list_title)
		if [ "x$f_title" = "x" ]; then
			echo "ERROR: Could not determine mp3 title, skipping file $f ..."
			continue
		fi

		# Check if the file name already has a numeric prefix. This
		# would indicate that we've already change it previously.
		local f_name=$(echo "$f" | grep '^[0-9][0-9]* .*')

		if [ "x$f_name" = "x" ]; then
			echo WARN: Ignoring file as it already has no count prefix: $f
			continue
		fi

		# File name has been changed previously. Remove leading 
		# count value from both the file name and the mp3 title.

		# Remove leading count value from file name.
		local f_new_name=$(echo "$f" | sed -n 's/^[0-9][0-9]* \(.*\)/\1/p')

		# Rmove the leading count value from the mp3 title.
		local f_new_title=$(echo "$f_title" | sed -n 's/^[0-9][0-9]* \(.*\)/\1/p')

		# Set the new file name.
		mv "$f" "$f_new_name" || (echo ERROR: Could not rename file $f. Exiting... && exit 1)

		# Set the new mp3 title.
		./mp3edit.sh "$f_new_name" --title "$f_new_title"

		#echo 
		#echo Removing count value prefix...
		#echo File name before: $f
		#echo File name after : $f_new_name
		#echo Title before    : $f_title
		#echo Title after     : $f_new_title
	done
}

addcountprefix
#removecountprefix
