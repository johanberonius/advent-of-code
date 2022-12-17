#!/usr/bin/perl
use strict;
use List::Util qw(all);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my ($w, $h) = (0, 0);
my %t;
my %a;
my %g;
while (<>) {
    chomp;
    next unless $_;
    $w = 0;
    for (split '') {
        if (/\w/) {
            $a{$_ . ++$t{$_}} = { x => $w, y => $h};
            $_ = '.';
        }
        $g{$w++ .','. $h} = $_;
    }
    $h++;
}

print "Grid width: $w, height: $h\n";

my %emove = (
    'A' => 1,
    'B' => 10,
    'C' => 100,
    'D' => 1000,
);

my %xhome = (
    'A' => 3,
    'B' => 5,
    'C' => 7,
    'D' => 9,
);

my %e;
my $emin;
my @q = ([0, \%a]);
my $final_state;

my $c = 0;
while (@q) {
    # @q = sort { our ($a, $b); $a->[0] <=> $b->[0] } @q;
    my $q = shift @q;
    my ($e, $a) = @$q;

    $c++;
    my $k = key(%$a);

    unless ($c % 10_000) {
        print "Iterations run: $c\n";
        print "Unique states visited: ", 0+values %e, "\n";
        print "Queue length: ", 0+@q, "  \n";
        print "Energy: $e  \n";
        print "State key: $k  \n";
        draw($a);
    }

    next if exists $e{$k} && $e{$k} <= $e;
    $e{$k} = $e;

    next if $emin && $e >= $emin;

    if ($k eq 'A:3,2;A:3,3;B:5,2;B:5,3;C:7,2;C:7,3;D:9,2;D:9,3') {
        print "Found new lowest energy solution: $e\n";
        $emin = $e if !$emin || $e < $emin;
        $final_state = $q;
        next;
    }

    my %o = (
        map {
            my ($t, $i) = split '';
            ("$a->{$_}{x},$a->{$_}{y}" => $t);
        } keys %$a
    );

    for my $k (keys %$a) {
        my ($t, $i) = split '', $k;
        my ($x, $y) = ($a->{$k}{x}, $a->{$k}{y});

        # Don't move from bottom if home
        next if $y == 3 && $x == $xhome{$t};

        # Don't move from top if home is full
        next if $y == 2 && $x == $xhome{$t} && $o{"$x,3"} eq $t;

        # Move up from bottom if not home
        if ($y == 3 && $x != $xhome{$t} && !$o{"$x,2"}) {
            push @q => [$e + $emove{$t}, { %$a, $k => { x => $x, y => 2 } }, $q];
            next;
        }

        # Move down to fill home
        if ($y == 2 && $x == $xhome{$t} && !$o{"$x,3"}) {
            push @q => [$e + $emove{$t}, { %$a, $k => { x => $x, y => 3 } }, $q];
            next;
        }

        # Move out of room
        if ($y == 2 && !$o{"$x,1"}) {
            for my $j (1..8) {
                my $x2 = $x - $j;
                last if $o{"$x2,1"} || $x2 < 1;
                push @q => [$e + ($j+1) * $emove{$t}, { %$a, $k => { x => $x2, y => 1 } }, $q];
            }

            for my $j (1..8) {
                my $x2 = $x + $j;
                last if $o{"$x2,1"} || $x2 > 11;
                push @q => [$e + ($j+1) * $emove{$t}, { %$a, $k => { x => $x2, y => 1 } }, $q];
            }
        }

        # Move into room
        if ($y == 1 && !$o{"$xhome{$t},2"} && (!$o{"$xhome{$t},3"} || $o{"$xhome{$t},3"} eq $t)) {
            if ($xhome{$t} >= $x && all { !$o{"$_,1"} } $x+1..$xhome{$t}) {
                my $j = $xhome{$t} - $x + 1;
                push @q => [$e + ($j+1) * $emove{$t}, { %$a, $k => { x => $xhome{$t}, y => 2 } }, $q];
            } elsif ($xhome{$t} <= $x && all { !$o{"$_,1"} } $xhome{$t}..$x-1) {
                my $j = $x - $xhome{$t} + 1;
                push @q => [$e + ($j+1) * $emove{$t}, { %$a, $k => { x => $xhome{$t}, y => 2 } }, $q];
            }
        }
    }
}


my $steps = 0;
my ($e, $a);
my $q = $final_state;
while (1) {
    ($e, $a, $q) = @$q;
    $steps++;
    my $k = key(%$a);
    print "$k\n";
    print "Energy: $e\n";
    draw($a, 1);
    last unless $q;
}

print "Steps: $steps\n";


sub key {
    my %a = @_;
    join ';',
    map {
        my $t = $_;
        map "$t:$_->{x},$_->{y}",
        sort {
            $a->{x} <=> $b->{x} ||
            $a->{y} <=> $b->{y}
        } $a{$t.'1'}, $a{$t.'2'}
    } 'A'..'D';
}


sub draw {
    my $a = shift;
    my $skip_linefeed = shift;

    my %o = (
        map {
            my ($t, $i) = split '';
            ("$a->{$_}{x},$a->{$_}{y}" => $t);
        } keys %$a
    );

    my $lines = 5;

    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            my $p = $o{"$x,$y"} || $g{"$x,$y"};
            if ($p eq 'A') {
                print color('grey16', 'on_red'), " $p ", color('reset');
            } elsif ($p eq 'B') {
                print color('grey16', 'on_green'), " $p ", color('reset');
            } elsif ($p eq 'C') {
                print color('grey16', 'on_blue'), " $p ", color('reset');
            } elsif ($p eq 'D') {
                print color('grey16', 'on_yellow'), " $p ", color('reset');
            } elsif ($p eq '#') {
                print color('grey8', 'on_grey4'), " $p ", color('reset');
            } elsif ($p eq '.') {
                print " • ";
            } else {
                print " $p ";
            }
        }
        print "\n";
        $lines++;
    }

    print "\x1B[", $lines, "A" unless $skip_linefeed;
    # sleep 0.1;
}
