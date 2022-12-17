#!/usr/bin/perl
use strict;

my @inst;
while (<>) {
    chomp;
    push @inst => [split /\s+/];
}

my $s = 0;
my $pc = 0;
my $mul = 0;
my %reg = (a => 0);
while ($inst[$pc]) {
    $s++;
    my ($i, $a, $b) = @{$inst[$pc]};
    my ($av, $bv) = map 0+$_ || 0+$reg{$_}, $a, $b;

    if ($i eq 'set') {
        $reg{$a} = $bv;
    } elsif ($i eq 'sub') {
        $reg{$a} -= $bv;
    } elsif ($i eq 'mul') {
        $reg{$a} *= $bv;
        $mul++;
    } elsif ($i eq 'jnz') {
        if ($av != 0) {
            $pc += $bv;
            next;
        }
    } else {
        die "Unmatched intruction '$i $a:$av $b:$bv' at $pc.\n";
    }




    $pc++;

    # print "$pc: $i $a:$av $b:$bv \t (a: $reg{a}, b: $reg{b}, c: $reg{c}, d: $reg{d}, e: $reg{e}, f: $reg{f}, g: $reg{g}, h: $reg{h})\n";
    # last if $s > 200;

    if ($s > 1_000_000) {
        print "Interupted.\n";
        last;
    }

}
use Data::Dumper;

print "Program ended after $s steps.\n";
print "Mul invoked $mul times.\n";
print "(", join(', ', map "$_: $reg{$_}", 'a'..'h'), ")\n";


# a 1
# b 57
# c 57

# a 1
# b 105700
# c 122700
