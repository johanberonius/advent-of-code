#!/usr/bin/perl
use List::Util qw(uniq);

# $/=\1;@o=@s=<>;shift@s while 14>uniq@s[0..13];print@o-@s+14
# @s=split'',<>;$i++while 14>uniq@s[$i-14..$i-1];print$i
# $/=\1;$s[@s]=<>while@s<14||14>uniq@s[-14..-1];print@s-0
# $/=\1;$s[@s]=<>while 14>uniq@{[@s[-14..-1]]};print@s-0
$/=\1;@s=<>;$i++while 14>uniq@s[$i-14..$i-1];print$i
