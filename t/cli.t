#! /usr/bin/perl

use strict;
use warnings;
use Test::More 0.88;
use File::Slurp;
use JSON;
use DBI;

my $program   = "$^X -Ilib bin/benchmarkanything-storage";
my $cfgfile   = "t/benchmarkanything-tapper.cfg";
my $infile;
my $input_json;
my $input;
my $inquery_file;
my $output_json;
my $output;

sub command {
        my ($cmd) = @_;
        # diag "\nexecute: $cmd";
        my $output = `$cmd`;
        return $output;
}

sub verify {
        my ($input, $output, $keys) = @_;

        for (my $i=0; $i < @{$input->{BenchmarkAnythingData}}-1; $i++) {
                my $got      = $output->[$i];
                my $expected = $input->{BenchmarkAnythingData}[$i];
                foreach my $key (@$keys) {
                        is($got->{$key},  $expected->{$key},  "re-found [$i].$key");
                }
        }
}

# Create test DB
command "$program createdb -c $cfgfile --really dbi:SQLite:t/benchmarkanything.sqlite";

# Fill with benchmarks
$infile     = "t/valid-benchmark-anything-data-01.json";
$input_json = File::Slurp::read_file($infile);
$input      = JSON::decode_json($input_json);
command "$program add      -c $cfgfile $infile";

# Search for benchmarks
$inquery_file = "t/query-benchmark-anything-01.json";
$output_json = command "$program search   -c $cfgfile $inquery_file";
$output = JSON::decode_json($output_json);

# Verify
verify($input, $output, [qw(NAME VALUE)]);

# Finish
done_testing;
