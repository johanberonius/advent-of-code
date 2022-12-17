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

    if ($k eq 'A:3,2;A:3,3;A:3,4;A:3,5;B:5,2;B:5,3;B:5,4;B:5,5;C:7,2;C:7,3;C:7,4;C:7,5;D:9,2;D:9,3;D:9,4;D:9,5') {
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

        # Don't move from home
        next if $y == 5 && $x == $xhome{$t};
        next if $y == 4 && $x == $xhome{$t} && $o{"$x,5"} eq $t;
        next if $y == 3 && $x == $xhome{$t} && $o{"$x,4"} eq $t && $o{"$x,5"} eq $t;
        next if $y == 2 && $x == $xhome{$t} && $o{"$x,3"} eq $t && $o{"$x,4"} eq $t && $o{"$x,5"} eq $t;

        # Move up from bottom if not home
        if ($y == 3 && ($x != $xhome{$t} || $o{"$x,4"} ne $t || $o{"$x,5"} ne $t) && !$o{"$x,2"}) {
            push @q => [$e + $emove{$t}, { %$a, $k => { x => $x, y => 2 } }, $q];
            next;
        }
        if ($y == 4 && ($x != $xhome{$t} || $o{"$x,5"} ne $t) && !$o{"$x,3"}) {
            push @q => [$e + $emove{$t}, { %$a, $k => { x => $x, y => 3 } }, $q];
            next;
        }
        if ($y == 5 && $x != $xhome{$t} && !$o{"$x,4"}) {
            push @q => [$e + $emove{$t}, { %$a, $k => { x => $x, y => 4 } }, $q];
            next;
        }

        # Move down to fill home
        if ($y == 2 && $x == $xhome{$t} && !$o{"$x,3"} && !$o{"$x,4"} && !$o{"$x,5"}) {
            push @q => [$e + 3 * $emove{$t}, { %$a, $k => { x => $x, y => 5 } }, $q];
            next;
        }
        if ($y == 2 && $x == $xhome{$t} && !$o{"$x,3"} && !$o{"$x,4"} && $o{"$x,5"} eq $t) {
            push @q => [$e + 2 * $emove{$t}, { %$a, $k => { x => $x, y => 4 } }, $q];
            next;
        }
        if ($y == 2 && $x == $xhome{$t} && !$o{"$x,3"} && $o{"$x,4"} eq $t && $o{"$x,5"} eq $t) {
            push @q => [$e + $emove{$t}, { %$a, $k => { x => $x, y => 3 } }, $q];
            next;
        }

        if ($y == 3 && $x == $xhome{$t} && !$o{"$x,4"} && !$o{"$x,5"}) {
            push @q => [$e + 2 * $emove{$t}, { %$a, $k => { x => $x, y => 5 } }, $q];
            next;
        }
        if ($y == 3 && $x == $xhome{$t} && !$o{"$x,4"} && $o{"$x,5"} eq $t) {
            push @q => [$e + $emove{$t}, { %$a, $k => { x => $x, y => 4 } }, $q];
            next;
        }

        if ($y == 4 && $x == $xhome{$t} && !$o{"$x,5"}) {
            push @q => [$e + $emove{$t}, { %$a, $k => { x => $x, y => 5 } }, $q];
            next;
        }

        # Move out of room
        if ($y == 2 && !$o{"$x,1"}) {
            for my $j (1,3,5,7,8) {
                my $x2 = $x - $j;
                last if $o{"$x2,1"} || $x2 < 1;
                push @q => [$e + ($j+1) * $emove{$t}, { %$a, $k => { x => $x2, y => 1 } }, $q];
            }

            for my $j (1,3,5,7,8) {
                my $x2 = $x + $j;
                last if $o{"$x2,1"} || $x2 > 11;
                push @q => [$e + ($j+1) * $emove{$t}, { %$a, $k => { x => $x2, y => 1 } }, $q];
            }
        }

        # Move into room
        if ($y == 1 && !$o{"$xhome{$t},2"} && (!$o{"$xhome{$t},3"} || $o{"$xhome{$t},3"} eq $t) &&
                                              (!$o{"$xhome{$t},4"} || $o{"$xhome{$t},4"} eq $t) &&
                                              (!$o{"$xhome{$t},5"} || $o{"$xhome{$t},5"} eq $t)) {
            if ($xhome{$t} >= $x && all { !$o{"$_,1"} } $x+1..$xhome{$t}) {
                my $j = $xhome{$t} - $x;
                push @q => [$e + ($j+1) * $emove{$t}, { %$a, $k => { x => $xhome{$t}, y => 2 } }, $q];
            } elsif ($xhome{$t} <= $x && all { !$o{"$_,1"} } $xhome{$t}..$x-1) {
                my $j = $x - $xhome{$t};
                push @q => [$e + ($j+1) * $emove{$t}, { %$a, $k => { x => $xhome{$t}, y => 2 } }, $q];
            }
        }
    }
}
print "\n" x 12;


if ($final_state) {
    my @steps;
    my ($e2, $a2);
    my $q2 = $final_state;
    while (1) {
        unshift @steps => $q2;
        ($e2, $a2, $q2) = @$q2;
        last unless $q2;
    }

    print "Steps: ", 0+@steps, "\n";

    while (1) {
        for my $step (0..@steps-1) {
            ($e2, $a2, $q2) = @{$steps[$step]};
            my $k2 = key(%$a2);
            print "\n\n";
            print "Step: ", $step+1, "  \n";
            print "Energy: $e2  \n";
            print "State key: $k2  \n";
            draw($a2, 1);
        }
        sleep 3;
    }

    print "\n" x 12;
}


sub key {
    my %a = @_;
    join ';',
    map {
        my $t = $_;
        map "$t:$_->{x},$_->{y}",
        sort {
            $a->{x} <=> $b->{x} ||
            $a->{y} <=> $b->{y}
        } $a{$t.'1'}, $a{$t.'2'}, $a{$t.'3'}, $a{$t.'4'}
    } 'A'..'D';
}


sub draw {
    my $a = shift;
    my $sleep = shift;

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

    print "\x1B[", $lines, "A";
    sleep 0.3 if $sleep;
}
