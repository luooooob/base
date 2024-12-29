package base.core

import std.deriving.Derive
import base.tailrec.Tailrec

@Derive[ToString where A <: ToString]
public enum List<A> {
    | Nil
    | Cons(A, List<A>)
}

extend<A> List<A> {
    /**
     * empty 构造一个空的 List
     */
    public static func empty(): List<A> {
        Nil
    }

    /** 
     * makeBy 使用 f 生成一个长度为 len 的 List
     * O(n), 尾递归
     */
    public static func makeBy(len: Int64, f: (Int64) -> A): List<A> {
        @Tailrec
        func aux(i: Int64, acc: List<A>): List<A> {
            match (i) {
                case 0 => Cons(f(i), acc)
                case _ => aux(i - 1, Cons(f(i), acc))
            }
        }
        aux(len - 1, Nil)
    }

    /**
     * fromArray 从数组构造 List
     * O(n), 尾递归
     */
    public static func fromArray(arr: Array<A>): List<A> {
        List.makeBy(arr.size, {i => arr[i]})
    }

    /**
     * cons 在 List 的头部增加一个元素
     * O(1)
     */
    public func cons(x: A): List<A> {
        Cons(x, this)
    }

    /**
     * find 返回满足 f 的第一个元素
     * O(n), 尾递归
     */
    public func find(f: (A) -> Bool): Option<A> {
        @Tailrec
        func aux(l: List<A>): Option<A> {
            match (l) {
                case Nil => None
                case Cons(hd, _) where f(hd) => Some(hd)
                case Cons(_, tl) => aux(tl)
            }
        }
        aux(this)
    }

    /**
     * nth 返回下标为 i 的元素
     * 第一个元素下标为 0
     * O(n), 尾递归
     */
    public func nth(i: Int64): Option<A> {
        @Tailrec
        func aux(l: List<A>, i: Int64): Option<A> {
            match (l) {
                case Nil => None
                case Cons(hd, _) where i == 0 => Some(hd)
                case Cons(_, tl) => aux(tl, i - 1)
            }
        }
        aux(this, i)
    }

    /**
     * head 返回第一个元素
     * O(1)
     */
    public func head(): Option<A> {
        match (this) {
            case Nil => None
            case Cons(hd, _) => Some(hd)
        }
    }

    /**
     * tail 返回除第一个元素外的所有元素
     * O(1)
     */
    public func tail(): Option<List<A>> {
        match (this) {
            case Nil => None
            case Cons(hd, tl) => Some(tl)
        }
    }

    /**
     * foldl 左折叠
     * O(n), 尾递归
     */
    public func foldl<B>(acc: B, f: (B, A) -> B): B {
        @Tailrec
        func aux(l: List<A>, acc: B): B {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, f(acc, hd))
            }
        }
        aux(this, acc)
    }

    /**
     * foldr 右折叠
     * O(n), *非尾递归*
     */
    public func foldr<B>(acc: B, f: (A, B) -> B): B {
        // not tailrec func
        func aux(l: List<A>, acc: B): B {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => f(hd, aux(tl, acc))
            }
        }
        aux(this, acc)
    }

    /** 
     * rev 反转List
     * O(n), 尾递归
     */
    public func rev(): List<A> {
        @Tailrec
        func aux(l: List<A>, acc: List<A>): List<A> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, Cons(hd, acc))
            }
        }
        aux(this, Nil)
    }

    /**
     * revMap 从右向左执行的 map，结果是反转的
     * O(n), 尾递归
     */
    public func revMap<B>(f: (A) -> B): List<B> {
        @Tailrec
        func aux(l: List<A>, acc: List<B>): List<B> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, Cons(f(hd), acc))
            }
        }
        aux(this, Nil)
    }

    /**
     * revMapi 从右向左执行的 mapi，结果是反转的
     * O(n), 尾递归
     */
    public func revMapi<B>(f: (A, Int64) -> B): List<B> {
        @Tailrec
        func aux(l: List<A>, i: Int64, acc: List<B>): List<B> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, i + 1, Cons(f(hd, i), acc))
            }
        }
        aux(this, 0, Nil)
    }

    /**
     * revFilter 从右向左执行的 filter，结果是反转的
     * O(n), 尾递归
     */
    public func revFilter(f: (A) -> Bool): List<A> {
        @Tailrec
        func aux(l: List<A>, acc: List<A>): List<A> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) where f(hd) => aux(tl, Cons(hd, acc))
                case Cons(_, tl) => aux(tl, acc)
            }
        }
        aux(this, Nil)
    }

    /**
     * revAppend 返回 this.rev() @ l
     * O(n), 尾递归
     */
    public func revAppend(l: List<A>): List<A> {
        @Tailrec
        func aux(l: List<A>, acc: List<A>): List<A> {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, Cons(hd, acc))
            }
        }
        aux(this, l)
    }

    /**
     * map 从左向右执行的 map
     * O(n), *非尾递归*
     */
    public func map<B>(f: (A) -> B): List<B> {
        func aux(l: List<A>): List<B> {
            match (l) {
                case Nil => Nil
                case Cons(hd, tl) => Cons(f(hd), aux(tl))
            }
        }
        aux(this)
    }

    /**
     * mapi 从左向右执行的 mapi
     * O(n), *非尾递归*
     */
    public func mapi<B>(f: (A, Int64) -> B): List<B> {
        // 非尾递归
        func aux(l: List<A>, i: Int64): List<B> {
            match (l) {
                case Nil => Nil
                case Cons(hd, tl) => Cons(f(hd, i), aux(tl, i + 1))
            }
        }
        aux(this, 0)
    }

    /**
     * filter 从左向右执行的 filter
     * O(n), *非尾递归*
     */
    public func filter(f: (A) -> Bool): List<A> {
        // 非尾递归
        func aux(l: List<A>): List<A> {
            match (l) {
                case Nil => Nil
                case Cons(hd, tl) where f(hd) => Cons(hd, aux(tl))
                case Cons(_, tl) => aux(tl)
            }
        }
        aux(this)
    }

    /**
     * append 返回 l1 @ l2
     * O(n), *非尾递归*
     */
    public func append(l: List<A>): List<A> {
        // 非尾递归
        func aux(l1: List<A>, l2: List<A>): List<A> {
            match (l1) {
                case Nil => l2
                case Cons(hd, tl) => Cons(hd, aux(tl, l2))
            }
        }
        aux(this, l)
    }

    /**
     * partition 将 List 划分为两个 List，左边的 List 元素都满足 f，右边的 List 元素都不满足 f
     * O(n), 尾递归
     */
    public func partition(f: (A) -> Bool): (List<A>, List<A>) {
        @Tailrec
        func aux(l: List<A>, yes: List<A>, no: List<A>): (List<A>, List<A>) {
            match (l) {
                case Nil => (yes.rev(), no.rev())
                case Cons(hd, tl) where f(hd) => aux(tl, Cons(hd, yes), no)
                case Cons(hd, tl) => aux(tl, yes, Cons(hd, no))
            }
        }
        aux(this, Nil, Nil)
    }

    /**
     * len 返回 List 的长度
     * O(n), 尾递归
     */
    public func len(): Int64 {
        @Tailrec
        func aux(l: List<A>, acc: Int64): Int64 {
            match (l) {
                case Nil => acc
                case Cons(_, tl) => aux(tl, acc + 1)
            }
        }
        aux(this, 0)
    }

    /**
     * isEmpty 判断 List 是否为空
     * O(1)
     */
    public func isEmpty(): Bool {
        match (this) {
            case Nil => true
            case _ => false
        }
    }

    /**
     * forAll 判断所有元素是否满足 f
     * O(n), 尾递归
     */
    public func forAll(f: (A) -> Bool): Bool {
        @Tailrec
        func aux(l: List<A>, acc: Bool): Bool {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, acc && f(hd))
            }
        }
        aux(this, true)
    }

    /**
     * exists 判断是否存在元素满足 f
     * O(n), 尾递归
     */
    public func exists(f: (A) -> Bool): Bool {
        @Tailrec
        func aux(l: List<A>, acc: Bool): Bool {
            match (l) {
                case Nil => acc
                case Cons(hd, tl) => aux(tl, acc || f(hd))
            }
        }
        aux(this, false)
    }

    /**
     * sort 对 List 进行归并排序
     * O(nlogn), 非尾递归
     */
    public func sort(cmp: (A, A) -> Bool): List<A> {
        @Tailrec
        func merge(l1: List<A>, l2: List<A>, acc: List<A>): List<A> {
            match ((l1, l2)) {
                case (Nil, Nil) => acc.rev()
                case (Nil, Cons(hd2, tl2)) => merge(Nil, tl2, Cons(hd2, acc))
                case (Cons(hd1, tl1), Nil) => merge(tl1, Nil, Cons(hd1, acc))
                case (Cons(hd1, tl1), Cons(hd2, tl2)) where cmp(hd1, hd2) => merge(tl1, l2, Cons(hd1, acc))
                case (Cons(hd1, tl1), Cons(hd2, tl2)) => merge(l1, tl2, Cons(hd2, acc))
            }
        }
        @Tailrec
        func revSplit(l: List<A>, l1: List<A>, l2: List<A>): (List<A>, List<A>) {
            match (l) {
                case Nil => (l1, l2)
                case Cons(hd, Nil) => (l1.cons(hd), l2)
                case Cons(hd, Cons(hd1, tl)) => revSplit(tl, Cons(hd, l1), Cons(hd1, l2))
            }
        }
        func aux(l: List<A>): List<A> {
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

extend<A> List<A> <: Equatable<List<A>> where A <: Equatable<A> {
    /**
     * == 判断两个 List 是否每一个元素都相等
     */
    public operator func ==(rhs: List<A>): Bool {
        func aux(l1: List<A>, l2: List<A>): Bool {
            match ((l1, l2)) {
                case (Nil, Nil) => true
                case (Cons(hd1, tl1), Cons(hd2, tl2)) where hd1 == hd2 => aux(tl1, tl2)
                case _ => false
            }
        }
        aux(this, rhs)
    }
}
