#!/usr/bin/perl
use strict;

my %g;
my $y = 0;
my $w;
while (<>) {
    chomp;
    my $x = 0;
    $g{$x++ .','. $y} = $_ for split '';
    $w = $x if $w < $x;
    $y++;
}

my $h = $y;
print "Grid size: ${w}x$h\n";



my (%c, $c);
for my $y (0..$h-1) {
    for my $x (0..$w-1) {
        my $g = $g{"$x,$y"};
        if ($g =~ /[<>^v]/) {
            $c++;
            $c{"$x,$y"} = [$g, -1];
            $g{"$x,$y"} = $g =~ /[<>]/ ? '-' : '|';
        }
    }
}

print "Carts: $c\n";

my $t = 0;
my $e;
while () {
    print "Tick: $t\n";

    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            print $c{"$x,$y"} && $c{"$x,$y"}[0] || $g{"$x,$y"};
        }
        print "\n";
    }

    last if keys %c <= 1;


    for my $p (sort { $a->[1] <=> $b->[1] || $a->[0] <=> $b->[0] } map [split ','], keys %c) {
        my ($x, $y) = @$p;
        my $g = $g{"$x,$y"};
        my ($c, $d) = @{delete $c{"$x,$y"} or next};
        my ($dx, $dy);

        if ($g eq '-') {
            $dx = {'<' => -1, '>' => 1}->{$c} or die $c;
        } elsif ($g eq '|') {
            $dy = {'^' => -1, 'v' => 1}->{$c} or die $c;
        } elsif ($g eq '/') {
            $dx = {'v' => -1, '^' => 1}->{$c};
            $dy = {'>' => -1, '<' => 1}->{$c};
            $c = {'<' => 'v', 'v' => '<', '>' => '^', '^' => '>'}->{$c};
        } elsif ($g eq '\\') {
            $dx = {'^' => -1, 'v' => 1}->{$c};
            $dy = {'<' => -1, '>' => 1}->{$c};
            $c = {'<' => '^', '^' => '<', '>' => 'v', 'v' => '>'}->{$c};
        } elsif ($g eq '+') {
            if ($d == -1) {
                $dx = {'^' => -1, 'v' => 1}->{$c};
                $dy = {'>' => -1, '<' => 1}->{$c};
                $c = {'<' => 'v', 'v' => '>', '>' => '^', '^' => '<'}->{$c};
            } elsif ($d == 0) {
                $dx = {'<' => -1, '>' => 1}->{$c};
                $dy = {'^' => -1, 'v' => 1}->{$c};
            } elsif ($d == 1) {
                $dx = {'v' => -1, '^' => 1}->{$c};
                $dy = {'<' => -1, '>' => 1}->{$c};
                $c = {'<' => '^', '^' => '>', '>' => 'v', 'v' => '<'}->{$c};
            } else {
                die $d;
            }

            $d = -1 if ++$d > 1;
        } else {
            die $g;
        }

        print "Cart $c at ${x}x$y moves ", {-1 => 'up', 1 => 'down'}->{$dy} || {-1 => 'left', 1 => 'right'}->{$dx}, "\n";

        $x += $dx;
        $y += $dy;

        if (delete $c{"$x,$y"}) {
            print "Colision at $x,$y\n";
            next;
        }
        $c{"$x,$y"} = [$c, $d];
    }

    print "\n";
    $t++;
}

print "No carts left\n" unless keys %c;
print "One cart left at ", keys %c, "\n" if keys %c;
