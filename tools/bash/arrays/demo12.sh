# Description:	Load file contents into an array.

cat > logfile <<EOI
Welcome you
to
thegeekstuff
Linux OS
Unix
EOI

# NOTE HOW THE SPACEY VALUES ARE PRESERVED USING \"IFS\"!"
IFS=$'\n' filecontent=( `cat "logfile" `)

for t in "${filecontent[@]}"
do
	echo $t
done

rm -f logfile
