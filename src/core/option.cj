package base.core

public interface OptionExt<A> {
    func mapNone(f: () -> A): Option<A>
    func flatMapNone(f: () -> Option<A>): Option<A>
    // func and<B>(b: Option<B>): Option<B>
    func or(b: Option<A>): Option<A>
    func xor(b: Option<A>): Option<A>
}

extend<A> Option<A> <: OptionExt<A> {
    /**
     * 如果该 option 为 Some 返回该 Some, 否则返回 Some(f())
     */
    public func mapNone(f: () -> A): Option<A> {
        match (this) {
            case Some(x) => Some(x)
            case None => Some(f())
        }
    }

    /**
     * 如果该 option 为 Some 返回该 Some, 否则返回 f(), 其中f()的返回值为 Option<A> 类型
     */
    public func flatMapNone(f: () -> Option<A>): Option<A> {
        match (this) {
            case Some(x) => Some(x)
            case None => f()
        }
    }

    /**
     * 如果该 option 为 Some 返回 b, 否则返回 None
     */
    public func and<B>(b: Option<B>): Option<B> {
        match (this) {
            case Some(x) => b
            case None => None
        }
    }

    /**
     * 如果该 option 为 Some 返回该 Some, 否则返回 b
     */
    public func or(b: Option<A>): Option<A> {
        match (this) {
            case Some(x) => Some(x)
            case None => b
        }
    }


    /**
     *如果该 option 和 b 有一个为 Some 返回该 Some, 否则返回 None
     */
    public func xor(b: Option<A>): Option<A> {
        match ((this, b)) {
            case (Some(x), None) => Some(x)
            case (None, Some(x)) => Some(x)
            case _ => None
        }
    }

    /**
     * 将该 option 转换为 Result 类型
     * 当该 option 为 Some 时返回 Result.Ok(A), 否则返回 Result.Err(E)
     */
    public func okOrErr<E>(err: E): Result<A, E> {
        match (this) {
            case Some(x) => Ok(x)
            case None => Err(err)
        }
    }
}