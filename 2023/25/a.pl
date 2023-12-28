#!/usr/bin/perl
use strict;

# input
my @disconnect = (
    ['thl', 'nmv'],
    ['mbq', 'vgk'],
    ['fzb', 'fxr'],
);

# # test1
# my @disconnect = (
#     ['hfx', 'pzl'],
#     ['bvb', 'cmg'],
#     ['nvd', 'jqt'],
# );

my %m;
while (<>) {
    my ($s, @d) = /(\w+)/g or die;

    for my $d (@d) {
        $m{$s}{$d}++;
        $m{$d}{$s}++;
    }
}

for (@disconnect) {
    my ($s, $d) = @$_;
    delete $m{$s}{$d};
    delete $m{$d}{$s};
}

my %c;
my @q = ((keys %m)[0]);
while (@q) {
    my $m = shift @q;
    next if $c{$m}++;
    push @q => keys %{$m{$m}};
}

my $m = keys %m;
my $c = keys %c;
my $o = $m - $c;

print "Modules: $m\n";
print "Cluster sizes: $c and $o\n";
print "Product: ", $c * $o, "\n";
