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
my $expected_json;

sub command {
        my ($cmd) = @_;
        # diag "\nexecute: $cmd";
        my $output = `$cmd`;
        return $output;
}

sub verify {
        my ($input_json, $output_json, $keys) = @_;

        my $input  = JSON::decode_json($input_json);
        my $output = JSON::decode_json($output_json);

        for (my $i=0; $i < @{$input->{BenchmarkAnythingData}}-1; $i++) {
                my $got      = $output->[$i];
                my $expected = $input->{BenchmarkAnythingData}[$i];
                foreach my $key (@$keys) {
                        is($got->{$key},  $expected->{$key},  "re-found [$i].$key");
                }
        }
}

# Search for benchmarks, verify against expectation
sub query_and_verify {
        my ($query_file, $expectation_file, $fields) = @_;

        my $output_json   = command "$program search -c $cfgfile $query_file";
        my $expected_json = File::Slurp::read_file($expectation_file);
        verify($expected_json, $output_json, $fields);
}

# Create and fill test DB
command "$program createdb -c $cfgfile --really dbi:SQLite:t/benchmarkanything.sqlite";
command "$program add      -c $cfgfile t/valid-benchmark-anything-data-01.json";

# Search for benchmarks, verify against expectation
query_and_verify("t/query-benchmark-anything-01.json",
                 "t/query-benchmark-anything-01-expectedresult.json",
                 [qw(NAME VALUE)]
                );

# Finish
done_testing;
