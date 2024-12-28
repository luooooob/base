protected package base.tailrecimpl

import std.unittest.*
import std.unittest.testmacro.{Test, TestCase, Expect, ExpectThrows}
import std.ast.{Tokens, compareTokens, FuncDecl, Node, Decl}

@Test
class TailrecTest {
    @TestCase
    func tailrecTest1() {
        let input = quote(
        func sum(acc: Int64, x: Int64): Int64 {
            if (x == 0) {
                acc
            } else {
                sum(acc + x, x - 1)
            }
        }
    )
        let output = quote(
        func sum(acc: Int64, x: Int64): Int64 {
            var value = Option<Int64>.None
            var __temp_acc = acc
            var __temp_x = x
            func __mut(acc: Int64, x: Int64): Option<Int64> {
                __temp_acc = acc
                __temp_x = x
                Option<Int64>.None
            }
            func __body(acc: Int64, x: Int64): Option<Int64> {
                if(x == 0) {
                    acc
                }
                else {
                    __mut(acc + x, x - 1)
                }
            }
            while(true) {
                match(value) {
                    case Some(x) => return x
                    case None => value = __body(__temp_acc, __temp_x)
                }
            }
            throw Exception("Unreachable code")
        }
    )
        @Expect(compareTokens(tailrec(input), output), true)
    }

    @TestCase
    func tailrecTest2() {
        let input = quote(
        public func sum(acc: Int64, x: Int64): Int64 {
            if (x == 0) {
                acc
            } else {
                sum(acc + x, x - 1)
            }
        }
    )
        let output = quote(
        public func sum(acc: Int64, x: Int64): Int64 {
            var value = Option<Int64>.None 
            var __temp_acc = acc
            var __temp_x = x
            func __mut(acc: Int64, x: Int64): Option<Int64> {
                __temp_acc = acc
                __temp_x = x
                Option<Int64>.None
            }
            func __body(acc: Int64, x: Int64): Option<Int64> {
                if(x == 0) {
                    acc
                }
                else {
                    __mut(acc + x, x - 1)
                }
            }
            while(true) {
                match(value) {
                    case Some(x) => return x
                    case None => value = __body(__temp_acc, __temp_x)
                }
            }
            throw Exception("Unreachable code")
        }
    )
        @Expect(compareTokens(tailrec(input), output), true)
    }

    @TestCase
    func tailrecTest3() {
        let input = quote(
        interface A {
            
        }
    )
        @ExpectThrows[NotFuncException](tailrec(input))
    }

    @TestCase
    func tailrecTest4() {
        let input = quote(
        public func sum(acc: Int64, x: Int64): Int64 {
            if (x == 0) {
                acc
            } else {
                this.sum(acc + x, x - 1)
            }
        }
    )
        let output = quote(
        public func sum(acc: Int64, x: Int64): Int64 {
            var value = Option<Int64>.None
            var __temp_acc = acc
            var __temp_x = x
            func __mut(acc: Int64, x: Int64): Option<Int64> {
                __temp_acc = acc
                __temp_x = x
                Option<Int64>.None
            }
            func __body(acc: Int64, x: Int64): Option<Int64> {
                if(x == 0) {
                    acc
                }
                else {
                    __mut(acc + x, x - 1)
                }
            }
            while(true) {
                match(value) {
                    case Some(x) => return x
                    case None => value = __body(__temp_acc, __temp_x)
                }
            }
            throw Exception("Unreachable code")
        }
    )
        @Expect(compareTokens(tailrec(input), output), true)
    }
}
