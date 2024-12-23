use std::{collections::{HashMap, HashSet, VecDeque}, fs};

fn main() {
    let input: String = fs::read_to_string("./input.txt").expect("Couldnt read file");
    let mut numbers:Vec<i64> = Vec::new();
    for num in input.split("\n") {
        if num == "" {
            continue;
        }
        numbers.push(num.parse().unwrap());
    }
    
    let mut changes:HashMap<VecDeque<i64>, i64> = HashMap::new();
    let mut sum :i64 = 0;
    for num in &numbers{
        sum += generate_secret_num(*num, 2000, &mut changes);
    }
    println!("{}", sum);

    //part 2
    let mut max_bananas = 0;
    for value in changes.values() {
        if *value > max_bananas {
            max_bananas = *value;
        }
    }
    println!("{}", max_bananas);
}

fn generate_secret_num(starting_number: i64, iterations: i64, changes: &mut HashMap<VecDeque<i64>, i64>) -> i64 {
    let mut result = starting_number; 
    let mut temp:i64;

    let mut current_change = VecDeque::new();
    let mut seen = HashSet::new();
    for _ in 0..iterations {
        let previous = result % 10;
        //Step 1
        temp = result * 64;
        result = mix(result, temp);
        result = prune(result);

        //Step 2
        temp = result / 32;
        result = mix(result, temp);
        result = prune(result);
        //Step3
        temp = result * 2048;
        result = mix(result, temp);
        result = prune(result);

        current_change.push_back((result % 10) - previous);

        if current_change.len() == 5{
            current_change.pop_front();

            if !seen.contains(&current_change) {
                changes.insert(current_change.clone(), (changes.get(&current_change).unwrap_or(&0)) + (result % 10));
                seen.insert(current_change.clone());
            }
        }

    }
    return result
}

fn mix(secret:i64, other:i64) -> i64 {
    return secret ^ other;
}

fn prune(secret:i64) -> i64 {
    return secret % 16777216;
}