import std/[strutils]
import ./[units, node]

type
  FontParams* = object
    vertSize*: float  # per char
    horizSize*: float # per char

  TextNode* = ref object of LayoutNode
    content*: string
    params*: FontParams

proc calculateTextBounds*(node: TextNode) =
  node.bounds = bounds(
    (proc: float =
      for c in node.content:
        case c
        of strutils.Newlines: discard
        else: result += node.params.horizSize
    )(),
    (proc: float =
      result = node.params.vertSize
      for c in node.content:
        if c == '\n':
          result += node.params.vertSize
    )()
  )

proc newLayoutTextNode*(
  content: string,
  params: FontParams = FontParams(horizSize: 16f, vertSize: 16f)
): TextNode {.inline.} =
  result = TextNode(content: content, params: params)
  result.calculateTextBounds()
