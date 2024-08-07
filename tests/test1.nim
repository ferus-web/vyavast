import vyavast
import pretty

var root = LayoutNode(
  bounds: bounds(
    100, 100
  ),
  children: @[
    LayoutNode(
      newLayoutTextNode("Hello vyavast!")
    ),
    LayoutNode(
      newLayoutTextNode("This is another text label")
    )
  ]
)

let solver = newLayoutSolver(
  root,
  vec2(
    1280, 720
  )
)
solver.solve()

print root
