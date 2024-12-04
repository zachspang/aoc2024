file = assert(io.open("input.txt", "r"))
fileString = file:read("*all")
file:close()

multiplyPattern = "mul%(%d+,%d+%)"
dontPattern = "don't%(%)"
doPattern = "do%(%)"

mulEnd = 0
sum = 0

repeat
    dontStart, dontEnd = string.find(fileString, dontPattern, mulEnd)
    doStart, doEnd = string.find(fileString, doPattern, mulEnd)
    mulStart, mulEnd = string.find(fileString, multiplyPattern, mulEnd)

    if doStart == nil then doStart = string.len(fileString) end
    if dontStart == nil then dontStart = string.len(fileString) end
    
    if mulStart ~= nil then
        if mulStart < doStart and mulStart > dontStart then 
            mulEnd = doStart
            goto continue 
        end

        currMultiply = string.sub(fileString, mulStart, mulEnd)
        leftStart, leftEnd = string.find(currMultiply, "%d+")
        rightStart, rightEnd = string.find(currMultiply, "%d+", leftEnd + 1)
        leftNum = string.sub(currMultiply, leftStart, leftEnd)
        rightNum = string.sub(currMultiply, rightStart, rightEnd)
        sum = sum + (tonumber(leftNum) * tonumber(rightNum))
    end
    ::continue::
until mulStart == nil

print(sum)
