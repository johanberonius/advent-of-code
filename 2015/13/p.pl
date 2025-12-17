#!/usr/bin/perl
use strict;

my %s;
my $m = 0;
my $i = 0;
for (permutations(1..5)) {
    my @r = reverse @$_;
    print "@$_ ";
    if ($s{"@r"}++ || $s{"@$_"}++) {
        print "mirror";
        $m++;
    }
    print "\n";
    $i++;
}

print "Permutations: $i\n";
print "Mirrors: $m\n";


sub permutations {
    my @p;
    my @q = ([[], @_]);
    while (@q) {
        my ($d, @s) = @{shift @q};
        push @p => $d unless @s;
        push @q => [[@$d, $s[$_]], @s[0..$_-1, $_+1..$#s]] for 0..$#s;
    }

    return @p;
}
