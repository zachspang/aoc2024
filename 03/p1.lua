file = assert(io.open("input.txt", "r"))
fileString = file:read("*all")
file:close()

multiplyPattern = "mul%(%d+,%d+%)"
sum = 0
mulEnd = 0
repeat
    mulStart, mulEnd = string.find(fileString, multiplyPattern, mulEnd)
    if mulStart ~= nil then
        currMultiply = string.sub(fileString, mulStart, mulEnd)
        leftStart, leftEnd = string.find(currMultiply, "%d+")
        rightStart, rightEnd = string.find(currMultiply, "%d+", leftEnd + 1)
        leftNum = string.sub(currMultiply, leftStart, leftEnd)
        rightNum = string.sub(currMultiply, rightStart, rightEnd)
        sum = sum + (tonumber(leftNum) * tonumber(rightNum))
    end
until mulStart == nil

print(sum)
