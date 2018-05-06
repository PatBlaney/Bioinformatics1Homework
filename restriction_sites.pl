#!/usr/bin/perl
use strict;
use warnings;

# Take user input sequence
# my $DNA_seq = "$ARGV[0]";

# Test sequence which included newline characters
my $DNA_seq = 'AACAGCACGGCAACGCTGTGCCTTGGGCACCATGCAGTACCAAACGGAACGATAGTGAAAACAATCACGA
ATGACCAAATTGAAGTTACTAATGCTACTGAGCTGGTTCAGAGTTCCTCAACAGGTGAAATATGCGACAG
TCCTCATCAGATCCTTGATGGAGAAAACTGCACACTAATAGATGCTCTATTGGGAGACCCTCAGTGTGAT
GGCTTCCAAAATAAGAAATGGGACCTTTTTGTTGAACGCAGCAAAGCCTACAGCAACTGTTACCCTTATG
ATGTGCCGGATTATGCCTCCCTTAGGTCACTAGTTGCCTCATCCGGCACACTGGAATTTAACAATGAAAG
CTTCAATTGGACTGGAGTCACTCAAAATGGAATCAGCTCTGCTTGCAAAAGGAGATCTAATAACAGTTTC
TTTAGTAGATTGAATTGGTTGACCCACTTAAAATTCAAATACCCAGCATTGAACGTGACTATGCCAAACA
ATGAAAAATTTGACAAATTGTACATTTGGGGGGTTCACCACCCGGGTACGGACAATGACCAAATCTTCCT
GTATGCTCAAGCATCAGGAAGAATCACAGTCTCTACCAAAAGAAGCCAACAGACTGTAATCCCGAATATC
GGATCTAGACCCAGAGTAAGGAATATCCCCAGCAGAATAAGCATCTATTGGACAATAGTAAAACCGGGAG
ACATACTTTTGATTAACAGCACAGGGAATTTAATTGCTCCTAGGGGTTACTTCAAAATACGAAGTGGGAA
AAGCTCAATAATGAGATCAGATGCACCCATTGGCAAATGCAATTCTGAATGCATCACTCCAAATGGAAGC
ATTCCCAATGACAAACCATTTCAAAATGTAAACAGGATCACATATGGGGCCTGGCCCAGATATGTTAAGC
AAAACACTCTGAAATTGGCAACAGGGATGCGAAATGTACCAGAGAAACAAACTAGAGGCATATTTGGCGC
AATCGCGGGTTTCATAGAAAATGGTTGGGAAGGAATGGTGGATGGTTGGTACGGTTT';

# Remove any newline characters
$DNA_seq =~ s/\n//g;

# Check if regexp properly removed newline characters and still preserved input sequence
# print $DNA_seq, "\n";

# Ensure that user input a DNA sequence that is a combinations of only atgc nucleotides
if ( $DNA_seq =~ /[bdefhijklmnopqrsuvwxyz]/gi ) {
	die "Please provide a proper DNA sequence", "\n";
}

# Check if a correct sequence made it through if statement
# print $DNA_seq, "\n";

# Regexp to match restriction enzyme motif 1
my $cut_site_1 = "(cac[atgc]{3})";

# Regexp to match restriction enzyme motif 2
my $cut_site_2 = "(gcc[at]gg)";

# Call subroutine using the DNA sequence and a regexp to match a restriction enzyme motif
find_cut_sites($DNA_seq, $cut_site_1);
print "\n";
find_cut_sites($DNA_seq, $cut_site_2);

# Create subroutine that takes a DNA sequence and regular expression as parameters.
# Subroutine will print out the position of the start of the  cut sites and the pattern
# that matched the restriction enzyme motif
sub find_cut_sites {
	my ( $seq, $motif ) = @_;
	while ( $seq =~ /$motif/gi ) {
		my $motif_end_position = pos($seq);
		my $motif_length = length($1);
		my $motif_start_position = $motif_end_position - $motif_length + 1;
		print "$1 matched at residue $motif_start_position", "\n";
	}
}
