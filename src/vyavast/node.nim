import std/[algorithm]
import ./[units]

type
  LayoutNode* = ref object of RootObj
    bounds*: Bounds
    children*: seq[LayoutNode]
    margin*, padding*: float = 1f

    computedPos*: Vec2

proc collectAllBounds(bounds: var seq[Bounds], node: LayoutNode) {.inline.} =
  for child in node.children:
    bounds &= child.bounds
    bounds.collectAllBounds(child)

proc calculateFinalBounds*(node: LayoutNode): tuple[min, max: Bounds] =
  var bounds = @[node.bounds]

  bounds.collectAllBounds(node)
  sort bounds
  
  (min: bounds[0], max: bounds[bounds.len - 1])
