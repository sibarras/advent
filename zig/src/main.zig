const std = @import("std");
const advent_utils = @import("advent_utils.zig");
const run = advent_utils.run;
const day01 = @import("days/day01.zig");
const day02 = @import("days/day02.zig");

pub fn main() !void {
    try run(usize, day01.Result, "../inputs/day01.txt");
}

test {
    try advent_utils.test_solutions(usize, day01.Solution, "../inputs/tests/day1_1.txt", 142, "../inputs/tests/day1_2.txt", 281);
    try advent_utils.test_solution(usize, day02.Solution, "../inputs/tests/day2_1.txt", 8, 2286);
}
