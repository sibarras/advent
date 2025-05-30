from math import sqrt, floor, ceil
from advent_utils import ListSolution


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
    lower_int, upper_int = Int(lower), Int(upper)
    return upper_int - lower_int + 1


struct Solution(ListSolution):
    alias dtype = DType.uint32

    @staticmethod
    fn part_1(input: List[String]) -> UInt32:
        total = 1
        for r_idx in range(len(input[0].split()) - 1):
            duration = input[0].split()[r_idx + 1]
            record = input[1].split()[r_idx + 1]
            try:
                duration_int = Int(duration)
                record_int = Int(record)
                total *= races_winning(duration_int, record_int)
            except:
                pass

        return total

    @staticmethod
    fn part_2(input: List[String]) -> UInt32:
        duration = StaticString("").join(input[0].split()[1:])
        record = StaticString("").join(input[1].split()[1:])
        try:
            duration_int = Int(duration)
            record_int = Int(record)
            return races_winning(duration_int, record_int)
        except:
            return 0
