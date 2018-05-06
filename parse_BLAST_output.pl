#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

# Locate correct sample file using absolute path
my $BLAST_file = '/scratch/SampleDataFiles/sampleBlastOutput.txt';

# Examine file to see how data is formated
my $file_check = system( 'less /scratch/SampleDataFiles/sampleBlastOutput.txt' );

# Open sample BLAST file to read
open( BLAST, "<", $BLAST_file ) or die "Cannot open file: $!";

# Open file to write to
open( NEW_BLAST, ">", 'first_four_BLAST_columns.txt' );

# Use loop to read first four columns of BLAST_file and write these lines to new empty file
while ( <BLAST> ) {
	chomp;
	my @BLAST_fields = split("\t", $_);
	my $percent_identity = $BLAST_fields[2];
	if ( $percent_identity > 70.00 ) {
		print NEW_BLAST $BLAST_fields[0], "\t", $BLAST_fields[1], "\t", $BLAST_fields[2], 			"\t", $BLAST_fields[3], "\n";
	}
}

# Close files at completion of reading and writing
close BLAST;
close NEW_BLAST;
