#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my $i = 10_551_410;
my $r = sum grep $i % $_ == 0, 1..$i;

# for my $y (1..$i) {
#     $r += $y unless $i % $y;
# }

# loop:
# for my $y (1..$i) {
#     for my $x (1..$i) {
#         my $xy = $y * $x;
#         if ($xy > $i) {
#             next loop;
#         } elsif ($xy == $i) {
#             $r += $y;
#             next loop;
#         }
#     }
# }

print "r: $r\n";


__END__
use strict;
my ($r0, $r1, $r2, $r3, $r4);
l0: goto 'l'.(0 + 17);
l1: $r3 = 1;
l2: $r2 = 1;
l3: $r4 = $r3 * $r2;
l4: $r4 = $r4 == $r1;
l5: goto 'l'.($r4 + 5 + 1);
l6: goto 'l'.(6 + 2);
l7: $r0 = $r3 + $r0;
l8: $r2 = $r2 + 1;
l9: $r4 = $r2 > $r1;
l10: goto 'l'.(10 + $r4 + 1);
l11: goto l3;
l12: $r3 = $r3 + 1;
l13: $r4 = $r3 > $r1;
l14: goto 'l'.($r4 + 14 + 1);
l15: goto l2;
l16: goto 'l'.(16 * 16);
l17: $r1 = $r1 + 2;
l18: $r1 = $r1 * $r1;
l19: $r1 = 19 * $r1;
l20: $r1 = $r1 * 11;
l21: $r4 = $r4 + 7;
l22: $r4 = $r4 * 22;
l23: $r4 = $r4 + 20;
l24: $r1 = $r1 + $r4;
l25: goto 'l'.(25 + $r0 + 1);
l26: goto l1;
l27: $r4 = 27;
l28: $r4 = $r4 * 28;
l29: $r4 = 29 + $r4;
l30: $r4 = 30 * $r4;
l31: $r4 = $r4 * 14;
l32: $r4 = $r4 * 32;
l33: $r1 = $r1 + $r4;
l34: $r0 = 0;
l35: goto l1;
