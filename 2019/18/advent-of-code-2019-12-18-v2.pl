#!/usr/bin/perl
use strict;
use List::Util qw(sum min max all);
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


my @q = map { my ($x, $y) = split ','; { x => 0+$x, y => 0+$y }} grep {($c{$_} eq lc $c{$_} && $c{$_} ne uc $c{$_}) || $c{$_} eq '@'} keys %c;
my $i = 0;
my %paths;

while (@q) {
    my %sp = %{shift @q};
    my ($sx, $sy) = @sp{'x', 'y'};
    my @p = ({ x => $sx, y => $sy, d => 0, k => {} });
    my %d = ();

    while (@p) {
        my %p = %{shift @p};
        my ($x, $y, $d) = @p{'x', 'y', 'd', 'k'};
        my %k = %{$p{k}};
        my $c = $c{"$x,$y"};

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

        # Stop at new key, mark path distance from start to key position
        if ($c eq lc $c and $c ne uc $c) {
            unless ($x == $sx and $y == $sy) {
                push @{$paths{"$sx,$sy"}} => { x => $x, y => $y, d => $d, k => $c, rk => { %k } };
            }

            # Mark key as required for continued path beyond this key
            $k{$c}++;
        }

        # Mark key as required and continue at door
        if ($c eq uc $c and $c ne lc $c) {
            $k{lc $c}++;
        }

        # Branch to 4 adjacent squares
        my ($n, $s) = ($y - 1, $y + 1);
        my ($w, $e) = ($x - 1, $x + 1);
        push @p => (
            { x => $w, y => $y, d => $d + 1, k => { %k } },
            { x => $e, y => $y, d => $d + 1, k => { %k } },
            { x => $x, y => $n, d => $d + 1, k => { %k } },
            { x => $x, y => $s, d => $d + 1, k => { %k } },
        );

    }

    $i++;
}

print "Calculated paths for $i start and key locations.\n";
print "Start position: $sx,$sy\n";

my @p = ({ x => $sx, y => $sy, d => 0, k => {} });
my $dmin;
my $qmax;
my $f = 0;
my $i = 0;

while (@p) {
    my %p = %{shift @p};
    my ($x, $y, $d) = @p{'x', 'y', 'd', 'k'};
    my %k = %{$p{k}};
    my @paths = @{$paths{"$x,$y"}};

    $i++;

    # print "Tracing path from ", $c{"$x,$y"}, ": $x,$y starting at distance $d with keys ", join('+', sort keys %k), ".\n";

    # Stop if path is longer than minimum found
    if ($dmin && $d >= $dmin) {
        next;
    }

    # Stop if we have got all keys
    if (keys %k == @k) {
        $dmin = $d if !$dmin || $dmin > $d;
        $f++;
        # print "  Found all keys in $f paths, shortest path: $dmin steps.\n";
        next;
    }

    # Branch to all available paths with matching keys
    my $bl = 0;
    my @br;
    for my $path (@paths) {
        # print "  Checking branch to $path->{k}: $path->{x},$path->{y} with distance $path->{d}, required keys ", join('+', keys %{$path->{rk}}), ".\n";

        if ($k{$path->{k}}) {
            # print "    Already visited, skipping!\n";
        } elsif ( all { $k{$_} } keys %{$path->{rk}}) {
            # print "    Got required keys, branching!\n";
            push @br => {
                x => $path->{x},
                y => $path->{y},
                d => $d + $path->{d},
                k => { %k, $path->{k} => 1 },
            };
            # Limit maximum number of new branches from each node
            last if ++$bl >= 4;
        } else {
            # print "    Missing reqiuired keys, skipping!\n";
        }
    }
    unshift @p => @br;
    # @p = sort { $b->{d} <=> $a->{d} } @p;


    $qmax = 0+@p if @p > $qmax;

    status() unless $i % 10_000;
}

status();

my $lines;
sub status {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    print "Branches ran: ", $i, "\n";
    $lines++;
    print "Branch queue: ", 0+@p, "   \n";
    $lines++;
    print "Max queue: $qmax\n";
    $lines++;
    print "Found all keys in $f paths, shortest path: $dmin steps.\n";
    $lines++;
}

# 4780 is too high, branch limit 3, 5.9 M iterations
# 4762 is the right answer, branch limit 4, ~18 M iterations
