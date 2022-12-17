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


my %r = (FUEL => 1);
my %i;

while (grep $_ ne 'ORE', keys %r) {


    for my $c (grep $_ ne 'ORE', keys %r) {

        use Data::Dumper;
        print Dumper(\%r);
        print Dumper(\%i);


        print "Produce $r{$c} $c, available in quantities of $m{$c}{q}.\n";

        if ($r{$c} > $i{$c}) {
            $r{$c} -= $i{$c};
            print "Got ", 0+$i{$c}, ", need $r{$c} more.\n";
            $i{$c} = 0;

            my $mult = ceil($r{$c} / $m{$c}{q});

            for my $i (keys %{$m{$c}{i}}) {
                my $q = $m{$c}{i}{$i} * $mult;
                print "Consume $q $i\n";
                $r{$i} += $q;
            }

            $i{$c} += ceil($r{$c} / $m{$c}{q}) * $m{$c}{q} - $r{$c};
        } else {
            print "Got ", 0+$i{$c}, ", ", $i{$c} - $r{$c}, " left.\n";
            $r{$c} = 0;
            $i{$c} -= $r{$c};
        }

        delete $r{$c};
        delete $i{$c} unless $i{$c};
    }

}

use Data::Dumper;
print Dumper(\%r);
print Dumper(\%i);
