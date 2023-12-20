#!/usr/bin/perl
use strict;

my %w;
my @p;
while (<>) {
    if (/(\w+)\{(.*?)\}/) {
        $w{$1} = [map {
            my ($c, $d) = /(?:(.+?):)?(\w+)/;
            [$c ? "\$$c" : 1, $d]
        } split ',', $2];
    } elsif (/\{x=(\d+),m=(\d+),a=(\d+),s=(\d+)\}/) {
        push @p => [$1, $2, $3, $4];
    }

}

my $c;
for my $p (@p) {
    my ($x, $m, $a, $s) = @$p;
    my $w = 'in';

    print "{x=$x,m=$m,a=$a,s=$s}: ";

    w: while ($w{$w}) {
        print "$w ";
        for my $r (@{$w{$w}}) {
            my ($c, $d) = @$r;

            if (eval($c)) {
                $w = $d;
                print "-> ";
                next w;
            }
        }
    }
    print "$w\n";
    $c += $x + $m + $a + $s if $w eq 'A';
}

print "Sum: $c\n";
