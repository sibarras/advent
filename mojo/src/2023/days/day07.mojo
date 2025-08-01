from collections import Dict
from memory import Span
import sys
from advent_utils import ListSolution

alias CardType = DType.uint8


struct HandMode:
    alias First = HandMode(1)
    alias Second = HandMode(2)
    var value: UInt8

    fn __init__(out self, value: UInt8):
        self.value = value

    fn __eq__(self, other: HandMode) -> Bool:
        return self.value == other.value


@register_passable("trivial")
struct Hand[mode: HandMode](Comparable & Copyable & Movable):
    alias type = SIMD[CardType, 8]
    var value: Self.type
    var level: UInt8
    var bid: UInt32

    fn __init__(out self, s: StringSlice):
        space_pos = s.find(" ")
        self.bid = parse_int(s[space_pos + 1 :])
        self.value = Self.type()

        @parameter
        for idx in range(5):
            self.value[idx] = Card[mode](s[idx]).value

        self.level = 1
        self._calc_level(s)

    @always_inline("nodebug")
    fn _calc_level(mut self, s: StringSlice):
        chars = Dict[String, Int](power_of_two_initial_capacity=Self.type.size)

        @parameter
        for i in range(5):
            chars[s[i]] = chars.get(s[i], 0) + 1

        @parameter
        if mode == HandMode.Second:
            j_val = chars.pop("J", 0)
            max_v, max_c = 0, String("")

            @parameter
            for i in range(5):
                if s[i] != "J":
                    cv = chars.get(s[i], 0)
                    if cv > max_v:
                        max_v = cv
                        max_c = s[i]

            if max_c and max_v:
                chars[max_c] = max_v + j_val
            else:
                chars["J"] = j_val

        for k in chars.values():
            self.level += k**3

    fn __eq__(self, other: Self) -> Bool:
        return (self.value == other.value).reduce_and()

    fn __ne__(self, other: Self) -> Bool:
        return not self == other

    fn __gt__(self, other: Self) -> Bool:
        if self.level > other.level:
            return True
        if self.level < other.level:
            return False

        @parameter
        for i in range(5):
            if self.value[i] > other.value[i]:
                return True
            if self.value[i] < other.value[i]:
                return False

        return False

    fn __lt__(self, other: Self) -> Bool:
        if self.level < other.level:
            return True
        if self.level > other.level:
            return False

        @parameter
        for i in range(5):
            if self.value[i] < other.value[i]:
                return True
            if self.value[i] > other.value[i]:
                return False

        return False

    fn __ge__(self, other: Self) -> Bool:
        return self == other or self > other

    fn __le__(self, other: Self) -> Bool:
        return self == other or self < other


@register_passable("trivial")
struct Card[mode: HandMode]:
    var value: Scalar[CardType]
    alias A = Self(14)
    alias K = Self(13)
    alias Q = Self(12)
    alias J = Self(11 if mode == HandMode.First else 1)
    alias T = Self(10)

    fn __init__(out self, v: Int):
        self.value = v

    fn __init__(out self, v: String):
        if v == "A":
            self = Self.A
        elif v == "K":
            self = Self.K
        elif v == "Q":
            self = Self.Q
        elif v == "J":
            self = Self.J
        elif v == "T":
            self = Self.T
        else:
            self.value = parse_int(v)


fn parse_int(string: StringSlice) -> Int:
    try:
        return Int(string)
    except:
        print("Error parsing int")
        sys.exit(1)
        return 0


struct Solution(ListSolution):
    alias dtype = DType.uint32
    alias Hand1 = Hand[HandMode.First]
    alias Hand2 = Hand[HandMode.Second]

    @staticmethod
    fn part_1(lines: List[String]) -> UInt32:
        cards = List[Self.Hand1](capacity=1000)
        for line in lines:
            cards.append(Self.Hand1(line))

        total = 0

        sort(cards)
        for idx in range(len(cards)):
            total += (idx + 1) * Int(cards[idx].bid)

        return total

    @staticmethod
    fn part_2(lines: List[String]) -> UInt32:
        cards = List[Self.Hand2](capacity=1000)
        for line in lines:
            cards.append(Self.Hand2(line))

        total = 0

        sort(cards)
        for idx in range(len(cards)):
            total += (idx + 1) * Int(cards[idx].bid)

        return total
