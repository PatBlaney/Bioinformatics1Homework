#!/usr/bin/perl
use strict;
use warnings;

# Set default FASTA file to be read if user defined filename is not provided
my $default_FASTA_filename = "/scratch/Drosophila/dmel-all-chromosome-r6.02.fasta";

# Assign a variable for any user defined filename
my $user_FASTA_filename = $ARGV[0];

# Conditional assessment to open the default if user did not define a filename
if ($user_FASTA_filename) {
	open(FASTA, "<", $user_FASTA_filename);
}
else {
	open(FASTA, "<", $default_FASTA_filename);
}

# Open file to write all potential binding sites to
open(SITES, ">", "binding_sites.txt");

# Read in the FASTA file, remove header and new line characters to isolate sequence then
# use subroutine to write output
my $number_of_sites = 0;
while (<FASTA>) {
	my $seq = $_;
	$seq =~ s/\\n//g;
	write_TFBS($seq, \$number_of_sites);
}

print SITES "$number_of_sites binding sites were found", "\n";


# Subroutine that identifies matches to the consensus sequence within the FASTA sequence then
# prints each match to a file and finally a total number of binding sites 
sub write_TFBS {
	my ($FASTA_line, $count) = @_;
	while ($FASTA_line =~ /([TC]C[TC]GGAAGC)/g) {
		print SITES $1, "\n";
		return $$count++;
	}
} 
