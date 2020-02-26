printf "<Root>\n"
for i in {1..5}
do
	printf "<Agent id=\"nwb-tpccsilk%d\" IpAddress=\"10.120.50.50\"\>\n" $i
done
printf "</Root>\n"
