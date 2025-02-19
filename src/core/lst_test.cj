package base.core

import std.unittest.*
import std.unittest.testmacro.{Test, TestCase, Expect}

@Test
class LstTest {
    @TestCase
    func emptyTest() {
        let l = Lst<Int64>.empty()
        @Expect(l, Lst.Nil)
    }

    @TestCase
    func consTest() {
        let l = Lst<Int64>.empty().cons(7)
        @Expect(l, Lst.Cons(7, Nil))
    }

    @TestCase
    func makeByTest() {
        let l = Lst.makeBy(3, {i => i})
        println(l)
        @Expect(l, Cons(0, Cons(1, Cons(2, Nil))))
    }

    @TestCase
    func fromArrayTest() {
        let l = Lst.fromArray([1, 2, 3])
        @Expect(l, Cons(1, Cons(2, Cons(3, Nil))))
    }

    @TestCase
    func fromStringTest() {
        let l = Lst<Rune>.fromString("abc")
        @Expect(l, Cons(r'a', Cons(r'b', Cons(r'c', Nil))))
    }

    @TestCase
    func foldlTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).foldl(0) {acc, x => acc + x}
        @Expect(l, 39)
    }

    @TestCase
    func foldrTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).foldr(0) {x, acc => acc + x}
        @Expect(l, 39)
    }

    @TestCase
    func revTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).rev()
        @Expect(l, Lst.fromArray([3, 9, 7, 6, 4, 1, 5, 4]))
    }

    @TestCase
    func revMapTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).revMap {x => x * 2}
        @Expect(l, Lst.fromArray([6, 18, 14, 12, 8, 2, 10, 8]))
    }

    @TestCase
    func revMapiTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).revMapi {_, i => i}
        @Expect(l, Lst.fromArray([7, 6, 5, 4, 3, 2, 1, 0]))
    }

    @TestCase
    func revFilterTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).revFilter {x => x % 2 == 0}
        @Expect(l, Lst.fromArray([6, 4, 4]))
    }

    @TestCase
    func revAppendTest() {
        let l1 = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3])
        let l2 = Lst.fromArray([14, 15, 11, 14, 16, 17, 19, 13])
        let l = l1.revAppend(l2)
        @Expect(l, Lst.fromArray([3, 9, 7, 6, 4, 1, 5, 4, 14, 15, 11, 14, 16, 17, 19, 13]))
    }

    @TestCase
    func mapTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).map {x => x * 2}
        @Expect(l, Lst.fromArray([8, 10, 2, 8, 12, 14, 18, 6]))
    }

    @TestCase
    func mapiTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).mapi {_, i => i}
        @Expect(l, Lst.fromArray([0, 1, 2, 3, 4, 5, 6, 7]))
    }

    @TestCase
    func filterTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).filter {x => x % 2 == 0}
        @Expect(l, Lst.fromArray([4, 4, 6]))
    }

    @TestCase
    func appendTest() {
        let l1 = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3])
        let l2 = Lst.fromArray([14, 15, 11, 14, 16, 17, 19, 13])
        let l = l1.append(l2)
        @Expect(l, Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3, 14, 15, 11, 14, 16, 17, 19, 13]))
    }

    @TestCase
    func partitionTest() {
        let (l1, l2) = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).partition {x => x % 2 == 0}
        @Expect(l1, Lst.fromArray([4, 4, 6]))
        @Expect(l2, Lst.fromArray([5, 1, 7, 9, 3]))
    }

    @TestCase
    func lenTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3])
        @Expect(l.len(), 8)
        @Expect(Lst<Int64>.empty().len(), 0)
    }

    @TestCase
    func headTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3])
        @Expect(l.head(), 4)
        @Expect(Lst<Int64>.empty().head(), None)
    }

    @TestCase
    func tailTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3])
        @Expect(l.tail(), Lst.fromArray([5, 1, 4, 6, 7, 9, 3]))
        @Expect(Lst<Int64>.empty().tail(), None)
        @Expect(Lst<Int64>.empty().cons(1).tail(), Lst.empty())
    }

    @TestCase
    func isEmptyTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3])
        @Expect(l.isEmpty(), false)
        @Expect(Lst<Int64>.empty().isEmpty(), true)
    }

    @TestCase
    func forAllTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3])
        @Expect(l.forAll { x => x % 2 == 0 }, false)
        @Expect(l.forAll { x => x < 10 }, true)
    }

    @TestCase
    func existsTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3])
        @Expect(l.exists { x => x % 2 == 0 }, true)
        @Expect(l.exists { x => x > 10 }, false)
    }

    @TestCase
    func sortTest() {
        let l = Lst.fromArray([4, 5, 1, 4, 6, 7, 9, 3]).sort {a, b => a < b}
        @Expect(l, Lst.fromArray([1, 3, 4, 4, 5, 6, 7, 9]))
    }
}
