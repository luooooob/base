package base.core

import std.unittest.*
import std.unittest.testmacro.{Test, TestCase, Expect}

@Test
class SetTest {
    @TestCase
    func emptyTest() {
        @Expect(Set<Int64>.empty().isEmpty(), true)
    }

    @TestCase
    func sizeTest() {
        @Expect(Set<Int64>.empty().size(), 0)
        @Expect(Set<Int64>.empty().add(1).size(), 1)
        @Expect(Set<Int64>.empty().add(1).add(2).size(), 2)
    }

    @TestCase
    func addTest() {
        @Expect(Set<Int64>.empty().add(1).isEmpty(), false)
    }

    @TestCase
    func removeTest() {
        let s = Set<Int64>.empty().add(1).add(2).remove(1)
        @Expect(s.exists(1), false)
        @Expect(s.exists(2), true)
    }
    
    @TestCase
    func existsTest() {
        @Expect(Set<Int64>.empty().add(1).exists(1), true)
        @Expect(Set<Int64>.empty().add(1).exists(2), false)
    }

    @TestCase
    func findTest() {
        @Expect(Set<Int64>.empty().add(1).find(1), Some(1))
        @Expect(Set<Int64>.empty().add(1).find(2), None)
    }
}
