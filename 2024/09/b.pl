#!/usr/bin/perl
use strict;

my $s = <>;
chomp $s;
my @n = split '', $s;
my @m;
for my $i (0..$#n) {
    my $l = $n[$i];
    my $f = $i % 2 ? '.' : int $i / 2;
    push @m => [$f, $l];
}

draw();

for my $i (reverse 0..$#m) {
    my ($f, $l) = @{$m[$i]};
    next if $f eq '.';

    my ($j) = grep { $_ < $i && $m[$_][0] eq '.' && $m[$_][1] >= $l } 0..$#m;
    if ($j) {
        $m[$i][0] = '.';
        $m[$j][1] -= $l;
        splice @m, $j, 0 => [$f, $l];
        draw();
    }
}

my $i = 0;
my $s = 0;
for my $m (@m) {
    my ($f, $l) = @$m;
    $s += $i++ * $f for 1..$l;
}
print "Sum: $s\n";

sub draw {
    for my $m (@m) {
        my ($f, $l) = @$m;
        print $f x $l;
    }
    print "\n";
}
