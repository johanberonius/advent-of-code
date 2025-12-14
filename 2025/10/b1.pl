#!/usr/bin/perl
use strict;
use List::Util qw(sum);
use Time::HiRes qw(time);
my $t1 = time();


my $r = 0;
my $s = 0;
my $si = 0;
while (<>) {
    my @c = map { split ',' } /{(.*?)}/;
    my @b = map [split ','], /\((.*?)\)/g;

    $r++;
    print;
    print "Row: $r\n";
    print "Counters: ", 0+@c, "\n";
    print "Buttons: ", 0+@b, "\n";
    print "Distance: ", sum(@c), "\n";

    my @q = ([0, sum(@c), (0) x @c]);
    my %m;
    my $m;
    my $i;
    l: while (@q) {
        my $q = shift @q;
        my ($p, $d, @s) = @$q;
        $i++;

# print "p: $p, $d, {@s}\n";
# last if $i > 150;
unless ($i % 1_000_000) {
    print "$i: q: ", 0+@q, ", p: $p, d: $d, w: ", $p+$d, " {@s}\n";
}


        next if exists $m{"@s"} && $m{"@s"} <= $p;
        $m{"@s"} = $p;

        if ("@s" eq "@c") {
            $m = $p;
            print "Found solution in $m button presses.\n";
print "$i: q: ", 0+@q, ", p: $p, d: $d {@s}\n";

            last;
        }

        b: for my $b (@b) {
            my @ns = @s;
            for (@$b) {
                $ns[$_]++;
                next b if $ns[$_] > $c[$_];
            }
            push @q => [$p+1, $d-@$b, @ns];
        }

        @q = sort {
            my ($ap, $ad) = @$a;
            my ($bp, $bd) = @$b;
            $ap + $ad <=> $bp + $bd;
        } @q;

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
