package base.parsec

import base.core.*

// WIP

public struct Parsec<I, O> {
    public Parsec(public let parseFunc: (Lst<I>) -> Option<(O, Lst<I>)>) {}
}

extend<I, O> Parsec<I, O> {
    public static func fromCond(predicate: (I) -> Bool): Parsec<I, I> {
        Parsec {
            input => match (input) {
                case Cons(hd, tl) where predicate(hd) => Some((hd, tl))
                case _ => None
            }
        }
    }

    public func map<O2>(f: (O) -> O2): Parsec<I, O2> {
        Parsec {
            input => match (this.parseFunc(input)) {
                case Some((value, rest)) => Some((f(value), rest))
                case None => None
            }
        }
    }

    public func and<O2>(p2: Parsec<I, O2>): Parsec<I, (O, O2)> {
        Parsec {
            input => match (this.parseFunc(input)) {
                case Some((value1, rest1)) => match (p2.parseFunc(rest1)) {
                    case Some((value2, rest2)) => Some(((value1, value2), rest2))
                    case None => None
                }
                case None => None
            }
        }
    }

    public func or(p2: Parsec<I, O>): Parsec<I, O> {
        Parsec {
            input => match (this.parseFunc(input)) {
                case Some(a) => Some(a)
                case None => p2.parseFunc(input)
            }
        }
    }

    public func many(): Parsec<I, Lst<O>> {
      func aux(l: Lst<I>, acc: Lst<O>): Option<(Lst<O>, Lst<I>)> {
        match(this.parseFunc(l)) {
          case None => Some((acc.rev(), l))
          case Some((v, rest)) => aux(rest, acc.cons(v))
        }
      }

      Parsec {
        input => aux(input, Lst<O>.empty())
      }
    }
    public func many1(): Parsec<I, Lst<O>> {
        // Parsec {
        //     input => 
        //     match(this.many().parseFunc(input)) {
        //         case  None => None
        //         case Some((vs, rest)) where vs.len() >= 1 =>  Some((vs, rest))
        //     }
        // }
        throw UnsupportedException()
    }

    public func between<OL, OR>(pl: Parsec<I, OL>, pr: Parsec<I, OR>): Parsec<I, O> {
        // (OL, O), OR)
        pl.and(this).and(pr).map { t => t[0][1] }
    }

    // ??
    // public func skip(p: Parsec<I, Any>): Parsec<I, O> {
    //     this.and(p).map { t => t[0] }
    // }

    public func sepBy<OP>(p: Parsec<I, OP>): Parsec<I, Lst<O>> {
        // (O, [O])
        this.and(p.and(this).map{ t => t[1] }.many()).map { t => t[1].cons(t[0])}
    }
}

