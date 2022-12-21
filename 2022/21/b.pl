#!/usr/bin/perl
use strict;

my %value;
my ($a, $b);
while (<>) {
    chomp;
    my ($key, $value) = split ': ';
    ($a, $b) = split ' \+ ', $value if $key eq 'root';
    $value =~ s/([a-z]+)/value('$1')/g;
    $value{$key} = $value;
}

sub value {
    my $key = shift;
    return 0+$value{$key} || eval $value{$key};
}


my $result = value($b);
my $id = 'humn';
my @ids;
my %ids = ($id => 1);
while (1) {
    ($id) = grep $value{$_} =~ /'$id'/, keys %value;
    last if $id eq 'root';
    unshift @ids => $id;
    $ids{$id}++;
}

print "Value: $b, $result\n";
print "Depends on ids: @ids\n";

for my $id (@ids) {
    my $operation = $value{$id};
    my ($other) = grep !$ids{$_}, $operation =~ /'([a-z]+)'/g;
    my ($this) = grep $ids{$_}, $operation =~ /'([a-z]+)'/g;
    my $value = value($other);
    my $reverse = $operation =~ /$other.+$this/;

    printf "Id: $id, other: $other, value: %4d, operation: $operation, $result ", $value;

    if ($operation =~ '\/') {
        $result *= $value;
        print "*";
    } elsif ($operation =~ '\*') {
        $result /= $value;
        print "/";
    } elsif ($reverse && $operation =~ '\-') {
        $result = $value - $result;
        print "<-";
    } elsif ($operation =~ '\-') {
        $result += $value;
        print "+";
    } elsif ($operation =~ '\+') {
        $result -= $value;
        print "-";
    } else {
        die $operation;
    }

    print " $value = $result\n";
}



$value{humn} = $result;

print "Human value: $value{humn}\n";
print "$a: ", value($a), "\n";
print "$b: ", value($b), "\n";


# 3087390115721 correct answer
