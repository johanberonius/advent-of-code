#!/usr/bin/perl
use strict;

my $c = 0;
my $n = 50;

while(<>) {
    chomp;
    tr/LR/-+/;
    print "$n$_";
    my $h = int abs $_ / 100;
    my $b = $n;
    $n = eval("$n$_") % 100;    
    print " = $n ";
    $c += $h;
    print " \t $h hundreds ";

    if ($n == 0) {
        $c++;
        print " \t stopped at zero";
    }
    elsif ($_ > 0 && $n < $b) {
        $c++;
        print " passed zero going up";
    }
    elsif ($_ < 0 && $b != 0 && $n > $b) {
        $c++;
        print " passed zero going down";
    }
    
    print " \t at zero $c times\n";
}

print "Points at zero $c times.\n";
