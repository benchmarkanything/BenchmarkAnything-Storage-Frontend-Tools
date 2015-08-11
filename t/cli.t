#! /usr/bin/perl

use strict;
use warnings;
use Test::More 0.88;
use DBI;

my $program   = "$^X -Ilib bin/benchmarkanything-storage";
my $infile    = "t/valid-benchmark-anything-data-01.json";
my $cfgfile   = "t/benchmarkanything-tapper.cfg";

sub command {
        my ($cmd) = @_;
        diag "\nexecute: $cmd";
        my $output = `$cmd`;
        diag "\n$output";
}

# Create test DB
command "$program createdb -c $cfgfile --really dbi:SQLite:t/benchmarkanything.sqlite";

# Fill with benchmarks
command "$program add      -c $cfgfile $infile";

# Search for benchmarks
# TODO
ok(1, "survived");

# Finish
done_testing;
