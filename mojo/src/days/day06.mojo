from advent_utils import AdventSolution, AdventResult, unwrap_or
from math import sqrt, floor, ceil


@always_inline
fn quadratic_solution(a: Float64, b: Float64, c: Float64) -> (Float64, Float64):
    cns = -b / (2 * a)
    v = sqrt(b**2 - 4.0 * a * c) / (2 * a)
    return cns - v, cns + v


@always_inline
fn races_winning(duration: Int, record: Int) -> UInt:
    a, b, c = 1, -duration, record
    lower, upper = quadratic_solution(a, b, c)
    lower, upper = floor(lower + 1), ceil(upper - 1)
    lower_int, upper_int = int(lower), int(upper)
    return upper_int - lower_int + 1


fn string_to_uint(inp: String) raises -> Int:
    return int(inp)


struct Solution(AdventSolution):
    @staticmethod
    fn part_1(input: List[String]) -> AdventResult:
        total = 1
        for r_idx in range(len(input[0].split()) - 1):
            duration = input[0].split()[r_idx + 1]
            record = input[1].split()[r_idx + 1]
            duration_int = unwrap_or(string_to_uint, duration, default=0)
            record_int = unwrap_or(string_to_uint, record, default=0)
            total *= races_winning(duration_int, record_int)

        return total

    @staticmethod
    fn part_2(input: List[String]) -> AdventResult:
        duration = "".join(input[0].split()[1:])
        record = "".join(input[1].split()[1:])
        duration_int = unwrap_or(string_to_uint, duration, default=0)
        record_int = unwrap_or(string_to_uint, record, default=0)
        return races_winning(duration_int, record_int)