#!/usr/bin/perl
use strict;


print <<'END';
#!/usr/bin/perl
use strict;

my ($w, $x, $y, $z);
my @i = split '', <>;

END

while (<>) {
    die "$_\n" unless my ($o, $a, $b) = /(\w+)\s+([wxyz])(?:\s?([wxyz]|-?\d+))?/;

    $a = "\$$a";
    $b = "\$$b" if $b =~ /[wxyz]/;

    if ($o eq 'inp') {
        print "$a = shift \@i;\n";
    } elsif ($o eq 'add') {
        print "$a += $b;\n";
    } elsif ($o eq 'mul') {
        print "$a *= $b;\n";
    } elsif ($o eq 'div') {
        print "$a = int($a / $b);\n";
    } elsif ($o eq 'mod') {
        print "$a %= $b;\n";
    } elsif ($o eq 'eql') {
        print "$a = $a == $b || 0;\n";
    } else {
        warn "Unrecognized instruction: $o $a $b\n";
    }

}
