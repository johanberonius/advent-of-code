#!/usr/bin/perl
use strict;
use List::Util qw(max);

my ($bih) = <> =~ /(\d+)/;
my ($bd) = <> =~ /(\d+)/;

print "Boss: $bih, $bd\n";

my $mih = 50;
my $mim = 500;

# mana cost, damage, healing, armor, mana recharge, duration
my @s = (
    [ 53, 4, 0, 0,   0, 1],
    [ 73, 2, 2, 0,   0, 1],
    [113, 0, 0, 7,   0, 6],
    [173, 3, 0, 0,   0, 6],
    [229, 0, 0, 0, 101, 5]
);


my $i = 0;
my %min;

# turn, mana cost, my health, my mana, boss health, effects {spell# => turns remaining}
my @q = ([0, 0, $mih, $mim, $bih, {}]);
while (@q) {
    my $q = shift @q;
    my ($t, $c, $mh, $mm, $bh, $e) = @$q;
    $i++;

    my $k = "$mh,$mm,$bh," . join(',', map "$_=>$e->{$_}", sort keys %$e);
    next if $min{$k}++;


    unless ($i % 1_000) {
        print "$i: Turn: $t, cost: $c, health: $mh, mana: $mm, boss health: $bh, effects: {@{[%$e]}}\n";
    }

    # My turn
    unless ($t % 2) {
        # Dead
        next if --$mh <= 0;
    }

    # Armor is set by effects
    my $ma = 0;

    # Apply effects
    for my $si (keys %$e) {
        # Duration
        $e->{$si}--;
        delete $e->{$si} unless $e->{$si};

        # Damage
        my $md = $s[$si][1];
        $bh -= $md;

        # Healing
        $mh += $s[$si][2];

        # Armor
        $ma += $s[$si][3];

        # Mana recharge
        $mm += $s[$si][4];
    }


    # Win
    if ($bh <= 0) {
        print "Win! Mana cost: $c\n";
        last;
    }

    # print "Turn: $t, cost: $c, health: $mh, mana: $mm, boss health: $bh, effects: {@{[%$e]}}\n\n";

# last if $i >= 10_000;


    # My turn
    unless ($t % 2) {
        # Choose all possible spells and push on q
        for my $si (0..$#s) {
            next if $e->{$si};
            my $sm = $s[$si][0];
            my $sd = $s[$si][5];
            push @q => [$t+1, $c+$sm, $mh, $mm-$sm, $bh, { %$e, $si => $sd }] if $mm >= $sm;
        }
        # If no spell afforded, thread dies

    # Boss turn
    } else {
        # Update health
        $mh -= max $bd - $ma, 1;

        # Dead
        next if $mh <= 0;

        # Push next turn on q
        push @q => [$t+1, $c, $mh, $mm, $bh, $e];
    }


    # Sort q by least mana cost + distance left (boss health / 7)
    @q = sort { $a->[1] + $a->[4]/7 <=> $b->[1] + $b->[4]/7 } @q;

}

print "Iterations: $i\n";
