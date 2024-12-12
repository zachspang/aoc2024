defmodule Helper do
    #indexIteration is how many more times this index needs to be added. Original call needs to be the value of the first index
    def getStartDisk(index, disk, input, indexIteration) do
        cond do 
            index == String.length(input) - 1 && indexIteration == 0 ->
                Enum.reverse(disk)
            indexIteration == 0 ->
                getStartDisk(index + 1, disk, input, String.to_integer(String.at(input, index + 1)))
            rem(index, 2) == 0 ->
                getStartDisk(index, [(index / 2) | disk], input, indexIteration - 1) 
            true ->
                getStartDisk(index, ["." | disk], input, indexIteration - 1)
        end
    end

    def compactDisk(disk, leftPointer, rightPointer) do
        cond do
            rightPointer < leftPointer ->
                disk
            disk[leftPointer] != "." ->
                compactDisk(disk, leftPointer + 1, rightPointer)
            disk[rightPointer] == "." ->
                compactDisk(disk, leftPointer, rightPointer - 1)
            true ->
                tempDisk = %{ disk | leftPointer => disk[rightPointer]}
                newDisk = %{ tempDisk | rightPointer => "."}
                compactDisk(newDisk, leftPointer + 1, rightPointer - 1)
        end
    end
    
    def bestFitDisk(disk, leftStart, leftEnd, rightStart, rightEnd) do
        cond do
            rightEnd == 0 ->
                disk

            leftStart >= rightStart ->
                bestFitDisk(disk, 0, 0, rightEnd, rightEnd)

            disk[rightStart] == "." ->
                bestFitDisk(disk, 0, 0, rightStart - 1, rightEnd - 1)

            disk[rightStart] == disk[rightEnd] ->
                bestFitDisk(disk, 0, 0, rightStart, rightEnd - 1)

            disk[leftStart] != "." ->
                bestFitDisk(disk, leftStart + 1, leftEnd + 1, rightStart, rightEnd)

            disk[leftStart] == disk[leftEnd] ->
                bestFitDisk(disk, leftStart, leftEnd + 1, rightStart, rightEnd)
            
            #if file is bigger than space
            rightStart - rightEnd > leftEnd - leftStart ->
                bestFitDisk(disk, leftEnd, leftEnd, rightStart, rightEnd)
            
            #leftStart and leftEnd contains enough free space for a file between rightStart and rightEnd
            true ->
                tempDisk = %{ disk | leftStart => disk[rightStart]}
                newDisk = %{ tempDisk | rightStart => "."}
                bestFitDisk(newDisk, leftStart + 1, leftEnd, rightStart - 1, rightEnd)
        end
    end

    def checksum(disk, index) do
        cond do
        index == length(Map.keys(disk)) - 1 ->
            0
        disk[index] == "." ->
            checksum(disk, index + 1)
        true ->
            (disk[index] * index) + checksum(disk, index + 1)
        end
    end

end
input = String.trim(File.read!("input.txt"))
disk = Helper.getStartDisk(0, [], input, String.to_integer(String.at(input, 0)))
mapDisk = Stream.with_index(disk) |> Enum.reduce(%{}, fn({v,k}, acc)-> Map.put(acc, k, v) end)
compactedDisk = Helper.compactDisk(mapDisk, 0, length(Map.keys(mapDisk)) - 1)
bestFitDisk = Helper.bestFitDisk(mapDisk, 0, 0, length(Map.keys(mapDisk)) - 1, length(Map.keys(mapDisk)) - 1)
IO.puts(Helper.checksum(compactedDisk, 0))
IO.puts(Helper.checksum(bestFitDisk, 0))