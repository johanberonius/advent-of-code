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



my $f = 1;
my $s = 0;

while (1) {
    my %r = (FUEL => $f);
    my %i;

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

    print "$f FUEL requires $r{ORE} ORE, step size: $s.\n";

    if ($s == 1) {
        last;
    } elsif ($r{ORE} > 1_000_000_000_000) {
        $s = $s ? $s / 2 : $f / 4;
        $f -= $s;
    } elsif ($s) {
        $s /= 2;
        $f += $s;
    } else {
        $f *= 2;
    }
}


# use Data::Dumper;
# print Dumper(\%r);
# print Dumper(\%i);


# 2690803 too high