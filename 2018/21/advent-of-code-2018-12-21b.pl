#!/usr/bin/perl
use strict;

die "Bitwise AND should be numeric" unless (123 & 456) == 72;

my $c = 0;
my $r = 10_504_829; # == 0xA0_4A7D;
my $x;
my $x2;
my $y;
my %s;
while() {
    $y = $x | 65_536; # == 0x10000
    $x = 10_649_702; # == 0xA2_8066

    while () {
        $x += $y & 255;
        $x &= 16_777_215; # == 0xFF_FFFF;
        $x *= 65_899; # == 0x1_016B
        $x &= 16_777_215; # == 0xFF_FFFF;
        last if $y < 256;
        $y >>= 8;
    }

    unless ($c % 1_000_000) {
        print "$c, \t x: $x, y: $y\n";
    }

    $c++;
    # last if $c > 20_000;
    # last if $x == $r && $x2;
    last if $s{$x};

    $x2 = $x;
    $s{$x} = $c;
}

print "Seen $x before after $c iterations\n";
print "Last value not seen before: $x2\n";
