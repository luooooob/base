package base.core

import std.deriving.Derive

// todo: 探索尾递归的ToString和Equatable实现

@Derive[ToString where V <: ToString]
public enum Set<V> where V <: Comparable<V> {
    | Empty
    | Node(Set<V>, V, Set<V>, Int64)
}

extend<V> Set<V> where V <: Comparable<V> {
    /**
     * 返回空 Set
     */
    public static func empty(): Set<V> {
        Empty
    }

    /**
     * 判断 Set 是否为空
     */
    public func isEmpty(): Bool {
        match (this) {
            case Empty => true
            case _ => false
        }
    }

    /**
     * 返回 Set 中的元素个数
     */
    public func size(): Int64 {
        match (this) {
            case Empty => 0
            case Node(l, _, r, _) => l.size() + 1 + r.size()
        }
    }

    func height(): Int64 {
        match (this) {
            case Empty => 0
            case Node(l, _, r, _) => 1 + max(l.height(), r.height())
        }
    }

    func create(l: Set<V>, v: V, r: Set<V>): Set<V> {
        let hl = l.height()
        let hr = r.height()
        if (hl > hr + 1) {
            match (l) {
                case Empty => Empty<V>
                case Node(ll, lv, lr, _) => create(ll, lv, create(lr, v, r))
            }
        } else if (hr > hl + 1) {
            match (r) {
                case Empty => Empty<V>
                case Node(rl, rv, rr, _) => create(create(l, v, rl), rv, rr)
            }
        } else {
            Node(l, v, r, 1 + max(hl, hr))
        }
    }

    func balance(l: Set<V>, v: V, r: Set<V>): Set<V> {
        let hl = l.height()
        let hr = r.height()
        if (hl > hr + 2) {
            match (l) {
                case Empty => Empty<V>
                case Node(ll, lv, lr, _) =>
                    if (ll.height() >= lr.height()) {
                        create(ll, lv, create(lr, v, r))
                    } else {
                        match (lr) {
                            case Empty => Empty<V>
                            case Node(lrl, lrv, lrr, _) => create(create(ll, lv, lrl), lrv, create(lrr, v, r))
                        }
                    }
            }
        } else if (hr > hl + 2) {
            match (r) {
                case Empty => Empty<V>
                case Node(rl, rv, rr, _) =>
                    if (rr.height() >= rl.height()) {
                        create(create(l, v, rl), rv, rr)
                    } else {
                        match (rl) {
                            case Empty => Empty<V>
                            case Node(rll, rlv, rlr, _) => create(create(l, v, rll), rlv, create(rlr, rv, rr))
                        }
                    }
            }
        } else {
            create(l, v, r)
        }
    }

    /**
     * 添加元素
     */
    public func add(v: V): Set<V> {
        match (this) {
            case Empty => Node(Empty, v, Empty, 1)
            case Node(l, _, r, _) => balance(l.add(v), v, r)
        }
    }

    func minBinding(): (V, Set<V>) {
        func aux(m: Set<V>): (V, Set<V>) {
            match (m) {
                case Empty => throw Exception("Not found")
                case Node(Empty, k, r, _) => (k, r)
                case Node(l, _, _, _) => aux(l)
            }
        }
        aux(this)
    }

    func removeMinBinding(): Set<V> {
        match (this) {
            case Empty => Empty
            case Node(Empty, _, r, _) => r
            case Node(l, k, r, _) => balance(l.removeMinBinding(), k, r)
        }
    }

    func merge(other: Set<V>): Set<V> {
        match ((this, other)) {
            case (Empty, m) => m
            case (m, Empty) => m
            case (m1, m2) =>
                let (k, r) = m2.minBinding()
                this.balance(m1, k, r)
        }
    }

    /**
     * 删除元素
     */
    public func remove(v: V): Set<V> {
        match (this) {
            case Empty => Empty
            case Node(l, k, r, _) => match (v.compare(k)) {
                case EQ => balance(l, k, r)
                case LT => balance(l.remove(v), k, r)
                case GT => balance(l, k, r.remove(v))
            }
        }
    }

    /**
     * 查找元素
     */
    public func find(v: V): Option<V> {
        match (this) {
            case Empty => None
            case Node(l, k, r, _) => match (v.compare(k)) {
                case EQ => Some(k)
                case LT => l.find(v)
                case GT => r.find(v)
            }
        }
    }

    /**
     * 判断 Set 中是否包含 v
     */
    public func exists(v: V): Bool {
        func aux(m: Set<V>, v: V): Bool {
            match (m) {
                case Empty => false
                case Node(l, k, r, _) => match (v.compare(k)) {
                    case EQ => true
                    case LT => aux(l, v)
                    case GT => aux(r, v)
                }
            }
        }
        aux(this, v)
    }
}
