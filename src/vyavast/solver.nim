import std/options
import vmath
import ./[
  node, margins, paddings
]

type
  LayoutSolver* = ref object
    viewport*: Vec2
    nodes*: seq[Node]

proc addNode*(
  solver: LayoutSolver,
  node: Node
): int {.inline.} =
  solver.nodes.add(node)
  solver.nodes.len - 1

proc solve*(
  solver: LayoutSolver
) =
  var
    posX: float32
    posY: float32

  for i, _ in solver.nodes:
    var lnode = solver.nodes[i]

    case lnode.kind
    of dkBlock:
      let
        horizMargin = lnode.margin.left + lnode.margin.right
        vertMargin = lnode.margin.top + lnode.margin.bottom

      posX += lnode.scale.x + horizMargin
      posY += lnode.scale.y + vertMargin

      lnode.computed = some vec2(
        0, posY
      )
    else: discard

proc getPosition*(solver: LayoutSolver, id: int): Option[Vec2] {.inline.} =
  solver.nodes[id].computed

proc newLayoutSolver*(viewport: Vec2): LayoutSolver {.inline.} =
  LayoutSolver(
    viewport: viewport
  )

export vmath
