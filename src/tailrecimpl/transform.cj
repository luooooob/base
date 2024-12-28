protected package base.tailrecimpl

import std.ast.*

public class NotFuncException <: Exception {
    public init() {
        super("Tailrec macro can only be used on function declarations")
    }
}

extend Iterator<Tokens> {
    func join(sp: Tokens): Tokens {
        match (this.next()) {
            case None => Tokens()
            case Some(first) => this.fold(Tokens().append(first)) {acc, x => acc.append(sp).append(x)}
        }
    }
}

class ReplaceCallExprVisitor <: Visitor {
    ReplaceCallExprVisitor(let id: String, let replaceId: String) {}

    public override func visit(callExpr: CallExpr) {
        func isMemberAccessMatch(memberAccess: MemberAccess): Bool {
            let isThis = compareTokens(memberAccess.baseExpr.toTokens(), Token(TokenKind.THIS, "this").toTokens())
            let isId = compareTokens(memberAccess.field.toTokens(), Token(TokenKind.IDENTIFIER, id).toTokens())
            isThis && isId
        }
        func isRefExprMatch(refExpr: RefExpr): Bool {
            compareTokens(refExpr.identifier.toTokens(), Token(TokenKind.IDENTIFIER, id).toTokens())
        }
        let isMatch = match (callExpr.callFunc) {
            case x: MemberAccess => isMemberAccessMatch(x)
            case x: RefExpr => isRefExprMatch(x)
            case _ => false
        }

        if (isMatch) {
            callExpr.callFunc = RefExpr(Token(TokenKind.IDENTIFIER, replaceId).toTokens())
        }
    }
}

public func tailrec(input: Tokens): Tokens {
    let funcDecl = (parseDecl(input) as FuncDecl).getOrThrow {=> NotFuncException()}

    let replaceCallExprVisitor = ReplaceCallExprVisitor(funcDecl.identifier.value, "__mut")
    funcDecl.block.traverse(replaceCallExprVisitor)

    let id = {x: String => Token(TokenKind.IDENTIFIER, x)}

    let modifiers = funcDecl.modifiers
    let identifier = funcDecl.identifier
    let funcParams = funcDecl.funcParams
    let declType = funcDecl.declType

    let tempParamsDefineExprs = funcParams
        .iterator()
        .map {
            param => quote(var $(id("__temp_${param.identifier.value}")) = $(param.identifier))
        }
        .join(Tokens([Token(TokenKind.NL)]))

    let tempParamsMutExprs = funcParams
        .iterator()
        .map {
            param => quote($(id("__temp_${param.identifier.value}")) = $(param.identifier))
        }
        .join(Tokens([Token(TokenKind.NL)]))

    let tempParamsCalls = funcParams
        .iterator()
        .map {
            param => quote($(id("__temp_${param.identifier.value}")))
        }
        .join(Tokens([Token(TokenKind.COMMA)]))

    let body = funcDecl.block.nodes

    quote(
        $(modifiers) func $(identifier) ($(funcParams)): $(declType) {
            var value = Option<$(declType)>.None
            $(tempParamsDefineExprs)
            func __mut ($(funcParams)): Option<$(declType)> {
                $(tempParamsMutExprs)
                Option<$(declType)>.None
            }
            func __body ($(funcParams)): Option<$(declType)> {
                $(body)
            }
            while(true) {
                match(value) {
                    case Some(x) => return x
                    case None => value = __body($(tempParamsCalls))
                }
            }
            throw Exception("Unreachable code")
        }
    )
}
