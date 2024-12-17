const fs = require('fs');

function combo(n) {
    switch (n) {
        case 0n:
        case 1n:
        case 2n:
        case 3n:
            return BigInt(n)
        case 4n:
            return A
        case 5n:
            return B
        case 6n:
            return C
    }
}

function runProgram(){
    for (let i = 0n; i < program.length; i += 2n) {
        var opcode = program[i]
        var operand = BigInt(program[i + 1n])

        if (opcode == 0) {
            A = BigInt.asIntN(64, A / 2n ** combo(operand))
        } else if (opcode == 1) {
            B = B ^ operand
        } else if (opcode == 2) {
            B = combo(operand) & 7n
        } else if (opcode == 3) {
            if (A != 0) {
                i = operand - 2n
            }
        } else if (opcode == 4) {
            B = B ^ C
        } else if (opcode == 5) {
            out += (combo(operand) % 8n) + ","
        } else if (opcode == 6) {
            B = BigInt.asIntN(64, A / 2n ** combo(operand))
        } else {
            C = BigInt.asIntN(64, A / 2n ** combo(operand))
        }

    }
    out = out.substring(0, out.length - 1)

    return out
}

var input = fs.readFileSync("input.txt", "utf-8").split("\n")

var A = BigInt(parseInt(input[0].substring(12)))
var B = BigInt(parseInt(input[1].substring(12)))
var C = BigInt(parseInt(input[2].substring(12)))
var programString = input[4].substring(9)
var program = programString.split(",").map(str => parseInt(str, 10))
var out = ""
console.log(runProgram())

//part 2
var startA = 0n
var currDigit = 1
while (out != programString) {    
    for (let num = 0n; num < 100000; num++) {
        A = startA + BigInt(num)
        B = 0n
        C = 0n
        out = ""
        runProgram()
        if (out == programString) {
            startA = startA + num
            break
        }

        if (out == programString.substring(programString.length - currDigit)) {
            // console.log(startA + num) 
            // console.log(programString.substring(programString.length - currDigit))
            // console.log(out + "\n")
            startA = (startA + num) << 3n
            break
        }
    }
    currDigit++
}
console.log(startA)

