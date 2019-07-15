# Notice 'trick' of using the 'o' in "demo" to sort
# the "demo[0-9]*" directories on the numeric part:
#
# sort -n	=	Sort numerically
# sort -k2	-	Sort on the second field
# sort -to	=	Use letter 'o' as field delimiter

echo
for d in $(ls -1 | grep ^demo | sort -n -k2 -to)
do
	printf "%-8s: %s\n" $d "$(head -1 "$d/README.md")"
done
echo
