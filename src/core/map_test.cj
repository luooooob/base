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
  func sizeTest() {
    @Expect(Map<String, Int64>.empty().size(), 0)
    @Expect(Map<String, Int64>.empty().add("1", 1).size(), 1)
  }

  @TestCase
  func removeTest() {
    @Expect(Map<String, Int64>.empty().add("1", 1).remove("1"), Map<String, Int64>.empty())
    @Expect(Map<String, Int64>.empty().add("1", 1).remove("2"), Map<String, Int64>.empty().add("1", 1))
  }
}