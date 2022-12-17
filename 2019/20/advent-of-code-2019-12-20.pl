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


my ($sx, $sy) = portal('A', 'A');
my ($ex, $ey) = portal('Z', 'Z');


my @p = ({ x => $sx, y => $sy, d => 0 });
my %d;
my $i = 0;
while (@p) {
    my %p = %{shift @p};
    my ($x, $y, $d) = @p{'x', 'y', 'd'};
    my $c = $c{"$x,$y"};

    draw() unless $i % 1;
    $i++;

    # Stop at wall
    if ($c eq '#') {
        next;
    }

    # Stop at empty space
    if ($c eq ' ' or !$c) {
        next;
    }

    # Stop if visited
    if ($d{"$x,$y"}) {
        next;
    }

    # Mark as visited
    $d{"$x,$y"} = $d;

    # Portal
    if ($c eq uc $c and $c ne lc $c) {
        my ($c1, $c2) = from($x, $y);
        ($x, $y) = portal($c1, $c2, $x, $y);
        $d{"$x,$y"} = $d;
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
}

draw();

print "Steps at exit position: ", $d{"$ex,$ey"}, "\n";


sub portal {
    my ($c1, $c2, $fx, $fy) = @_;
    my @a = grep $c{$_} eq $c1, keys %c;
    for (@a) {
        my ($x, $y) = split ',';
        next if $x == $fx && $y == $fy;
        my ($n, $s, $s2) = ($y - 1, $y + 1, $y + 2);
        my ($w, $e, $e2) = ($x - 1, $x + 1, $x + 2);

        if ($c{"$e,$y"} eq $c2) {
            next if $e == $fx && $y == $fy;
            return ($w, $y) if $c{"$w,$y"} eq '.';
            return ($e2, $y) if $c{"$e2,$y"} eq '.';
            die "Portal exit not found 1";
        } elsif ($c{"$x,$s"} eq $c2) {
            next if $x == $fx && $s == $fy;
            return ($x, $n) if $c{"$x,$n"} eq '.';
            return ($x, $s2) if $c{"$x,$s2"} eq '.';
            die "Portal exit not found 2";
        }
    }
}

sub from {
    my ($x, $y) = @_;
    my ($n, $s) = ($y - 1, $y + 1);
    my ($w, $e) = ($x - 1, $x + 1);
    my $c1 = $c{"$x,$y"};
    my ($c2) = grep { $_ eq uc $_ && $_ ne lc $_ } @c{("$e,$y", "$x,$s")};
    return ($c1, $c2) if $c2;
    $c2 = $c1;
    ($c1) = grep { $_ eq uc $_ && $_ ne lc $_ } @c{"$w,$y", "$x,$n"};
    return ($c1, $c2);
}

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;

    # print "Start position: $sx,$sy  \n";
    # $lines++;
    print "Interations ran: ", $i, " \n";
    $lines++;

    for my $py ($ymin .. $ymax) {
        for my $px ($xmin .. $xmax) {
            my $c = $c{"$px,$py"};
            my $d = $d{"$px,$py"};
            my $e = $px == $ex && $py == $ey ? 'on_green' : '';
            if ($c eq '#') {
                print color('on_black'), '   '
            } elsif ($px == $sx && $py == $sy) {
                print color('on_magenta'), ' @ ';
            } elsif ($c eq uc $c and $c ne lc $c) {
                print color('on_red'), " $c ";
            } elsif ($d) {
                print color($e || 'on_cyan'), sprintf('%3d', $d);
            } elsif ($c eq '.') {
                print color($e || 'on_blue'), ' • ';
            } else {
                print color('reset'), '   ';
            }
        }
        print color('reset'), "\n";
        $lines++;
    }

    # sleep 0.05;
}
