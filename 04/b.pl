#!/usr/bin/perl
use strict;

my @p = split /\s*\n\s*\n\s*/, join '', <>;

print "Number of passports: ", 0+@p, "\n";

my $v = 0;
for my $p (@p) {
    my %p = map { split ':' } split /\s+/, $p;

    next unless 7 == grep $_ ne 'cid', keys %p;
    next unless $p{byr} >= 1920 && $p{byr} <= 2002;
    next unless $p{iyr} >= 2010 && $p{iyr} <= 2020;
    next unless $p{eyr} >= 2020 && $p{eyr} <= 2030;
    next unless $p{hgt} =~ /^\d+cm$/i && $p{hgt} >= 150 && $p{hgt} <= 193 ||
                $p{hgt} =~ /^\d+in$/i && $p{hgt} >= 59 && $p{hgt} <= 76;
    next unless $p{hcl} =~ /^#[0-9a-fA-F]{6}$/;
    next unless $p{ecl} =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/i;
    next unless $p{pid} =~ /^\d{9}$/i;
    $v++;
}

print "$v valid passports.\n";
