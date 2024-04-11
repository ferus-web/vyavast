# requires ferusgfx and windy to work!
# `nimble install https://github.com/ferus-web/ferusgfx`
import std/[options, sugar]
import vyavast, ferusgfx, windy, opengl

const
  ViewportDims* = (
    width: 1080f,
    height: 720f
  )

proc main =
  let nodes = collect:
    for _ in 0..32:
      Node(
        scale: vec2(30, 30),
        opts: NodeOpts(
          moves: false,
          scales: false
        )
      )

  var solver = newLayoutSolver(
    vec2(ViewportDims.width, ViewportDims.height)
  )

  let ids = collect:
    for node in nodes:
      solver.addNode(node)

  solver.solve()

  let window = newWindow("Vyavast Layout Solver", ivec2(1080, 720))
  window.makeContextCurrent()

  loadExtensions()

  var scene = newScene(1080, 720)
  scene.camera.setBoundaries(
    vec2(0, -300),
    vec2(0, 256 * 16)
  )

  window.onResize = proc() =
    scene.onResize((w: window.size.x.int, h: window.size.y.int))

  window.onScroll = proc() =
    let delta = vec2(window.scrollDelta.x, window.scrollDelta.y)
    scene.onScroll(delta)

  # Load a font
  scene.fontManager.load("Default", "tests/IBMPlexSans-Regular.ttf")

  var displayList = newDisplayList(addr scene)

  for id in ids:
    let content = "TextNode #" & $id
    displayList.add(
      newTextNode(
        content,
        solver.getPosition(id).get(),
        scene.fontManager
      )
    )

  commit displayList

  while not window.closeRequested:
    scene.draw()
    window.swapBuffers()
    
    pollEvents()

when isMainModule:
  main()
