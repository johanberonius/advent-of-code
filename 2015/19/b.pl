#!/usr/bin/perl
use strict;
use List::Util qw(min);

my @r;
my $t;
while (<>) {
    if (/(\w+) => (\w+)/) {
        push @r => [$1, $2];
    } elsif (/(\w+)/) {
        $t = $1;
    }
}


my %m;
my $i = 0;
my $s = synth('e', 0);


# my $s = reveng($t, 0);
# print "Synthesized $t in $s steps and $i iterations.\n";


print "$i: m#: ", 0+keys %m, "\n";


sub synth {
    my $m = shift;
    my $l = shift;
    $i++;

    $m{$m} = $l;

    return if $l >= 10;

    print "$i: l: $l, m: $m{$m}, m#: ", 0+keys %m, " $m\n" unless $i % 100_000;

    my @s;
    for my $r (@r) {
        # print "Rule $r->[0] => $r->[1]\n";
        $m =~ s/$r->[0]/push @s => "$`$r->[1]$'"; $&/ge;
    }

    unless (@s) {
        print "No subs: l: $l, $m\n";
    }


    for (@s) {
        synth($_, $l+1) unless $m{$_};
    }
    # print "Set memo: $m in $m{$m} steps.\n";

}


sub reveng {
    my $m = shift;
    my $l = shift;

    if ($m eq 'e') {
        print "Found e at level $l\n";
        return 0;
    }

    $i++;
    print "$i: l: $l, m: $m{$m}, m#: ", 0+keys %m, " $m\n" unless $i % 100_000;

    my @s;
    for my $r (@r) {
        # print "Rule $r->[0] => $r->[1]\n";
        if ($r->[0] eq 'e') {
            push @s => 'e' if $r->[1] eq $m;
        } else {
            $m =~ s/$r->[1]/push @s => "$`$r->[0]$'"; $&/ge;
        }
    }

    unless (@s) {
        print "No subs: l: $l, $m\n";
        return $m{$m} = 999_999;
    }


    $m{$m} = 1 + min map { $m{$_} || reveng($_, $l+1) } @s;
    # print "Set memo: $m in $m{$m} steps.\n";
    return $m{$m};
}
