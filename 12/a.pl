#!/usr/bin/perl
use strict;

my @q;
push @q => [$1, 0+$2] while <> =~ /([a-z]+)(\d+)/i;

print "Number of instructions: ", 0+@q, "\n";

my ($x, $y) = (0, 0);
my ($dx, $dy) = (1, 0);

for my $q (@q) {
    my ($a, $v) = @$q;

    print "Position of ferry: $x, $y, heading: $dx, $dy, going $a by $v\n";

    if ($a eq 'N') {
        $y -= $v;
    } elsif ($a eq 'S') {
        $y += $v;
    } elsif ($a eq 'W') {
        $x -= $v;
    } elsif ($a eq 'E') {
        $x += $v;
    } elsif ($a eq 'F') {
        $x += $dx * $v;
        $y += $dy * $v;
    } elsif ($a eq 'R') {
        if ($v == 90) {
            ($dx, $dy) = (-$dy, $dx);
        } elsif ($v == 180) {
            ($dx, $dy) = (-$dx, -$dy);
        } elsif ($v == 270) {
            ($dx, $dy) = ($dy, -$dx);
        } else {
            die "Unrecognized turn: $a$v\n";
        }
    } elsif ($a eq 'L') {
        if ($v == 90) {
            ($dx, $dy) = ($dy, -$dx);
        } elsif ($v == 180) {
            ($dx, $dy) = (-$dx, -$dy);
        } elsif ($v == 270) {
            ($dx, $dy) = (-$dy, $dx);
        } else {
            die "Unrecognized turn: $a$v\n";
        }
    }
}

print "Position of ferry: $x, $y. Distance: ", abs($x) + abs($y), "\n";
