#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;

my $r = 0;
my $pc = 0;
my @p = map 0+$_, split ',', join '', <>;
print "Program loaded, length: ", 0+@p, "\n";

my @q = (
    'west',
    'west',
    'west',
    'west',
    'take dark matter',
    'east',
    'south',
    'take fixed point',
    'west',
    'take food ration',
    'east',
    'north',
    'east',
    'east',
    'south',
    'south',
    'south',
    'take asterisk',
    'north',
    'north',
    'east',
    'south',
    'north',
    'west',
    'north',
    'west',
    'south',
    'take astronaut ice cream',
    'south',
    'take polygon',
    'east',
    'north',
    'south',
    'take easter egg',
    'east',
    'take weather machine',
    'north',
    'north',
);
my @in;
my $out;
my ($x, $y) = (0, 0);
my ($nx, $ny) = (0, 0);
my %c = ("$x,$y" => '@');
my $i = 0;
my @o = run();

draw();
print "Output value: @o\n";

sub input {

    unless ($out =~ /you (can't (go that way|move)|are ejected back)/is) {
        $c{"$x,$y"} = '.';
        ($x, $y) = ($nx, $ny);
        $c{"$x,$y"} = '@';
    } else {
        ($nx, $ny) = ($x, $y);
    }

    my ($n, $s) = ($y - 1, $y + 1);
    my ($w, $e) = ($x - 1, $x + 1);
    $c{"$w,$y"} ||= $out =~ /doors.+lead.+west/is ? '|' : '#';
    $c{"$e,$y"} ||= $out =~ /doors.+lead.+east/is ? '|' : '#';
    $c{"$x,$n"} ||= $out =~ /doors.+lead.+north/is ? '-' : '#';
    $c{"$x,$s"} ||= $out =~ /doors.+lead.+south/is ? '-' : '#';
    $c{"$w,$n"} = '#';
    $c{"$e,$n"} = '#';
    $c{"$w,$s"} = '#';
    $c{"$e,$s"} = '#';

    if ($out =~ /you are ejected back/is and $i <= 255) {
        print "Too heavy!\n" if $out =~ /lighter/is;
        print "Too light!\n" if $out =~ /heavier/is;
        push @q => (
            ($i & 1 ? 'take' : 'drop') .' asterisk',
            ($i & 2 ? 'take' : 'drop') .' astronaut ice cream',
            ($i & 4 ? 'take' : 'drop') .' dark matter',
            ($i & 8 ? 'take' : 'drop') .' fixed point',
            ($i & 16 ? 'take' : 'drop') .' food ration',
            ($i & 32 ? 'take' : 'drop') .' polygon',
            ($i & 64 ? 'take' : 'drop') .' weather machine',
            ($i & 128 ? 'take' : 'drop') .' easter egg',
            'north',
        );
        print "Trying combination of items: $i\n";

       $i++;
    }



    draw() unless @q;
    $out = '';
    my $in = @q ? shift @q : <>;
    chomp $in;

    if ($in eq "n" or $in eq "north") {
        $in = "north";
        ($nx, $ny) = ($x, $y - 2);
    } elsif ($in eq "s" or $in eq "south") {
        $in = "south";
        ($nx, $ny) = ($x, $y + 2);
    } elsif ($in eq "e" or $in eq "east") {
        $in = "east";
        ($nx, $ny) = ($x + 2, $y);
    } elsif ($in eq "w" or $in eq "west") {
        $in = "west";
        ($nx, $ny) = ($x - 2, $y);
    }

    $in =~ s/^i$/inv/;
    $in =~ s/^t /take /;
    $in =~ s/^d /drop /;

    push @in => map ord, split '', "$in\n";
}


sub draw {
    print "\033[2J\033[H"; # Clear Home

    my @x = map [split ',']->[0], keys %c;
    my @y = map [split ',']->[1], keys %c;
    my $w = max(@x) - min(@x) + 1;
    my $h = max(@y) - min(@y) + 1;
    print "Width: $w\n";
    print "Height: $h\n";
    print "Size: ", $w * $h, "\n";
    print "Position: $x,$y\n";

    for my $py (min(@y, -4) .. max(@y, 4)) {
        for my $px (min(@x, -10) .. max(@x, 10)) {
            my $c = $c{"$px,$py"};
            if ($c eq '#') {
                print color('white', 'on_black'), '   ';
            } elsif ($c eq '@') {
                print color('black', 'on_green'), " $c "
            } elsif ($c eq '.') {
                print color('black', 'on_cyan'), ' • ';
            } elsif ($c eq '|' or $c eq '-') {
                print color('black', 'on_cyan'), " $c ";
            } else {
                print color('reset'), '   ';
            }
        }
        print color('reset'), "\n";
    }

    print "\n", $out;
}


sub run {
    my @o;

    while (1) {
        die "Program counter out of bounds: $pc" if $pc < 0 || $pc > $#p;

        my $i = $p[$pc] % 100;
        my @m = reverse split '', int($p[$pc] / 100);
        $pc++;

        my $param = sub {
            my $w = shift;
            my $m = shift @m;
            my $a = $p[$pc++];
            $a = $r + $a if $m == 2;
            die "Immediate mode not valid for write parameter" if $w && $m == 1;
            $a = $p[$a] if ($m == 0 || $m == 2) && !$w;
            return $a;
        };

        # ADD, MUL, LESS THAN, EQUALS
        if ($i == 1 || $i == 2 || $i == 7 || $i == 8) {
            my $a = $param->();
            my $b = $param->();
            my $c = $param->('w');

            $p[$c] = $a + $b if $i == 1;
            $p[$c] = $a * $b if $i == 2;
            $p[$c] = 0+($a < $b) if $i == 7;
            $p[$c] = 0+($a == $b) if $i == 8;
        }
        # INPUT
        elsif ($i == 3) {
            my $a = $param->('w');
            input() unless @in;
            my $b = 0+shift @in;
            # print "Input: $b\n";
            $p[$a] = $b;
        }
        # OUTPUT
        elsif ($i == 4) {
            my $a = $param->();
            if ($a < 256) {
                $out .= chr $a;
            } else {
                push @o => $a;
            }
        }
        # JUMP if true, JUMP if false
        elsif ($i == 5 || $i == 6) {
            my $a = $param->();
            my $b = $param->();

            if ($i == 5 && $a or $i == 6 && !$a) {
                $pc = $b;
                next;
            }
        }
        # RELATIVE BASE
        elsif ($i == 9) {
            my $a = $param->();
            $r += $a;
        }
        # HALT
        elsif ($i == 99) {
            print "Program halted.\n";
            last;
        } else {
            die "Unknown inctruction: $i";
        }
    }

    return @o;
}
