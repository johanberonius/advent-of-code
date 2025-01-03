#!/usr/bin/perl
use strict;
use List::Util qw(min max product sum);

chomp(my $input = <>);
print "Input: $input\n";

my %h2b = (
    0 => '0000',
    1 => '0001',
    2 => '0010',
    3 => '0011',
    4 => '0100',
    5 => '0101',
    6 => '0110',
    7 => '0111',
    8 => '1000',
    9 => '1001',
    A => '1010',
    B => '1011',
    C => '1100',
    D => '1101',
    E => '1110',
    F => '1111',
);

$input =~ s/[0-9A-F]/$h2b{$&}/eg;
print "Binary: $input\n";

my $bits = [map 0+$_, split '', $input];

my @values = read_packets($bits);
print "Values: @values\n";

sub read_packets {
    my $bits = shift;
    my $limit = shift;
    my @values;

    my $count = 0;
    while (@$bits) {
        print "Remaining bits: ", 0+@$bits, "\n";
        last if @$bits <= 7;

        my $version = eval "0b" . join '', splice @$bits, 0, 3;
        print "Version: $version\n";

        my $type = eval "0b" . join '', splice @$bits, 0, 3;
        print "Type: $type\n";

        if ($type == 4) {
            my $continue = 1;
            my $value = '';
            while ($continue) {
                $continue = shift @$bits;
                $value .= join '', splice @$bits, 0, 4;
            }
            $value = eval "0b" . $value;
            print "Value: $value\n";
            push @values => $value;
        } else {
            my $lengthType = shift @$bits;
            my @subvalues;
            print "Operator, ";
            if ($lengthType) {
                my $packets = eval "0b" . join '', splice @$bits, 0, 11;
                print "sub packets: $packets\n";
                @subvalues = read_packets($bits, $packets);
                print "sub packets read.\n";
            } else {
                my $length = eval "0b" . join '', splice @$bits, 0, 15;
                print "sub data length: $length\n";
                my @data = splice @$bits, 0, $length;
                @subvalues = read_packets(\@data);
                print "sub data read.\n";
            }

            my $value;
            if ($type == 0) {
                $value = sum @subvalues;
            } elsif ($type == 1) {
                $value = product @subvalues;
            } elsif ($type == 2) {
                $value = min @subvalues;
            } elsif ($type == 3) {
                $value = max @subvalues;
            } elsif ($type == 5) {
                $value = $subvalues[0] > $subvalues[1];
            } elsif ($type == 6) {
                $value = $subvalues[0] < $subvalues[1];
            } elsif ($type == 7) {
                $value = $subvalues[0] == $subvalues[1];
            }
            print "Value: $value\n";
            push @values => $value;

        }
        print "\n";

        last if $limit > 0 && ++$count >= $limit;
    }

    return @values;
}
