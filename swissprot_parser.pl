#!/usr/bin/perl
use strict;
use warnings;

# Store the path to the SwissProt format file
my $swissprot_file = '/scratch/SampleDataFiles/example.sp';

# Construct regexps for subroutine
my $AC_line = "AC   ((.*?;) (.*?;))";
my $OS_line = "OS   (.*?)\\.";
my $OX_line = "OX   (.*?;)";
my $ID_line = "PRT;  (.*? AA)";
my $GN_line = "GN   (.*?\\.)";
my $SQ_line = ";
     ([A-Z].*)";

# Locally set the input record separator to '//' which is used in the SwissProt format
local $/ = "//";

# Read in the file
open( SWISSPROT, "<", $swissprot_file );

# Create an empty string to add the parsed file to that will then be used as the input string 
# for the subroutine
my $read_lines = "";

# Read in each line of the SwissProt file and add each part to the empty string previously 
# assigned
while ( <SWISSPROT> ) {
	chomp;
	$read_lines .= $_;
}


# Open FASTA file and write to it with annotation lines from SwissProt file
open ( FASTA, ">", "ceru_human.fasta");

# Write the lines of interest that were matched to the new FASTA format file 
print FASTA ">", find_pattern($read_lines, $AC_line), " | ";
print FASTA find_pattern($read_lines, $OS_line), " | ";
print FASTA find_pattern($read_lines, $OX_line), " | ";
print FASTA find_pattern($read_lines, $ID_line), " | ";
print FASTA find_pattern($read_lines, $GN_line), "  ", "\n";

# Remove the extra spaces and newline characters from the peptide sequence taken from the 
# SwissProt file and then print this to the FASTA format file
my $peptide_seq = find_pattern($read_lines, $SQ_line);
$peptide_seq =~ s/ //g;
$peptide_seq =~ s/\n//g;
print FASTA $peptide_seq, "\n";

# Create a subroutine that takes the read lines from the SwissProt file and a regular expression
# used to match specific lines of interest. Return the match or "error" if not a match.
sub find_pattern {
	my ( $file_line, $pattern_for_FASTA ) = @_;
	if ( $file_line =~ /$pattern_for_FASTA/gs) {
		return $1;
	}
	else {
		return "error", "\n";
	}
}

# Close files once finished
close SWISSPROT;
close FASTA;
