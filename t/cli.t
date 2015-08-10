#! /usr/bin/perl

use strict;
use warnings;
use Test::More 0.88;

my $program   = "$^X -Ilib bin/benchmarkanything-storage";
my $infile    = "t/valid-benchmark-anything-data-01.json";
my $cfgfile   = "t/benchmarkanything-tapper.cfg";
my $cmd       = "$program add -c $cfgfile $infile";

diag "\nexecute: $cmd";
my $output    = `$cmd`;

diag "\n$output";

ok(1, "survived");
done_testing;
