package example
import scala.util.matching.Regex

object main {
  def main(args: Array[String]) {
    var ax, ay, bx, by, px, py, lineNumber, tokens= 0
    var part2px, part2py, part2tokens, part2a, part2b  :Long = 0
    var a, b :Double = 0;
    var prizePattern: Regex = """Prize: X=(\d+), Y=(\d+)""".r

    scala.io.Source.fromFile("input.txt").getLines().foreach{ line => 
      if (lineNumber % 4 == 0 ) {
        ax = line.substring(12,14).toInt
        ay = line.substring(18,20).toInt
      } else if (lineNumber % 4 == 1 ) {
        bx = line.substring(12,14).toInt
        by = line.substring(18,20).toInt
      } else if (lineNumber % 4 == 2 ) {
        line match {
          case prizePattern(num1, num2) =>
            px = num1.toInt 
            py = num2.toInt 
            part2px = num1.toInt + 10000000000000L
            part2py = num2.toInt + 10000000000000L
        }
        //part 1
        b = ((1f * ax * py) - (ay * px)) / ((ax * by) - (ay * bx))
        a = (px - (bx * b)) / ax
        if (a.isValidInt && b.isValidInt) {
          tokens += 3 * a.toInt + b.toInt
        }
        //part 2
        if (((ax * part2py) - (ay * part2px)) % ((ax * by) - (ay * bx)) == 0) {
          part2b = ((ax * part2py) - (ay * part2px)) / ((ax * by) - (ay * bx))
          if ((((part2px - (bx * part2b))) % ax) == 0) {
            part2a = (part2px - (bx * part2b)) / ax
            part2tokens += (3 * part2a) + part2b
          }
        }
      } 
      lineNumber += 1
    }

    println(tokens)
    println(part2tokens)
  }
}
