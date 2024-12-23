import Foundation 
import Algorithms

let codes = try String(contentsOfFile: "input.txt", encoding: .utf8).split(separator: "\n")
let numpad: [[Character]] = [["7", "8", "9"],[ "4", "5", "6"], ["1", "2", "3"], [" ", "0", "A"]]
let dirpad: [[Character]] = [[" ", "^", "A"], ["<", "v", ">"]]
let directions = ["^" : (-1, 0), "v" : (1, 0), "<" : (0, -1), ">" : (0, 1)]
var cache: [String : Int] = [:]

var p1Complexity = 0
var p2Complexity = 0

for code in codes {
    var startingButton:Character = "A"
    var numpadPaths: [String] = [""]
    for numButton in code {

        let startButtonLocation = locationOfButton(pad: numpad, searchButton: startingButton)
        var newNumpadPaths:[String ] = []
        for product in Algorithms.product(numpadPaths, findPathsFromTo(pad: numpad, start: startButtonLocation, end: numButton, visited: Set())) {
            newNumpadPaths.append(product.0 + product.1)
        }
        numpadPaths = newNumpadPaths
        startingButton = numButton
    }

    let robotCode = bestPath(paths: numpadPaths)

    let p1Length = pathLength(path:robotCode, depth:2, cache: &cache)
    let p2Length = pathLength(path:robotCode, depth:25, cache: &cache)
    p1Complexity += (Int(code[code.startIndex..<code.lastIndex(of: "A")!])! * p1Length)
    p2Complexity += (Int(code[code.startIndex..<code.lastIndex(of: "A")!])! * p2Length)
}
print(p1Complexity)
print(p2Complexity)

//DFS to build a path with depth amount of robots in the middle. 
//Because in part2 the strings take up so much memory we need to split them into chunks and work on one chunk at a time.
func pathLength(path: String, depth: Int, cache: inout [String : Int]) -> Int{

    if let total = cache[path + String(depth)] {
        return total
    }

    var chunks =  path.split(separator: "A", omittingEmptySubsequences: false).map{$0 + "A"}
    chunks.removeLast()
    if depth == 0 {
        return path.count
    }

    var total = 0
    for chunk in chunks {
        var chunkBest = ""
        var startingButton:Character = "A"
        for button in chunk {
            let startButtonLocation = locationOfButton(pad: dirpad, searchButton: startingButton)
            let best = bestPath(paths: findPathsFromTo(pad: dirpad, start: startButtonLocation, end: button, visited: Set()))
            chunkBest.append(contentsOf: best)
            startingButton = button
        }
        total += pathLength(path: chunkBest, depth: depth - 1, cache: &cache)
        cache[path + String(depth)] = total
    }

    return total
}

func bestPath(paths: [String]) -> String {
    //Check for minimum turns
    var goodPaths:[String] = []
    var minTurns = Int(MAX_INPUT)
    for path in paths {
        var turnCounter = 0
        var previousChar:Character = "A"
        for char in path {
            if previousChar != char {
                turnCounter += 1
            }
            previousChar = char
        }
        
        if turnCounter < minTurns {
            minTurns = turnCounter
            goodPaths = [path]
        } else if turnCounter == minTurns {
            goodPaths.append(path)
        }
    }

    //Check for optimal directions
    for i in 0..<goodPaths[0].count {
        var newGoodPaths: [String] = []
        let index = goodPaths[0].index(goodPaths[0].startIndex, offsetBy: i)

        //Left moves are the best, then vertical, and moving right is the worst. If one of these flags are set then a better path exists
        var leftflag = false
        var vertflag = false

        for path in goodPaths {
            if path[index] == "<" {
                if !leftflag {
                    newGoodPaths = []
                    leftflag = true
                }
            } else if path[index] == "^" || path[index] == "v" {
                if leftflag {
                    continue
                }

                if !vertflag && !leftflag {
                    newGoodPaths = []
                }
                vertflag = true
            } else if path[index] == ">" {
                if leftflag || vertflag {
                    continue
                }
            }
            newGoodPaths.append(path)
        }
        goodPaths = newGoodPaths
    }

    //All of the paths remaining in goodPaths should expand equally so return the first one
    return goodPaths[0]
}

func locationOfButton(pad: [[Character]], searchButton: Character) -> (Int, Int) {
    for r in 0..<pad.count {
        for c in 0..<pad[0].count {
            if pad[r][c] == searchButton {
                return (r,c)
            }
        }
    }
    return (-1,-1)
}

func findPathsFromTo(pad: [[Character]], start: (Int, Int), end: Character, visited: Set<Character>) -> [String] {

    if pad[start.0][start.1] == end {
        return ["A"]
    }
    var newVisited = visited
    newVisited.insert(pad[start.0][start.1])

    var paths: [String] = []
    for direction in directions.keys {
        let nr = start.0 + directions[direction]!.0
        let nc = start.1 + directions[direction]!.1

        if nr >= 0 && nc >= 0 && nr < pad.count && nc < pad[0].count && pad[nr][nc] != " " && !visited.contains(pad[nr][nc]) {
            paths.append(contentsOf: findPathsFromTo(pad: pad, start: (nr,nc), end: end, visited: newVisited).map {direction + $0})
        }
    }

    var minLength = 1000
    for path in paths {
        if path.count < minLength {
            minLength = path.count
        }
    }

    var minPaths: [String] = [] 
    for path in paths {
        if path.count == minLength {
            minPaths.append(path)
        }
    }

    return minPaths
}