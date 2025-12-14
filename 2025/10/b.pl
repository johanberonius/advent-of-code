#!/usr/bin/perl
use strict;
use List::Util qw(sum any max min product);
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


    my %r;
    for my $ci (0..$#c) {
        my @bi = grep { any {$_ == $ci} @{$b[$_]} } 0..$#b;
        $r{$ci} = \@bi;
        print "Counter: $ci, value: $c[$ci] incremented by buttons @bi\n";
    }

    my @bm;
    for my $bi (0..$#b) {
        my $bm = min map $c[$_], @{$b[$bi]};
        push @bm => $bm;
        print "Button: $bi, max value: $bm\n";
    }

    print "Product button max values: ", product(@bm), "\n";


    my @q = ([0, sum(@c), [(0) x @c], [(0) x @b]]);
    my %m;
    my $m;
    my $i;
    l: while (@q) {
        my $q = shift @q;
        my ($p, $d, $sr, $pr) = @$q;
        my @s = @$sr;
        my @p = @$pr;

        $i++;

# print "p: $p, $d, {@s}\n";
# last if $i > 150;
unless ($i % 1_00_000) {
    print "$i: q: ", 0+@q, ", p: $p, d: $d, w: ", $p+$d, " (@p) {@s}\n";
}


        next if exists $m{"@s"} && $m{"@s"} <= $p;
        $m{"@s"} = $p;

        if ("@s" eq "@c") {
            $m = $p;
            print "Found solution in $m button presses.\n";
print "$i: q: ", 0+@q, ", p: $p, d: $d (@p) {@s}\n";

            last;
        }

        b: for my $bi (0..$#b) {
            my $b = $b[$bi];
            my @ns = @s;
            for (@$b) {
                $ns[$_]++;
                next b if $ns[$_] > $c[$_];
            }

            my @np = @p;
            $np[$bi]++;

            for my $ci (0..$#c) {
                my @bi = @{$r{$ci}};
                my $bs = sum map $np[$_], @bi;
# print "Checking counter $ci buttons @bi, sum: $bs over $c[$ci] (@np) {@ns} {@c}\n";
                if ($bs > $c[$ci]) {
                    print "Sum of buttons @bi over $c[$ci] (@np)\n";
                    next b;
                }
            }

            push @q => [$p+1, $d-@$b, \@ns, \@np];
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



# docs
# https://www.reddit.com/r/adventofcode/comments/1pity70/2025_day_10_solutions/
# https://github.com/gabrielmougard/AoC-2025/blob/main/10-factory/main.zig
# https://en.wikipedia.org/wiki/Gaussian_elimination
