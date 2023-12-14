#!/usr/bin/perl
use strict;

my $pc = 0;
my $s = 0;
my %c;
while (<>) {
    chomp;
    my ($p, $l) = split ' ';

    $p = join '?', ($p) x 5;
    $l = join ',', ($l) x 5;

    $p =~ s/\.{2,}/./g;
    $p =~ s/^\.+|\.+$//g;

    my @l = map 0+$_, split ',', $l;

    $pc++;
    print "$pc: $p @l\n";

    my $c = branch($p, [@l]);

    print "Combinations: $c\n\n";
    $s += $c;
}

print "Sum: $s\n";


sub branch {
    my $p = shift @_;
    my $l = shift @_;
    my $k = "$p @$l";
    my $c = $c{$k};
    return $c if defined $c;

    my $n = shift @$l;
    for my $o (0..length($p) - $n) {
        if ($p =~ /^[^#]{$o}[#?]{$n}([.?]|$)/) {
            if (@$l) {
                $c += branch($', [@$l]);
            } elsif ($' !~ /#/) {
                $c++;
            }
        }
        last if substr($p, $o, 1) eq '#';
    }

    return $c{$k} = $c;
}
