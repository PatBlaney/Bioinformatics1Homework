#!/usr/bin/perl
use strict;
use warnings;

# Assign path to FASTA file to a variable
my $test_FASTA = '/scratch/SampleDataFiles/test.fasta';

# Reassign the input record separator to correctly work with FASTA format
local $/ = ">"; 

# Assign regular expression to find hydrophobic motif to a variable
my $hydrophobic_motif_pattern = "([VILMFWCA]{8,})";

# Assign regular expression to pull header of sequence where a motif region is found
my $seq_header = "([A-Z].*;)";

# Open and read in test FASTA file
open( FASTA, "<", $test_FASTA );

while( <FASTA> ) {
	header_for_motif($_, $seq_header, $hydrophobic_motif_pattern);
	chomp;
	find_motif($_, $hydrophobic_motif_pattern);
}

# Assign variable that holds the number of sequences with a hydrophobic region
my $number_of_seq_with_region = 2;

# Assign variable that holds the total number of sequences found in the file
my $total_seq = 15; 

# Print out message telling how many sequences were found with hydrophobic regions out 
# of the total number of sequences
print "Hydrophobic region(s) found in $number_of_seq_with_region out of $total_seq seqences. ", "\n";

# Create subroutine that will accept a string from a FASTA format file and match all the
# regions that match the passed hydrophobic motif pattern
sub find_motif {
	my( $FASTA_line, $motif ) = @_;
	while( $FASTA_line =~ /$motif/g ) {
		my $motif_end_position = pos($FASTA_line);
		my $motif_length = length($1);
		my $motif_start_position = $motif_end_position - $motif_length + 1;
		print "$1 found at $motif_start_position", "\n";
	}
}

# Create subroutine to pull out the header of the FASTA file for each sequence that
# contains a hydrophobic motif region
sub header_for_motif {
	my( $FASTA_header, $FASTA_seq_header, $motif_2 ) = @_;
	if ($FASTA_header =~ /$FASTA_seq_header/) {
		my $header_output = $1;
		if( $FASTA_header =~ /$motif_2/ ) {
			print "Hydrophobic region found in $header_output", "\n";
		}
	}
}
