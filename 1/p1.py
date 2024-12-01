file = open("input.txt")
left = []
right = []
for line in file:
    numbers = line.split(" ")
    left.append(int(numbers[0]))
    right.append(int(numbers[3]))

left.sort()
right.sort()

sum = 0
for i in range(0, len(left)):
    sum += abs(left[i] - right[i])

print(sum)