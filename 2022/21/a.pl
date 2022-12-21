#!/usr/bin/perl
use strict;

my %value;
while (<>) {
    chomp;
    my ($key, $value) = split ': ';
    $value =~ s/([a-z]+)/value('$1')/g;
    $value{$key} = $value;
}

sub value {
    my $key = shift;
    return 0+$value{$key} || eval $value{$key};
}

print value('root'), "\n";
