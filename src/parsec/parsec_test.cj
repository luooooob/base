package base.parsec

import std.unittest.*
import std.unittest.testmacro.{Test, TestCase, Expect}
import base.core.*

@Test
class ParsecTest {
    @TestCase
    func fromCondTest() {
        let p = Parsec<Rune, Rune>.fromCond {x => x == r'a'}
        @Expect(p.parseFunc(Lst<Rune>.fromString("ABC")).isSome(), false)
        @Expect(p.parseFunc(Lst<Rune>.fromString("abc")).isSome(), true)
        @Expect(p.parseFunc(Lst<Rune>.fromString("bac")).isSome(), false)
    }

    @TestCase
    func andTest() {
        let p1 = Parsec<Rune, Rune>.fromCond {x => x == r'a'}
        let p2 = Parsec<Rune, Rune>.fromCond {x => x == r'b'}
        let p3 = p1.and(p2)
        @Expect(p3.parseFunc(Lst<Rune>.fromString("ABC")).isSome(), false)
        @Expect(p3.parseFunc(Lst<Rune>.fromString("abc")).isSome(), true)
        @Expect(p3.parseFunc(Lst<Rune>.fromString("bac")).isSome(), false)
    }

    @TestCase
    func orTest() {
        let p1 = Parsec<Rune, Rune>.fromCond {x => x == r'a'}
        let p2 = Parsec<Rune, Rune>.fromCond {x => x == r'b'}
        let p3 = p1.or(p2)
        @Expect(p3.parseFunc(Lst<Rune>.fromString("ABC")).isSome(), false)
        @Expect(p3.parseFunc(Lst<Rune>.fromString("abc")).isSome(), true)
        @Expect(p3.parseFunc(Lst<Rune>.fromString("bac")).isSome(), true)
    }
}
