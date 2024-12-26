package main

import (
	"bufio"
	"log"
	"os"
)

func main() {
    file, err := os.Open("input.txt")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)

    locks := [][5]int{}
    keys := [][5]int{}

    lockRemaining := 0
    keyRemaining := 0
    for scanner.Scan() {
        line := scanner.Text();

        if lockRemaining == 0 && keyRemaining == 0 {
            if line == "#####" {
                lockRemaining = 7
                locks = append(locks, [5]int{-1,-1,-1,-1,-1})
            } else if line == "....." {
                keyRemaining = 7
                keys = append(keys, [5]int{-1,-1,-1,-1,-1})
            }
        }

        if lockRemaining > 0 {
            lockRemaining -= 1
            for i, char := range line {
                if char == '#' {
                    locks[len(locks) - 1][i] = locks[len(locks) - 1][i] + 1
                }
            }
        } else if keyRemaining > 0{
            keyRemaining -= 1
            for i, char := range line {
                if char == '#' {
                    keys[len(keys) - 1][i] = keys[len(keys) - 1][i] + 1
                }
            }
        }
    }

    fitCount := 0
    for _, lock := range locks {
        for _, key := range keys {
            fits := true
            for i := 0; i < 5; i++  {
                if lock[i] + key[i] > 5 {
                    fits = false
                }
            }
            if (fits) {
                fitCount++
            }
        }
    }

    println(fitCount)
}