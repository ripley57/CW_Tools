#
# Description:
#   Awk script to analyse a Java stack dump and print the line number ranges
#   of the largest stacks, since these are usually the most important ones.
#
#   Example output:
#
#   awk -f stacks.awk dump.log
#
#   5 Largest Stacks:
#   105    [6600,6705] [23050,23155]
#    29    [6369,6398]
#    27    [12751,12778] [12837,12864]
#    26    [8953,8979] [13066,13092] [16362,16388]
#    24    [5148,5172]
#
#
#   Example of a single stack from a Java dump file:
# 
#     [java] 
#     [java] java.lang.Throwable
#     [java] 	at java.net.SocketInputStream.socketRead0(Native Method)
#     [java] 	at java.net.SocketInputStream.socketRead(SocketInputStream.java:116)
#     [java] 	at java.net.SocketInputStream.read(SocketInputStream.java:170)
#     [java] 	at java.net.SocketInputStream.read(SocketInputStream.java:141)
#     [java] 	at java.net.SocketInputStream.read(SocketInputStream.java:223)
#     [java] 	at com.teneo.esa.admin.jmx.SocketTerminationServer$TerminationWaiterClientThread.run(SocketTerminationServer.java:253)
#     [java] 
#
# JeremyC 5/12/2015

debug=0

# Length of array
function alen(a, i, k) {
    for (i in a)
	k++
    return k
}

BEGIN {

}

/Current Time.*= / {
	DATE_TIME=$0
	sub(/^.*Current Time.*= /,"",DATE_TIME)
}

# Start or end of current stack.
/^[ \t]+\[java\] $/ {
	len = alen(CURRENT_STACK)
	if (len > 0) {
		line_count=NR - lineno_stack_start

		# End of current stack. 
		if (debug) printf("End of stack. len=%d, line_count=%d, start=%d, end=%d\n", len, line_count, lineno_stack_start, NR);

		# Record stack details.
		s1=ALL_STACKS[line_count]
		s2=sprintf("[%d,%d]", lineno_stack_start, NR)
		s3=sprintf("%s %s", s1, s2);
		if (debug) printf("s3=%s\n", s3)
		ALL_STACKS[line_count]=s3

		# Reset for next stack.
		delete CURRENT_STACK
		lineno_stack_start=0
	} else {
		# End of previous stack. Ignore.
	}
}

/^[ \t]+\[java\] .+$/ {
	if (lineno_stack_start == 0) {
		# Start of a new stack.
		lineno_stack_start=NR
	}
	
	# Save stack line.
	CURRENT_STACK[NR - lineno_stack_start]=$0
}

END {
	stacks_count=alen(ALL_STACKS)
	if (debug) printf("\nNumber of stacks: %d\n\n", stacks_count)

	# Create a sorted array of keys (i.e. of line counts).
	j = 1
	for (i in ALL_STACKS) {
		ind[j] = i
		j++
	}
	n = asort(ind, ind_sorted, "@val_num_desc")

	# Now use the sorted index to print the largest stack dumps.
	printf("\n5 Largest Stacks:\n\n");
	for (i = 1; i <= 5; i++) {
		lc = ind_sorted[i]
		# Print: <lines in stack> <stack metadata>
		printf("%6d \t %s\n", lc, ALL_STACKS[lc]);
	}
}
