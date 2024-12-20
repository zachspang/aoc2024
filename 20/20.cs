// See https://aka.ms/new-console-template for more information
using System.Collections;
using System.Runtime.CompilerServices;

public class MainClass
{
    static void Main(string[] args)
    {
        List<String> map = new List<String>();
        map.AddRange(File.ReadAllText("input.txt").Split("\n"));
        map.RemoveAt(map.Count - 1);

        Tuple<int, int> start = new Tuple<int,int>(0,0);
        for (int i = 0; i < map.Count; i++) {
            if (map[i].IndexOf('S') != -1) {
                start = Tuple.Create(i, map[i].IndexOf('S'));
            }
        }

        Dictionary<Tuple<int, int>, int> originalPath = BFS(map, start);

        int validCheats = 0;
        foreach (Tuple<int, int> node in originalPath.Keys) {
            for (int x = -2; x <= 2; x++) {
                for (int y = -2; y <=2; y++) { 
                    int cheatDistance = Math.Abs(x) + Math.Abs(y);
                    if (cheatDistance <= 2 && cheatDistance != 0) {
                        if (node.Item1 + x >= 0 && node.Item2 + y >= 0 && node.Item1 + x < map.Count && node.Item2 + y < map[0].Length && !map[node.Item1 + x][node.Item2 + y].Equals('#')) {
                            int distanceSaved = originalPath[Tuple.Create(node.Item1 + x, node.Item2 + y)] - (originalPath[node] + cheatDistance); 
                            if (distanceSaved >= 100) {
                                validCheats++;
                            }
                        }
                    }
                }
            }
        }
        Console.WriteLine(validCheats);

        //Part 2
        int p2validCheats = 0;
        foreach (Tuple<int, int> node in originalPath.Keys) {
            for (int x = -20; x <= 20; x++) {
                for (int y = -20; y <= 20; y++) {
                    int cheatDistance = Math.Abs(x) + Math.Abs(y);
                    if (cheatDistance <= 20 && cheatDistance != 0) {
                        if (node.Item1 + x >= 0 && node.Item2 + y >= 0 && node.Item1 + x < map.Count && node.Item2 + y < map[0].Length && !map[node.Item1 + x][node.Item2 + y].Equals('#')) {
                            int distanceSaved = originalPath[Tuple.Create(node.Item1 + x, node.Item2 + y)] - (originalPath[node] + cheatDistance);
                            if (distanceSaved >= 100) {
                                p2validCheats++;
                            }
                        }
                    }
                }
            }
        }
        Console.WriteLine(p2validCheats);
    }

    //BFS the track and return the path from start to end as a dictionary with key of the coords and value of the distance from the start
    static Dictionary<Tuple<int, int>, int> BFS(List<String> map, Tuple<int, int> start) {
        Tuple<int, int>[] directions = { Tuple.Create(0, 1), Tuple.Create(0, -1), Tuple.Create(1, 0), Tuple.Create(-1, 0) };

        //queue has a pair of coordinates and the distance from the start
        Queue<Tuple<int,int,int>> queue = new Queue<Tuple<int, int, int>>();
        queue.Enqueue(Tuple.Create(start.Item1, start.Item2, 0));

        HashSet<Tuple<int, int>> visited = new HashSet<Tuple<int, int>>();
        visited.Add(start);

        Dictionary<Tuple<int, int>, int> path = new Dictionary<Tuple<int, int>, int>();
        path.Add(Tuple.Create(start.Item1, start.Item2), 0);

        while (queue.Count != 0) {
            var currentNode = queue.Dequeue();
            var currentScore = currentNode.Item3;

            if (map[currentNode.Item1][currentNode.Item2].Equals('E')) {
                return path;
            }
            foreach (Tuple<int, int> direction in directions) {
                var adjacentNode = Tuple.Create(currentNode.Item1 - direction.Item1, currentNode.Item2 - direction.Item2);
                if (adjacentNode.Item1 >= 0 && adjacentNode.Item2 >= 0 && adjacentNode.Item1 < map.Count && adjacentNode.Item2 < map[0].Length) {
                    if (!visited.Contains(adjacentNode) && !map[adjacentNode.Item1][adjacentNode.Item2].Equals('#')) {
                        queue.Enqueue(Tuple.Create(adjacentNode.Item1, adjacentNode.Item2, currentScore + 1));
                        visited.Add(adjacentNode);
                        path.Add(Tuple.Create(adjacentNode.Item1, adjacentNode.Item2), currentScore + 1);
                    }
                }
            }
        }
        return path;
    }
}
