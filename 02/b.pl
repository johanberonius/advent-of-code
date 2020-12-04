#!/usr/bin/perl
use strict;

my $i = 0;

my @r;

push @r => [$1, $2, $3, $4] while <> =~ /(\d+)\s*-\s*(\d+)\s*(\w)\s*:\s*(\w+)/;


print "Rules and passwords: ", 0+@r, "\n";

for my $r (@r) {
    my ($p1, $p2, $letter, $password) = @$r;
    my @chars = split '', $password;
    my $n = grep $_ eq $letter, @chars[$p1-1, $p2-1];
    $i++ if $n == 1;

    print "$p1, $p2, $letter, $password => @chars[$p1-1, $p2-1] => $n\n";
}

print "$i are valid.\n";
