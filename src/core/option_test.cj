package base.core

import std.unittest.*
import std.unittest.testmacro.{Test, TestCase, Expect}

/**
 * 由于泛型接口尚未支持, 替代方案又遇到和单测冲突的问题，所以部分测试被注释
 * 替代方案问题 https://gitcode.com/Cangjie/UsersForum/issues/757
 * 单测冲突问题 https://gitcode.com/Cangjie/UsersForum/issues/1387
 */
@Test
class OptionTest {
    @TestCase
    func mapNoneTest() {
        let f = {=> 2}
        @Expect(Some(1).mapNone(f), Some(1))
        @Expect(None<Int64>.mapNone(f), Some(2))
    }

    @TestCase
    func flatMapNoneTest() {
        let f = {=> Some(2)}
        @Expect(Some(1).flatMapNone(f), Some(1))
        @Expect(None<Int64>.flatMapNone(f), Some(2))
    }

    // @TestCase
    // func andTest() {
    //   let table: Array<(Option<Int64>, Option<Int64>, Option<Int64>)> = [
    //     (Some(1), Some(2), Some(2)),
    //     (Some(1), None, None),
    //     (None, Some(2), None),
    //     (None, None, None)
    //   ]
    //   table.iterator().forEach { t => 
    //     let (a, b, c) = t
    //     @Expect(a.and(b), c)
    //   }
    // }

    @TestCase
    func orTest() {
        let table: Array<(Option<Int64>, Option<Int64>, Option<Int64>)> = [
            (Some(1), Some(2), Some(1)),
            (Some(1), None, Some(1)),
            (None, Some(2), Some(2)),
            (None, None, None)
        ]
        table.iterator().forEach {
            t =>
            let (a, b, c) = t
            @Expect(a.or(b), c)
        }
    }

    @TestCase
    func xorTest() {
        let table: Array<(Option<Int64>, Option<Int64>, Option<Int64>)> = [
            (Some(1), Some(2), None),
            (Some(1), None, Some(1)),
            (None, Some(2), Some(2)),
            (None, None, None)
        ]
        table.iterator().forEach {
            t =>
            let (a, b, c) = t
            @Expect(a.xor(b), c)
        }
    }

    // @TestCase
    // func okOrErrTest() {
    //   @Expect(Some(1).okOrErr("no number"), Ok(1))
    //   @Expect(None<Int64>.okOrErr("no number"), Err("no number"))
    // }
}
