#!/usr/bin/perl
use strict;

my $p = "fbgdceah";

my @i;
while (<>) {
    if (/swap position (\d+) with position (\d+)/) {
        push @i => ['swp', $1, $2];
    } elsif (/swap letter (\w) with letter (\w)/) {
        push @i => ['swl', $1, $2];
    } elsif (/rotate left (\d+) step/) {
        push @i => ['rol', $1];
    } elsif (/rotate right (\d+) step/) {
        push @i => ['ror', $1];
    } elsif (/rotate based on position of letter (\w)/) {
        push @i => ['rop', $1];
    } elsif (/reverse positions (\d+) through (\d+)/) {
        push @i => ['rev', $1, $2];
    } elsif (/move position (\d+) to position (\d+)/) {
        push @i => ['mov', $1, $2];
    } else {
        die $_;
    }
}

for (reverse @i) {
    my ($i, $a, $b) = @$_;

    if ($i eq 'swp') {
        my $p1 = $p;
        (substr($p, $a, 1), substr($p, $b, 1)) = (substr($p, $b, 1), substr($p, $a, 1));
        my $p2 = $p;
        (substr($p2, $a, 1), substr($p2, $b, 1)) = (substr($p2, $b, 1), substr($p2, $a, 1));
        print "swp not reversible, p1: $p1, p2: $p2, p: $p\n" unless $p1 eq $p1;

    } elsif ($i eq 'swl') {
        my $p1 = $p;
        eval qq(\$p =~ tr/$a$b/$b$a/);
        my $p2 = $p;
        eval qq(\$p2 =~ tr/$a$b/$b$a/);
        print "swl not reversible, p1: $p1, p2: $p2, p: $p\n" unless $p1 eq $p1;

    } elsif ($i eq 'rol') {
        $a %= length $p;
        $p =~ s/(.{$a})(.*)/$2$1/;

    } elsif ($i eq 'ror') {
        $a %= length $p;
        $p =~ s/(.*)(.{$a})/$2$1/;

    } elsif ($i eq 'rop') {

        my $p1 = $p;
        for (0..length($p)-1) {
            $p =~ s/(.)(.*)/$2$1/;

            my $p2 = $p;
            my $i = index $p2, $a;
            $i++ if $i >= 4;
            $i++;
            $i %= length $p2;
            $p2 =~ s/(.*)(.{$i})/$2$1/;

            last if $p1 eq $p2;
        }


    } elsif ($i eq 'rev') {
        my $s = substr $p, $a, $b-$a+1;
        substr $p, $a, $b-$a+1, reverse $s;

    } elsif ($i eq 'mov') {
        my $s = substr $p, $b, 1, '';
        my $l = substr $p, $a, 1;
        substr $p, $a, 1, "$s$l";
    } else {
        die $i;
    }

    # print "$p\n";
}

print "$p\n";
