#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $e (split '') {
        $g{"$x,$y"} = $e;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

print "\nGrid width: $width, height: $height\n";

draw();
sleep 2;

my %m;
my %c;
my $m;
my %p;
my @q = [0, 0, 0, 0, 0, {}];
while (@q) {
    @q = sort { $a->[2] <=> $b->[2] } @q;
    my ($x, $y, $c, $sx, $sy, $p) = @{shift @q};
    next unless $x >= 0 && $x < $width && $y >= 0 && $y < $height;

    my $xy = "$x,$y";
    $p = { %$p, $xy => 1};

    my $k = "$x,$y,$sx,$sy";
    if (defined $m && $c >= $m) {
        next;
    } elsif (!exists $c{$k} || $c < $c{$k}) {
        $c{$k} = $c;
    } else {
        next;
    }

    $m{$xy} = $c if !exists $m{$xy} || $c < $m{$xy};

    if ($x == $width-1 && $y == $height-1) {
        $m = $c;
        %p = %$p;
        next;
    }

    my ($n, $s) = ($y-1, $y+1);
    my ($w, $e) = ($x-1, $x+1);


    if (abs($sy) < 3) {
        unshift @q => [$x, $n, $c + $g{"$x,$n"}, 0, $sy-1, $p] if $sy <= 0;
        unshift @q => [$x, $s, $c + $g{"$x,$s"}, 0, $sy+1, $p] if $sy >= 0;
    }

    if (abs($sx) < 3) {
        unshift @q => [$w, $y, $c + $g{"$w,$y"}, $sx-1, 0, $p] if $sx <= 0;
        unshift @q => [$e, $y, $c + $g{"$e,$y"}, $sx+1, 0, $p] if $sx >= 0;
    }


} continue {
    draw();
}

print "\x1B[", 1, "A";
print "Minimum heatloss: $m\n";



my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $m = $m{"$x,$y"};
            my $p = $p{"$x,$y"};
            my $c = defined $p ? 'on_rgb115' : defined $m ? 'on_rgb511' : 'on_rgb333';
            if (defined $m) {
                print color($c), sprintf("%3d" , $m), color('reset');
            } else {
                print color($c), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    print "\n";
    $lines++;
    sleep 0.0005;
}

