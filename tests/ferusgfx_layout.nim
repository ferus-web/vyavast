# requires ferusgfx and windy to work!
# `nimble install https://github.com/ferus-web/ferusgfx`
import std/[options, sugar, random]
import vyavast, ferusgfx, windy, opengl
import pretty

var root = LayoutNode(
  bounds: bounds(
    100, 100
  ),
  padding: 1,
  margin: 1,
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

proc main =
  randomize()

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

  for node in root.children:
    let casted = vyavast.TextNode(node)
    if casted.content == "": continue

    displayList.add(
      newTextNode(
        casted.content,
        casted.computedPos,
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
