import unittest, astbuilding, macros

macro makeSomething() = expandMacros:
  buildAst:
    StmtList:
      Call(ident"echo"):
        Infix(ident"+", 2, 3)

test "TypeSection":
  expandMacros:
    makeSomething()
