file = open("input.txt")
left = []
right = []
for line in file:
    numbers = line.split(" ")
    left.append(int(numbers[0]))
    right.append(int(numbers[3]))

similarityScore = 0
for num in left:
    similarityScore += (num * right.count(num))
print(similarityScore) 