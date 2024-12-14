open System.IO
open System.Linq
let addTuple (t1 : byref<int * int>, t2 : int * int) =
    t1 <- (fst t1 + fst t2, snd t1 + snd t2) 

//Return tuple (perimeter, area)
let rec getPerimeterArea(row, col, map : char array array, rowLen, colLen, plotChar) =
    if row >= 0 && col >= 0 && row < rowLen && col < colLen && System.Char.ToUpper(map[row].[col]) = plotChar then
        //If already checked
        if System.Char.IsLower(map[row].[col]) then
            (0, 0)
        else
            let mutable result = (0, 0)
            map[row].[col] <- System.Char.ToLower(map[row].[col])
            //Check up down left right
            addTuple(&result, getPerimeterArea(row - 1, col, map, rowLen, colLen, plotChar))
            addTuple(&result, getPerimeterArea(row + 1, col, map, rowLen, colLen, plotChar))
            addTuple(&result, getPerimeterArea(row, col - 1, map, rowLen, colLen, plotChar))
            addTuple(&result, getPerimeterArea(row, col + 1, map, rowLen, colLen, plotChar))
            //Return all search directions summed and add 1 to area
            addTuple(&result, (0, 1))
            result
    //Part of a different plant
    else
        (1, 0)

let checkIfNew(row, col, map : char array array, rowLen, colLen, plotChar) =
    if row >= 0 && col >= 0 && row < rowLen && col < colLen && System.Char.ToUpper(map[row].[col]) = plotChar then
        false
    else true
let rec getSides(row, col, map : char array array, rowLen, colLen, plotChar) =
    if System.Char.IsUpper(map[row].[col]) then
        let u = checkIfNew(row - 1, col, map, rowLen, colLen, plotChar)
        let d = checkIfNew(row + 1, col, map, rowLen, colLen, plotChar)
        let l = checkIfNew(row, col - 1, map, rowLen, colLen, plotChar)
        let r = checkIfNew(row, col + 1, map, rowLen, colLen, plotChar)
        
        let mutable sides = 0
        //Add number of corners to sides
        if u = l && (u = true || checkIfNew(row - 1, col - 1, map, rowLen, colLen, plotChar)) then
            sides <- sides + 1
        if u = r && (u = true || checkIfNew(row - 1, col + 1, map, rowLen, colLen, plotChar)) then
            sides <- sides + 1
        if d = l && (d = true || checkIfNew(row + 1, col - 1, map, rowLen, colLen, plotChar)) then
            sides <- sides + 1
        if d = r && (d = true || checkIfNew(row + 1, col + 1, map, rowLen, colLen, plotChar)) then
            sides <- sides + 1
      
        map[row].[col] <- System.Char.ToLower(map[row].[col])
        //Check up down left right
        if u = false then
            sides <- sides + getSides(row - 1, col, map, rowLen, colLen, plotChar)
        if d = false then
            sides <- sides + getSides(row + 1, col, map, rowLen, colLen, plotChar)
        if l = false then
            sides <- sides + getSides(row, col - 1, map, rowLen, colLen, plotChar)
        if r = false then
            sides <- sides + getSides(row, col + 1, map, rowLen, colLen, plotChar)
        sides
    else
        0


let map = File.ReadAllText("input.txt").Trim().Split("\n").Select(fun str -> str.ToCharArray()).ToArray();
let p2Map = File.ReadAllText("input.txt").Trim().Split("\n").Select(fun str -> str.ToCharArray()).ToArray();
let rowLen = map.Length
let colLen = map[0].Length
let mutable p1Total = 0
let mutable p2Total = 0
for i = 0 to map.Length - 1 do
    for j = 0 to map[0].Length - 1 do
        if System.Char.IsUpper(map[i].[j]) then
            let p,a = getPerimeterArea(i, j, map, rowLen, colLen, map[i].[j])
            p1Total <- p1Total + (p * a)
            let s = getSides(i, j, p2Map, rowLen, colLen, p2Map[i].[j])
            p2Total <- p2Total + (s * a)
            
printfn "\n%A" p1Total
printfn "%A" p2Total