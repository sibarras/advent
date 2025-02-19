use std::path::Path;
type DaySolution = (fn(&str) -> usize, fn(&str) -> usize);

pub trait Solution {
    fn part_1(data: &str) -> usize;
    fn part_2(data: &str) -> usize;
}

pub struct Solver {
    i: usize,
    solutions: [DaySolution; 25],
    path: &'static Path,
}

impl Solver {
    pub fn from(path: &'static str) -> Self {
        Self {
            i: 0,
            solutions: [(|_| 0, |_| 0); 25],
            path: path.as_ref(),
        }
    }
    pub fn add<S: Solution>(&self) -> Self {
        let mut s = Self { ..*self };
        s.solutions[s.i] = (S::part_1, S::part_2);
        s.i += 1;
        s
    }

    pub fn compute(self) {
        for (n, (part_1, part_2)) in self.solutions.into_iter().enumerate() {
            let day = format!("{:02}", n + 1);
            let fname = format!("day{day}.txt");
            let path = self.path.join(fname);
            run(path, day, part_1, part_2);
        }
    }
}
pub fn run(
    path: std::path::PathBuf,
    day: String,
    part_1: fn(&str) -> usize,
    part_2: fn(&str) -> usize,
) {
    if !path.exists() {
        return;
    }
    println!("Day {day} =>");
    let data = std::fs::read_to_string(path).expect("Error while reading the file. Aborting.");
    let data = data.trim();

    let result_1 = part_1(data);
    println!("\tPart 1: {result_1}");

    let result_2 = part_2(data);
    println!("\tPart 2: {result_2}\n");
}
