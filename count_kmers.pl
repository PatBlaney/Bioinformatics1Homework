#!/usr/bin/perl
use strict;
use warnings;

my $sequence = load_sequence("/scratch/Drosophila/dmel-2L-chromosome-r5.54.fasta");

#print $sequence;	# FOR TESTING

my $kmers_count = count_kmers($sequence, 15);

#print $kmers_count{"ATTTTTTGGCAACCC"}, "\n";	# FOR TESTING

#print values $kmers_count, "\n";

my $output_filename = 'kmers.txt';
print_kmers_and_counts($kmers_count, $output_filename);

sub load_sequence {
	my ($seq_file) = @_;
	
	# Create empty string to then populate with sequence from provided file
	my $seq_string = "";
	open (SEQ, "<", $seq_file) or die "Cannot open file: $!\n";
	
	# Remove header from file
	my $header = <SEQ>;
	
	#print $header, "\n"; 	# FOR TESTING 
	while (<SEQ>) {
		chomp;
		$seq_string .= $_;
	}
	close SEQ;

	# Return the complete sequence string
	return $seq_string;
}

sub count_kmers {
	my ($seq, $kmer_length) = @_;
	
	# Create an empty hash to populate with unique k-mer sequences and count associated with
	# each sequence
	my %kmer_count = ();
	for (my $seq_index = 0; $seq_index <= length($seq) - $kmer_length; $seq_index++) {
		
		# Extract each k-mer of a given length from the sequence provided
		my $kmer_sequence = substr($seq, $seq_index, $kmer_length);
		#print $kmer_sequence, "\n";	# FOR TESTING
		
		if (not defined $kmer_count{$kmer_sequence}) {
			
			# Given each new kmer_sequence an initial count if not already found in
			# the k-mer count hash
			my $count = 1;
			
			# Assign the k-mer sequence to the hash using the sequence as the key
			# and the count as the value
			$kmer_count{$kmer_sequence} = $count;
		}
		else {
			$kmer_count{$kmer_sequence} += 1;
		}
	}
	# Return the hash reference 
	return \%kmer_count;
}


sub print_kmers_and_counts {
	my ($hash_reference, $file_to_write) = @_;
	open (KMERS, ">", $file_to_write);
	
	# Cycle through keys of has and output each key and its associated value
	# into a .txt file
	foreach my $kmer_key (keys %$hash_reference) {
		print KMERS "$kmer_key\t$$hash_reference{$kmer_key}\n";
	}
	close KMERS;
}		
