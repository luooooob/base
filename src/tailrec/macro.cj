macro package base.tailrec

import std.ast.Tokens
import base.tailrecimpl.tailrec
import std.ast.FuncDecl

public macro Tailrec(input: Tokens): Tokens {
    tailrec(input)
}
