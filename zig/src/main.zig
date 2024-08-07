const std = @import("std");
const advent_utils = @import("advent_utils.zig");
const day01 = @import("days/day01.zig");
const day02 = @import("days/day02.zig");
const day03 = @import("days/day03.zig");

pub fn main() !void {
    try advent_utils.run(usize, day01.Solution, "../inputs/day01.txt");
    try advent_utils.run(usize, day02.Solution, "../inputs/day02.txt");
    try advent_utils.run(usize, day03.Solution, "../inputs/day03.txt");
}

test "day01" {
    try advent_utils.testSolutions(usize, day01.Solution, "../tests/day1_1.txt", 142, "../tests/day1_2.txt", 281);
}
test "day02" {
    try advent_utils.testSolution(usize, day02.Solution, "../tests/day2_1.txt", 8, 2286);
}
test "day03" {
    try advent_utils.testSolution(usize, day03.Solution, "../tests/day3_1.txt", 4361, 467835);
}
