#!/usr/bin/perl
use strict;
use warnings;

# Open cross-reference mapping file 
open(MAPPING, "<", "/scratch/Drosophila/fb_synonym_fb_2014_05.tsv");

# Set up globably available hash for conversion of ID number to gene symbol
my %ID_to_symbol;

# Use while loop to identify only lines contain a FB ID number, then save the number and the 
# associated gene symbol to the empty hash ID_to_symbol
while (<MAPPING>) {
	my $line = $_;
	$line =~ /^FB.*/gm;
	my @ID_and_symbol_strings = split(/\t{2,}/, $line);	
	find_ID_and_symbol(@ID_and_symbol_strings);	
}

# Subroutine that pulls out the ID number and gene symbols from the array of split strings
sub find_ID_and_symbol {
	my (@file_line) = @_;
	foreach my $file_piece (@file_line) {
		if ($file_piece =~ /(FB[\w]+\d)\t(.*?)\t/) {
			$ID_to_symbol{$1} = "$2";
		}
	}
}

# Checkpoint: Use a ID number to see if corresponding gene symbol was attached as value in 
# key-value pair of hash
#print $ID_to_symbol{"FBtp0092930"}, "\n";

# Close the mapping file now that we have ID numbers and the associated gene symbols isolated
close MAPPING;	

# Open EGF expression data file 
open(EXPRESSION, "<", "/scratch/Drosophila/FlyRNAi_data_baseline_vs_EGF.txt");

# Open file to write the gene symbol of each FBgn, the EGF baseline expression, and
# the EGF stimulus expression to
open(EGFDATA, ">", "FlyRNAi_data_baseline_vs_EGF_Symbol.txt");

# Find the EGF baseline expression and EGF stimulus for each FBgn ID
while (<EXPRESSION>) {
	chomp;
	my $observations = $_;	
	find_FBgn_matches($observations);
}

# Subroutine that looks for FBgn ID number matches then writes relevant info to EGF data file
sub find_FBgn_matches {
	my ($data) = @_;
	if ($data =~ /(FBgn.*)\t(.*)\t(.*)/) {
		my $FBgn_number = $1;
		my $EGF_baseline = $2;
		my $EGF_stimulus = $3;
		if ($ID_to_symbol{$FBgn_number}) {
			print EGFDATA "$ID_to_symbol{$FBgn_number}\t$EGF_baseline\t$EGF_stimulus\n";
		}
	}
}

# Close files once done using them
close EXPRESSION;
close EGFDATA;

# Open gene association file
open(GENEASSOC, "<", "/scratch/Drosophila/gene_association.goa_fly");

# Set up globally available hash to store the gene symbol and associated GO term
my %symbol_to_GO;

# Isolate the gene symbol and GO term of the gene association file 
while (<GENEASSOC>) {
	chomp;
	my $GO_term_and_symbol = $_;
	find_GO_term($GO_term_and_symbol);	
}
 
# Subroutine for isolating the gene symbol and GO term for storage in hash
sub find_GO_term {
	my ($UniProt_line) = @_;
	if ($UniProt_line =~ /\t([\d\w]+)\t+(GO:\d+)/) {
		$symbol_to_GO{$1} = "$2";
	}
}

# Close files when finished using them
close GENEASSOC;

# Open EGF data and gene symbol .txt file
open(EGFDATA, "<", "FlyRNAi_data_baseline_vs_EGF_Symbol.txt");

# Open new file to write final GO terms to with EGF data
open(GODATA, ">", "FlyRNAi_data_baseline_vs_EGF_GO.txt");

# Identify matches for GO terms and write them to a new file along with associated EGF data
while (<EGFDATA>) {
	chomp;
	$_ =~ /(.*)\t(.*)\t(.*)/;
	if ($symbol_to_GO{$1}) {
		print GODATA "$symbol_to_GO{$1}\t$2\t$3\n";
	}
}

# Close files once done
close EGFDATA;
close GODATA;
