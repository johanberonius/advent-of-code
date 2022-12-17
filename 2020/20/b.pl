#!/usr/bin/perl
use strict;
use List::Util qw(min max all product);
use Term::ANSIColor;

my ($x, $y) = (0, 0);
my $i;
my %c;
while (<>) {
    chomp;

    if (/Tile\s*(\d+)/i) {
        $i = 0+$1;
        $y = 0;
    } elsif ($i and $_) {
        $c{$i}{$x++ . ',' . $y} = $_ for split '';
        $y++;
        $x = 0;
    }
}

my $t = 0+keys %c;
my $g = sqrt $t;
my @x = map [split ',']->[0], keys %{$c{$i}};
my @y = map [split ',']->[1], keys %{$c{$i}};
my ($xmin, $xmax) = (min(@x), max(@x));
my ($ymin, $ymax) = (min(@y), max(@y));
my $w = $xmax - $xmin + 1;
my $h = $ymax - $ymin + 1;
print "Tiles: $t\n";
print "Tile width: $w\n";
print "Tile height: $h\n";
print "Tile size: ", $w * $h, "\n";
print "Grid size: $g x $g\n";


my $te = [map "$_,$ymin", $xmin..$xmax];
my $be = [map "$_,$ymax", $xmin..$xmax];
my $le = [map "$xmin,$_", $ymin..$ymax];
my $re = [map "$xmax,$_", $ymin..$ymax];

my %te;
my %be;
my %le;
my %re;

my %d;
for my $i (keys %c) {
    for my $fx (0, 1) {
        for my $fy (0, 1) {
            for my $sxy (0, 1) {
                my $j = "$i-$fx$fy$sxy";

                for my $y ($ymin..$ymax) {
                    for my $x ($xmin..$xmax) {
                        my ($sx, $sy) = ($x, $y);
                        $sx = $xmax - $x + $xmin if $fx;
                        $sy = $ymax - $y + $ymin if $fy;
                        ($sx, $sy) = ($sy, $sx) if $sxy;
                        $d{$j}{"$x,$y"} = $c{$i}{"$sx,$sy"};
                    }
                }

                $d{$j}{'te'} = join '', @{$d{$j}}{@$te};
                $d{$j}{'be'} = join '', @{$d{$j}}{@$be};
                $d{$j}{'le'} = join '', @{$d{$j}}{@$le};
                $d{$j}{'re'} = join '', @{$d{$j}}{@$re};

                push @{$te{join '', @{$d{$j}}{@$te}}} => $j;
                push @{$be{join '', @{$d{$j}}{@$be}}} => $j;
                push @{$le{join '', @{$d{$j}}{@$le}}} => $j;
                push @{$re{join '', @{$d{$j}}{@$re}}} => $j;
            }
        }
    }
}


my %notop = map { $te{$_}[0] => 1 } grep keys @{$te{$_}} == 1, keys %te;
my @notopleft = sort grep $notop{$_}, map $le{$_}[0], grep keys @{$le{$_}} == 1, keys %le;


my %gt;

$gt{'0,0'} = $notopleft[7];

for my $gy (0..$g-1) {
    for my $gx (0..$g-1) {
        next if $gt{"$gx,$gy"};
        my $gl = $gt{($gx-1) . ',' . $gy};
        my $gt = $gt{$gx   . ',' . ($gy-1)};
        if ($gl) {
            ($gt{"$gx,$gy"}) = grep $_ != $gl, @{$le{$d{$gl}{'re'}}};
        } elsif ($gt) {
            ($gt{"$gx,$gy"}) = grep $_ != $gt, @{$te{$d{$gt}{'be'}}};
        } else {
            die "No grid tile";
        }
    }
}


my %g;
for my $gy (0..$g-1) {
    for my $gx (0..$g-1) {
        my $i = $gt{"$gx,$gy"};

        for my $y ($ymin+1..$ymax-1) {
            for my $x ($xmin+1..$xmax-1) {
                my $dx = $gx * ($w - 2) + $x;
                my $dy = $gy * ($h - 2) + $y;
                $g{"$dx,$dy"} = $d{$i}{"$x,$y"};
            }
        }
    }
}

my @gx = map [split ',']->[0], keys %g;
my @gy = map [split ',']->[1], keys %g;
my ($gxmin, $gxmax) = (min(@gx), max(@gx));
my ($gymin, $gymax) = (min(@gy), max(@gy));
my $gw = $gxmax - $gxmin + 1;
my $gh = $gymax - $gymin + 1;
print "Image width: $gw\n";
print "Image height: $gh\n";
print "Image size: ", $gw * $gh, "\n";





my @sm = (
    '..................#.',
    '#....##....##....###',
    '.#..#..#..#..#..#...',
);

($x, $y) = (0, 0);
my %sm;
my %tsm;
my %fsm;
while ($_ = shift @sm) {
    chomp;
    $sm{$x++ . ',' . $y} = $_ for split '';
    $y++;
    $x = 0;
}
my @smx = map [split ',']->[0], keys %sm;
my @smy = map [split ',']->[1], keys %sm;
my ($smxmin, $smxmax) = (min(@smx), max(@smx));
my ($smymin, $smymax) = (min(@smy), max(@smy));
my $smw = $smxmax - $smxmin + 1;
my $smh = $smymax - $smymin + 1;
print "Monster width: $smw\n";
print "Monster height: $smh\n";
print "Monster size: ", $smw * $smh, "\n";

my $smp = grep $_ eq '#', values %sm;
print "Monster pixels: $smp\n";

my $smc = 0;
for my $y ($gymin..$gymax) {
    for my $x ($gxmin..$gxmax) {
        # print "Looking for sea monster at $x,$y\n";
        # print $g{"$x,$y"};

        for my $fx (0, 1) {
            for my $fy (0, 1) {
                sm: for my $sxy (0, 1) {
                    # print "Orientation $fx,$fy,$sxy\n";
                    %tsm = ();

                    for my $smy (!$sxy ? ($smymin..$smymax) : ($smxmin..$smxmax)) {
                        for my $smx (!$sxy ? ($smxmin..$smxmax) : ($smymin..$smymax)) {

                            my ($sx, $sy) = ($smx, $smy);
                            $sx = $smxmax - $smx + $smxmin if $fx && !$sxy;
                            $sx = $smymax - $smx + $smymin if $fx && $sxy;

                            $sy = $smymax - $smy + $smymin if $fy && !$sxy;
                            $sy = $smxmax - $smy + $smxmin if $fy && $sxy;

                            ($sx, $sy) = ($sy, $sx) if $sxy;
# print $sm{"$sx,$sy"} || '°';

                            if ($sm{"$sx,$sy"} eq '#') {

                                my ($gx, $gy) = ($x + $smx, $y + $smy);
                                $tsm{"$gx,$gy"} = '#';

                                next sm unless $g{"$gx,$gy"} eq '#';
                            }
                        }
# print "\n";

                    }
                    # print "Found sea monster at $x,$y\n";
                    $smc++;
                    %fsm = (%fsm, %tsm);

                }
            }
        }

    }
    # print "\n";
}

print "Found $smc sea monsters\n";


my $wr = grep $_ eq '#', values %g;
$wr -= $smc * $smp;
print "Water roughness: $wr\n";



print "\n\n";

for my $y ($gymin .. $gymax) {
    for my $x ($gxmin .. $gxmax) {
        my $g = $g{"$x,$y"};
        my $sm = $fsm{"$x,$y"};
        if ($sm eq '#') {
            print color('black', 'on_green'), ' # ';
        } elsif ($g eq '#') {
            print color('white', 'on_blue'), ' ~ ';
        } elsif ($g eq '.') {
            print color('white', 'on_blue'), ' • ';
        }
    }
    print color('reset'), "\n";
}
print "\n\n";
