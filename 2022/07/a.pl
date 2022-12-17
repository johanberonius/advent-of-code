#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my $root = { dirs => {'/' => {}}};
my $cwd = $root;

while (<>) {
    if (/^\$\s+cd\s+(\w+|\/)\s*$/) {
        $cwd = $cwd->{dirs}{$1} or die "Unknown directory: $1\n";
    } elsif (/^\$\s+cd\s+\.\.\s*$/) {
        $cwd = $cwd->{parent} or die "Directory has no parent: $cwd->{name}\n";
    } elsif (/^\$\s+ls/) {
    } elsif (/^dir\s+(\w+)\s*$/) {
        $cwd->{dirs}{$1} = { name => $1, parent => $cwd };
    } elsif (/^(\d+)/) {
        $cwd->{size} += $1;
    } else {
        die "Unrecognized command: $_\n";
    }
}


my $total = 0;
du($root);
sub du {
    my $cwd = shift;
    $cwd->{du} = $cwd->{size} + sum map du($_), values %{$cwd->{dirs}};
    $total += $cwd->{du} if $cwd->{du} <= 100000;
    return $cwd->{du};
}

print "Sum of the total sizes of large directories: $total\n";

# use Data::Dumper;
# print Dumper($root);
