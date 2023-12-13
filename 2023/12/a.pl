#!/usr/bin/perl
use strict;

my $s = 0;
while (<>) {
    chomp;
    my ($p, $l) = split ' ';

    my $e = my @e = $p =~ /\?/g;
    my $re = join '\.+', map "#{$_}", split ',', $l;

    print "$p\n";
    print "$re\n";

    my $c = 0;
    for my $n (0 .. 2**$e-1) {
        my $m = $p;
        my $i = 0.5;
        $m =~ s/\?/ ($n & ($i *= 2)) ? '#' : '.'  /ge;
        my $d = $m =~ /^\.*$re\.*$/;
        $c += $d;
        # print "$m ", $d && 'match', "\n";

    }
    print "$c combinations.\n";
    print "\n";
    $s += $c;
}

print "Sum: $s\n";
