import vyavast

let solver = newLayoutSolver(
  vec2(640, 480) # window dimensions
)

let id = solver.addNode(
  Node(
    scale: vec2(30, 30),
    opts: NodeOpts(
      moves: false,   # if this node will never move, we can apply special optimizations to it by marking it as non-dynamic. 
                      # ('move' here excludes normal moving like resizing of the viewport)
      scales: false   # same as above but for scaling (changing dimensions) like for static content
    )
  )
)

solver.solve()

let n1Pos = solver.getPosition(id)
echo n1Pos
