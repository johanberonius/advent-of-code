#!/usr/bin/perl
use strict;
my ($r0, $r1, $r3, $r4, $r5);
l0: $r3 = 123;
l1: $r3 = $r3 & 456;
l2: $r3 = $r3 == 72;
l3: goto 'l'.($r3 + 3 + 1);
l4: goto l1;
l5: $r3 = 0;
l6: $r4 = $r3 | 65536;
l7: $r3 = 10649702;
l8: $r5 = $r4 & 255;
l9: $r3 = $r3 + $r5;
l10: $r3 = $r3 & 16777215;
l11: $r3 = $r3 * 65899;
l12: $r3 = $r3 & 16777215;
l13: $r5 = 256 > $r4;
l14: goto 'l'.($r5 + 14 + 1);
l15: goto 'l'.(15 + 2);
l16: goto l28;
l17: $r5 = 0;
l18: $r1 = $r5 + 1;
l19: $r1 = $r1 * 256;
l20: $r1 = $r1 > $r4;
l21: goto 'l'.($r1 + 21 + 1);
l22: goto 'l'.(22 + 2);
l23: goto l26;
l24: $r5 = $r5 + 1;
l25: goto l18;
l26: $r4 = $r5;
l27: goto l8;
l28: $r5 = $r3 == $r0;
l29: goto 'l'.($r5 + 29 + 1);
l30: goto l6;