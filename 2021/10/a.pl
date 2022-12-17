#!/usr/bin/perl
use strict;

my $s = 0;
my %p = (
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
);
my %o = (
    ')' => '(',
    ']' => '[',
    '}' => '{',
    '>' => '<',
);

while (<>) {
    chomp;
    print "$_\n";
    my @q;
    for (split '') {
        print;
        if (/[(\[{<]/) {
            push @q => $_;
        } elsif ($q[-1] eq $o{$_}) {
            pop @q;
        } else {
            $s += $p{$_};
            print "\nIllegal closing bracket: $_, $p{$_} points.";
            last;
        }
    }
    print "\n\n";
}

print "Total syntax error score: $s\n";
