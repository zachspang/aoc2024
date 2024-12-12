<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>
    <?php
        set_time_limit(300);
        #Returns the replaced character if the guard can move, if the guard rotates it returns nothing and if the guard goes OoB then it returns d for done.
        #For part 2 brute force by checking the full path that the guard will take if an obstacle was placed infront of it.
        #$visted stores the row and col and direction the guard has been
        function move(&$row, &$col, &$map, &$direction, &$visited, &$attemptedObstacles, &$newObstacleCount){

            $map[$row][$col] = "X";
            if ($direction == "^"){
                addToVisited($row, $col, -1, 0, $visited);

                if ($row - 1 >= 0 and $map[$row -1][$col] == "#"){
                    $direction = ">";
                    return "";
                }

                $rowDir = -1;
                $colDir = 0;
            }
            else if ($direction == ">"){
                addToVisited($row, $col, 0, 1, $visited);

                if ($col + 1 < count($map) and $map[$row][$col + 1] == "#"){
                    $direction = "v";
                    return "";
                }

                $rowDir = 0;
                $colDir = 1;
            }
            else if ($direction == "v"){
                addToVisited($row, $col, 1, 0, $visited);

                if ($row + 1 < strlen($map[0]) and $map[$row + 1][$col] == "#"){
                    $direction = "<";
                    return "";
                }

                $rowDir = 1;
                $colDir = 0;
            }
            else if ($direction == "<"){
                addToVisited($row, $col, 0, -1, $visited);

                if ($col - 1 >= 0 and $map[$row][$col - 1] == "#"){
                    $direction = "^";
                    return "";
                }

                $rowDir = 0;
                $colDir = -1;
            }
            
            if (!in_array([$row + $rowDir, $col + $colDir], $attemptedObstacles)){
                $attemptedObstacles[] = [$row + $rowDir, $col + $colDir];
                if (willMakeLoop($row, $col, $rowDir, $colDir, $map, $visited)){
                    $newObstacleCount++;
                }
            }
            
            $row += $rowDir;
            $col += $colDir;

            if ($row >= count($map) or $row < 0 or $col >= strlen($map[0]) or $col < 0){
                return "d";
            }

            $replacedChar = $map[$row][$col];
            $map[$row][$col] = $direction;
            return $replacedChar;
        }

        function addToVisited($row, $col, $rowDir, $colDir, &$visited) {
            if (!in_array([$row, $col, $rowDir, $colDir], $visited)){
                $visited[] = [$row, $col, $rowDir, $colDir];
            }
        }

        function willMakeLoop($row, $col, $rowDir, $colDir, $map, $visited){
            $row += $rowDir;
            $col += $colDir;

            if ($row >= count($map) or $row < 0 or $col >= strlen($map[0]) or $col < 0){
                return false;
            }

            $map[$row][$col] = "#";
            while ($row < count($map) and $row >= 0 and $col < strlen($map[0]) and $col >= 0){

                if(in_array([$row, $col, $rowDir, $colDir], $visited)){
                    return true;
                }

                $visited[] = [$row, $col, $rowDir, $colDir];

                if($map[$row][$col] == "#"){

                    $row -= $rowDir;
                    $col -= $colDir;

                    if($rowDir == 1){
                        $rowDir = 0;
                        $colDir = -1;
                    } else if ($rowDir == -1){
                        $rowDir = 0;
                        $colDir = 1;
                    } else if($colDir == 1){
                        $rowDir = 1;
                        $colDir = 0;
                    } else if ($colDir == -1){
                        $rowDir = -1;
                        $colDir = 0;
                    }
                }
                
                $row += $rowDir;
                $col += $colDir;
            }
            return false;
        }

        $filename = "input.txt";
        $inputFile = fopen($filename, "r") or die("Cant open file");
        $map = explode("\n", fread($inputFile, filesize($filename)));
        fclose($inputFile);
        array_pop($map);
        $guardRow = 0;
        $guardCol = 0;
        $direction = "^";

        #iterate over the characters of the map to find the starting position
        for ($i = 0; $i < count($map); $i++){
            for ($j = 0; $j < strlen($map[$i]); $j++){
                if ($map[$i][$j] == "^"){
                    $guardRow = $i;
                    $guardCol = $j;
                }
            }
        }
        
        $visited = array();
        $totalPositions = 1;
        $attemptedObstacles = array();
        $attemptedObstacles[] = [$guardRow, $guardCol];
        $newObstacleCount = 0;
        while (true){
            $replacedChar = move($guardRow, $guardCol, $map, $direction, $visited, $attemptedObstacles, $newObstacleCount);
            
            if ($replacedChar == "d"){
                break;
            }
            else if ($replacedChar == "."){
                $totalPositions++;
            }
        }

        echo "$totalPositions <br>";
        echo $newObstacleCount;
    ?>
</body>
</html>