#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my ($w, $h) = (0, 0);
my %a;
my %g;
while (<>) {
    chomp;
    next unless $_;
    $w = 0;
    for (split '') {
        if (/\w/) {
            push @{$a{$_}} => { x => $w, y => $h};
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

my $c = 0;
while (@q) {
    @q = sort { our ($a, $b); $a->[0] <=> $b->[0] } @q;
    my $q = shift @q;
    my ($e, $a) = @$q;

    $c++;
    my $k = key(%$a);

    unless ($c % 1000) {
        print "Iterations run: $c\n";
        print "Unique states visited: ", 0+values %e, "\n";
        print "Queue length: ", 0+@q, "  \n";
        print "Energy: $e  \n";
        print "State key: $k  \n";
        draw($a);

        @q = grep {
            my ($e, $a) = @$_;
            my $k = key(%$a);
            !(
                exists $e{$k} && $e{$k} <= $e or
                $emin && $_->[0] >= $emin
            );
        } @q;
    }

    next if exists $e{$k} && $e{$k} <= $e;
    $e{$k} = $e;

    next if $emin && $e >= $emin;

    if ($k eq 'A:3,2;A:3,3;B:5,2;B:5,3;C:7,2;C:7,3;D:9,2;D:9,3') {
        print "Found new lowest energy solution: $e\n";
        $emin = $e if !$emin || $e < $emin;
        next;
    }

    branch($_, $e, $a) for ('A'..'D');

    # last if $c > 10;
}

sub branch {
    my $t = shift;
    my $e = shift;
    my $a = shift;

    my %o = (
        map {
            my $t = $_;
            map { ("$_->{x},$_->{y}" => $t) } @{$a->{$t}};
        } keys %$a
    );

    my ($x1, $y1) = ($a->{$t}[0]{x}, $a->{$t}[0]{y});
    my ($w1, $e1) = ($x1 - 1, $x1 + 1);
    my ($n1, $s1) = ($y1 - 1, $y1 + 1);

    my ($x2, $y2) = ($a->{$t}[1]{x}, $a->{$t}[1]{y});
    my ($w2, $e2) = ($x2 - 1, $x2 + 1);
    my ($n2, $s2) = ($y2 - 1, $y2 + 1);

    # 1 W
    if ($g{"$w1,$y1"} eq '.' && !$o{"$w1,$y1"}) {
        push @q => [$e + $emove{$t}, { %$a, $t => [ { x => $w1, y => $y1 }, { x => $x2, y => $y2 } ] }];
    }
    # 1 E
    if ($g{"$e1,$y1"} eq '.' && !$o{"$e1,$y1"}) {
        push @q => [$e + $emove{$t}, { %$a, $t => [ { x => $e1, y => $y1 }, { x => $x2, y => $y2 } ] }];
    }
    # 1 N
    if ($g{"$x1,$n1"} eq '.' && !$o{"$x1,$n1"}) {
        if ($x1 == $xhome{$t} && $n1 == 2) {
            # Don't move from home
        } elsif ($x1 == $xhome{$t} && $n1 == 1 && (!$o{"$xhome{$t},3"} || $o{"$xhome{$t},3"} eq $t)) {
            # Don't move from home
        } elsif ($n1 == 1 && ($x1 == 3 || $x1 == 5 || $x1 == 7 || $x1 == 9)) {
            # Move out of room
            push @q => [$e + 2 * $emove{$t}, { %$a, $t => [ { x => $w1, y => $n1 }, { x => $x2, y => $y2 } ] }]
                if !$o{"$w1,$n1"};
            push @q => [$e + 2 * $emove{$t}, { %$a, $t => [ { x => $e1, y => $n1 }, { x => $x2, y => $y2 } ] }]
                if !$o{"$e1,$n1"};
        } else {
            push @q => [$e + $emove{$t}, { %$a, $t => [ { x => $x1, y => $n1 }, { x => $x2, y => $y2 } ] }];
        }
    }
    # 1 S
    if ($g{"$x1,$s1"} eq '.' && !$o{"$x1,$s1"}) {
        if ($s1 == 3 ||
            ($x1 == $xhome{$t} && (!$o{"$xhome{$t},3"} || $o{"$xhome{$t},3"} eq $t))
        ) {
            # Move into room
            push @q => [$e + $emove{$t}, { %$a, $t => [ { x => $x1, y => $s1 }, { x => $x2, y => $y2 } ] }];
        }
    }


    # 2 W
    if ($g{"$w2,$y2"} eq '.' && !$o{"$w2,$y2"}) {
        push @q => [$e + $emove{$t}, { %$a, $t => [ { x => $x1, y => $y1 }, { x => $w2, y => $y2 } ] }];
    }
    # 2 E
    if ($g{"$e2,$y2"} eq '.' && !$o{"$e2,$y2"}) {
        push @q => [$e + $emove{$t}, { %$a, $t => [ { x => $x1, y => $y1 }, { x => $e2, y => $y2 } ] }];
    }
    # 2 N
    if ($g{"$x2,$n2"} eq '.' && !$o{"$x2,$n2"}) {
        if ($x2 == $xhome{$t} && $n2 == 2) {
            # Don't move from home
        } elsif ($x2 == $xhome{$t} && $n2 == 1 && (!$o{"$xhome{$t},3"} || $o{"$xhome{$t},3"} eq $t)) {
            # Don't move from home
        } elsif ($n2 == 1 && ($x2 == 3 || $x2 == 5 || $x2 == 7 || $x2 == 9)) {
            # Move out of room
            push @q => [$e + 2 * $emove{$t}, { %$a, $t => [ { x => $x1, y => $y1 }, { x => $w2, y => $n2 } ] }]
                if !$o{"$w2,$n2"};
            push @q => [$e + 2 * $emove{$t}, { %$a, $t => [ { x => $x1, y => $y1 }, { x => $e2, y => $n2 } ] }]
                if !$o{"$e2,$n2"};
        } else {
            push @q => [$e + $emove{$t}, { %$a, $t => [ { x => $x1, y => $y1 }, { x => $x2, y => $n2 } ] }];
        }
    }
    # 2 S
    if ($g{"$x2,$s2"} eq '.' && !$o{"$x2,$s2"}) {
        if ($s2 == 3 ||
            ($x2 == $xhome{$t} && (!$o{"$xhome{$t},3"} || $o{"$xhome{$t},3"} eq $t))
        ) {
            # Move into room
            push @q => [$e + $emove{$t}, { %$a, $t => [ { x => $x1, y => $y1 }, { x => $x2, y => $s2 } ] }];
        }
    }
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
        } @{$a{$t}}
    } 'A'..'D';
}


sub draw {
    my $a = shift;
    my %o = (
        map {
            my $k = $_;
            map { ("$_->{x},$_->{y}" => $k) } @{$a->{$k}};
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
    # sleep 0.1;
}
