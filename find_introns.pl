#!/usr/bin/perl
use strict;
use warnings;

# Initially, declare variable to hold default sequence
my $DNA_seq = "AATGGTTTCTCCCATCTCTCCATCGGCATAAAAATACAGAATGATCTAACGAA";

# Check if user provided valid sequence to replace default, if not, print message and end
# program
if ( $ARGV[0] ) {
	my $user_seq = $ARGV[0];
	if ( $user_seq =~ /[^atgc]/gi ) {
		die "This is not a valid sequence. Try again.", "\n";
	}
	else {
		$DNA_seq = $user_seq;
	}
}

# Checkpoint: print out sequence that will be analyzed, either default or user defined
print "Input sequence: $DNA_seq", "\n";

print "\n";

# Call recursive subroutine to identify all potential introns within a sequences assuming
# only canonical splice sites 
if ( $DNA_seq =~ /GT.*AG/gi ) {
	find_introns($DNA_seq);
}
else {
	print "No potential introns were found.", "\n";
}

sub find_introns {
	my ( $sequence ) = @_;	
	while ( $sequence =~ /(GT(.*?)AG)/gi ) {
		my $intron = $1;
		my $new_seq = $2;
		find_introns($new_seq);
		print "Potential intron: $intron", "\n";
	}		
}
