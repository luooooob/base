package base.core

import std.unittest.*
import std.unittest.testmacro.{Test, TestCase, Expect}

@Test
class ResultTest {
  @TestCase
  func isOkTest() {
    @Expect(Result<Int64, String>.Ok(1).isOk(), true)
    @Expect(Result<Int64, String>.Err("e").isOk(), false)
  }

  @TestCase
  func isErrTest() {
    @Expect(Result<Int64, String>.Ok(1).isErr(), false)
    @Expect(Result<Int64, String>.Err("e").isErr(), true)
  }

  @TestCase
  func someOrNoneTest() {
     @Expect(Result<Int64, String>.Ok(1).ok(), Some(1))
     @Expect(Result<Int64, String>.Err("e").ok(), None)
  }

  @TestCase
  func someOrNoneErrTest() {
     @Expect(Result<Int64, String>.Ok(1).err(), None)
     @Expect(Result<Int64, String>.Err("e").err(), Some("e"))
  }

  @TestCase
  func andTest() {
    let table: Array<(Result<Int64, String>, Result<Int64, String>, Result<Int64, String>)> = [
      (Ok(1), Ok(2), Ok(2)),
      (Ok(1), Err("e"), Err("e")),
      (Err("e"), Ok(2), Err("e")),
      (Err("e"), Err("e"), Err("e"))
    ]
    table.iterator().forEach { t => 
      let (a, b, c) = t
      @Expect(a.and(b), c)
    }
  }

  @TestCase
  func orTest() {
    let table: Array<(Result<Int64, String>, Result<Int64, String>, Result<Int64, String>)> = [
      (Ok(1), Ok(2), Ok(1)),
      (Ok(1), Err("e"), Ok(1)),
      (Err("e"), Ok(2), Ok(2)),
      (Err("e"), Err("e"), Err("e"))
    ]
    table.iterator().forEach { t => 
      let (a, b, c) = t
      @Expect(a.or(b), c)
    }
  }
}