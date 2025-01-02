package base.core

import std.unittest.*
import std.unittest.testmacro.{Test, TestCase, Expect}

@Test
class MapTest {
    @TestCase
    func emptyTest() {
        @Expect(Map<Int64, Int64>.empty().isEmpty(), true)
    }

    @TestCase
    func sizeTest() {
        @Expect(Map<String, Int64>.empty().size(), 0)
        @Expect(Map<String, Int64>.empty().add("1", 1).size(), 1)
        @Expect(Map<String, Int64>.empty().add("1", 1).add("2", 2).size(), 2)
    }

    @TestCase
    func addTest() {
        @Expect(Map<String, Int64>.empty().add("1", 1).isEmpty(), false)
    }

    @TestCase
    func existsTest() {
        @Expect(Map<String, Int64>.empty().add("1", 1).exists("1"), true)
        @Expect(Map<String, Int64>.empty().add("1", 1).exists("2"), false)
    }

    @TestCase
    func findTest() {
        @Expect(Map<String, Int64>.empty().add("1", 1).find("1"), Some(1))
        @Expect(Map<String, Int64>.empty().add("1", 1).find("2"), None)
    }

    @TestCase
    func removeTest() {
        let m = Map<String, Int64>.empty().add("1", 1).add("2", 2).remove("1")
        @Expect(m.find("1"), None)
        @Expect(m.find("2"), Some(2))
    }
}
