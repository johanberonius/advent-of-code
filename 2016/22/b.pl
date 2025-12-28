#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);


my %u;
my %a;
my ($sx, $sy) = (0, 0);
my ($tx, $ty) = (0, 0);
my ($mx, $my) = (0, 0);
my ($ex, $ey) = (0, 0);
while (<>) {
    my ($x, $y, $s, $u, $a, $p) = /node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)%/ or next;

    $u{"$x,$y"} = 0+$u;
    $a{"$x,$y"} = 0+$a;
    $mx = $tx = $x if $tx <= $x;
    $my = $y if $mx <= $y;
    ($ex, $ey) = ($x, $y) if $u == 0;
}

print "Grid size: 0,0 - $mx,$my\n";
print "Target node: $tx,$ty\n";
print "Empty node: $ex,$ey\n";


my @q = ([0, ]);
my $i = 0;
while (@q) {
    my $q = shift @q;
    my ($s, ) = @$q;


}


print $ex - 25 + $ey + $tx - 1 - 25 + 5 * ($tx - 1) + 1, " steps\n";

draw();


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    print "   ";
    for my $x (0..$mx) {
        printf(" %3d  ", $x);
    }
    print "\n";
    $lines++;

    for my $y (0..$my) {
        printf("%2d ", $y);
        for my $x (0..$mx) {
            my $u = $u{"$x,$y"};
            my $a = $a{"$x,$y"};

            print color($u == 0 ? 'on_rgb113' : $u > 100 ? 'on_rgb200' : 'on_rgb311'), sprintf('%3d', $u), color('reset');
            print color($u > 100 ? 'on_rgb020' : 'on_rgb131'), sprintf('%3d', $a), color('reset');
        }
        print "\n";
        $lines++;
    }
    print "\n";
    $lines++;
    sleep 0.2;
}
