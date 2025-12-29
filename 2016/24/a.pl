#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my %k;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($sx, $sy);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        ($sx, $sy) = ($x, $y) if $g eq '0';
        if (0+$g eq $g) {
            $k{"$x,$y"} = $g;
            $g = '.';
        }
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

my $ak = join ',', sort values %k;
print "Grid size: $width x $height\n";
print "Start position: $sx x $sy\n";
print "Keys: ", 0+values %k," ($ak)\n";
print "\n";

my %s;
my $i = 1;
my @q = ([0, $sx, $sy, '0']);
while (@q) {
    $i++;
    my $q = shift @q;
    my ($s, $x, $y, $k) = @$q;

    unless ($i % 10_000) {
        print "$i: q: ", 0+@q, ", s: $s, x: $x, y: $y, k: $k\n";
    }

    next unless $g{"$x,$y"} eq '.';
    next if $s{"$x,$y,$k"}++;

    if (exists $k{"$x,$y"}) {
        my %nk = map { $_ => 1 } $k{"$x,$y"}, split ',', $k;
        $k = join ',', sort keys %nk;
    }

    if ($k eq $ak) {
        print "Visited all locations in $s steps.\n";
        last;
    }

    my ($wx, $ex) = ($x-1, $x+1);
    my ($ny, $sy) = ($y-1, $y+1);
    push @q => [$s+1, $ex, $y, $k] if $g{"$ex,$y"} eq '.' && !$s{"$ex,$y,$k"};
    push @q => [$s+1, $x, $sy, $k] if $g{"$x,$sy"} eq '.' && !$s{"$x,$sy,$k"};
    push @q => [$s+1, $wx, $y, $k] if $g{"$wx,$y"} eq '.' && !$s{"$wx,$y,$k"};
    push @q => [$s+1, $x, $ny, $k] if $g{"$x,$ny"} eq '.' && !$s{"$x,$ny,$k"};


    # draw();
}

print "$i iterations.\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $k = $k{"$x,$y"};

            if (0+$k eq $k) {
                print color('on_rgb411'), " $k ", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), " • ", color('reset');
            } else {
                print color('on_rgb111'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    print "\n";
    $lines++;
    sleep 0.2;
}
