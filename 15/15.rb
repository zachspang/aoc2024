filename = "input.txt"
map = []
part2Map = []
File.readlines(filename).each do |line|
    if line == "\n"
        break
    end

    line = line.tr("\n", "")

    part2Line = ""
    line.each_char do |char|
        if char == "#"
            part2Line.concat("##")
        elsif char == "O"
            part2Line.concat("[]")
        elsif char == "."
            part2Line.concat("..")
        else
            part2Line.concat("@.")
        end
    end

    map.push(line)
    part2Map.push(part2Line)
end

for i in 0..map.length - 1
    for j in 0..map[0].length - 1
        if map[i][j] == "@"
            r = i
            c = j
        end
    end
end

atDirections = false
File.readlines(filename).each do |line|
    if line == "\n"
        atDirections = true
    elsif line == "\n" && atDirections == true
        break
    elsif atDirections == true
        line = line.tr("\n", "")
        line.each_char do |direction|
            rDir = 0
            cDir = 0

            if direction == "^"
                rDir = -1
            elsif direction == "v"
                rDir = 1
            elsif direction == "<"
                cDir = -1
            elsif direction == ">"
                cDir = 1
            end

            if map[r + rDir][c + cDir] == "."
                map[r][c] = "."
                map[r + rDir][c + cDir] = "@"
                r += rDir
                c += cDir
            elsif map[r + rDir][c + cDir] == "O"
                tempR = r + rDir
                tempC = c + cDir

                #atempt to push boxes
                while true
                    if map[tempR][tempC] == "."
                        map[tempR][tempC] = "O"
                        map[r][c] = "."

                        r += rDir
                        c += cDir
                        map[r][c] = "@"
                        break
                    elsif map[tempR][tempC] == "#"
                        break
                    end
                    tempR += rDir
                    tempC += cDir
                end
            end
        end
    end
end

gpsSum = 0
for i in 0..map.length - 1
    for j in 0..map[0].length - 1
        if map[i][j] == "O"
            gpsSum += (i * 100) + j
        end
    end
end

print(gpsSum)
print("\n")

#part 2
def moveVertical(r, c, rDir, map)
    map[r][c] = "."
    map[r][c + 1] = "."
    map[r + rDir][c] = "["
    map[r + rDir][c + 1] = "]"
end

def boxPush(r, c, rDir, cDir, map) 
    #push up and down
    if cDir == 0 
        #Only work on [ for simplification
        if map[r][c] == "]"
            return boxPush(r, c - 1, rDir, cDir, map) 
        end

        if map[r + rDir][c] == "#" || map[r + rDir][c + 1] == "#"
            return false
        end

        if map[r + rDir][c] == "." && map[r + rDir][c + 1] == "."
            moveVertical(r, c, rDir, map)
            return true
        elsif map[r + rDir][c] == "[" 
            if boxPush(r + rDir, c, rDir, cDir, map) 
                moveVertical(r, c, rDir, map)
                return true
            end
        elsif map[r + rDir][c] == "]" && map[r + rDir][c + 1] == "."
            if boxPush(r + rDir, c - 1, rDir, cDir, map) 
                moveVertical(r, c, rDir, map)
                return true
            end
        elsif map[r + rDir][c] == "." && map[r + rDir][c + 1] == "["
            if boxPush(r + rDir, c + 1, rDir, cDir, map) 
                moveVertical(r, c, rDir, map)
                return true
            end
        elsif map[r + rDir][c] == "]" && map[r + rDir][c + 1] == "["
            if boxPush(r + rDir, c - 1, rDir, cDir, map) && boxPush(r + rDir, c + 1, rDir, cDir, map) 
                moveVertical(r, c, rDir, map)
                return true
            end
        end

    #push left and right
    else
        if map[r][c + cDir + cDir] == "#"
            return false
        elsif map[r][c + cDir + cDir] == "."
            map[r][c + cDir + cDir] = map[r][c + cDir] 
            map[r][c + cDir] = map[r][c] 
            map[r][c] = "."
            return true
        elsif map[r][c + cDir + cDir] == "[" || map[r][c + cDir + cDir] == "]" 
            if boxPush(r, c + cDir + cDir, rDir, cDir, map) 
                map[r][c + cDir + cDir] = map[r][c + cDir] 
                map[r][c + cDir] = map[r][c] 
                map[r][c] = "."
                return true
            end
        end
    end
    
    return false
end


for i in 0..part2Map.length - 1
    for j in 0..part2Map[0].length - 1
        if part2Map[i][j] == "@"
            r = i
            c = j
        end
    end
end

atDirections = false
File.readlines(filename).each do |line|
    if line == "\n"
        atDirections = true
    elsif line == "\n" && atDirections == true
        break
    elsif atDirections == true
        line = line.tr("\n", "")
        line.each_char do |direction|
            rDir = 0
            cDir = 0

            if direction == "^"
                rDir = -1
            elsif direction == "v"
                rDir = 1
            elsif direction == "<"
                cDir = -1
            elsif direction == ">"
                cDir = 1
            end

            if part2Map[r + rDir][c + cDir] == "."
                part2Map[r][c] = "."
                part2Map[r + rDir][c + cDir] = "@"
                r += rDir
                c += cDir
            elsif part2Map[r + rDir][c + cDir] == "[" || part2Map[r + rDir][c + cDir] == "]" 
                #Use a copy to restore the map if the boxes cant be pushed
                part2MapCopy = part2Map.map(&:clone)
                if boxPush(r + rDir, c + cDir, rDir, cDir, part2MapCopy)
                    part2Map = part2MapCopy.map(&:clone)
                    part2Map[r][c] = "."
                    part2Map[r + rDir][c + cDir] = "@"
                    r += rDir
                    c += cDir
                end
            end
        end
    end
end

gpsSum = 0
for i in 0..part2Map.length - 1
    for j in 0..part2Map[0].length - 1
        if part2Map[i][j] == "["
            gpsSum += (i * 100) + j
        end
    end
end

print(gpsSum)
print("\n")