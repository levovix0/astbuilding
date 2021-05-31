import macros, fusion/matching, strformat

{.experimental: "caseStmtMacros".}

proc enumItems(x: typedesc[enum]): seq[string] =
  for a in x:
    result.add $a

const nimNodeKinds = NimNodeKind.enumItems
proc isNnk(a: string): bool = &"nnk{a}" in nimNodeKinds
proc isNnk(a: NimNode): bool = isNnk $a

proc buildAstImpl(a: NimNode): NimNode =
  case a
  of StmtList[@b is Call()|Command()]: return buildAstImpl b

  of Call[@kind is Ident(isNnk: true), all @b] | Command[@kind is Ident(isNnk: true), all @b]:
    let k = ident &"nnk{kind}"
    let c =
      if b.len == 0: b
      elif b[^1].kind == nnkStmtList: b[0..^2] & b[^1][0..^1]
      else: b
    
    result = newCall(ident"newTree", k)
    for d in c: result.add buildAstImpl d
  
  of IntLit(intVal: @val): return (quote do: newLit `val`)
  of FloatLit(floatVal: @val): return (quote do: newLit `val`)
  of StrLit(strVal: @val): return (quote do: newLit `val`)

  of Ident(strVal: "_"): return (quote do: newEmptyNode())

  else: return a

macro buildAst*(body): untyped =
  buildAstImpl body
