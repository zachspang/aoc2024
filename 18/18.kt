
import java.io.File
import java.util.*

fun main() {
    val test = false
    var filename: String
    var dimension: Int
    var byteCount: Int
    
    if (test) {
        filename = "test.txt"
        dimension = 7
        byteCount = 12
    } else {
        filename = "input.txt"
        dimension = 71
        byteCount = 1024
    }

    val input = File(filename).readText().trim().split("\n")
    var map = Array(dimension) {Array(dimension) {'.'} }

    for (byteNum in 0..byteCount - 1) {
        val byte = input[byteNum].split(",")
        map[byte[1].toInt()][byte[0].toInt()] = '#'
    }
    println("Part1: ${BFS(map, dimension)}")
    
    //binary search for the index that makes the maze unsolvable
    var start = byteCount
    var end = input.size - 1
    var mapCopy: Array<Array<Char>>

    while (start <= end) {
        mapCopy = map.map{ it.copyOf() }.toTypedArray()

        var searchIndex = (start + end) / 2
        for (byteNum in byteCount..searchIndex) {
            val byte = input[byteNum].split(",")
            mapCopy[byte[1].toInt()][byte[0].toInt()] = '#'
        }

        if (BFS(mapCopy, dimension) == -1) {
            end = searchIndex - 1
        } else {
            start = searchIndex + 1
        }
    }
    println("Part2: ${input[start]}")

}
fun BFS(map: Array<Array<Char>>, dimension: Int): Int{    
    val directions = arrayOf(Pair(0,1), Pair(0,-1), Pair(1,0), Pair(-1,0))
    //queue has a pair of coordinates and the distance from the start
    var queue: Queue<Pair<Pair<Int, Int>, Int>> = LinkedList()
    queue.add(Pair(Pair(0,0), 0))
    var visited = mutableSetOf(Pair(0,0))

    while (queue.isNotEmpty()) {
        var currentNodeAndScore = queue.remove()
        var currentNode = currentNodeAndScore.first
        var currentScore = currentNodeAndScore.second

        if (currentNode == Pair(dimension -1, dimension -1)) {
            return currentScore
        }
        for (direction in directions) {
            var adjacentNode = Pair(currentNode.first - direction.first, currentNode.second - direction.second)
            if (adjacentNode.first >= 0 && adjacentNode.second >= 0 && adjacentNode.first < dimension && adjacentNode.second < dimension) {
                if (!visited.contains(adjacentNode) && map[adjacentNode.second][adjacentNode.first] != '#') {
                    queue.add(Pair(adjacentNode, currentScore + 1))
                    visited.add(adjacentNode)
                }
            }
        }
    }
    return -1
}
