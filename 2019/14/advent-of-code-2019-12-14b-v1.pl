#!/usr/bin/perl
use strict;
use Math::Utils qw(ceil);

my %m;
while (<>) {
    chomp;
    my ($i, $o) = split /\s*=>\s*/;

    my ($oq, $oc) = split /\s+/, $o;
    die "Found duplicate formulas to synthesize: $oc" if $m{$oc};
    $m{$oc} = { q => 0+$oq };

    my @i = split /\s*,\s*/, $i;
    for my $i (@i) {
        my ($iq, $ic) = split /\s+/, $i;
        $m{$oc}{i}{$ic} = 0+$iq;
    }
}


my $t = time;
my %r;
my %i;
my $f = 0;
while (1) {
    my $inc = 10_000;
    # $inc = 1_000 if $r{ORE} > 900_000_000_000;
    # $inc = 10 if $r{ORE} > 990_000_000_000;
    # $inc = 10 if $r{ORE} > 999_000_000_000;
    $inc = 1 if $r{ORE} > 999_000_000_000;
    $r{FUEL} = $inc;

    while (grep $_ ne 'ORE', keys %r) {
        for my $c (grep $_ ne 'ORE', keys %r) {

            if ($r{$c} > $i{$c}) {
                $r{$c} -= $i{$c};
                $i{$c} = 0;

                my $mult = ceil($r{$c} / $m{$c}{q});
                for my $i (keys %{$m{$c}{i}}) {
                    my $q = $m{$c}{i}{$i} * $mult;
                    $r{$i} += $q;
                }

                $i{$c} += ceil($r{$c} / $m{$c}{q}) * $m{$c}{q} - $r{$c};
            } else {
                $r{$c} = 0;
                $i{$c} -= $r{$c};
            }

            delete $r{$c};
            delete $i{$c} unless $i{$c};
        }
    }


    last if $r{ORE} > 1_000_000_000_000;
    $f += $inc;

    unless ($f % 10_000) {
        my $p = $r{ORE} / 1_000_000_000_000;
        my $t2 = time - $t;
        my $eta = time + $t2 / $p;
        printf "$f FUEL for $r{ORE} ORE, %.2f%%, time %d s. eta %s\n", 100 * $p, $t2, scalar localtime($eta);

    }
}

use Data::Dumper;
print Dumper(\%r);
print Dumper(\%i);

print "$f FUEL\n";

# 2690803 too high