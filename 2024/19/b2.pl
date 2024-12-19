#!/usr/bin/perl
use strict;

$_ = <>;
chomp;
my @t = split /\s*,\s*/;
my @d = map { chomp; $_ || () } <>;

print "Towels: ", 0+@t, "\n";
print "Designs: ", 0+@d, "\n";

my $t = 0;
for my $d (@d) {
    print "Testing design: $d\n";
    my $c = c($d);
    print "Possible combinations: $c\n";
    $t += $c;
}

print "Sum of possible combinations: $t\n";


my %c;
sub c {
    my $d = shift;
    return $c{$d} if exists $c{$d};

    my $c = 0;
    for my $t (@t) {
        if ($d eq $t) {
            $c++;
        } elsif (rindex($d, $t, 0) == 0) {
            $c += c(substr($d, length($t)));
        }
    }

    return $c{$d} = $c;
}

