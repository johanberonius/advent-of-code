#!/usr/bin/perl
use strict;
use List::Util qw(max min);

my %w;
while (<>) {
    if (/(\w+)\{(.*?)\}/) {
        $w{$1} = [map {
            my ($v, $o, $n, $d) = /(?:(\w)([<>])(\d+):)?(\w+)/;

            [$v, $o, $n, $d]
        } split ',', $2];
    }
}

my $sum = 0;
w('in', {
    x => [1, 4000],
    m => [1, 4000],
    a => [1, 4000],
    s => [1, 4000],
});

print "Sum: $sum\n";

sub w{
    my $w = shift;
    my $r = shift;

    return if $w eq 'R';

    if ($w eq 'A') {
        my ($x1, $x2) = @{$r->{x}};
        my ($m1, $m2) = @{$r->{m}};
        my ($a1, $a2) = @{$r->{a}};
        my ($s1, $s2) = @{$r->{s}};

        my $xr = $x2 - $x1 + 1;
        my $mr = $m2 - $m1 + 1;
        my $ar = $a2 - $a1 + 1;
        my $sr = $s2 - $s1 + 1;

        my $n = $xr * $mr * $ar * $sr;
        $sum += $n;

        print "{x=$x1-$x2,m=$m1-$m2,a=$a1-$a2,s=$s1-$s2}: $xr * $mr * $ar * $sr = $n\n";
        return;
    }

    for (@{$w{$w}}) {
        my ($v, $o, $n, $d) = @$_;

        my $s = {%$r};

        if ($v) {
            my $r1 = [max(1, $r->{$v}[0]), min($n-1, $r->{$v}[1])];
            my $r2 = [max($n+1, $r->{$v}[0]), min(4000, $r->{$v}[1])];

            my $r3 = [max(1, $r->{$v}[0]), min($n, $r->{$v}[1])];
            my $r4 = [max($n, $r->{$v}[0]), min(4000, $r->{$v}[1])];

            $s->{$v} = $o eq '<' ? $r1 : $r2;
            $r->{$v} = $o eq '<' ? $r4 : $r3;
        }

        w($d, $s);
    }
}

# test1
# 166847596592385 to low
# 167245503449662 to low
# 167409079868000 correct

# input
# 123033926652145 too low
# 123166077450919 too low
# 123923311689109 too low
# 124693661917133 correct