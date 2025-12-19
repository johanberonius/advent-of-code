#!/usr/bin/perl
use strict;

my %r;
my $t;
while (<>) {
    if (/(\w+) => (\w+)/) {
        $r{reverse $2} = reverse $1;
    } elsif (/(\w+)/) {
        $t = reverse $1;
    }
}

print "$t\n";
my $s = 0;
my $re = join '|', keys %r;
while ($t =~ s/($re)/$r{$1}/) {
    print "$t\n";
    $s++;
}

print "Steps: $s\n";
