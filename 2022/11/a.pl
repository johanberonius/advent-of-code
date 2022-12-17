#!/usr/bin/perl
use strict;

my @m;
my $m;

while (<>) {
    $m = 0+$1 if /Monkey (\d+)/;
    $m[$m]{items} = [map 0+$_, split /,\s*/, $1] if /Starting items:\s*((\d+,?\s*)+)/;
    $m[$m]{operation} = $1 if /Operation: .*([+*]\s+(\d+|old))/;
    $m[$m]{test} = 0+$1 if /Test: .*?(\d+)/;
    $m[$m]{destination}[1] = 0+$1 if /If true: .*?(\d+)/;
    $m[$m]{destination}[0] = 0+$1 if /If false: .*?(\d+)/;
}


my $r = 0;
round: while (++$r <= 20) {

    for $m (0..$#m) {
        # print "monkey: $m\n";
        # print "items: @{$m[$m]{items}}\n";

        while (@{$m[$m]{items}}) {
            my $item = shift @{$m[$m]{items}};
            $m[$m]{inspections}++;
            # print "$item\n";

            $m[$m]{operation} =~ s/old/\$item/;
            $item = eval "$item $m[$m]{operation}";
            # print "$item\n";

            $item = int $item / 3;
            # print "$item\n";

            push @{$m[ $m[$m]{destination}[ $item % $m[$m]{test} == 0 ] ]{items}} => $item;
            # print "to monkey $m[$m]{destination}[ $item % $m[$m]{test} == 0 ]\n";
            # print "\n";

        }
        # last round;
    }
}


for $m (0..$#m) {
    print "Monkey $m inspected items $m[$m]{inspections} times.\n";
}

my ($i, $j) = sort {$b <=> $a} map $m[$_]{inspections}, 0..$#m;
print "Level of monkey business: ", $i * $j, "\n";

# use Data::Dumper;
# print Dumper(\@m);