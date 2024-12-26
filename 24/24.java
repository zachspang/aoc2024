import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

class Main
{
    public static void main(String []args)
    {
        Map<String, Integer> map = new HashMap<>();
        Queue<String> operationQueue = new LinkedList<>();
        try (BufferedReader br = new BufferedReader(new FileReader("/home/ubuntu/projects/aoc2024/24/input.txt"))) {
            
            Boolean startingValues = true;
            String line;
            while ((line = br.readLine()) != null) {
                if (startingValues) {
                    if (line.equals("")) {
                        startingValues = false;
                        continue;
                    }
                    map.put(line.substring(0, 3), Integer.parseInt(line.substring(5, 6)));
                } else {
                    operationQueue.add(line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file: " + e.getMessage());
        }

        System.out.println(runOperations(new LinkedList<>(operationQueue), new HashMap<>(map)));
        
        ArrayList<String> wrong = new ArrayList<>();
        //Follow the rules of a ripple carry adder to find misplaced outputs
        for (String line : operationQueue) {
            String[] split = line.split(" ");
            //Besides the last bit, z gates must come for XOR
            if (split[4].charAt(0) == 'z' && !split[1].equals("XOR") && !split[4].equals("z45")) {
                wrong.add(split[4]);
            //If the gate is a XOR and the inputs need to be x or y or the output needs to be z
            } else if (split[1].equals("XOR") && split[0].charAt(0) != 'x' && split[0].charAt(0) != 'y' && split[4].charAt(0) != 'z') {
                wrong.add(split[4]);
            //The next two apply to all but the first bit
            } else if (!split[0].equals("x00") && !split[0].equals("y00")) {
                //Output of x XOR y needs to be input of some other XOR
                if (split[1].equals("XOR") && (split[0].charAt(0) == 'x' || split[0].charAt(0) == 'y')) {
                    Boolean found = false;
                    for (String line2 : operationQueue) {
                        String[] split2 = line2.split(" ");
                        if (split2[1].equals("XOR") && (split2[0].equals(split[4]) || split2[2].equals(split[4]))) {
                            found = true;
                        }
                    }
                    if (!found) {
                        wrong.add(split[4]);
                    }
                //Output of AND needs to be input of an OR
                } else if (split[1].equals("AND")) {
                    Boolean found = false;
                    for (String line2 : operationQueue) {
                        String[] split2 = line2.split(" ");
                        if (split2[1].equals("OR") && (split2[0].equals(split[4]) || split2[2].equals(split[4]))) {
                            found = true;
                        }
                    }
                    if (!found) {
                        wrong.add(split[4]);
                    }
                }
            }
        }
        Collections.sort(wrong);
        System.out.println(String.join(",", wrong));
    }

    public static Long runOperations(Queue<String> operations, Map<String,Integer> map) {
        int loops = 0;
        while (!operations.isEmpty()) {
            if (loops > operations.size()) {
                break;
            }
            
            String currentLine = operations.remove();
            if (!parseLine(currentLine, map)) {
                operations.add(currentLine);
                loops++;
            } else {
                loops = 0;
            }
        }

        char[] binaryNum = new char[46];
        Arrays.fill(binaryNum, '0');
        
        for (String key : map.keySet()) {
            if (key.charAt(0) == 'z') {
                binaryNum[Integer.parseInt(key.substring(1,3))] = Character.forDigit(map.get(key), 10);
            }
        }

        return convertReversedBinary(binaryNum);
    }

    public static Boolean parseLine(String line, Map<String,Integer> map) {
        String[] lineSplit = line.split(" ");
        String wire1 = lineSplit[0];
        String wire2 = lineSplit[2];

        if (!map.containsKey(wire1) || !map.containsKey(wire2)) {
            return false;
        }

        String destinationWire = lineSplit[4];
        String operator = lineSplit[1];

        if (operator.equals("AND")) {
            map.put(destinationWire, map.get(wire1) & map.get(wire2));
        } else if (operator.equals("OR")) {
            map.put(destinationWire, map.get(wire1) | map.get(wire2));
        } else {
            map.put(destinationWire, map.get(wire1) ^ map.get(wire2));
        }

        return true;
    }

    public static Long convertReversedBinary (char[] binaryNum) {
        char [] reversed = new char[binaryNum.length];
        Arrays.fill(reversed, '0');
        int j = 0;
        for(int i = binaryNum.length - 1; i >= 0; i--) {
            reversed[j] = binaryNum[i];
            j++;
        }
        return Long.parseLong(String.valueOf(reversed), 2);
    }
};