import 'dart:math';
import 'package:collection/collection.dart';
import 'dart:io';

void main() {
  var map = File("input.txt").readAsStringSync().split("\n");
  map.removeAt(map.length - 1);
  map[map.length - 2] = map[map.length - 2].replaceFirst("S", ".");

  var distance = dijkstra(map, map.length - 2, 1, 0, 1);

  var lowest = 10000000;
  for (var nDirection in [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
    var rDir = nDirection.$1;
    var cDir = nDirection.$2;

    if (distance.containsKey((1, map[0].length - 2, rDir, cDir))) {
      lowest = min(lowest, distance[(1, map[0].length - 2, rDir, cDir)]);
    }
  }
  print("Part 1: $lowest");

  Set<(int, int)> onPath = Set();

  onPath.add((1, map[0].length - 2,));

  onPath.add((map.length - 2, 1));

  //Take the reverse paths and forward paths. If a tiles forward and backwards dist sum to the lowest distance possible then it is on a optimal path.
  //Do this from both possible ways of entering the exit
  for (var rDirection in [(1, 0), (0, -1)]) {
    var rrDir = rDirection.$1;
    var rcDir = rDirection.$2;
    Map reverseDistance = dijkstra(map, 1, map[0].length - 2, rrDir, rcDir);
    for (var row = 0; row < map.length; row++) {
      for (var col = 0; col < map[0].length; col++) {
        for (var nDirection in [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
          var rDir = nDirection.$1;
          var cDir = nDirection.$2;
          if (distance.containsKey((row, col, rDir, cDir)) &&
              reverseDistance.containsKey((row, col, rDir * -1, cDir * -1)) &&
              distance[(row, col, rDir, cDir)] +
                      reverseDistance[(row, col, rDir * -1, cDir * -1)] ==
                  lowest) {
            onPath.add((row, col));
          }
        }
      }
    }
  }
  print("Part 2: ${onPath.length}");
}

class Node implements Comparable<Node> {
  final int dist;
  final int r;
  final int c;
  final int rDir;
  final int cDir;

  Node(this.dist, this.r, this.c, this.rDir, this.cDir);
  @override
  int compareTo(Node other) {
    return dist.compareTo(other.dist);
  }
}

//c = current, n = next
Map dijkstra(List<String> map, int r, int c, int rDir, int cDir) {
  var distance = Map();
  var pq = PriorityQueue();
  pq.add(Node(0, r, c, rDir, cDir));

  while (pq.isNotEmpty) {
    Node cNode = pq.removeFirst();
    var cDist = cNode.dist;
    var cr = cNode.r;
    var cc = cNode.c;
    var crDir = cNode.rDir;
    var ccDir = cNode.cDir;

    if (distance.containsKey((cr, cc, crDir, ccDir)) &&
        distance[(cr, cc, crDir, ccDir)] < cDist) {
      continue;
    }

    for (var nDirection in [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
      if (nDirection == (crDir, ccDir)) {
        continue;
      }
      var nrDir = nDirection.$1;
      var ncDir = nDirection.$2;
      if (!distance.containsKey((cr, cc, nrDir, ncDir)) ||
          distance[(cr, cc, nrDir, ncDir)] > cDist + 1000) {
        distance[(cr, cc, nrDir, ncDir)] = cDist + 1000;
        pq.add(Node(cDist + 1000, cr, cc, nrDir, ncDir));
      }
    }

    var nr = cr + crDir;
    var nc = cc + ccDir;

    if ((nr >= 0 && nr < map.length) &&
        (nc >= 0 && nc < map[0].length) &&
        map[nr][nc] != "#" &&
        (!distance.containsKey((nr, nc, crDir, ccDir)) ||
            distance[(nr, nc, crDir, ccDir)] > cDist + 1)) {
      distance[(nr, nc, crDir, ccDir)] = cDist + 1;
      pq.add(Node(cDist + 1, nr, nc, crDir, ccDir));
    }
  }
  return distance;
}
