#!/usr/bin/perl
use strict;
use List::Util qw(sum);


my %i;
my %a;
my %m;
my %c;
my $f = 0;
while (<>) {
    if (/([\w\s]+)\s+\(contains\s*(.+?)\)/) {
        $f++;
        my @i = split /\s+/, $1;
        $i{$_}++ for @i;
        my @a = split /\s*,\s*/, $2;
        for my $a (@a) {
            $a{$a}++;

            unless ($m{$a}) {
                $m{$a}{$_}++ for @i;
            } else {
                my %j = map { $_ => 1 } @i;
                for (keys %{$m{$a}}) {
                    delete $m{$a}{$_} unless $j{$_};
                }
            }

        }
    }
}

print "Food items: $f\n";
print "Ingredients: ", 0+keys %i, "\n";
print "Allergens: ", 0+keys %a, "\n";

while (%m) {
    my ($a) = grep keys %{$m{$_}} == 1, keys %m;
    die "No unique allergen found" unless $a;

    my @i = keys %{$m{$a}};
    my $i = $i[0];
    print "$a is contained in $i\n";

    $c{$i} = $a;
    delete $m{$a};
    delete $m{$_}{$i} for keys %m;
}

my @f = grep !$c{$_}, keys %i;
my $f = sum map $i{$_}, @f;
print "Allergen free ingredients: ", 0+@f, ", appears $f times.\n";

my $d = join ',', sort { $c{$a} cmp $c{$b} } keys %c;
print "Dangerous ingredients: $d\n";
