sub teleport {
    my ($pos, $len) = @_;
    return abs(abs($pos) - $len);
}

@input;

$vertLen = 103;
$horiLen = 101;
open my $info, "input.txt" or die "Could not open $file: $!";
while( my $line = <$info>)  {  
    my ($x, $y, $xVel, $yVel) = ($line =~ m/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/); 
    my %robot = (
        x => int($x),
        y => int($y),
        xVel => int($xVel),
        yVel => int($yVel),
    );
    push(@input, \%robot);
}

for( $i = 0; $i < 100; $i = $i + 1) {
    foreach $robot (@input) {
        my $x = $robot -> {'x'};
        my $y = $robot -> {'y'};
        my $xVel = $robot -> {'xVel'};
        my $yVel = $robot -> {'yVel'};

        $x = $x + $xVel;
        if ($x < 0 or $x >= $horiLen ) {
            $x = teleport($x, $horiLen) ;

        } 
        $robot -> {'x'} = $x;

        $y = $y + $yVel;
        if ($y < 0 or $y >= $vertLen ) {
            $y = teleport($y, $vertLen) ;
        } 
        $robot -> {'y'} = $y;
    }  
}

$vertMid = int($vertLen / 2);
$horiMid = int($horiLen / 2);
$quad1, $quad2, $quad3, $quad4 = 0;

foreach $robot (@input) {
    my $x = $robot -> {'x'};
    my $y = $robot -> {'y'};

    if ($x > $horiMid && $y < $vertMid) {
        $quad1 += 1;
    } elsif ($x < $horiMid && $y < $vertMid) {
        $quad2 += 1;
    } elsif ($x > $horiMid && $y > $vertMid) {
        $quad3 += 1;
    } elsif ($x < $horiMid && $y > $vertMid) {
        $quad4 += 1;
    }
}

print("\n");
print(($quad1 * $quad2 * $quad3 * $quad4));
print("\n");

#part 2
$part2Index = 0;
for( $i = 101; $i < 100000; $i = $i + 1) {
    my @display;
    foreach $robot (@input) {
        my $x = $robot -> {'x'};
        my $y = $robot -> {'y'};
        my $xVel = $robot -> {'xVel'};
        my $yVel = $robot -> {'yVel'};

        $x = $x + $xVel;
        if ($x < 0 or $x >= $horiLen ) {
            $x = teleport($x, $horiLen) ;

        } 
        $robot -> {'x'} = $x;

        $y = $y + $yVel;
        if ($y < 0 or $y >= $vertLen ) {
            $y = teleport($y, $vertLen) ;
        } 
        $robot -> {'y'} = $y;

        $display[$y][$x] = "X";
    }  
  
    foreach $line (@display) {
        my $numInLine = 0;
        for($j = 0; $j < scalar @$line; $j = $j + 1) {
            if (@$line[$j] eq 'X') {
                $numInLine += 1;
            } else {
                $numInLine = 0;
            }

            if ($numInLine == 30) {
                $part2Index = $i;
                goto DONE;
            }
        }
    }
}
DONE:
print($part2Index);
print("\n");