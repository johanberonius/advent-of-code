#!/usr/bin/perl
use strict;

my @o = split '', <>;
my ($c, %l);

print "Original length: ", 0+@o, "\n";

for my $L ('A'..'Z') {
    my $l = lc $L;
    my @a = grep $_ ne $L && $_ ne $l, @o;
    print "Removing $L$l, starting length: ", 0+@a, "\n";

    for (my $i; $i < $#a; $i++) {
        if ($a[$i] ne $a[$i+1] and lc $a[$i] eq lc $a[$i+1]) {
            # print "Removing $a[$i]$a[$i+1] at $i\n";
            splice @a, $i, 2;
            $i-- if $i;
            redo;
        }
    }

    print "Remaining length: ", 0+@a, "\n";
    $l{"$L$l"} = 0+@a;
}

my ($k) = sort { $l{$a} <=> $l{$b} } keys %l;
my ($s) = sort { $a <=> $b } values %l;
print "Shortest remaining length after removing $k: $s\n";
