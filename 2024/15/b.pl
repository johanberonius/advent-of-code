#!/usr/bin/perl
use strict;
use List::Util qw(any all sum);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($px, $py) = (0, 0);

while (<>) {
    chomp;
    last unless $_;
    $x = 0;
    for my $g (map { $_ eq 'O' ? ('[', ']') : $_ eq '@' ? ('@', '.') : ($_, $_) } split '') {
        if ($g eq '@') {
            ($px, $py) = ($x, $y);
        }
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;
print "Grid width: $width, height: $height\n";
print "Robot position: $px, $py\n";

my %d = (
    '^' => [0, -1],
    '>' => [1,  0],
    'v' => [0,  1],
    '<' => [-1, 0],
);

my @d = map { chomp; map $d{$_}, split '';} <>;
print "Directions: ", 0+@d, "\n";

draw();

for my $d (@d) {
    my ($dx, $dy) = @$d;

    ($x, $y) = ($px, $py);
    if ($dx) {
        while (1) {
            $x += $dx;
            $y += $dy;
            my $g = $g{"$x,$y"};
            last if $g eq '#' || $g eq '.';
        }

        while (1) {
            my ($mx, $my) = ($x-$dx, $y-$dy);

            if ($g{"$x,$y"} eq '.') {
                $g{"$x,$y"} = $g{"$mx,$my"};
                $g{"$mx,$my"} = '.';
                if ($mx == $px && $my == $py) {
                    $px += $dx;
                    $py += $dy;
                    last;
                }
            }
            $x -= $dx;
            $y -= $dy;
            last if $x == $px && $y == $py;
        }
    } else {
        my @q = ([$px, $py]);
        my @nq = @q;

        while (1) {
            if (any { $g{($_->[0]+$dx) .','. ($_->[1]+$dy)} eq '#' } @nq) {
                last;
            } elsif (all { $g{($_->[0]+$dx) .','. ($_->[1]+$dy)} eq '.' } @nq) {
                for (@q) {
                    my ($x, $y) = @$_;
                    my ($nx, $ny) = ($x+$dx, $y+$dy);
                    $g{"$nx,$ny"} = $g{"$x,$y"};
                    $g{"$x,$y"} = '.';

                    if ($x == $px && $y == $py) {
                        $px += $dx;
                        $py += $dy;
                    }
                    # draw();
                }
                last;
            } else {
                my @tq = @nq;
                @nq = ();
                my %nq;
                for (@tq) {
                    my ($x, $y) = @$_;
                    my ($nx, $ny) = ($x+$dx, $y+$dy);
                    my $g = $g{"$nx,$ny"};
                    if ($g eq '[') {
                        unshift @nq => [$nx, $ny] unless $nq{"$nx,$ny"}++;
                        unshift @nq => [$nx+1, $ny] unless $nq{($nx+1).",$ny"}++;
                    } elsif ($g eq ']') {
                        unshift @nq => [$nx-1, $ny] unless $nq{($nx-1).",$ny"}++;
                        unshift @nq => [$nx, $ny] unless $nq{"$nx,$ny"}++;
                    } elsif ($g eq '#') {
                        die;
                    }
                }
                unshift @q => @nq;
            }
        }
    }

    draw();
}


my $s = 0;
for (keys %g) {
    next unless $g{$_} eq '[';
    my ($x, $y) = split ',';
    $s += $y * 100 + $x;
}

print "Sum: $s\n";

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};

            if ($x == $px && $y == $py) {
                print color('on_rgb113'), " $g ", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), " • ", color('reset');
            } elsif ($g eq '[') {
                print color('on_rgb210'), " ${g}>", color('reset');
            } elsif ($g eq ']') {
                print color('on_rgb210'), "<$g ", color('reset');
            } elsif ($g eq '#') {
                print color('on_rgb111'), "   ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    print "\n";
    $lines++;
    sleep 0.2;
}
