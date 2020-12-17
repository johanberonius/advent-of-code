#!/usr/bin/perl
use strict;

my $i = 0;

my @r;

push @r => [$1, $2, $3, $4] while <> =~ /(\d+)\s*-\s*(\d+)\s*(\w)\s*:\s*(\w+)/;


print "Rules and passwords: ", 0+@r, "\n";

for my $r (@r) {
    my ($min, $max, $letter, $password) = @$r;
    my $n = grep $_ eq $letter, split '', $password;
    $i++ if $n >= $min && $n <= $max;

    print "$min, $max, $letter, $password => $n\n";
}

print "$i are valid.\n";
