Simple macros to build NimNode AST

```nim
buildAst:
  StmtList:
    Call(ident"echo"):
      Infix(ident"+", 2, 3)
```
generates something like
```nim
nnkStmtList.newTree(
  nnkCall.newTree(
    ident"echo",
    nnkInfix.newTree(ident"+", newLit 2, newLit 3)
  )
)
```
use `_` to make empty node
