#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my ($x, $y) = (0, 0);
my %c;
while (<>) {
    chomp;
    $c{$x++ .','. $y} = $_ for split '';
    $y++;
    $x = 0;
}

my @x = map [split ',']->[0], keys %c;
my @y = map [split ',']->[1], keys %c;
my $xmin = min @x;
my $xmax = max @x;
my $ymin = min @y;
my $ymax = max @y;
my $w = $xmax - $xmin + 1;
my $h = $ymax - $ymin + 1;
print "Width: $w\n";
print "Height: $h\n";
print "Size: ", $w * $h, "\n";

my ($s) = grep $c{$_} eq '@', keys %c;
my ($sx, $sy) = split ',', $s;

my @k = sort grep $_ eq lc $_ && $_ ne uc $_, values %c;
print "Found ", 0+@k, " keys, @k\n";


my @q = ({ x => $sx, y => $sy, d => 0, k => {} });
my @p;
my %d;
my $dmin;
my $f = 0;
my %k;
my $i = 0;

while (@q) {
    my %sp = %{shift @q};
    ($sx, $sy) = @sp{'x', 'y'};
    @p = ({ x => $sx, y => $sy, d => $sp{d} });
    %d = ();
    %k = %{$sp{k}};

    while (@p) {
        my %p = %{shift @p};
        my ($x, $y, $d) = @p{'x', 'y', 'd'};
        my $c = $c{"$x,$y"};

        # Stop if path is longer than minimum found
        if ($dmin && $d >= $dmin) {
            next;
        }

        # Stop at wall
        if ($c eq '#') {
            next;
        }

        # Stop if visited
        if ($d{"$x,$y"}) {
            next;
        }

        # Mark as visited
        $d{"$x,$y"} = $d;

        # Stop at new key, collect and restart at key position unless we have all keys
        if ($c eq lc $c and $c ne uc $c and !$k{$c}) {
            if (1+keys %k == @k) {
                $dmin = $d if !$dmin || $dmin > $d;
                $f++;
            } else {
                unshift @q => { x => $x, y => $y, d => $d, k => { %k, $c => 1 } };
            }

            next;
        }

        # Stop at door unless we have matching key
        if ($c eq uc $c and $c ne lc $c and !$k{lc $c}) {
            next;
        }

        # Branch to 4 adjacent squares
        my ($n, $s) = ($y - 1, $y + 1);
        my ($w, $e) = ($x - 1, $x + 1);
        push @p => (
            { x => $w, y => $y, d => $d + 1 },
            { x => $e, y => $y, d => $d + 1 },
            { x => $x, y => $n, d => $d + 1 },
            { x => $x, y => $s, d => $d + 1 },
        );

        draw();
    }

    # draw() unless $i % 10;
    $i++;
}

draw();

print "Found all keys after $dmin steps.\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;

    print "Start position: $sx,$sy  \n";
    $lines++;
    print "Branches ran: ", $i, " \n";
    $lines++;
    print "Branch queue: ", 0+@q, " \n";
    $lines++;
    print "Point queue: ", 0+@p, " \n";
    $lines++;
    print "Got ", 0+keys(%k), " keys, ", join(' ', sort keys %k), "\n";
    $lines++;
    print "Found all keys in $f paths, shortest path: $dmin steps.\n";
    $lines++;

# return;

    for my $py ($ymin .. $ymax) {
        for my $px ($xmin .. $xmax) {
            my $c = $c{"$px,$py"};
            my $d = $d{"$px,$py"};
            if ($c eq '#') {
                print color('on_black'), '   '
            } elsif ($px == $sx && $py == $sy) {
                print color('on_magenta'), ' @ ';
            } elsif ($c eq lc $c and $c ne uc $c and !$k{$c}) {
                print color('on_green'), " $c ";
            } elsif ($c eq uc $c and $c ne lc $c and !$k{lc $c}) {
                print color('on_red'), " $c ";
            } elsif ($d) {
                print color('on_cyan'), sprintf('%3d', $d);
            } else {
                print color('on_blue'), ' • ';
            }
        }
        print color('reset'), "\n";
        $lines++;
    }

    sleep 0.01;
}
