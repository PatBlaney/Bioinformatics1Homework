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

# Call recursive subroutine to identify all the potential coding regions by identifying
# start and stop codons
find_coding_regions($DNA_seq);

sub find_coding_regions {
	my ( $seq ) = @_;
	while ( $seq =~ /((ATG)\w*(TAA|TGA|TAG))/gi ) {
		my $coding_region = $1;
		my $start_codon = $2;
		my $stop_codon = $3;
		my $end_cut_point = rindex($coding_region, $stop_codon);
		my $start_cut_point = rindex($coding_region, $start_codon);
		my $new_seq1 = substr($coding_region, $start_cut_point);
                if ( substr($new_seq1, -3) eq $stop_codon && length($new_seq1) > 5 && length($new_seq1) < length($coding_region) ) {
			print "Potential coding region: $new_seq1", "\n";
		}
		if ( substr($coding_region, -3) eq $stop_codon ) {
			my $new_seq2 = substr($coding_region, 0, $end_cut_point);
			find_coding_regions($new_seq2);
			print "Potential coding region: $coding_region", "\n";
		} 
	}
}
