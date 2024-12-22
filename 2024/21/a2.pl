#!/usr/bin/perl
use strict;
use Math::Utils qw(sign);

my @c = map { chomp; $_ } <>;

my %k = (
    7 => [0, 0], 8 => [1, 0], 9 => [2, 0],
    4 => [0, 1], 5 => [1, 1], 6 => [2, 1],
    1 => [0, 2], 2 => [1, 2], 3 => [2, 2],
    E => [0, 3], 0 => [1, 3], A => [2, 3],
);

my %d = (
    'E' => [0, 0], '^' => [1, 0], 'A' => [2, 0],
    '<' => [0, 1], 'v' => [1, 1], '>' => [2, 1],
);

sub c {
    my $i = shift;
    my $p = shift;
    my $m = '';
    my $k = 'A';
    for my $c (split '', $i) {
        my ($x1, $y1) = @{$p->{$k}};
        my ($x2, $y2) = @{$p->{$c}};
        my ($ax, $ay) = @{$p->{E}};
        my $dx = $x2 - $x1;
        my $dy = $y2 - $y1;

        if ($ax == 0 && $ay == 0) {
            if ($x2 == 0) {
                $m .= '^' x -$dy . 'v' x  $dy . '<' x -$dx . '>' x  $dx . 'A';
            } else {
                $m .= '<' x -$dx . '>' x  $dx . '^' x -$dy . 'v' x  $dy . 'A';
            }
        } else {
            if ($y1 == 3 && $x2 == 0) {
                $m .= '^' x -$dy . 'v' x  $dy . '<' x -$dx . '>' x  $dx . 'A';
            } else {
                $m .= '<' x -$dx . '>' x  $dx . '^' x -$dy . 'v' x  $dy . 'A';
            }
        }

        $k = $c;
    }
    return $m;
}

my $s = 0;

for my $c (@c) {
    print "Moves: $c\n";

    my $m1 = c($c, \%k);
    print "Moves: $m1\n";

    my $m2 = c($m1, \%d);
    print "Moves: $m2\n";

    my $m3 = c($m2, \%d);
    print "Moves: $m3\n";

    my $l = length($m3);
    print "Complexity: $l * ", 0+$c, "\n";

    $s += $l * $c;
}

print "Sum: $s\n";
