#!/usr/bin/perl
use strict;
use List::Util qw(pairmap all sum);

my %f = (E => 0);
while (<>) {
    /The (first|second|third|fourth) floor/ or die $_;
    my $f = {first => 0, second => 1, third => 2, fourth => 3}->{$1};

    my @m = grep $_, /(\w+)-compatible (microchip)|(\w+) (generator)/g;
    pairmap {
        $a = uc substr $a, 0, 1;
        $b = uc substr $b, 0, 1;
        $f{$a.$b} = $f;
    } @m;
}

my $r = sum map 3 - $_, values %f;
print "Minimum steps remaining: $r\n";
my @q = ([0, $r, \%f]);
my %s;
my $i = 0;
i: while (@q) {
    my $q = shift @q;
    my ($s, $r, $f) = @$q;
    $i++;


    unless ($i % 1_000) {
        print "i: $i, q: ", 0+@q, ", s: ", 0+keys %s, ", step: $s, r: $r\n";
    }


    next if $s{join ',', map "$_:$f->{$_}", sort keys %$f}++;

    my %fg;
    for my $g (grep /G$/, keys %$f) {
        $fg{$f->{$g}}++;
    }
    for my $t1 (keys %$f) {
        my $t2 = $t1 =~ tr/M/G/r;
        if ($t1 ne $t2 && $fg{$f->{$t1}} && $f->{$t1} != $f->{$t2}) {
            # print "$t1 $f->{$t1} and $t2 $f->{$t2} not on the same floor.\n";
            next i;
        }
    }

    if (all { $_ == 3} values %$f) {
        print "All objects on fourth floor after $s steps.\n";
        last;
    }

    my $fe = $f->{E};
    my @o = sort grep { $_ ne 'E' && $f->{$_} == $fe } keys %$f;
    # print "Object on same floor as elevator: @o\n";

    my %oc;
    for my $o1 (@o) {
        # up down with 1 object
        unshift @q => [$s+1, $r+1-2, {%$f, $o1 => $fe+1, E => $fe+1}] if $fe < 3;
        push @q => [$s+1, $r+1+2, {%$f, $o1 => $fe-1, E => $fe-1}] if $fe > 0;

        for my $o2 (@o) {
            next if $o1 eq $o2;
            next if $oc{"$o1,$o2"}++;
            next if $oc{"$o2,$o1"}++;
            # up down with 2 objects
            unshift @q => [$s+1, $r+1-3, {%$f, $o1 => $fe+1, $o2 => $fe+1, E => $fe+1}] if $fe < 3;
            push @q => [$s+1, $r+1+3, {%$f, $o1 => $fe-1, $o2 => $fe-1, E => $fe-1}] if $fe > 0;
        }
    }

    # @q = sort {
    #     $a->[1] <=> $b->[1]
    # } @q;
}

print "Iterations: $i\n";
