#!/usr/bin/perl
use strict;
use List::Util qw(min);

my $l = 3;
my @f = ('A') x $l;
my %m;


my $s = 0;

my $c = '029A';
my $m = 0;
$m += d('<', $l);
$m += d('A', $l);
$m += d('^', $l);
$m += d('A', $l);
$m += d('>', $l);
$m += d('^', $l);
$m += d('^', $l);
$m += d('A', $l);
$m += d('v', $l);
$m += d('v', $l);
$m += d('v', $l);
$m += d('A', $l);
print "Code: $c, moves: $m, complexity: $m * ", 0+$c, "\n";
$s += $m * $c;

my $c = '980A';
my $m = 0;
$m += d('^', $l);
$m += d('^', $l);
$m += d('^', $l);
$m += d('A', $l);
$m += d('<', $l);
$m += d('A', $l);
$m += d('v', $l);
$m += d('v', $l);
$m += d('v', $l);
$m += d('A', $l);
$m += d('>', $l);
$m += d('A', $l);
print "Code: $c, moves: $m, complexity: $m * ", 0+$c, "\n";
$s += $m * $c;

my $c = '179A';
my $m = 0;
$m += d('^', $l);
$m += d('<', $l);
$m += d('<', $l);
$m += d('A', $l);
$m += d('^', $l);
$m += d('^', $l);
$m += d('A', $l);
$m += d('>', $l);
$m += d('>', $l);
$m += d('A', $l);
$m += d('v', $l);
$m += d('v', $l);
$m += d('v', $l);
$m += d('A', $l);
print "Code: $c, moves: $m, complexity: $m * ", 0+$c, "\n";
$s += $m * $c;

my $c = '456A';
my $m = 0;
$m += d('^', $l);
$m += d('^', $l);
$m += d('<', $l);
$m += d('<', $l);
$m += d('A', $l);
$m += d('>', $l);
$m += d('A', $l);
$m += d('>', $l);
$m += d('A', $l);
$m += d('v', $l);
$m += d('v', $l);
$m += d('A', $l);
print "Code: $c, moves: $m, complexity: $m * ", 0+$c, "\n";
$s += $m * $c;

my $c = '379A';
my $m = 0;
$m += d('^', $l);
$m += d('A', $l);
$m += d('<', $l);
$m += d('<', $l);
$m += d('^', $l);
$m += d('^', $l);
$m += d('A', $l);
$m += d('>', $l);
$m += d('>', $l);
$m += d('A', $l);
$m += d('v', $l);
$m += d('v', $l);
$m += d('v', $l);
$m += d('A', $l);
print "Code: $c, moves: $m, complexity: $m * ", 0+$c, "\n";
$s += $m * $c;

print "Sum: $s\n";


sub d {
    my $t = shift;
    my $l = shift;
    my $n = $l - 1;
    my $f = $f[$l-1];
    $f[$l-1] = $t;
    my $m = $m{"$f,$t,$l"};
    # return $m if $m;

    if ($l == 1) {
        $m = 1;
    } elsif ($t eq 'A') {
        if ($f eq 'A') {
            $m = d('A', $n);
        } elsif ($f eq '^') {
            $m = d('>', $n) + d('A', $n);
        } elsif ($f eq '>') {
            $m = d('^', $n) + d('A', $n);
        } elsif ($f eq 'v') {
            $m = min(
                d('^', $n) + d('>', $n) + d('A', $n),
                d('>', $n) + d('^', $n) + d('A', $n)
            );
        } elsif ($f eq '<') {
            $m = min(
                d('>', $n) + d('^', $n) + d('>', $n) + d('A', $n),
                d('>', $n) + d('>', $n) + d('^', $n) + d('A', $n)
            );
        }
    } elsif ($t eq '^') {
        if ($f eq 'A') {
            $m = d('<', $n) + d('A', $n);
        } elsif ($f eq '^') {
            $m = d('A', $n);
        } elsif ($f eq '>') {
            $m = min(
                d('^', $n) + d('<', $n) + d('A', $n),
                d('<', $n) + d('^', $n) + d('A', $n)
            );
        } elsif ($f eq 'v') {
            $m = d('^', $n) + d('A', $n);
        } elsif ($f eq '<') {
            $m = d('>', $n) + d('^', $n) + d('A', $n);
        }
    } elsif ($t eq '>') {
        if ($f eq 'A') {
            $m = d('v', $n) + d('A', $n);
        } elsif ($f eq '^') {
            $m = min(
                d('v', $n) + d('>', $n) + d('A', $n),
                d('>', $n) + d('v', $n) + d('A', $n)
            );
        } elsif ($f eq '>') {
            $m = d('A', $n);
        } elsif ($f eq 'v') {
            $m = d('>', $n) + d('A', $n);
        } elsif ($f eq '<') {
            $m = d('>', $n) + d('>', $n) + d('A', $n);
        }
    } elsif ($t eq 'v') {
        if ($f eq 'A') {
            $m = min(
                d('v', $n) + d('<', $n) + d('A', $n),
                d('<', $n) + d('v', $n) + d('A', $n)
            );
        } elsif ($f eq '^') {
            $m = d('v', $n) + d('A', $n);
        } elsif ($f eq '>') {
            $m = d('<', $n) + d('A', $n);
        } elsif ($f eq 'v') {
            $m = d('A', $n);
        } elsif ($f eq '<') {
            $m = d('>', $n) + d('A', $n);
        }
    } elsif ($t eq '<') {
        if ($f eq 'A') {
            $m = min(
                d('v', $n) + d('<', $n) + d('<', $n) + d('A', $n),
                d('<', $n) + d('v', $n) + d('<', $n) + d('A', $n)
            );
        } elsif ($f eq '^') {
            $m = d('v', $n) + d('<', $n) + d('A', $n);
        } elsif ($f eq '>') {
            $m = d('<', $n) + d('<', $n) + d('A', $n);
        } elsif ($f eq 'v') {
            $m = d('<', $n) + d('A', $n);
        } elsif ($f eq '<') {
            $m = d('A', $n);
        }
    }

    return $m{"$f,$t,$l"} = $m;
}
