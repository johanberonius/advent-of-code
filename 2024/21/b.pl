#!/usr/bin/perl
use strict;
use List::Util qw(min);

my $l = 26;
my @f = ('A') x $l;
my %m;


my $s = 0;

my $c = '869A';
my $m = 0;
# A - 8
$m += min(
    d('<', $l) + d('^', $l) + d('^', $l) + d('^', $l) + d('A', $l),
    d('^', $l) + d('^', $l) + d('^', $l) + d('<', $l) + d('A', $l)
);
# 8 - 6
$m += min(
    d('v', $l) + d('>', $l) + d('A', $l),
    d('>', $l) + d('v', $l) + d('A', $l)
);
# 6 - 9
$m += d('^', $l) + d('A', $l);
# 9 - A
$m += d('v', $l) + d('v', $l) + d('v', $l) + d('A', $l);
print "Code: $c, moves: $m, complexity: $m * ", 0+$c, "\n";
$s += $m * $c;

my $c = '170A';
my $m = 0;
# A - 1
$m += min(
    d('^', $l) + d('<', $l) + d('<', $l) + d('A', $l),
    d('<', $l) + d('^', $l) + d('<', $l) + d('A', $l),
);
# 1 - 7
$m += d('^', $l) + d('^', $l) + d('A', $l);
# 7 - 0
$m += min(
    d('>', $l) + d('v', $l) + d('v', $l) + d('v', $l) + d('A', $l),
    d('v', $l) + d('>', $l) + d('v', $l) + d('v', $l) + d('A', $l),
    d('v', $l) + d('v', $l) + d('>', $l) + d('v', $l) + d('A', $l)
);
# 0 - A
$m += d('>', $l) + d('A', $l);
print "Code: $c, moves: $m, complexity: $m * ", 0+$c, "\n";
$s += $m * $c;

my $c = '319A';
my $m = 0;
# A - 3
$m += d('^', $l) + d('A', $l);
# 3 - 1
$m += d('<', $l) + d('<', $l) + d('A', $l);
# 1 - 9
$m += min(
    d('>', $l) + d('>', $l) + d('^', $l) + d('^', $l) + d('A', $l),
    d('^', $l) + d('^', $l) + d('>', $l) + d('>', $l) + d('A', $l)
);
# 9 - A
$m += d('v', $l) + d('v', $l) + d('v', $l) + d('A', $l);
print "Code: $c, moves: $m, complexity: $m * ", 0+$c, "\n";
$s += $m * $c;

my $c = '349A';
my $m = 0;
# A - 3
$m += d('^', $l) + d('A', $l);
# 3 - 4
$m += min(
    d('<', $l) + d('<', $l) + d('^', $l) + d('A', $l),
    d('^', $l) + d('<', $l) + d('<', $l) + d('A', $l)
);
# 4 - 9
$m += min(
    d('^', $l) + d('>', $l) + d('>', $l) + d('A', $l),
    d('>', $l) + d('>', $l) + d('^', $l) + d('A', $l),
);
# 9 - A
$m += d('v', $l) + d('v', $l) + d('v', $l) + d('A', $l);
print "Code: $c, moves: $m, complexity: $m * ", 0+$c, "\n";
$s += $m * $c;

my $c = '489A';
my $m = 0;
# A - 4
$m += min(
    d('^', $l) + d('^', $l) + d('<', $l) + d('<', $l) + d('A', $l),
    d('<', $l) + d('^', $l) + d('<', $l) + d('^', $l) + d('A', $l),
    d('<', $l) + d('^', $l) + d('^', $l) + d('<', $l) + d('A', $l)
);
# 4 - 8
$m += min(
    d('^', $l) + d('>', $l) + d('A', $l),
    d('>', $l) + d('^', $l) + d('A', $l)
);
# 8 - 9
$m += d('>', $l) + d('A', $l);
# 9 - A
$m += d('v', $l) + d('v', $l) + d('v', $l) + d('A', $l);
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
    return $m if $m;

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
        } else {
            die;
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
        } else {
            die;
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
        } else {
            die;
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
        } else {
            die;
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
        } else {
            die;
        }
    } else {
        die;
    }

    return $m{"$f,$t,$l"} = $m;
}
