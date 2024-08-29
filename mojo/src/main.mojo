from days import day01, day02, day03, day04, day05, day06, day07
from advent_utils import read_input, run, test_solution


fn main() raises:
    run[day01.Solution, "../inputs/day01.txt"]()
    run[day02.Solution, "../inputs/day02.txt"]()
    run[day03.Solution, "../inputs/day03.txt"]()
    run[day04.Solution, "../inputs/day04.txt"]()
    run[day05.Solution, "../inputs/day05.txt"]()
    run[day06.Solution, "../inputs/day06.txt"]()
    run[day07.Solution, "../inputs/day07.txt"]()