# Base

实验性的仓颉语言基础库，为仓颉函数式编程探索更多可能

## 功能

- [x] `base.tailrec.Tailrec`

尾递归宏，将尾递归的函数优化成循环的形式

- [x] `base.core.Lst`

函数式风格的单链表

- [x] `base.core.Map`

avl树实现的 Map

- [x] `base.core.Set`

avl树实现的 Set

- [ ] `base.core.Str`
- [x] `base.core.Option`

扩展标准库的 `Option`

- [x] `base.core.Result`

标准库中缺少的 `Result`

- [ ] `base.clap.App`

构建命令行程序的工具

- [x] `base.parsec.Parsec`

Parser Combinator 库

## 用法
```toml
# cjpm.toml

# ...

[dependencies] 
  base = { git = "https://github.com/luooooob/base.git", branch = "main" }

# ...

```

```cj
import base.core.*

@Tailrec func sum(acc: Int64, x: Int64): Int64 {
    if (x == 0) {
        acc
    } else {
        sum(acc + x, x - 1)
    }
}

main() {
    println(sum(0, 5))
    println(Lst
        .fromArray([4, 5, 1, 4, 6, 7, 9, 3])
        .foldl(0) { acc, x => acc + x }
    )
}

```

## 开发

```sh
cjpm build
cjpm test
```



## "--help" 的问题

```sh
# [command] [subcommand]
cjpm run

# [command] [subcommand] [options]
cjpm run --build=args xxx --run-args xxx

# [command] [subcommand] [subcommand]
# 他好像不是 run 的一个option，他其实是个 subcommand
cjpm run --help

# [command] [subcommand] [subcommand]
# 所以应该是这样的……
cjpm run help



```