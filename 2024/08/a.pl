#!/usr/bin/perl
use strict;
use Term::ANSIColor;

my %g;
my %n;
my @a;
my ($x, $y) = (0, 0);
my ($width, $height);
my $c;

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        if ($g ne '.') {
            push @a => [$g, $x, $y];
        }
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;
print "Grid width: $width, height: $height\n";
print "Antennas: ", 0+@a, "\n";

for my $a1 (@a) {
    my ($t1, $x1, $y1) = @$a1;

    for my $a2 (@a) {
        my ($t2, $x2, $y2) = @$a2;
        next if $a1 == $a2;
        next unless $t1 eq $t2;

        my $x = $x1 - ($x2 - $x1);
        my $y = $y1 - ($y2 - $y1);
        next unless $g{"$x,$y"};
        $n{"$x,$y"}++;
    }
}

draw();

print "Nodes: ", 0+values %n, "\n";

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $n = $n{"$x,$y"} && 'on_rgb311';

            if ($g ne '.') {
                print color($n || 'on_rgb113'), " $g ", color('reset');
            } elsif ($g eq '.') {
                print color($n || 'on_rgb333'), " • ", color('reset');
            } else {
                print color($n || 'on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
}
