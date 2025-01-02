package base.core

import std.deriving.Derive

// todo: 探索 entries
// todo: 跟踪编译器错误, 使一些aux函数能够展开为尾递归

@Derive[ToString where K <: ToString, V <: ToString]
public enum Map<K, V> where K <: Comparable<K> {
    | Empty
    | Node(Map<K, V>, K, V, Map<K, V>, Int64)
}

extend<K, V> Map<K, V> {
    /**
     * 返回空 Map
     */
    public static func empty(): Map<K, V> {
        Empty
    }

    /**
     * 判断 Map 是否为空
     */
    public func isEmpty(): Bool {
        match (this) {
            case Empty => true
            case _ => false
        }
    }

    /**
     * 返回 Map 中的元素个数
     */
    public func size(): Int64 {
        match (this) {
            case Empty => 0
            case Node(l, _, _, r, _) => l.size() + 1 + r.size()
        }
    }

    func height(): Int64 {
        match (this) {
            case Empty => 0
            case Node(_, _, _, _, h) => h
        }
    }

    func create(l: Map<K, V>, k: K, v: V, r: Map<K, V>): Map<K, V> {
        let hl = l.height()
        let hr = r.height()
        let h = if (hl >= hr) {
            hl + 1
        } else {
            hr + 1
        }
        Node(l, k, v, r, h)
    }

    func balance(l: Map<K, V>, k: K, v: V, r: Map<K, V>): Map<K, V> {
        let hl = l.height()
        let hr = r.height()
        if (hl > hr + 2) {
            match (l) {
                case Empty => Empty<K, V>
                case Node(ll, lk, lv, lr, _) =>
                    if (ll.height() >= lr.height()) {
                        create(ll, lk, lv, create(lr, k, v, r))
                    } else {
                        match (lr) {
                            case Empty => Empty<K, V>
                            case Node(lrl, lrv, lrd, lrr, _) => create(create(ll, lk, lv, lrl), lrv, lrd,
                                create(lrr, k, v, r))
                        }
                    }
            }
        } else if (hr > hl + 2) {
            match (r) {
                case Empty => Empty<K, V>
                case Node(rl, rk, rv, rr, _) =>
                    if (rr.height() >= rl.height()) {
                        create(create(l, k, v, rl), rk, rv, rr)
                    } else {
                        match (rl) {
                            case Empty => Empty<K, V>
                            case Node(rll, rlk, rlv, rlr, _) => create(create(l, k, v, rll), rlk, rlv,
                                create(rlr, rk, rv, rr))
                        }
                    }
            }
        } else {
            create(l, k, v, r)
        }
    }

    /**
     * 添加元素
     */
    public func add(key: K, value: V): Map<K, V> {
        match (this) {
            case Empty => Node(Empty, key, value, Empty, 1)
            case Node(l, k, v, r, h) => match (key.compare(k)) {
                case EQ => Node(l, key, value, r, h)
                case LT => balance(l.add(key, value), k, v, r)
                case GT => balance(l, k, v, r.add(key, value))
            }
        }
    }

    func minBinding(): (K, V) {
        func aux(m: Map<K, V>): (K, V) {
            match (m) {
                case Empty => throw Exception("Not found")
                case Node(Empty, k, v, _, _) => (k, v)
                case Node(l, _, _, _, _) => aux(l)
            }
        }
        aux(this)
    }

    func removeMinBinding(): Map<K, V> {
        match (this) {
            case Empty => Empty
            case Node(Empty, _, _, r, _) => r
            case Node(l, k, v, r, _) => balance(l.removeMinBinding(), k, v, r)
        }
    }

    func merge(other: Map<K, V>): Map<K, V> {
        match ((this, other)) {
            case (Empty, m) => m
            case (m, Empty) => m
            case (m1, m2) =>
                let (k, v) = m2.minBinding()
                this.balance(m1, k, v, m2.removeMinBinding())
        }
    }

    /**
     * 删除元素
     */
    public func remove(key: K): Map<K, V> {
        match (this) {
            case Empty => Empty
            case Node(l, k, v, r, _) => match (key.compare(k)) {
                case EQ => l.merge(r)
                case LT => balance(l.remove(key), k, v, r)
                case GT => balance(l, k, v, r.remove(key))
            }
        }
    }

    /**
     * 查找元素
     */
    public func find(key: K): Option<V> {
        func aux(m: Map<K, V>, key: K): Option<V> {
            match (m) {
                case Empty => None
                case Node(l, k, v, r, _) => match (key.compare(k)) {
                    case EQ => Some(v)
                    case LT => aux(l, key)
                    case GT => aux(r, key)
                }
            }
        }
        aux(this, key)
    }

    /**
     * 判断 Map 中是否包含 key
     */
    public func exists(key: K): Bool {
        func aux(m: Map<K, V>, key: K): Bool {
            match (m) {
                case Empty => false
                case Node(l, k, v, r, _) => match (key.compare(k)) {
                    case EQ => true
                    case LT => aux(l, key)
                    case GT => aux(r, key)
                }
            }
        }
        aux(this, key)
    }
}
