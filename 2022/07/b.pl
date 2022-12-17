#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my $space = 70000000;
my $root = { dirs => {'/' => {}}};
my $cwd = $root;

while (<>) {
    if (/^\$\s+cd\s+(\w+|\/)\s*$/) {
        $cwd = $cwd->{dirs}{$1} or die "Unknown directory: $1\n";
        <> =~ /^\$\s+ls/ or die "cd now followed by ls\n";
    } elsif (/^\$\s+cd\s+\.\.\s*$/) {
        $cwd = $cwd->{parent} or die "Directory has no parent: $cwd->{name}\n";
    } elsif (/^dir\s+(\w+)\s*$/) {
        $cwd->{dirs}{$1} = { name => $1, parent => $cwd };
    } elsif (/^(\d+)/) {
        $cwd->{size} += $1;
    } else {
        die "Unrecognized command: $_\n";
    }
}

du($root);
sub du {
    my $cwd = shift;
    $cwd->{du} = $cwd->{size} + sum map du($_), values %{$cwd->{dirs}};
    return $cwd->{du};
}

my $free = $space - $root->{du};
my $required = 30000000 - $free;

print "Total space: $space\n";
print "Used space: $root->{du}\n";
print "Free space: $free\n";
print "Required space: $required\n";

my @dirs;
find($root);
sub find {
    my $cwd = shift;
    push @dirs => $cwd if $cwd->{du} >= $required;
    find($_) for values %{$cwd->{dirs}};
}

my ($dir) = sort { $a->{du} <=> $b->{du} } @dirs;
print "Size of smallest dir above required size: $dir->{du}\n";

# use Data::Dumper;
# print Dumper($root);
