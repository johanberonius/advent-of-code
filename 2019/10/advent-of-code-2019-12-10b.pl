#!/usr/bin/perl
use strict;
use Math::Trig;

my ($ox, $oy) = (22, 19); # input
# my ($ox, $oy) = (11, 13); # test4

my $y = 0;
my $x;
my %a;
my %v;

while (<>) {
    chomp;
    $x = 0;
    for (split '') {
        if ($_ eq '#') {
            unless ($x == $ox && $y == $oy) {
                my ($dx, $dy) = ($x - $ox, $y - $oy);
                my $a = atan2($dy, $dx);
                $a += pi/2;
                $a += pi*2 if $a < 0;
                my $l = sqrt($dx**2 + $dy**2);
                $a{"$x,$y"} = $a;
                push @{$v{$a}} => ["$x,$y", $l];
            }
        }
        $x++;
    }
    $y++;
}

my $w = $x;
my $h = $y;
print "Asteroid field, width: $w, height: $h\n";

my $n = values %a;
print "Number of asteroids: $n\n";

print "Laser position: $ox,$oy\n";


for my $v (keys %v) {
    my @a = sort { $a->[1] <=> $b->[1] } @{$v{$v}};
    for my $i (1..$#a) {
        my $p = $a[$i][0];
        $a{$p} += $i * pi*2;
    }
}

my @o = sort { $a{$a} <=> $a{$b} } keys %a;

for my $i (1,2,3,10,20,50,100,199,200,201,299) {
    print "The ${i}th asteroid to be vaporized is at $o[$i-1]\n";
}


# use Data::Dumper;
# print Dumper(\%a);


for my $y (0..$h-1) {
    for my $x (0..$w-1) {
        my $a = $a{"$x,$y"};

        printf "%6.2f", $a unless $a eq '';
        print $x == $ox && $y == $oy ? '   X  ' : '   .  ' if $a eq '';
    }
    print "\n";
}
