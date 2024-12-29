package base.core

import base.tailrec.Tailrec
import std.deriving.Derive

@Derive[ToString where A <: ToString, E <: ToString]
@Derive[Equatable where A <: Equatable<A>, E <: Equatable<E>]
public enum Result<A, E> {
    | Ok(A)
    | Err(E)
}

extend<A, E> Result<A, E> {
    /**
     * 判断该 result 是否为 Ok
     */
    public func isOk(): Bool {
        match (this) {
            case Ok(_) => true
            case _ => false
        }
    }

    /**
     * 判断该 result 是否为 Err
     */
    public func isErr(): Bool {
        match (this) {
            case Err(_) => true
            case _ => false
        }
    }

    /**
     * 如果该 result 为 Ok 返回 Ok(f(a)), 否则返回原 Err
     */
    public func map<B>(f: (A) -> B): Result<B, E> {
        match (this) {
            case Ok(a) => Ok(f(a))
            case Err(e) => Err(e)
        }
    }

    /**
     * 如果该 result 为 Err 返回 Err(f(e)), 否则返回原 Ok
     */
    public func mapErr<F>(f: (E) -> F): Result<A, F> {
        match (this) {
            case Ok(a) => Ok(a)
            case Err(e) => Err(f(e))
        }
    }

    /** 
     * 如果该 result 为 Ok 返回 f(a), 其中 f(a) 的结果为 Result<B, E> 类型, 否则返回原 Err
     */
    public func flatMap<B>(f: (A) -> Result<B, E>): Result<B, E> {
        match (this) {
            case Ok(a) => f(a)
            case Err(e) => Err(e)
        }
    }

    public func flatMapErr<F>(f: (E) -> Result<A, F>): Result<A, F> {
        match (this) {
            case Ok(a) => Ok(a)
            case Err(e) => f(e)
        }
    }

    /**
     * 将该 result 转换成 Option 类型
     * 如果该 result 为 Ok 返回 Some(a), 否则返回 None
     */
    public func ok(): Option<A> {
        match (this) {
            case Ok(a) => Some(a)
            case _ => None
        }
    }

    /**
     * 将该 result 转换成 Option 类型, 但是反过来的
     * 如果该 result 为 Err 返回 Some(e), 否则返回 None
     */
    public func err(): Option<E> {
        match (this) {
            case Err(e) => Some(e)
            case _ => None
        }
    }

    /**
     * 如果该 result 为 Ok 返回 b, 否则返回原 Err
     */
    public func and(b: Result<A, E>): Result<A, E> {
        match (this) {
            case Ok(a) => b
            case Err(e) => Err(e)
        }
    }

    /**
     * 如果该 result 为 Ok 返回该 Ok, 否则返回 b
     */
    public func or(b: Result<A, E>): Result<A, E> {
        match (this) {
            case Ok(a) => Ok(a)
            case Err(e) => b
        }
    }
}

// extend<A, E> Result<A, E> <: Equatable<Result<A, E>> where A <: Equatable<A>, E <: Equatable<E> {
//     /**
//      * 判断两个 Result 是否相等
//      */
//     public operator func == (rhs: Result<A, E>): Bool {
//         match ((this, rhs)) {
//             case (Ok(a), Ok(b)) => a == b
//             case (Err(a), Err(b)) => a == b
//             case _ => false
//         }
//     }
// }