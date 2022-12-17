#!/usr/bin/perl
use strict;

my @s;
while (<>) {
    if (/scanner\s+(\d+)/) {
        push @s => [[]];
    } elsif (/(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)/) {
        push @{$s[-1][-1]} => [0+$1, 0+$2, 0+$3]
    }
}

print "Scanners: ", 0+@s, "\n";
print "Scanner 0 orientation 0 points: ", 0+@{$s[0][0]}, "\n";


my @m;
for my $x (0..2) {
    for my $y (0..2) {
        next if $y == $x;
        for my $z (0..2) {
            next if $z == $y || $z == $x;
            for my $ix (1,-1) {
                for my $iy (1,-1) {
                    for my $iz (1,-1) {
                        push @m => [$x, $y, $z,  $ix, $iy, $iz];
                    }
                }
            }
        }
    }
}

# my @m = (
#     [0, 1, 2,   1,  1,  1],
#     [1, 0, 2,   1, -1,  1],
#     [0, 1, 2,  -1, -1,  1],
#     [1, 0, 2,  -1,  1,  1],
# );


print "Variants: ", 0+@m, "\n";

for my $s (@s) {
    for my $m (@m[1..$#m]) {
        my $v = [];
        push @$s => $v;
        for my $p (@{$s->[0]}) {

            push @$v => [
                $p->[$m->[0]] * $m->[3],
                $p->[$m->[1]] * $m->[4],
                $p->[$m->[2]] * $m->[5],
            ];
        }
    }
}

my %w;
print "Locating scanner 0 at 0, 0, 0.\n";
for my $p (@{$s[0][0]}) {
    $w{join ',', @$p}++;
}
shift @s;
print "Scanners remaining: ", 0+@s, "\n";

while (@s) {
    scanner:
    for my $s (@s) {
        for my $v (@$s) {
            for my $w (keys %w) {
                my ($wx, $wy, $wz) = split ',', $w;

                for my $p (@$v) {
                    my ($px, $py, $pz) = @$p;
                    my ($ox, $oy, $oz) = ($wx - $px, $wy - $py, $wz - $pz);

                    my $pn = grep {
                        my ($px, $py, $pz) = @$_;
                        my ($tx, $ty, $tz) = ($ox + $px, $oy + $py, $oz + $pz);
                        $w{"$tx,$ty,$tz"};
                    } @$v;

                    if ($pn >= 12) {
                        print "Matching points: $pn\n";
                        print "Locating scanner at $ox, $oy, $oz.\n";
                        for my $wp (@$v) {
                            my ($px, $py, $pz) = @$wp;
                            my ($tx, $ty, $tz) = ($ox + $px, $oy + $py, $oz + $pz);
                            $w{"$tx,$ty,$tz"}++;
                        }

                        undef $s;
                        last scanner;
                    }
                }
            }
        }
    }
    @s = grep $_, @s;
    print "Scanners remaining: ", 0+@s, "\n";
}

my $b = 0+keys %w;
print "Beacons in world space: $b\n";


# use Data::Dumper;
# print Dumper(\%w);
