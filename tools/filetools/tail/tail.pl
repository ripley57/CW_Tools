#!/usr/bin/perl

# Description:
#    Tail command using Perl.
#
# Example usage:
#    ./tail.pl /cygdrive/c/tmp/out.log

open(FH,'<',"$ARGV[0]") 
	or die "Could not open file: $ARGV[0] $!";

seek FH,-2000,2;

# Do not print all lines from the start of file.
$skipped = 0;

for(;;){
	while(<FH>){
		chomp $_;
		if ($skipped == 1) {
			print $_.qq~\r\n~;
		}
	}
	if ($skipped == 0) {
		$skipped = 1;
	}
	sleep 1;
	seek FH,0,1;
}
