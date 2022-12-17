#!/usr/bin/perl
use strict;

my %r;
my $c = 0;
while (<>) {
    chomp;
    my ($s, $d) = split /\s*=>\s*/;
    my $a = g2a($s);
    for my $i (0..7) {
        my $k = a2g(rot($a, $i));
        warn "Duplicate rule: $k\n" if $r{$k} && $r{$k} ne $d;
        $r{$k} = $d;
    }
    $c++;
}

print "$c replacement rules read.\n";
print scalar keys %r, " replacement rules generated.\n\n";

my $a = g2a('.#./..#/###');
for (1..18) {
    print "Iteration: $_\n";
    $a = div($a);
    $a = [map g2a($r{a2g($_)}), @$a];
    $a = merge($a);
    my @c = a2g($a) =~ /(#)/g;
    print "Pixels set: ", scalar @c, "\n\n";
}

sub div {
    my $a = shift;
    my $s = 0+@$a;
    my $b = [];
    my $ss = $s % 2 == 0 ? 2 : 3;
    my $sw = $s / $ss;

    for my $y (0..$s-1) {
        for my $x (0..$s-1) {
            $b->[int($y / $ss) * $sw + int($x / $ss)][$y % $ss][$x % $ss] = $a->[$y][$x];
        }
    }

    print "Dividing $s x $s grid into ", scalar @$b, " ($sw x $sw) no. $ss x $ss grids.\n";
    return $b;
}

sub merge {
    my $a = shift;
    my $sw = sqrt(0+@$a);
    my $ss = 0+@{$a->[0]};
    my $s = $sw*$ss;
    my $b = [];

    for my $y (0..$s-1) {
        for my $x (0..$s-1) {
            $b->[$y][$x] = $a->[int($y / $ss) * $sw + int($x / $ss)][$y % $ss][$x % $ss];
        }
    }

    print "Joining ", scalar @$a, " ($sw x $sw) no. $ss x $ss grids into one $s x $s grid.\n";
    return $b;
}


sub g2a {
    my $s = shift;
    my %m = ('#' => 1, '.' => 0);
    return [map [map $m{$_}, split ''], split '/', $s];
}

sub a2g {
    my $a = shift;
    my %m = (1 => '#', 0 => '.');
    return join '/', map join('', map $m{$_}, @$_), @$a;
}

sub rot {
    my ($a, $o) = @_;
    my $h = $#$a;
    my $w = $#{$a->[0]};
    my $b = [];

    for my $y (0..$h) {
        for my $x (0..$w) {
            my $bx = $o & 1 ? $x : $w-$x;
            my $by = $o & 2 ? $y : $h-$y;
            ($bx, $by) = ($by, $bx) if $o & 4;
            $b->[$by][$bx] = $a->[$y][$x];
        }
    }
    return $b;
}
