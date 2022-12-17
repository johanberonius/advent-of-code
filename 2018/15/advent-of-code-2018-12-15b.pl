#!/usr/bin/perl
use strict;
use List::Util qw(sum max);
use Term::ANSIColor;

my %maze;
my %maze_init;
my %health;
my %health_init;
my $width;
my $y = 0;
my $elves = 0;
my $goblins = 0;
while (<>) {
    chomp;
    my $x = 0;
    for my $s (split '') {
        if ($s eq 'E') {
            $s .= ++$elves;
            $health_init{$s} = 200;
        }
        if ($s eq 'G') {
            $s .= ++$goblins;
            $health_init{$s} = 200;
        }
        $maze_init{"$x,$y"} = $s;
        $x++;
    }
    $width = $x if $width < $x;
    $y++;
}
my $height = $y;

print "Maze size ${width}x$height\n";
print "Elves: $elves, goblins: $goblins\n";
print "\n";

my $round;
my $power = 4;
power: while () {
    %maze = %maze_init;
    %health = %health_init;

    print "Elves power: $power\n";

    $round = 0;
    round: while () {
        $elves = grep is_elve($_), keys %health;
        $goblins = grep is_goblin($_), keys %health;
        print "After $round rounds, $elves elves and $goblins goblins alive.\n";
        show();

        unit: for my $unit_position (sort { readingorder($a, $b) } grep units($_), keys %maze) {
            my ($unit_x, $unit_y) = split ',', $unit_position;
            my $unit = $maze{$unit_position};

            # print "$unit at $unit_position\n";

            next unit if $health{$unit} <= 0;

            # Move
            move: {
                # 1. find targets in range
                my @attack_positions = grep { is_elve($unit) ? goblins($_) : elves($_) } (
                    ($unit_x-1).','.($unit_y),
                    ($unit_x+1).','.($unit_y),
                    ($unit_x  ).','.($unit_y-1),
                    ($unit_x  ).','.($unit_y+1),
                );
                last move if @attack_positions;

                # 1. find targets
                my @target_positions = grep { is_elve($unit) ? goblins($_) : elves($_) } keys %maze;
                # print "Target pos: @target_positions\n";

                # 1b. if no targets left, combat ends
                last round unless @target_positions;

                # 2. find adjacent free tiles
                my @destination_positions;
                for my $target_position (@target_positions) {
                    my ($target_x, $target_y) = split ',', $target_position;

                    for my $destination_position (
                        ($target_x-1).','.($target_y),
                        ($target_x+1).','.($target_y),
                        ($target_x  ).','.($target_y-1),
                        ($target_x  ).','.($target_y+1),
                        ) {
                        push @destination_positions => $destination_position if $maze{$destination_position} eq '.';
                    }
                }
                last move unless @destination_positions;
                # print "@destination_positions\n";

                # 3. find distances from unit to reachable tiles
                my %reachable_distance;
                for my $destination_position (@destination_positions) {
                    my ($destination_x, $destination_y) = split ',', $destination_position;
                    my $distance = distance($unit_x, $unit_y => $destination_x, $destination_y);
                    # print "Distance to $destination_position is $distance\n";
                    $reachable_distance{$destination_position} = $distance if $distance;
                }
                last move unless %reachable_distance;

                # 4. choose closest tile as target
                my ($choosen_position) =  sort { $reachable_distance{$a} <=> $reachable_distance{$b} || readingorder($a, $b) } keys %reachable_distance;
                $choosen_position or die "Can't find reachable position";
                # print "$choosen_position\n";

                # 5. find distances from target back to unit
                my ($choosen_x, $choosen_y) = split ',', $choosen_position;
                my %distance = distance_from($choosen_x, $choosen_y);

                # for my $y (0..$height-1) {
                #     for my $x (0..$width-1) {
                #         printf '%-2s', $distance{"$x,$y"} || $maze{"$x,$y"};
                #     }
                #     print "\n";
                # }

                # 5. step along closest path
                my @step_positions = sort { $distance{$a} <=> $distance{$b} || readingorder($a, $b) } grep $distance{$_}, (
                    ($unit_x-1).','.($unit_y),
                    ($unit_x+1).','.($unit_y),
                    ($unit_x  ).','.($unit_y-1),
                    ($unit_x  ).','.($unit_y+1),
                );
                # for (@step_positions) {
                #     print "Possible step: $_, distance: $distance{$_}\n";
                # }
                my $step_position = $step_positions[0];
                # print "Choosen step: $step_position\n";
                $maze{$unit_position} = '.';
                $maze{$step_position} eq '.' or die "Step position, $step_position, is not free, $maze{$step_position}.";
                $maze{$step_position} = $unit;
                ($unit_x, $unit_y) = split ',', $step_position;
                # print "$unit moves to $step_position\n";
            }
            # Attack
            attack: {
                # 1. find targets in range
                my @attack_positions = sort { readingorder($a, $b) } grep { is_elve($unit) ? goblins($_) : elves($_) } (
                    ($unit_x-1).','.($unit_y),
                    ($unit_x+1).','.($unit_y),
                    ($unit_x  ).','.($unit_y-1),
                    ($unit_x  ).','.($unit_y+1),
                );
                last attack unless @attack_positions;
                # print "$unit can attack @attack_positions\n";

                # 2. choose weakest
                my ($attack_position) = sort { $health{$maze{$a}} <=> $health{$maze{$b}} || readingorder($a, $b) } @attack_positions;
                # print "$unit attacks $maze{$attack_position} at $attack_position\n";

                # 3. reduce target health by 3
                my $opponent = $maze{$attack_position};
                $health{$opponent} -= is_elve($unit) ? $power : 3;
                # print "$opponent health is $health{$opponent}\n";

                # 4. clear if dead
                if ($health{$opponent} <= 0) {
                    delete $health{$opponent};
                    $maze{$attack_position} = '.';
                    # print "$opponent dies\n";

                    if (is_elve($opponent)) {
                        print "Elve $opponent dies, more power!\n";
                        $power++;
                        next power;
                    }
                }
            }
        }

        $round++;
        # print "\n";
    }
    last;
}

print "\n";
show();

print "Combat ended with elve attack power $power after $round completed round.\n";

my $elves_health = sum map $health{$_}, grep /^E/, keys %health;
my $goblins_health = sum map $health{$_}, grep /^G/, keys %health;

print "Health score $elves_health vs. $goblins_health\n";
print "Result: ", $round * max($elves_health, $goblins_health), "\n";




sub show {
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            print color({ '.' => 'bright_black', '#' => 'black', 'E' => 'blue', 'G' => 'green'}->{substr $maze{"$x,$y"}, 0, 1});
            printf '%-2s', $maze{"$x,$y"};
            print color('reset');
        }
        print "  ";
        for my $x (0..$width-1) {
            print color({ 'E' => 'blue', 'G' => 'green'}->{substr $maze{"$x,$y"}, 0, 1}), $maze{"$x,$y"}, color('reset'), "(", ($health{$maze{"$x,$y"}} < 50 ? color('red') : ''), $health{$maze{"$x,$y"}}, color('reset'), "), " if $health{$maze{"$x,$y"}};
        }
        print "\n";
    }
}

sub readingorder {
    my @a = split ',', shift;
    my @b = split ',', shift;
    $a[1] <=> $b[1] ||
    $a[0] <=> $b[0];
}

sub elves {
    is_elve($maze{$_});
}

sub is_elve {
    shift =~ /^E/;
}

sub goblins {
    is_goblin($maze{$_});
}

sub is_goblin {
    shift =~ /^G/;
}

sub units {
    is_elve($maze{$_}) ||
    is_goblin($maze{$_});
}


sub distance_from {
    my ($x, $y) = @_;
    my $distance = 1;
    my %distance;
    $distance{"$x,$y"} = $distance;

    my %positions;
    $positions{$_} = 1 for grep $maze{$_} eq '.', keys %maze;
    delete $positions{"$x,$y"};

    while () {
        $distance++;
        my $added;

        for my $position (keys %positions) {
            my ($x, $y) = split ',', $position;

            if ($distance{($x-1) .",$y"} == $distance - 1 or
                $distance{($x+1) .",$y"} == $distance - 1 or
                $distance{"$x,". ($y-1)} == $distance - 1 or
                $distance{"$x,". ($y+1)} == $distance - 1
                ) {
                $distance{"$x,$y"} = $distance;
                delete $positions{$position};
                $added++;
            }

        }
        last unless $added;
    }

    return %distance;
}

sub distance {
    my ($sx, $sy, $dx, $dy) = @_;
    my %distance = distance_from($sx, $sy);
    return $distance{"$dx,$dy"};
}