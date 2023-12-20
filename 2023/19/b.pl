#!/usr/bin/perl
use strict;

my %w;
while (<>) {
    if (/(\w+)\{(.*?)\}/) {
        $w{$1} = [map {
            my ($v, $o, $n, $d) = /(?:(\w)([<>])(\d+):)?(\w+)/;
            [$v ? "\$$v$o$n" : 1, $v, $o, $n, $d]
        } split ',', $2];
    }
}

my @p;
my $c;
my $i;
my $x = 1;
while ($x <= 4000) {
    my $m = 1;
    while ($m <= 4000) {
        my $a = 1;
        while ($a <= 4000) {
            my $s = 1;
            while ($s <= 4000) {

                print "{x=$x,m=$m,a=$a,s=$s}: ";
                my $w = 'in';
                w: while ($w{$w}) {
                    print "$w ";
                    for my $r (@{$w{$w}}) {
                        my ($c, $v, $o, $n, $d) = @$r;

                        if (eval($c)) {
                            $w = $d;
                            print "-> ";
                            next w;
                        }
                    }
                }

                my $ms = 4000;
                for my $r (['', 's', '', 4001], map @$_, values %w) {
                    my ($c, $v, $o, $n, $d) = @$r;
                    $ms = $n-$s if $v eq 's' && $n > $s && $ms > $n-$s;
                }
                $s += $ms;

                print "$w, inc $ms count $c\n";
                $c += $ms if $w eq 'A';
                $i++;
            }

            my $ma = 4000;
            for my $r (['', 'a', '', 4001], map @$_, values %w) {
                my ($c, $v, $o, $n, $d) = @$r;
                $ma = $n-$a if $v eq 'a' && $n > $a && $ma > $n-$a;
            }
            $a += $ma;
        }

        my $mm = 4000;
        for my $r (['', 'm', '', 4001], map @$_, values %w) {
            my ($c, $v, $o, $n, $d) = @$r;
            $mm = $n-$m if $v eq 'm' && $n > $m && $mm > $n-$m;
        }
        $m += $mm;
    }

    my $mx = 4000;
    for my $r (['', 'x', '', 4001], map @$_, values %w) {
        my ($c, $v, $o, $n, $d) = @$r;
        $mx = $n-$x if $v eq 'x' && $n > $x && $mx > $n-$x;
    }
    $x += $mx;
}

print "Iterations: $i\n";
print "Sum: $c\n";
