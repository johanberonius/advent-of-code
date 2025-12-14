#!/usr/bin/perl
use strict;
use Time::HiRes qw(time);
my $t1 = time();


my $s = 0;
my $si = 0;
while (<>) {
    my @l = /(\.|#)/g;
    my @b = map [split ','], /\((.*?)\)/g;

    print;
    print "Lights: ", 0+@l, "\n";
    print "Buttons: ", 0+@b, "\n";

    my @q = ([0, ('.') x @l]);
    my %m;
    my $m;
    my $i;
    while (@q) {
        my $q = shift @q;
        my ($p, @s) = @$q;
        $i++;

        next if exists $m{"@s"} && $m{"@s"} <= $p;
        $m{"@s"} = $p;

        if ("@s" eq "@l") {
            $m = $p;
            print "Found solution in $m button presses.\n";
            last;
        }

        for my $b (@b) {
            my @ns = @s;
            $ns[$_] = $ns[$_] eq '#' ? '.' : '#' for @$b;
            push @q => [$p+1, @ns];
        }


    }
    print "Iterations: $i\n";
    print "Minimum button presses: $m\n";
    print "\n";
    $s += $m;
    $si += $i;
}

print "Total iterations: $si\n";
print "Sum of minimum button presses: $s\n";
print "Time: ", time() - $t1, "\n";
