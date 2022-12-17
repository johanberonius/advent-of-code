#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my ($w, $h) = (0, 0);
my %g;
while (<>) {
    chomp;
    next unless $_;
    $w = 0;
    $g{$w++ .','. $h} = $_ for split '';
    $h++;
}

print "Grid width: $w, height: $h\n";

my $s = 0;
my $moved = 1;
while (1) {
    print "After $s steps.\n";
    # draw();
    last unless $moved;

    $moved = 0;
    my %h = %g;
    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            my $p = "$x,$y";
            my $e = (($x+1) % $w) .','. $y;

            if ($g{$p} eq '>' && $g{$e} eq '.') {
                $h{$e} = '>';
                $h{$p} = '.';
                $moved = 1;
            }
        }
    }
    %g = %h;

    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            my $p = "$x,$y";
            my $s = $x .','. (($y+1) % $h);

            if ($g{$p} eq 'v' && $g{$s} eq '.') {
                $h{$s} = 'v';
                $h{$p} = '.';
                $moved = 1;
            }
        }
    }
    %g = %h;


    $s++;
}



sub draw {
    my $lines = 5;
    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            my $p = $g{"$x,$y"};
            if ($p eq '>') {
                print color('grey8', 'on_rgb225'), " $p ", color('reset');
            } elsif ($p eq 'v') {
                print color('grey6', 'on_rgb115'), " $p ", color('reset');
            } elsif ($p eq '.') {
                print color('grey12', 'on_blue'), " • ", color('reset');
            } else {
                print " $p ";
            }
        }
        print "\n";
        $lines++;
    }

    # print "\x1B[", $lines, "A";
    # sleep 0.1 if $sleep;
}
