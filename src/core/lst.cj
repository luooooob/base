package base.core

import std.deriving.Derive
import base.tailrec.Tailrec

@Derive[ToString where A <: ToString]
public enum Lst<A> {
    | Nil
    | Cons(A, Lst<A>)
}

extend<A> Lst<A> {
    /**
     * 构造一个空的 Lst
     */
    public static func empty(): Lst<A> {
        Nil
    }

    /** 
     * 使用 f 生成一个长度为 len 的 Lst
     * O(n), 尾递归
     */
    public static func makeBy(len: Int64, f: (Int64) -> A): Lst<A> {
        @Tailrec
        func aux(i: Int64, acc: Lst<A>): Lst<A> {
            match (i) {
                case 0 => Cons(f(i), acc)
                case _ => aux(i - 1, Cons(f(i), acc))
            }
        }
        aux(len - 1, Nil)
    }

    /**
     * 从数组构造 Lst
     * O(n), 尾递归
     */
    public static func fromArray(arr: Array<A>): Lst<A> {
        Lst.makeBy(arr.size, {i => arr[i]})
    }

    /**
     * 在 Lst 的头部增加一个元素
     * 等于 Cons(this, x)
     * O(1)
     */
    public func cons(x: A): Lst<A> {
        Cons(x, this)
    }

    /**
     * 返回满足 f 的第一个元素
     * O(n), 尾递归
     */
    public func find(f: (A) -> Bool): Option<A> {
        @Tailrec
        func aux(l: Lst<A>): Option<A> {
            match (l) {
                case Nil => None
                case Cons(hd, _) where f(hd) => Some(hd)
                case Cons(_, tl) => aux(tl)
            }
        }
        aux(this)
    }

    /**
     * 返回下标为 i 的元素
     * 第一个元素下标为 0
     * O(n), 尾递归
     */
    public func nth(i: Int64): Option<A> {
        @Tailrec
        func aux(l: Lst<A>, i: Int64): Option<A> {
            match (l) {
                case Nil => None
                case Cons(hd, _) where i == 0 => Some(hd)
                case Cons(_, tl) => aux(tl, i - 1)
            }
        }
        aux(this, i)
    }

    /**
     * 返回第一个元素
     * O(1)
     */
    public func head(): Option<A> {
        match (this) {
            case Nil => None
            case Cons(hd, _) => Some(hd)
        }
    }

    /**
     * 返回除第一个元素外的所有元素
     * O(1)
     */
    public func tail(): Option<Lst<A>> {
        match (this) {
            case Nil => None
            case Cons(hd, tl) => Some(tl)
        }
    }

    /**
     * 左折叠
     * O(n), 尾递归
     */
    public func foldl<B>(acc: B, f: (B, A) -> B): B {
        @Tailrec
        func aux(l: Lst<A>, acc: B): B {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, f(acc, hd))
            }
        }
        aux(this, acc)
    }

    /**
     * 右折叠
     * O(n), *非尾递归*
     */
    public func foldr<B>(acc: B, f: (A, B) -> B): B {
        // not tailrec func
        func aux(l: Lst<A>, acc: B): B {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => f(hd, aux(tl, acc))
            }
        }
        aux(this, acc)
    }

    /** 
     * 反转Lst
     * O(n), 尾递归
     */
    public func rev(): Lst<A> {
        @Tailrec
        func aux(l: Lst<A>, acc: Lst<A>): Lst<A> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, Cons(hd, acc))
            }
        }
        aux(this, Nil)
    }

    /**
     * 从右向左执行的 map，结果是反转的
     * O(n), 尾递归
     */
    public func revMap<B>(f: (A) -> B): Lst<B> {
        @Tailrec
        func aux(l: Lst<A>, acc: Lst<B>): Lst<B> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, Cons(f(hd), acc))
            }
        }
        aux(this, Nil)
    }

    /**
     * 从右向左执行的 mapi，结果是反转的
     * O(n), 尾递归
     */
    public func revMapi<B>(f: (A, Int64) -> B): Lst<B> {
        @Tailrec
        func aux(l: Lst<A>, i: Int64, acc: Lst<B>): Lst<B> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, i + 1, Cons(f(hd, i), acc))
            }
        }
        aux(this, 0, Nil)
    }

    /**
     * 从右向左执行的 filter，结果是反转的
     * O(n), 尾递归
     */
    public func revFilter(f: (A) -> Bool): Lst<A> {
        @Tailrec
        func aux(l: Lst<A>, acc: Lst<A>): Lst<A> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) where f(hd) => aux(tl, Cons(hd, acc))
                case Cons(_, tl) => aux(tl, acc)
            }
        }
        aux(this, Nil)
    }

    /**
     * 返回 this.rev() @ l
     * O(n), 尾递归
     */
    public func revAppend(l: Lst<A>): Lst<A> {
        @Tailrec
        func aux(l: Lst<A>, acc: Lst<A>): Lst<A> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, Cons(hd, acc))
            }
        }
        aux(this, l)
    }

    /**
     * 从左向右执行的 map
     * O(n), *非尾递归*
     */
    public func map<B>(f: (A) -> B): Lst<B> {
        func aux(l: Lst<A>): Lst<B> {
            match (l) {
                case Nil => Nil
                case Cons(hd, tl) => Cons(f(hd), aux(tl))
            }
        }
        aux(this)
    }

    /**
     * 从左向右执行的 mapi
     * O(n), *非尾递归*
     */
    public func mapi<B>(f: (A, Int64) -> B): Lst<B> {
        // 非尾递归
        func aux(l: Lst<A>, i: Int64): Lst<B> {
            match (l) {
                case Nil => Nil
                case Cons(hd, tl) => Cons(f(hd, i), aux(tl, i + 1))
            }
        }
        aux(this, 0)
    }

    /**
     * 从左向右执行的 filter
     * O(n), *非尾递归*
     */
    public func filter(f: (A) -> Bool): Lst<A> {
        // 非尾递归
        func aux(l: Lst<A>): Lst<A> {
            match (l) {
                case Nil => Nil
                case Cons(hd, tl) where f(hd) => Cons(hd, aux(tl))
                case Cons(_, tl) => aux(tl)
            }
        }
        aux(this)
    }

    /**
     * 返回 l1 @ l2
     * O(n), *非尾递归*
     */
    public func append(l: Lst<A>): Lst<A> {
        // 非尾递归
        func aux(l1: Lst<A>, l2: Lst<A>): Lst<A> {
            match (l1) {
                case Nil => l2
                case Cons(hd, tl) => Cons(hd, aux(tl, l2))
            }
        }
        aux(this, l)
    }

    /**
     * 将 Lst 划分为两个 Lst，左边的 Lst 元素都满足 f，右边的 Lst 元素都不满足 f
     * O(n), 尾递归
     */
    public func partition(f: (A) -> Bool): (Lst<A>, Lst<A>) {
        @Tailrec
        func aux(l: Lst<A>, yes: Lst<A>, no: Lst<A>): (Lst<A>, Lst<A>) {
            match (l) {
                case Nil => (yes.rev(), no.rev())
                case Cons(hd, tl) where f(hd) => aux(tl, Cons(hd, yes), no)
                case Cons(hd, tl) => aux(tl, yes, Cons(hd, no))
            }
        }
        aux(this, Nil, Nil)
    }

    /**
     * 返回 Lst 的长度
     * O(n), 尾递归
     */
    public func len(): Int64 {
        @Tailrec
        func aux(l: Lst<A>, acc: Int64): Int64 {
            match (l) {
                case Nil => acc
                case Cons(_, tl) => aux(tl, acc + 1)
            }
        }
        aux(this, 0)
    }

    /**
     * 判断 Lst 是否为空
     * O(1)
     */
    public func isEmpty(): Bool {
        match (this) {
            case Nil => true
            case _ => false
        }
    }

    /**
     * 判断所有元素是否满足 f
     * O(n), 尾递归
     */
    public func forAll(f: (A) -> Bool): Bool {
        @Tailrec
        func aux(l: Lst<A>, acc: Bool): Bool {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, acc && f(hd))
            }
        }
        aux(this, true)
    }

    /**
     * 判断是否存在元素满足 f
     * O(n), 尾递归
     */
    public func exists(f: (A) -> Bool): Bool {
        @Tailrec
        func aux(l: Lst<A>, acc: Bool): Bool {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, acc || f(hd))
            }
        }
        aux(this, false)
    }

    /**
     * 对 Lst 进行归并排序
     * O(nlogn), 非尾递归
     */
    public func sort(cmp: (A, A) -> Bool): Lst<A> {
        @Tailrec
        func merge(l1: Lst<A>, l2: Lst<A>, acc: Lst<A>): Lst<A> {
            match ((l1, l2)) {
                case (Nil, Nil) => acc.rev()
                case (Nil, Cons(hd2, tl2)) => merge(Nil, tl2, Cons(hd2, acc))
                case (Cons(hd1, tl1), Nil) => merge(tl1, Nil, Cons(hd1, acc))
                case (Cons(hd1, tl1), Cons(hd2, tl2)) where cmp(hd1, hd2) => merge(tl1, l2, Cons(hd1, acc))
                case (Cons(hd1, tl1), Cons(hd2, tl2)) => merge(l1, tl2, Cons(hd2, acc))
            }
        }
        @Tailrec
        func revSplit(l: Lst<A>, l1: Lst<A>, l2: Lst<A>): (Lst<A>, Lst<A>) {
            match (l) {
                case Nil => (l1, l2)
                case Cons(hd, Nil) => (l1.cons(hd), l2)
                case Cons(hd, Cons(hd1, tl)) => revSplit(tl, Cons(hd, l1), Cons(hd1, l2))
            }
        }
        func aux(l: Lst<A>): Lst<A> {
            match (l) {
                case Nil | Cons(_, Nil) => l
                case Cons(_, _) =>
                    let (l1, l2) = revSplit(l, Nil, Nil)
                    merge(aux(l1), aux(l2), Nil)
            }
        }
        aux(this)
    }
}

// 需要手动实现 Equatable 因此为 Lst 自动派生的 Equatable 实现会有性能问题
extend<A> Lst<A> <: Equatable<Lst<A>> where A <: Equatable<A> {
    /**
     * 判断两个 Lst 是否每一个元素都相等
     */
    public operator func ==(rhs: Lst<A>): Bool {
        func aux(l1: Lst<A>, l2: Lst<A>): Bool {
            match ((l1, l2)) {
                case (Nil, Nil) => true
                case (Cons(hd1, tl1), Cons(hd2, tl2)) where hd1 == hd2 => aux(tl1, tl2)
                case _ => false
            }
        }
        aux(this, rhs)
    }
}
