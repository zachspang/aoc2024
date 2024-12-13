import Data.List.Split  
import qualified Data.Text as T
import Data.IntMap 

loop :: (Integer, IntMap Int)-> IntMap Int
loop (0, stoneList) = stoneList
loop (n, stoneList) =
    --For all stones, blink each then turn list of stones into map, if ther is multiple of the same stone their counts are added
    --A stone is (stoneNumber, count)
    loop (n-1, fromListWith (+) [newStone | stone <- assocs stoneList, newStone <- blink stone])

blink :: (Int, Int)-> [(Int,Int)]
blink (num, count) = 
        do
        let digitCount = length (show num)
        if num == 0
            then  
                [(1, count)]
        else if even digitCount
            then
                do
                let (left, right) = num `divMod` (10 ^ (digitCount `div` 2)) 
                [(left, count), (right, count)]
        else
            [(num * 2024, count)]

main :: IO ()
main = do
    input <- readFile "input.txt"
    let stoneList = Prelude.map (read::String->Int) (splitOn " " (T.unpack (T.stripEnd (T.pack input))))

    let part1List = loop (25, fromListWith (+) [(i, 1) | i <- stoneList])
    let part2List = loop (75, fromListWith (+) [(i, 1) | i <- stoneList])
    print (sum (elems part1List))
    print (sum (elems part2List))
    