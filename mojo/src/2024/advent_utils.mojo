from pathlib import Path
from time import time_function
from pathlib import _dir_of_current_file
from testing import assert_equal
from benchmark import run as bench

alias Part = Int
alias PART_1 = 1
alias PART_2 = 2


trait Solution:
    alias T: DType

    @staticmethod
    fn part_1(data: String) -> Scalar[Self.T]:
        ...

    @staticmethod
    fn part_2(data: String) -> Scalar[Self.T]:
        ...


fn run[input_path: StringLiteral, *solutions: Solution]() raises:
    filepath = Path() / ".." / input_path
    alias sols = VariadicList(solutions)
    alias n_sols = len(sols)
    res_part_1 = SIMD[DType.int64, 32](0)
    res_part_2 = SIMD[DType.int64, 32](0)
    res_bench_1 = SIMD[DType.float64, 32](0)
    res_bench_2 = SIMD[DType.float64, 32](0)

    @parameter
    for i in range(n_sols):
        alias Sol = solutions[i]

        fmt = "0" + str(i + 1) if i < 9 else str(i + 1)
        file = filepath / "day{}.txt".format(fmt)
        data = file.read_text()

        var p1: Scalar[Sol.T] = 0
        var p2: Scalar[Sol.T] = 0

        @parameter
        fn part_1():
            p1 = Sol.part_1(data)

        @parameter
        fn part_2():
            p2 = Sol.part_2(data)

        # Saving results
        res_bench_1[i] = time_function[part_1]()
        res_bench_2[i] = time_function[part_2]()
        res_part_1[i] = p1.cast[DType.int64]()
        res_part_2[i] = p2.cast[DType.int64]()

        fmt = "0" + str(i + 1) if i < 9 else str(i + 1)
        print("Day {} =>".format(fmt))
        r1, r2 = res_part_1[i], res_part_2[i]
        b1, b2 = res_bench_1[i], res_bench_2[i]
        print("\tPart 1: {} in {} ns.".format(r1, int(b1)))
        print("\tPart 2: {} in {} ns.\n".format(r2, int(b2)))


fn test[
    S: Solution,
    file: StringLiteral,
    part: Part,
    expected: Int,
]() raises:
    filepath = _dir_of_current_file() / "../../.." / file
    data = filepath.read_text()

    @parameter
    if part == PART_1:
        res = S.part_1(data)
    else:
        res = S.part_2(data)

    assert_equal(res, expected)
