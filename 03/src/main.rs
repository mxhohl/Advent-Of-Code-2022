use std::fs::File;
use std::io::{self, BufReader, BufRead};
use std::path::Path;

fn main() {
    let data = match load_data("input.txt") {
        Ok(d) => d,
        Err(err) => panic!("Unable to open input file: {}", err),
    };
    let commons = get_common_data(&data);
    let badges = get_groups_badges(&data);

    let sum = commons.into_iter()
        .fold(0, |acc, e| acc + e as u32);
    let badges_sum = badges.into_iter()
        .fold(0, |acc, e| acc + e as u32);

    println!("Sum of priorities for common items: {}", sum);
    println!("Sum of badges: {}", badges_sum);
}

fn get_common_item(first: &Vec<(u8, u8)>, second: &Vec<(u8, u8)>, third: &Vec<(u8, u8)>) -> u8 {
    for (e11, e12) in first {
        for (e21, e22) in second {
            if e11 == e21 || e11 == e22 {
                for (e31, e32) in third {
                    if e11 == e31 || e11 == e32 {
                        return e11.clone();
                    }
                }
            } else if e12 == e21 || e12 == e22 {
                for (e31, e32) in third {
                    if e12 == e31 || e12 == e32 {
                        return e12.clone();
                    }
                }
            }
        }
    }
    panic!("No common item for group.");
}

fn get_groups_badges(data: &Vec<Vec<(u8, u8)>>) -> Vec<u8> {
    if data.len() % 3 != 0 {
        panic!("Number of lines is not a multiple of 3.");
    }

    let mut badges: Vec<u8> = vec![];
    let mut i = 0;
    while i < data.len() {
        let common = get_common_item(&data[i], &data[i + 1], &data[i + 2]);
        badges.push(common);
        i += 3;
    }

    badges
}

fn get_common_data(data: &Vec<Vec<(u8, u8)>>) -> Vec<u8> {
    data.iter()
        .map(|rucksack| {
            for (e1, _) in rucksack.iter() {
                for (_, e2) in rucksack.iter() {
                    if e1 == e2 {
                        return e1.clone();
                    }
                }
            }
            panic!("");
        })
        .collect()
}

fn load_data<P>(sub_path: P) -> io::Result<Vec<Vec<(u8, u8)>>>
where
    P: AsRef<Path>
{
    let file = File::open(sub_path)?;
    let reader = BufReader::new(file);

    let mut data: Vec<Vec<(u8, u8)>> = vec![];
    for (index, line) in reader.lines().enumerate() {
        let index = index + 1; // We want the line number and not the array index
        let line = line?;

        let priorities: Vec<u8> = line.chars()
            .map(|c| match letter_to_priority(c) {
                Some(p) => p,
                None => panic!("Line {}: Unable to get priority for char '{}'.", index, c),
            })
            .collect();

        if priorities.len() & 1 == 1 {
            panic!("Line {}: Number of items is odd.", index);
        }

        let half_size = priorities.len() / 2;

        let mut line_data: Vec<(u8, u8)> = vec![];
        for i in 0..half_size {
            line_data.push((priorities[i], priorities[i + half_size]));
        }
        data.push(line_data);
    }

    Ok(data)
}

fn letter_to_priority(c: char) -> Option<u8> {
    if c >= 'a' && c <= 'z' {
        Some(c as u8 - b'a' + 1)
    } else if c >= 'A' && c <= 'Z' {
        Some(c as u8 - b'A' + 27)
    } else {
        None
    }
}
