from pathlib import Path
from time import time_function
from pathlib import _dir_of_current_file
from testing import assert_equal
from benchmark import run as bench


struct Part(EqualityComparable):
    alias one = Part(1)
    alias two = Part(2)
    alias bad = Part(-1)
    var v: Int32

    @implicit
    fn __init__(out self, v: Int):
        if v < 1 or v > 2:
            self.v = -1

        self.v = v

    fn __eq__(self, other: Self) -> Bool:
        return self.v == other.v

    fn __ne__(self, other: Self) -> Bool:
        return not (self == other)


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
        b1 = time_function[part_1]()
        b2 = time_function[part_2]()
        r1 = p1.cast[DType.int64]()
        r2 = p2.cast[DType.int64]()

        fmt = "0" + str(i + 1) if i < 9 else str(i + 1)
        print("Day {} =>".format(fmt))
        print("\tPart 1: {} in {} ns.".format(r1, int(b1)))
        print("\tPart 2: {} in {} ns.\n".format(r2, int(b2)))


fn test[
    S: Solution,
    part: Part,
    file: StringLiteral,
    expected: Int,
]() raises:
    filepath = _dir_of_current_file() / "../../.." / file
    data = filepath.read_text()

    @parameter
    if part == Part.one:
        res = S.part_1(data)
    elif part == Part.two:
        res = S.part_2(data)
    else:
        raise Error("Part argument is incorrectly set.")

    assert_equal(res, expected)
