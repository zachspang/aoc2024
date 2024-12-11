library("stringr")
input <- read.delim("input.txt", sep = "", header = FALSE)
map <- data.frame()
for (i in 1:nrow(input)) {
    map <- rbind(map, t(c(str_split_1(input[i,], pattern = ""))))
}

antiNodeMap <- map
p1Count <- 0
for (firstR in 1:nrow(map)) {
    for(firstC in 1:ncol(map)) {
        firstAntennaChar = map[firstR,firstC]
        if (firstAntennaChar != "." && firstAntennaChar != "#" ) {
            for (secondR in 1:nrow(map)) {
                for(secondC in 1:ncol(map)) {
                    secondAntennaChar = map[secondR,secondC]
                    if (firstAntennaChar == secondAntennaChar && (firstR != secondR && firstC != secondC)) {
                        antiR <- secondR + secondR - firstR
                        antiC <- secondC + secondC - firstC
                        if (antiR > 0 && antiC > 0 && antiR <= nrow(map) && antiC <= ncol(map) && antiNodeMap[antiR,antiC] != "#") {
                            p1Count <- p1Count + 1
                            antiNodeMap[antiR,antiC] = "#"
                        }
                    }
                }
            }
        }
    }
}

antiNodeMap <- map
p2Count <- 0
for (firstR in 1:nrow(map)) {
    for(firstC in 1:ncol(map)) {
        firstAntennaChar = map[firstR,firstC]
        if (firstAntennaChar != "." && firstAntennaChar != "#" ) {
            for (secondR in 1:nrow(map)) {
                for(secondC in 1:ncol(map)) {
                    secondAntennaChar = map[secondR,secondC]
                    if (firstAntennaChar == secondAntennaChar && (firstR != secondR && firstC != secondC)) {
                        distR <- secondR - firstR
                        distC <- secondC - firstC
                        antiR <- secondR 
                        antiC <- secondC 
                        while (antiR > 0 && antiC > 0 && antiR <= nrow(map) && antiC <= ncol(map)){
                            if (antiNodeMap[antiR,antiC] != "#") {
                                p2Count <- p2Count + 1
                                antiNodeMap[antiR,antiC] = "#"
                            }
                            antiR <- antiR + distR
                            antiC <- antiC + distC
                        }
                    }
                }
            }
        }
    }
}

p1Count
p2Count