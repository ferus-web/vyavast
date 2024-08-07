import std/[logging]
import ./[node, units]
import pretty

type
  LayoutSolver* = ref object
    root: LayoutNode
    viewport: Vec2

    overflowing*: bool

proc solve*(solver: LayoutSolver, node: LayoutNode, x, y: var float) =
  node.computedPos = vec2(x, y)
  
  var 
    cx = x #x + node.padding
    cy = y + node.padding

  for i, _ in node.children:
    node.children[i].computedPos = vec2(cx, cy)
    
    cy += node.children[i].bounds.h + node.children[i].margin + node.padding

    solver.solve(node.children[i], cx, cy)

  x += node.bounds.w
  #y += node.bounds.h
  
proc solve*(solver: LayoutSolver) =
  let bounds = solver.root.calculateFinalBounds()

  if bounds.max.w > solver.viewport.x:
    warn "solver: root layout node is overflowing beyond the viewport dimensions on the X axis - things might look wonky!"
    solver.overflowing = true

  if bounds.max.h > solver.viewport.y:
    warn "solver: root layout node is overflowing beyond the viewport dimensions on the Y axis - extending viewport vertically to accomodate"
    solver.viewport.y = bounds.max.h
  
  var
    x = solver.root.padding
    y: float
  
  for i, _ in solver.root.children:
    solver.solve(solver.root.children[i], x, y)

proc newLayoutSolver*(root: LayoutNode, viewport: Vec2): LayoutSolver {.inline.} =
  LayoutSolver(root: root, viewport: viewport)
